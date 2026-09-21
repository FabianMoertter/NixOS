{ palette, video }:

''
  import Quickshell
  import Quickshell.Services.Pam
  import Quickshell.Wayland
  import QtMultimedia
  import QtQuick

  ShellRoot {
    id: root

    property string password: ""
    property string statusText: ""
    property bool authenticationFailed: false
    signal clearPassword()

    function authenticate(candidate) {
      if (pam.active || candidate.length === 0)
        return

      password = candidate
      authenticationFailed = false
      statusText = "Checking…"

      if (!pam.start()) {
        password = ""
        statusText = "Authentication could not be started"
        authenticationFailed = true
        clearPassword()
      }
    }

    PamContext {
      id: pam
      config: "quickshell"

      onPamMessage: {
        if (responseRequired)
          respond(root.password)
        else if (messageIsError)
          root.statusText = message
      }

      onCompleted: result => {
        root.password = ""
        root.clearPassword()

        if (result === PamResult.Success) {
          root.statusText = ""
          lock.locked = false
        } else {
          root.statusText = "Incorrect password"
          root.authenticationFailed = true
        }
      }
    }

    WlSessionLock {
      id: lock
      locked: true

      // Wait for the compositor to acknowledge the unlock before exiting.
      onSecureChanged: {
        if (!secure && !locked)
          Qt.quit()
      }

      WlSessionLockSurface {
        id: surface
        color: "#${palette.base00}"

        MediaPlayer {
          id: player
          source: "file://${video}"
          videoOutput: videoOutput
          audioOutput: AudioOutput { muted: true }
          loops: MediaPlayer.Infinite
          autoPlay: true
        }

        VideoOutput {
          id: videoOutput
          anchors.fill: parent
          fillMode: VideoOutput.PreserveAspectCrop
        }

        Rectangle {
          anchors.fill: parent
          color: "#52000000"
        }

        Column {
          anchors.centerIn: parent
          width: 340
          spacing: 22

          Text {
            id: clock
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#${palette.base05}"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 86
            font.weight: Font.Light
            text: Qt.formatTime(new Date(), "HH:mm")

            Timer {
              interval: 1000
              running: true
              repeat: true
              onTriggered: clock.text = Qt.formatTime(new Date(), "HH:mm")
            }
          }

          Rectangle {
            width: parent.width
            height: 58
            radius: 12
            color: "#dd${palette.base00}"
            border.width: 2
            border.color: root.authenticationFailed ? "#${palette.base08}" : "#${palette.base0E}"

            TextInput {
              id: passwordInput
              anchors.fill: parent
              anchors.leftMargin: 18
              anchors.rightMargin: 18
              color: "#${palette.base05}"
              selectionColor: "#${palette.base0E}"
              selectedTextColor: "#${palette.base00}"
              font.family: "JetBrainsMono Nerd Font"
              font.pixelSize: 20
              echoMode: TextInput.Password
              passwordCharacter: "●"
              verticalAlignment: TextInput.AlignVCenter
              focus: true

              onAccepted: root.authenticate(text)
              onTextChanged: {
                root.authenticationFailed = false
                root.statusText = ""
              }
              Keys.onEscapePressed: clear()

              Component.onCompleted: forceActiveFocus()

              Connections {
                target: root
                function onClearPassword() {
                  passwordInput.clear()
                  passwordInput.forceActiveFocus()
                }
              }
            }

            Text {
              anchors.fill: parent
              anchors.leftMargin: 18
              color: "#${palette.base04}"
              font.family: "JetBrainsMono Nerd Font"
              font.pixelSize: 18
              text: "Password…"
              verticalAlignment: Text.AlignVCenter
              visible: passwordInput.text.length === 0
            }
          }

          Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: root.authenticationFailed ? "#${palette.base08}" : "#${palette.base05}"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 15
            text: root.statusText
            visible: text.length > 0
          }
        }

        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.AllButtons
          onPressed: passwordInput.forceActiveFocus()
        }
      }
    }
  }
''
