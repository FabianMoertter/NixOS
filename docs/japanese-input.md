# Japanese input with rōmaji on NixOS

The common solution is a Japanese **IME** (input method editor). It keeps the
existing keyboard layout and interprets Latin letters as **rōmaji**:

```text
arigatou → ありがとう
```

While composing text:

- Press `Enter` to keep the hiragana.
- Press `Space` to see kanji candidates, such as `ありがとう` or `有難う`.
- Switch the IME off to type normal Latin letters again.

## Recommended software

On NixOS, use **Fcitx5 with Mozc**. Mozc is the open-source Japanese IME that
originated from Google Japanese Input, while Fcitx5 connects it to Linux
applications.

Add the following to the NixOS configuration:

```nix
i18n.inputMethod = {
  enable = true;
  type = "fcitx5";

  fcitx5.addons = with pkgs; [
    fcitx5-mozc
    fcitx5-gtk
  ];
};
```

After rebuilding and logging in again, add **Mozc** in the Fcitx5
configuration tool. A shortcut such as `Ctrl+Space` is normally used to toggle
Japanese input.

## Learner examples

```text
nihongo     → にほんご
sensei      → せんせい
gakkou      → がっこう
konnichiwa  → こんにちは
```

Useful conventions:

- Double a consonant for small `っ`: `gakkou` → `がっこう`.
- Type `nn` when `ん` could be ambiguous: `konnichi` → `こんにち`.
- Type grammatical particles according to their written spelling. For
  example, type `ha` for `は`, even when it is pronounced “wa.”
- Leave Mozc in rōmaji input mode; there is no need to learn the Japanese kana
  keyboard layout.

Mozc is useful for real Japanese writing and eventual kanji conversion. It
does not check whether a word or sentence is grammatically correct, so it
complements rather than replaces kana study.

## References

- [Mozc project](https://github.com/google/mozc)
- [Fcitx5 on the NixOS Wiki](https://wiki.nixos.org/wiki/Fcitx5)
- [Mozc on the NixOS Wiki](https://wiki.nixos.org/wiki/Mozc)
