"""Arrange workspaces across displays and select left/right workspace pairs."""

import argparse
import json
import os
from pathlib import Path
import socket
import subprocess
import sys


def layout_displays(monitors):
    monitors = [m for m in monitors if not m.get("disabled", False)
                and m.get("mirrorOf", "none") == "none"]
    external = [m for m in monitors if not m["name"].startswith("eDP-")]
    return sorted(external if len(external) >= 2 else monitors,
                  key=lambda m: (m["x"], m["y"], m["name"]))


def layout_commands(monitors, workspaces, count):
    displays = layout_displays(monitors)
    if not displays:
        return []

    left, right = displays[0]["name"], displays[-1]["name"]
    targets = {number: left if number % 2 else right
               for number in range(1, count + 1)}
    commands = [f"keyword workspace {number}, monitor:{monitor}"
                for number, monitor in targets.items()]
    # Move existing workspaces too: rules alone only place newly created ones.
    commands.extend(
        f"dispatch moveworkspacetomonitor {w['id']} {targets[w['id']]}"
        for w in workspaces
        if w["id"] in targets and w["monitor"] != targets[w["id"]]
    )
    return commands


def pair_commands(monitors, pair, count):
    if not 1 <= pair <= count // 2:
        raise ValueError(f"Workspace pair must be between 1 and {count // 2}")
    displays = layout_displays(monitors)
    if not displays:
        return []
    odd = pair * 2 - 1
    if len(displays) == 1:
        return [f"dispatch workspace {odd}"]

    focused = next((m["name"] for m in monitors if m.get("focused")),
                   displays[0]["name"])
    return [
        f"dispatch focusmonitor {displays[0]['name']}",
        f"dispatch workspace {odd}",
        f"dispatch focusmonitor {displays[-1]['name']}",
        f"dispatch workspace {odd + 1}",
        f"dispatch focusmonitor {focused}",
    ]


def apply_layout(hyprctl, count):
    def query(subject):
        return json.loads(subprocess.check_output([hyprctl, "-j", subject], text=True))

    try:
        commands = layout_commands(query("monitors"), query("workspaces"), count)
        if commands:
            subprocess.run([hyprctl, "--batch", "; ".join(commands)], check=True,
                           stdout=subprocess.DEVNULL)
    except (subprocess.SubprocessError, ValueError) as error:
        print(f"Workspace layout: {error}", file=sys.stderr)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("hyprctl")
    parser.add_argument("count", type=int)
    parser.add_argument("--pair", type=int, help="Select a workspace pair instead of watching monitors")
    args = parser.parse_args()
    hyprctl, count = args.hyprctl, args.count
    if args.pair is not None:
        monitors = json.loads(subprocess.check_output([hyprctl, "-j", "monitors"], text=True))
        commands = pair_commands(monitors, args.pair, count)
        if commands:
            subprocess.run([hyprctl, "--batch", "; ".join(commands)], check=True,
                           stdout=subprocess.DEVNULL)
        return

    socket_path = (Path(os.environ["XDG_RUNTIME_DIR"]) / "hypr"
                   / os.environ["HYPRLAND_INSTANCE_SIGNATURE"] / ".socket2.sock")
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as events:
        events.connect(str(socket_path))
        apply_layout(hyprctl, count)
        with events.makefile() as stream:
            for event in stream:
                if event.partition(">>")[0] in {
                    "monitoradded", "monitorremoved", "configreloaded"
                }:
                    apply_layout(hyprctl, count)


if __name__ == "__main__":
    main()
