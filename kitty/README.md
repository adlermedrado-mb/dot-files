# Kitty Configuration

This directory contains the configuration for [kitty](https://sw.kovidgoyal.net/kitty/),
a fast, GPU-based terminal emulator.

## Files

- `kitty.conf` — main configuration, symlinked to `~/.config/kitty/kitty.conf`
  by `install.sh`.

## What it sets

- **Font**: `FiraCode Nerd Font` — the font installed by the "Nerd Fonts" step
  of `install.sh`, including ligatures and the glyphs used by Starship/Neovim.
- **Maximized on launch**: kitty has no config directive to start maximized, so
  the installer adds `--start-as=maximized` to the kitty `.desktop` launcher on
  Linux. Launch manually with `kitty --start-as=maximized` if needed.
- **Theme**: Rose Pine, matching the Neovim theme used in this repo.
- Sensible defaults for scrollback, cursor, tab bar and bell.

## Installation

Run the top-level installer and accept the Kitty step:

```bash
./install.sh
```

To reload the configuration in a running kitty instance, press
`ctrl+shift+f5`.
