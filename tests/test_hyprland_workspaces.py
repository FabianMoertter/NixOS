"""Dock layout behavior without a running Hyprland session."""

import importlib.util
from pathlib import Path
import unittest

spec = importlib.util.spec_from_file_location(
    "hyprland_workspaces", Path(__file__).parents[1] / "scripts/hyprland-workspaces.py"
)
layout = importlib.util.module_from_spec(spec)
spec.loader.exec_module(layout)


class WorkspaceLayoutTests(unittest.TestCase):
    def test_dock_uses_position_instead_of_connector_order(self):
        monitors = [
            {"name": "DP-6", "x": -1920, "y": 0},
            {"name": "DP-9", "x": -3840, "y": 0},
        ]
        commands = layout.layout_commands(monitors, [], 6)
        self.assertEqual(len(commands), 6)
        for number, command in enumerate(commands, 1):
            target = "DP-9" if number % 2 else "DP-6"
            self.assertEqual(command, f"keyword workspace {number}, monitor:{target}")

    def test_open_panel_does_not_replace_the_external_pair(self):
        monitors = [
            {"name": "eDP-1", "x": 0, "y": 0},
            {"name": "DP-3", "x": -1920, "y": 0},
            {"name": "DP-4", "x": -3840, "y": 0},
        ]
        commands = layout.layout_commands(monitors, [], 6)
        self.assertIn("keyword workspace 1, monitor:DP-4", commands)
        self.assertIn("keyword workspace 2, monitor:DP-3", commands)
        self.assertFalse(any("eDP-1" in command for command in commands))

    def test_undocking_returns_existing_workspaces_to_panel(self):
        monitors = [{"name": "eDP-1", "x": 0, "y": 0}]
        workspaces = [
            {"id": 1, "monitor": "DP-9"},
            {"id": 2, "monitor": "eDP-1"},
            {"id": -99, "monitor": "DP-9"},
        ]
        commands = layout.layout_commands(monitors, workspaces, 6)
        self.assertEqual(len(commands), 7)
        self.assertEqual(commands[-1], "dispatch moveworkspacetomonitor 1 eDP-1")
        self.assertTrue(all("monitor:eDP-1" in command for command in commands[:6]))

    def test_single_external_display_and_panel_alternate(self):
        monitors = [
            {"name": "eDP-1", "x": 0, "y": 0},
            {"name": "HDMI-A-1", "x": -1920, "y": 0},
        ]
        commands = layout.layout_commands(monitors, [{"id": 1, "monitor": "eDP-1"}], 6)
        self.assertIn("keyword workspace 1, monitor:HDMI-A-1", commands)
        self.assertIn("keyword workspace 2, monitor:eDP-1", commands)
        self.assertIn("dispatch moveworkspacetomonitor 1 HDMI-A-1", commands)

    def test_no_active_displays_is_a_noop(self):
        self.assertEqual(layout.layout_commands([], [], 6), [])
        self.assertEqual(layout.layout_commands([
            {"name": "eDP-1", "x": 0, "y": 0, "disabled": True},
            {"name": "DP-1", "x": 0, "y": 0, "mirrorOf": "eDP-1"},
        ], [], 6), [])


if __name__ == "__main__":
    unittest.main()
