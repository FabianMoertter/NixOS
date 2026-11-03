"""Selection and dispatch boundaries: no desktop session required."""
import importlib.util
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("workstation", Path(__file__).parents[1] / "scripts/workstation.py")
workstation = importlib.util.module_from_spec(spec)
spec.loader.exec_module(workstation)


class PickerTests(unittest.TestCase):
    @patch.dict(os.environ, {"WAYLAND_DISPLAY": "test"})
    def test_cancel_does_not_select(self):
        with patch.object(workstation.subprocess, "run", return_value=subprocess.CompletedProcess([], 1, "")):
            self.assertIsNone(workstation.pick("Test", [("Entry", "id")]))

    @patch.dict(os.environ, {"WAYLAND_DISPLAY": "test"})
    def test_display_label_never_becomes_command(self):
        with patch.object(workstation.subprocess, "run", return_value=subprocess.CompletedProcess([], 0, "0\n")) as process:
            self.assertEqual(workstation.pick("Test", [("$(touch /tmp/unsafe)", "safe-id")]), "safe-id")
            self.assertNotIn("shell", process.call_args.kwargs)

    @patch.dict(os.environ, {"WAYLAND_DISPLAY": "test"})
    def test_invalid_indexes_do_not_select(self):
        for value in ["-1", "9", "label", ""]:
            with patch.object(workstation.subprocess, "run", return_value=subprocess.CompletedProcess([], 0, value)):
                self.assertIsNone(workstation.pick("Test", [("Entry", "id")]))

    def test_no_entries_do_not_launch_picker(self):
        with patch.object(workstation.subprocess, "run") as process:
            self.assertIsNone(workstation.pick("Test", []))
            process.assert_not_called()

    def test_project_creation_rejects_escape(self):
        with patch("builtins.input", return_value="../escape"):
            with self.assertRaises(ValueError):
                workstation.project({"projectsDirectory": "/tmp/unused"}, ["create", "python"])

    def test_existing_project_is_not_overwritten(self):
        with tempfile.TemporaryDirectory() as root:
            (Path(root) / "existing").mkdir()
            with patch("builtins.input", return_value="existing"), patch.object(workstation, "run") as run:
                with self.assertRaises(FileExistsError):
                    workstation.project({"projectsDirectory": root}, ["create", "python"])
                run.assert_not_called()

    def test_action_dispatch_uses_registered_argv(self):
        config = {"actions": {"test": {"category": "Test", "label": "Test", "argv": ["command", "argument with spaces"]}}}
        with patch.object(workstation, "pick", return_value="test"), patch.object(workstation, "run") as run:
            workstation.menu(config, [])
            self.assertEqual(run.call_args.args[0], ["command", "argument with spaces"])

    def test_window_selection_uses_address(self):
        clients = '[{"workspace":{"name":"1"},"class":"test","title":"A","address":"0xabc"}]'
        with patch.object(workstation, "output", return_value=clients), patch.object(workstation, "pick", return_value="0xabc"), patch.object(workstation, "run") as run:
            workstation.menu({}, ["windows"])
            run.assert_called_once_with(["hyprctl", "dispatch", "focuswindow", "address:0xabc"])

    def test_screenshot_cancellation_preserves_clipboard(self):
        with patch.object(workstation.subprocess, "run", return_value=subprocess.CompletedProcess([], 1, "")), patch.object(workstation, "run") as run:
            workstation.menu({}, ["screenshot"])
            run.assert_not_called()

    def test_gui_attachment_does_not_inherit_nested_tmux(self):
        with tempfile.TemporaryDirectory() as root:
            with patch.dict(os.environ, {"XDG_RUNTIME_DIR": root, "WORKSTATION_GUI": "1", "TMUX": "old"}, clear=True), patch.object(workstation, "output", return_value=""), patch.object(workstation, "run") as run:
                workstation.attach("test-session")
                self.assertEqual(run.call_args.args[0][0], "ghostty")
                self.assertNotIn("TMUX", run.call_args.kwargs["env"])


if __name__ == "__main__":
    unittest.main()
