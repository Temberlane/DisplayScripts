# DisplayScripts

One-keystroke toggle between two MacBook + external monitor layouts on macOS, powered by [`displayplacer`](https://github.com/jakehilborn/displayplacer).

## What this is for

The very specific setup this was built for: a **laptop on a stand next to an external monitor**, where the laptop's role changes depending on what you're doing.

- **In a meeting** — pull the MacBook off the stand and put it in front of you. Camera centered, face centered. The display arrangement should match: external monitor stacked above, MacBook stacked below (`up-and-down`).
- **Working / focused** — push the laptop back onto the stand to the side, external keyboard and mouse in front of you, external as the main canvas (`side-by-side`).

Doing this from System Settings → Displays every time is friction. This toggles between the two with one shortcut.

```
┌───────────────────────────────┐         ┌──────┐ ┌─────────────────────┐
│   External 3440×1440 (top)    │         │ Mac  │ │  External 3440×1440 │
└───────────────────────────────┘         │ Book │ │      (main)         │
        ┌──────────────┐                  │ left │ │                     │
        │   MacBook    │  ← meeting mode  └──────┘ └─────────────────────┘
        └──────────────┘                          ↑ focus mode
```

A scale diagram is in [`diagram.svg`](./diagram.svg).

## Install

### Option A — Raycast extension (recommended)

Once accepted into the Raycast Store:

```
raycast://extensions/Thomas/display-scripts
```

The extension source is at [`./raycast-extension/`](./raycast-extension/) and mirrors the canonical copy under [`raycast/extensions`](https://github.com/raycast/extensions/tree/main/extensions/display-scripts).

After install, open Raycast preferences for the extension and set:

| Preference | What to put |
| --- | --- |
| External Display ID | `displayplacer list` → external monitor's `Persistent screen id` |
| MacBook Display ID | `displayplacer list` → MacBook's `Persistent screen id` |
| MacBook Origin (Side-by-Side) | The `Origin:` you want for focus mode (e.g. `(-1512,360)`) |
| MacBook Origin (Up-and-Down) | The `Origin:` you want for meeting mode (e.g. `(949,1440)`) |
| Path to displayplacer | `/opt/homebrew/bin/displayplacer` on Apple Silicon, `/usr/local/bin/displayplacer` on Intel |

Bind it to a Raycast hotkey and the toggle is one keystroke.

### Option B — Shell script

```sh
brew install displayplacer
chmod +x arrange_displays.sh
./arrange_displays.sh toggle
```

Supported layout arguments:

- `toggle` (default) — auto-detect current layout and switch to the other
- `side-by-side`
- `up-and-down`
- `external-left` — external left, MacBook right
- `laptop-only`
- `external-only` — useful when the lid is closed

## Tuning for your hardware

The script and the extension hardcode resolution/refresh-rate values for the author's specific monitors:

| Display | Resolution | Refresh | Notes |
| --- | --- | --- | --- |
| External | 3440×1440 | 144 Hz | Rotated 180° (ultrawide hung upside-down) |
| MacBook | 1512×982 | 120 Hz | HiDPI scaling |

Two parameters that you'll most likely want to change without touching the rest:

- **Display IDs** — every Mac generates its own UUIDs per port. Run `displayplacer list` and copy the IDs.
- **`MACBOOK_ORIGIN`** — the laptop's `Origin:` coordinate in each of the two layouts. These are also what the `toggle` detection compares against to figure out which layout you're currently in.

If your resolutions or refresh rates differ from the ones above, edit `arrange_displays.sh` (or `raycast-extension/src/toggle-arrangement.tsx` → `buildLayoutArgs`).

## License

MIT.
