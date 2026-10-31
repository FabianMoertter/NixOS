{ lib, pkgs, palette }:

let
  cava = lib.getExe pkgs.cava;
  df = lib.getExe' pkgs.coreutils "df";
  hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
  ip = lib.getExe' pkgs.iproute2 "ip";

  # 8 bars as semicolon-separated 0-7 levels, one frame per line.
  cavaConfig = pkgs.writeText "quickshell-bar-cava.conf" ''
    [general]
    framerate = 60
    bars = 8
    sleep_timer = 5

    [output]
    method = raw
    raw_target = /dev/stdout
    data_format = ascii
    ascii_max_range = 7
    bar_delimiter = 59
    frame_delimiter = 10
  '';
in
''
  import Quickshell
  import Quickshell.Bluetooth
  import Quickshell.Hyprland
  import Quickshell.Io
  import Quickshell.Networking
  import Quickshell.Services.Pipewire
  import Quickshell.Services.SystemTray
  import Quickshell.Widgets
  import QtQuick
  import QtQuick.Controls
  import QtQuick.Layouts

  ShellRoot {
    id: root

    readonly property string fontFamily: "JetBrainsMono Nerd Font"

    // ── Shared state (one source for every bar) ──────────────────

    property string cavaText: ""
    property bool cavaSilent: true

    property string diskPercent: ""
    property string diskTooltip: ""

    property string netDevice: ""
    property string netAddress: ""

    property string keymapShort: ""
    property string keymapLong: ""

    readonly property var wifiNetwork: {
      for (const dev of Networking.devices.values) {
        if (dev.type !== DeviceType.Wifi || !dev.connected)
          continue
        const net = dev.networks.values.find(n => n.connected)
        if (net)
          return net
      }
      return null
    }
    readonly property bool wiredConnected:
      Networking.devices.values.some(d => d.type === DeviceType.Wired && d.connected)

    readonly property var sink: Pipewire.defaultAudioSink
    // lepidoptera has one adapter per Wi-Fi card, so look across all of them
    // rather than only Bluetooth.defaultAdapter.
    readonly property bool btEnabled: Bluetooth.adapters.values.some(a => a.enabled)
    readonly property var btConnected: Bluetooth.devices.values.filter(d => d.connected)

    function run(command) {
      Quickshell.execDetached(["sh", "-c", command])
    }

    PwObjectTracker {
      objects: root.sink ? [root.sink] : []
    }

    Process {
      running: true
      command: ["${cava}", "-p", "${cavaConfig}"]
      stdout: SplitParser {
        onRead: line => {
          const levels = line.split(";").filter(s => s.length > 0).map(Number)
          root.cavaSilent = levels.every(l => l === 0)
          root.cavaText = levels.map(l => "▁▂▃▄▅▆▇█"[l]).join("")
        }
      }
    }

    Process {
      id: diskProc
      running: true
      command: ["${df}", "-B1", "--output=used,size,target", "/"]
      stdout: StdioCollector {
        onStreamFinished: {
          const fields = text.trim().split("\n")[1].trim().split(/\s+/)
          const gib = bytes => (bytes / 1073741824).toFixed(1) + " GiB"
          // used / total, like waybar (df's own pcent leaves out reserved blocks)
          const percent = Math.round(100 * Number(fields[0]) / Number(fields[1])) + "%"
          root.diskPercent = percent
          root.diskTooltip = gib(fields[0]) + " / " + gib(fields[1]) + " (" + percent + ") on " + fields[2]
        }
      }
    }

    Timer {
      interval: 600000
      running: true
      repeat: true
      onTriggered: diskProc.running = true
    }

    // Networking does not expose IP addresses, so ask the kernel which
    // interface and source address the default route uses.
    Process {
      id: routeProc
      command: ["${ip}", "-j", "route", "get", "1.1.1.1"]
      stdout: StdioCollector {
        onStreamFinished: {
          try {
            const route = JSON.parse(text)[0]
            root.netDevice = route.dev
            root.netAddress = route.prefsrc
          } catch (e) {
            root.netDevice = ""
            root.netAddress = ""
          }
        }
      }
    }

    Timer {
      interval: 30000
      running: true
      repeat: true
      triggeredOnStart: true
      onTriggered: routeProc.running = true
    }

    Connections {
      target: Networking
      function onConnectivityChanged() { routeProc.running = true }
    }

    Process {
      id: keymapProc
      running: true
      command: ["${hyprctl}", "-j", "devices"]
      stdout: StdioCollector {
        onStreamFinished: {
          const kb = JSON.parse(text).keyboards.find(k => k.main)
          if (!kb)
            return
          root.keymapLong = kb.active_keymap
          root.keymapShort = kb.layout.split(",")[kb.active_layout_index] ?? kb.active_keymap
        }
      }
    }

    Connections {
      target: Hyprland
      function onRawEvent(event) {
        if (event.name === "activelayout")
          keymapProc.running = true
      }
    }

    // ── Reusable pieces ──────────────────────────────────────────

    component Tip: PopupWindow {
      id: tip
      required property Item target
      property string text: ""
      property bool shown: false

      anchor.item: target
      anchor.edges: Edges.Bottom
      anchor.gravity: Edges.Bottom
      visible: shown && text.length > 0
      color: "transparent"
      implicitWidth: tipLabel.implicitWidth + 16
      implicitHeight: tipLabel.implicitHeight + 18

      Rectangle {
        anchors.fill: parent
        anchors.topMargin: 6
        radius: 10
        color: "#${palette.base00}"
        border.width: 1
        border.color: "#${palette.base0E}"

        Text {
          id: tipLabel
          anchors.centerIn: parent
          color: "#${palette.base05}"
          font.family: "JetBrainsMono Nerd Font"
          font.pixelSize: 13
          text: tip.text
        }
      }
    }

    component Module: Item {
      id: mod
      property string text: ""
      property color textColor: "#${palette.base05}"
      property color hoverColor: textColor
      property string tooltip: ""
      property int pixelSize: 13
      property int padding: 10
      signal clicked(var mouse)
      signal scrolled(int delta)

      Layout.fillHeight: true
      implicitWidth: label.implicitWidth + 2 * padding

      Text {
        id: label
        anchors.centerIn: parent
        text: mod.text
        color: area.containsMouse ? mod.hoverColor : mod.textColor
        font.family: "JetBrainsMono Nerd Font"
        font.bold: true
        font.pixelSize: mod.pixelSize

        Behavior on color {
          ColorAnimation { duration: 150 }
        }
      }

      MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onClicked: mouse => mod.clicked(mouse)
        onWheel: wheel => mod.scrolled(wheel.angleDelta.y)
      }

      Tip {
        target: mod
        text: mod.tooltip
        shown: area.containsMouse
      }
    }

    component Pill: Rectangle {
      default property alias content: row.data
      implicitWidth: row.implicitWidth + 8
      radius: 12
      color: "#eb${palette.base00}"
      border.width: 1
      border.color: "#59${palette.base0E}"

      RowLayout {
        id: row
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4
        spacing: 0
      }
    }

    // ── One bar per screen ───────────────────────────────────────

    Variants {
      model: Quickshell.screens

      PanelWindow {
        id: bar
        required property var modelData
        readonly property var monitor: Hyprland.monitorFor(modelData)

        screen: modelData
        anchors {
          top: true
          left: true
          right: true
        }
        margins {
          top: 8
          left: 10
          right: 10
        }
        implicitHeight: 44
        color: "transparent"

        // Left: workspaces + cava
        Pill {
          anchors.left: parent.left
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.topMargin: 4
          anchors.bottomMargin: 4

          Row {
            Layout.leftMargin: 4
            Layout.rightMargin: 4
            Layout.alignment: Qt.AlignVCenter
            spacing: 2

            Repeater {
              model: 10

              Rectangle {
                id: wsButton
                required property int index
                readonly property int number: index + 1
                readonly property var workspace:
                  Hyprland.workspaces.values.find(w => w.id === number) ?? null
                readonly property bool isActive: bar.monitor?.activeWorkspace?.id === number
                readonly property bool isUrgent: workspace?.urgent ?? false
                readonly property bool isEmpty:
                  !workspace || workspace.toplevels.values.length === 0

                width: Math.max(isActive ? 22 : 18, wsLabel.implicitWidth + 14)
                height: 28
                radius: 8
                color: isActive ? "#${palette.base0E}"
                  : isUrgent ? "#${palette.base08}"
                  : wsArea.containsMouse ? "#2e${palette.base0E}"
                  : "transparent"

                Behavior on color {
                  ColorAnimation { duration: 150 }
                }
                Behavior on width {
                  NumberAnimation { duration: 150 }
                }

                Text {
                  id: wsLabel
                  anchors.centerIn: parent
                  text: wsButton.number
                  font.family: root.fontFamily
                  font.bold: true
                  font.pixelSize: 13
                  color: wsButton.isActive || wsButton.isUrgent ? "#${palette.base00}"
                    : wsArea.containsMouse ? "#${palette.base05}"
                    : wsButton.isEmpty ? "#${palette.base03}"
                    : "#${palette.base04}"
                }

                MouseArea {
                  id: wsArea
                  anchors.fill: parent
                  hoverEnabled: true
                  onClicked: Hyprland.dispatch("workspace " + wsButton.number)
                }
              }
            }
          }

          Module {
            visible: !root.cavaSilent
            text: root.cavaText
            textColor: "#${palette.base0E}"
            padding: 7
          }
        }

        // Center: clock with a month calendar on hover
        Pill {
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.topMargin: 4
          anchors.bottomMargin: 4

          Item {
            id: clock
            property date now: new Date()
            property bool alt: false
            property int monthOffset: 0

            Layout.fillHeight: true
            implicitWidth: clockLabel.implicitWidth + 32

            Timer {
              interval: 1000
              running: true
              repeat: true
              onTriggered: clock.now = new Date()
            }

            Text {
              id: clockLabel
              anchors.centerIn: parent
              color: "#${palette.base05}"
              font.family: root.fontFamily
              font.bold: true
              font.pixelSize: 14
              text: clock.alt
                ? Qt.formatDateTime(clock.now, "hh:mm AP")
                : "󰃭  " + Qt.formatDateTime(clock.now, "ddd dd MMM  HH:mm")
            }

            MouseArea {
              id: clockArea
              anchors.fill: parent
              hoverEnabled: true
              acceptedButtons: Qt.LeftButton | Qt.RightButton
              onClicked: mouse => {
                if (mouse.button === Qt.LeftButton)
                  clock.alt = !clock.alt
                else
                  clock.monthOffset = 0
              }
              onWheel: wheel => clock.monthOffset += wheel.angleDelta.y > 0 ? -1 : 1
              onContainsMouseChanged: if (!containsMouse) clock.monthOffset = 0
            }

            PopupWindow {
              id: calendarPopup
              readonly property date shownMonth:
                new Date(clock.now.getFullYear(), clock.now.getMonth() + clock.monthOffset, 1)

              anchor.item: clock
              anchor.edges: Edges.Bottom
              anchor.gravity: Edges.Bottom
              visible: clockArea.containsMouse
              color: "transparent"
              implicitWidth: 260
              implicitHeight: calendar.implicitHeight + 30

              Rectangle {
                anchors.fill: parent
                anchors.topMargin: 6
                radius: 10
                color: "#${palette.base00}"
                border.width: 1
                border.color: "#${palette.base0E}"

                ColumnLayout {
                  id: calendar
                  anchors.fill: parent
                  anchors.margins: 12
                  spacing: 6

                  Text {
                    Layout.alignment: Qt.AlignHCenter
                    color: "#${palette.base0E}"
                    font.family: root.fontFamily
                    font.bold: true
                    font.pixelSize: 13
                    text: Qt.formatDate(calendarPopup.shownMonth, "MMMM yyyy")
                  }

                  DayOfWeekRow {
                    Layout.fillWidth: true
                    delegate: Text {
                      required property string shortName
                      horizontalAlignment: Text.AlignHCenter
                      color: "#${palette.base0A}"
                      font.family: root.fontFamily
                      font.bold: true
                      font.pixelSize: 12
                      text: shortName
                    }
                  }

                  MonthGrid {
                    id: monthGrid
                    Layout.fillWidth: true
                    month: calendarPopup.shownMonth.getMonth()
                    year: calendarPopup.shownMonth.getFullYear()
                    delegate: Text {
                      required property var model
                      readonly property bool isToday: model.today
                      horizontalAlignment: Text.AlignHCenter
                      opacity: model.month === monthGrid.month ? 1 : 0.35
                      color: isToday ? "#${palette.base08}" : "#${palette.base05}"
                      font.family: root.fontFamily
                      font.bold: isToday
                      font.underline: isToday
                      font.pixelSize: 12
                      text: model.day
                    }
                  }
                }
              }
            }
          }
        }

        // Right: status modules, launchers and tray
        Pill {
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.topMargin: 4
          anchors.bottomMargin: 4

          Module {
            text: "󰌌 " + root.keymapShort
            textColor: "#${palette.base0E}"
            hoverColor: "#${palette.base05}"
            tooltip: "Keyboard: " + root.keymapLong + "\nClick or Super+Alt+K to switch"
            onClicked: root.run("${hyprctl} switchxkblayout all next")
          }

          Module {
            text: "󰋊 " + root.diskPercent
            textColor: "#${palette.base0A}"
            tooltip: root.diskTooltip
            onClicked: root.run("kitty -e btop")
          }

          Module {
            text: root.wifiNetwork ? "󰤨 " + root.wifiNetwork.name
              : root.wiredConnected ? "󰈀 " + root.netAddress
              : "󰤭 Offline"
            textColor: root.wifiNetwork || root.wiredConnected
              ? "#${palette.base0B}" : "#${palette.base08}"
            tooltip: root.wifiNetwork
              ? "󰤨 " + root.wifiNetwork.name + "  "
                + Math.round(root.wifiNetwork.signalStrength * 100) + "%\n"
                + root.netAddress + " on " + root.netDevice
              : root.wiredConnected ? "󰈀 " + root.netDevice + "\n" + root.netAddress
              : "Disconnected"
            onClicked: root.run("wifimenu")
          }

          Module {
            readonly property var audio: root.sink?.audio ?? null
            readonly property bool isBluetooth: (root.sink?.name ?? "").startsWith("bluez")
            readonly property int volume: Math.round((audio?.volume ?? 0) * 100)

            text: !audio ? "󰝟"
              : audio.muted ? (isBluetooth ? "󰂲 Muted" : "󰝟 Muted")
              : isBluetooth ? "󰂯 " + volume + "%"
              : (volume < 34 ? "󰕿" : volume < 67 ? "󰖀" : "󰕾") + " " + volume + "%"
            textColor: audio && !audio.muted ? "#${palette.base09}" : "#${palette.base04}"
            tooltip: root.sink?.description ?? ""
            onClicked: mouse => {
              if (mouse.button === Qt.MiddleButton && audio)
                audio.muted = !audio.muted
              else
                root.run("pavucontrol")
            }
            onScrolled: delta => {
              if (!audio)
                return
              audio.volume = Math.max(0, Math.min(1, audio.volume + (delta > 0 ? 0.05 : -0.05)))
            }
          }

          Module {
            readonly property var devices: root.btConnected

            text: !root.btEnabled ? "󰂲"
              : devices.length === 1 && devices[0].batteryAvailable
                ? "󰂱 " + devices[0].name + " " + Math.round(devices[0].battery * 100) + "%"
              : devices.length > 0 ? "󰂱 " + devices.length
              : "󰂯 on"
            textColor: root.btEnabled ? "#${palette.base0D}" : "#${palette.base04}"
            tooltip: Bluetooth.adapters.values.length === 0 ? "No Bluetooth adapter"
              : devices.length + " connected"
                + devices.map(d => "\n" + d.name).join("")
            onClicked: root.run("blueman-manager")
          }

          Module {
            text: "󰉋"
            pixelSize: 15
            textColor: "#${palette.base0C}"
            hoverColor: "#${palette.base05}"
            tooltip: "Files"
            onClicked: root.run("nautilus")
          }

          Module {
            text: "󱎓"
            pixelSize: 15
            textColor: "#${palette.base0C}"
            hoverColor: "#${palette.base05}"
            tooltip: "Paperless"
            onClicked: root.run("brave --app=http://mantodea:8026")
          }

          Row {
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            Layout.alignment: Qt.AlignVCenter
            spacing: 10
            visible: SystemTray.items.values.length > 0

            Repeater {
              model: SystemTray.items

              Rectangle {
                id: trayItem
                required property var modelData
                width: 24
                height: 24
                radius: 8
                color: modelData.status === Status.NeedsAttention
                  ? "#${palette.base08}" : "transparent"

                IconImage {
                  anchors.centerIn: parent
                  implicitSize: 18
                  source: trayItem.modelData.icon
                  opacity: trayItem.modelData.status === Status.Passive ? 0.5 : 1
                }

                MouseArea {
                  id: trayArea
                  anchors.fill: parent
                  hoverEnabled: true
                  acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                  onClicked: mouse => {
                    const item = trayItem.modelData
                    if (mouse.button === Qt.MiddleButton) {
                      item.secondaryActivate()
                    } else if (mouse.button === Qt.RightButton || item.onlyMenu) {
                      if (item.hasMenu) {
                        const pos = trayItem.mapToItem(null, 0, trayItem.height + 6)
                        item.display(bar, pos.x, pos.y)
                      }
                    } else {
                      item.activate()
                    }
                  }
                  onWheel: wheel => trayItem.modelData.scroll(wheel.angleDelta.y, false)
                }

                Tip {
                  target: trayItem
                  text: trayItem.modelData.tooltipTitle || trayItem.modelData.title
                  shown: trayArea.containsMouse
                }
              }
            }
          }
        }
      }
    }
  }
''
