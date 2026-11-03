"""Shared, argument-based desktop and terminal actions (no shell evaluation)."""
import hashlib
import fcntl
import json
import os
from pathlib import Path
import re
import subprocess
import sys


def run(argv, **kwargs):
    return subprocess.run(argv, check=True, **kwargs)


def output(argv, **kwargs):
    return run(argv, stdout=subprocess.PIPE, text=True, **kwargs).stdout


def pick(prompt, records):
    """Return the selected value; cancellation and custom input have no effect."""
    if not records:
        print(f"{prompt}: no entries", file=sys.stderr)
        return None
    labels = [label.replace("\n", " ").replace("\r", " ") for label, _ in records]
    if os.environ.get("WAYLAND_DISPLAY"):
        argv = ["rofi", "-dmenu", "-i", "-no-custom", "-format", "i", "-p", prompt]
        result = subprocess.run(argv, input="\n".join(labels), text=True, capture_output=True)
        if result.returncode:
            return None
        selected = result.stdout.strip()
    else:
        result = subprocess.run(["fzf", "--delimiter=\t", "--with-nth=2..", "--prompt", prompt + "> "],
                                input="\n".join(f"{i}\t{label}" for i, label in enumerate(labels)),
                                text=True, stdout=subprocess.PIPE)
        if result.returncode:
            return None
        selected = result.stdout.split("\t", 1)[0]
    if selected.isdecimal() and int(selected) < len(records):
        return records[int(selected)][1]
    return None


def terminal(argv):
    if sys.stdin.isatty() and not os.environ.get("WORKSTATION_GUI"):
        return run(argv)
    return run(["ghostty", "-e", *argv])


def attach(name):
    gui = os.environ.get("WORKSTATION_GUI") == "1" or not sys.stdin.isatty()
    if os.environ.get("TMUX") and not gui:
        run(["tmux", "switch-client", "-t", name])
    elif gui:
        identifier = hashlib.sha256(name.encode()).hexdigest()[:16]
        window_class = "project-" + identifier
        if os.environ.get("HYPRLAND_INSTANCE_SIGNATURE"):
            subprocess.run(["hyprctl", "dispatch", "focuswindow", f"class:^({window_class})$"], capture_output=True)
        state = Path(os.environ.get("XDG_RUNTIME_DIR", str(Path.home() / ".local/state"))) / "workstation-projects"
        state.mkdir(parents=True, exist_ok=True, mode=0o700)
        with (state / (identifier + ".lock")).open("w") as lock:
            try:
                fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            except BlockingIOError:
                return
            clients = output(["tmux", "list-clients", "-t", "=" + name, "-F", "#{client_name}"])
            if not clients.strip():
                run(["ghostty", "--gtk-single-instance=false", "--class=" + window_class,
                     "-e", "tmux", "attach-session", "-t", "=" + name], pass_fds=(lock.fileno(),),
                    env={key: value for key, value in os.environ.items() if key not in ("TMUX", "TMUX_PANE")})
    else:
        terminal(["tmux", "attach-session", "-t", "=" + name])


def project(config, args):
    if args and args[0] == "sessions":
        sessions = subprocess.run(["tmux", "list-sessions", "-F", "#{session_name}"],
                                  text=True, capture_output=True)
        name = pick("Session", [(s, s) for s in sessions.stdout.splitlines()])
        if name:
            attach(name)
        return
    if args and args[0] == "new":
        template_root = Path(config["repoDirectory"]) / "templates"
        template = pick("Template", [(p.name, p.name) for p in sorted(template_root.iterdir())
                                     if p.is_dir() and (p / "flake.nix").exists()])
        if not template:
            return
        # A terminal prompt gives a clear destination and never merges into existing data.
        if not sys.stdin.isatty():
            terminal(["project", "create", template])
            return
        args = ["create", template]
    if args and args[0] == "create":
        if len(args) != 2 or not re.fullmatch(r"[a-z]+", args[1]):
            raise ValueError("usage: project create TEMPLATE")
        name = input("New project name (under Projects): ").strip()
        if not re.fullmatch(r"[A-Za-z0-9][A-Za-z0-9_-]*", name):
            raise ValueError("Use letters, digits, underscores or hyphens")
        path = Path(config["projectsDirectory"]) / name
        path.mkdir(parents=True, exist_ok=False)
        run(["nix", "flake", "init", "-t", f"{config['repoDirectory']}#{args[1]}"], cwd=path)
        print(f"Created {path}. Review .envrc, then run direnv allow in that directory.")
    elif args:
        if len(args) != 1:
            raise ValueError("usage: project [PATH|new|sessions]")
        path = Path(args[0]).expanduser().resolve(strict=True)
    else:
        root = Path(config["projectsDirectory"])
        candidates = []
        if root.is_dir():
            for child in sorted(root.iterdir()):
                if child.is_dir() and not child.name.startswith("."):
                    candidates.append(child)
                    candidates.extend(p for p in sorted(child.iterdir())
                                      if p.is_dir() and not p.name.startswith("."))
        selected = pick("Project", [(str(p.relative_to(root)), p) for p in candidates])
        if selected is None:
            return
        path = selected.resolve()
    if not path.is_dir():
        raise ValueError("Project path must be a directory")
    slug = re.sub(r"[^A-Za-z0-9_-]", "-", path.name)[:35]
    name = slug + "-" + hashlib.sha256(os.fsencode(path)).hexdigest()[:10]
    if subprocess.run(["tmux", "has-session", "-t", "=" + name], capture_output=True).returncode:
        run(["tmux", "new-session", "-d", "-s", name, "-c", str(path)])
        run(["tmux", "new-window", "-t", "=" + name + ":", "-n", "editor", "-c", str(path), "zsh", "-ic", "direnv exec . nvim"])
    attach(name)


