# Learning sessions

Each mode provides a persistent tmux session with a Neovim journal and a practice
window. Notes live under `~/Documents/Learning/<mode>/journal.md`; edit the
`workstation.studyDirectory` option to choose a different writable location.

```sh
study start japanese
study start programming
study start reading
study start general
study status
study stop
```

Starting again reuses the session. Rofi opens a dedicated Ghostty window and
focuses it on repeated launches. The terminal command attaches or switches the
current tmux client. `study stop` clears the active-mode marker; it preserves
sessions, applications, and unsaved editor work. Modes do not change notification
or input state automatically.
The bar shows the selected mode and refreshes it within ten seconds.

## Japanese reading and review

The first creation of the Japanese session also opens Anki and the separate
Firefox `learning` profile. `study resources` reopens that profile's Yomitan
setup guide. Anki remains available through the action picker for later review.

1. Install [Yomitan](https://yomitan.wiki/getting-started/) in the learning profile
   and import appropriate dictionaries.
2. Start Anki, create/select your Japanese deck and note type, then configure
   [Yomitan's Anki integration](https://yomitan.wiki/anki/). AnkiConnect is already
   enabled in the Nix configuration.
3. Map expression, reading, sentence, and source fields; add audio if your
   dictionary/source provides it. Test one card before capturing many.
4. Read in Firefox, capture useful words in context, and record grammar questions
   and short writing exercises in the journal.
5. Review cards and finish with a short note about the next session.

Fcitx5/Mozc and a Japanese CJK font are installed. Select Mozc in Fcitx's
configuration first. `study input` explicitly toggles the configured input method;
it does not select Mozc or change the US/German keyboard layout. See
[Japanese input](japanese-input.md) for composition examples. Keep the IME off
while entering Vim normal-mode commands.

## Other modes

For programming practice, use the practice window to enter an exercise project
with its own devshell, run tests, and record the lesson learned. For reading,
open Zotero or a PDF/browser alongside the journal and save the source with each
note. General study is a reusable place for recall questions and topic notes.

Back up the learning directory and Anki's user data separately from this Git
repository. The Nix configuration installs tools; it does not store your cards,
dictionaries, browser data, or notes.
