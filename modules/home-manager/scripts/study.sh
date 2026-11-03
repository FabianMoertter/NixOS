# Included by writeShellApplication; Neovim is resolved from the user's
# configured Home Manager package instead of adding an unconfigured binary.
usage() {
  printf '%s\n' 'study start japanese|programming|reading|general' \
    'study status | stop | resources | input' \
    'study input toggles the configured Fcitx input method; select Mozc first.'
}

state_directory="${XDG_STATE_HOME:-$HOME/.local/state}/workstation-study"
mkdir -p "$state_directory"

case "${1:-help}" in
  status)
    if [[ -f "$state_directory/active" ]]; then
      printf 'Active study mode: %s\n' "$(cat "$state_directory/active")"
    else
      printf '%s\n' 'No active study mode.'
    fi
    exit 0
    ;;
  stop)
    # Ending a mode never destroys an editor or an unfinished exercise.
    exec 9>"$state_directory/state.lock"
    flock 9
    rm -f -- "$state_directory/active"
    printf '%s\n' 'Study mode stopped. Sessions and notes are preserved.'
    exit 0
    ;;
  input)
    exec fcitx5-remote -t
    ;;
  resources)
    exec firefox -P learning --new-window 'https://yomitan.wiki/getting-started/'
    ;;
  start)
    mode="${2:-}"
    case "$mode" in
      japanese|programming|reading|general) ;;
      *) usage >&2; exit 2 ;;
    esac
    ;;
  help|--help|-h) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac

directory="$STUDY_DIRECTORY/$mode"
session="study-$mode"
mkdir -p "$directory"

# Serialize first launch, journal creation, and active-mode updates.
exec 9>"$state_directory/state.lock"
flock 9
if [[ ! -e "$directory/journal.md" ]]; then
  printf '# %s study\n\n## Goal\n\n## Notes\n\n## Questions\n\n## Next session\n' "$mode" >"$directory/journal.md"
fi
created=0
if ! tmux has-session -t "=$session" 2>/dev/null; then
  created=1
  printf -v editor_command '%q ' nvim "$directory/journal.md"
  tmux new-session -d -s "$session" -c "$directory" -n notes "$editor_command"
  tmux new-window -d -t "$session:" -n practice -c "$directory"
fi
printf '%s\n' "$mode" >"$state_directory/active"
flock -u 9
exec 9>&-

# Only the first creation launches supporting apps; resuming keeps the layout.
if [[ "$created" == 1 && "$mode" == japanese ]]; then
  firefox -P learning --new-window >>"$state_directory/browser.log" 2>&1 &
  anki >>"$state_directory/anki.log" 2>&1 &
fi

if [[ "${WORKSTATION_GUI:-0}" != 1 && -n "${TMUX:-}" ]]; then
  exec tmux switch-client -t "=$session"
elif [[ "${WORKSTATION_GUI:-0}" != 1 && -t 0 && -t 1 ]]; then
  exec tmux attach-session -t "=$session"
else
  # A separate Ghostty process keeps flock held for the window's lifetime.
  # Repeated picker activations focus the existing window instead of opening
  # more attached clients; launch races are covered by the same lock.
  if command -v hyprctl >/dev/null 2>&1 && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    hyprctl dispatch focuswindow "class:^(study-$mode)$" >/dev/null 2>&1 || true
  fi
  (
    exec 8>"$state_directory/$mode-window.lock"
    flock -n 8 || exit 0
    if [[ -n "$(tmux list-clients -t "=$session" -F '#{client_name}' 2>/dev/null)" ]]; then
      exit 0
    fi
    exec env -u TMUX -u TMUX_PANE ghostty --gtk-single-instance=false --class="study-$mode" \
      --title="Study: $mode" --working-directory="$directory" \
      -e tmux attach-session -t "=$session"
  ) </dev/null >>"$state_directory/$mode-window.log" 2>&1 &
fi