def help_picker(config, args):
    if args:
        raise ValueError("usage: config-help")
    repo = Path(config["repoDirectory"])
    docs = [("README", repo / "README.md")]
    docs.extend((str(p.relative_to(repo)), p) for p in sorted((repo / "docs").rglob("*.md")))
    docs.append(("Configured actions (generated)", Path(os.environ.get("XDG_DATA_HOME", str(Path.home() / ".local/share"))) / "workstation/actions.md"))
    selected = pick("Config help", docs)
    if selected is not None:
        terminal(["nvim", "-R", str(selected)])


def menu(config, args):
    mode = args[0] if args else "actions"
    if mode == "windows":
        clients = json.loads(output(["hyprctl", "-j", "clients"]))
        selected = pick("Window", [(f"{c['workspace']['name']} · {c['class']} · {c['title']}", c["address"]) for c in clients])
        if selected:
            run(["hyprctl", "dispatch", "focuswindow", "address:" + selected])
    elif mode == "workspaces":
        spaces = json.loads(output(["hyprctl", "-j", "workspaces"]))
        selected = pick("Workspace", [(f"{s['name']} · {s['windows']} windows", s["name"]) for s in spaces])
        if selected:
            run(["hyprctl", "dispatch", "workspace", selected])
    elif mode in ("screenshot", "screenshot-full"):
        command = ["grim"]
        if mode == "screenshot":
            region = subprocess.run(["slurp"], text=True, capture_output=True)
            if region.returncode:
                return
            command.extend(["-g", region.stdout.strip()])
        picture = run([*command, "-"], stdout=subprocess.PIPE).stdout
        run(["wl-copy", "--type", "image/png"], input=picture)
    elif mode == "clipboard":
        entries = output(["cliphist", "list"]).splitlines()
        selected = pick("Clipboard", [(e, e) for e in entries])
        if selected:
            decoded = run(["cliphist", "decode"], input=selected.encode(), stdout=subprocess.PIPE).stdout
            run(["wl-copy"], input=decoded)
    elif mode == "audio":
        sinks = json.loads(output(["pactl", "--format=json", "list", "sinks"]))
        selected = pick("Default audio output", [(s["description"], s["name"]) for s in sinks])
        if selected:
            run(["pactl", "set-default-sink", selected])
    elif mode == "actions":
        records = sorted(config["actions"].items(), key=lambda pair: (pair[1]["category"], pair[1]["label"]))
        selected = pick("Actions", [(f"{a['category']} · {a['label']}", ident) for ident, a in records])
        if selected:
            # GUI actions should open a window even if Rofi was launched from a shell.
            run(config["actions"][selected]["argv"], env={**os.environ, "WORKSTATION_GUI": "1"})
    else:
        raise ValueError("Unknown menu: " + mode)


def main():
    with open(sys.argv[1]) as file:
        config = json.load(file)
    command, args = sys.argv[2], sys.argv[3:]
    if command == "project":
        project(config, args)
    elif command == "config-help":
        help_picker(config, args)
    elif command == "workstation-action":
        if len(args) != 1 or args[0] not in config["actions"]:
            raise ValueError("usage: workstation-action ID (see generated actions cheatsheet)")
        run(config["actions"][args[0]]["argv"])
    else:
        menu(config, args)


if __name__ == "__main__":
    try:
        main()
    except (EOFError, KeyboardInterrupt):
        sys.exit(0)
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        print(f"workstation: {error}", file=sys.stderr)
        sys.exit(1)
