# Omarchy Screensaver Toggle Plugin

A custom menu bar widget for [Omarchy Linux](https://omarchy.org/) (Hyprland / Quickshell) that allows you to easily toggle the screensaver on or off directly from your status bar, with instant launch and options on right-click.

![Screensaver Toggle Preview](https://raw.githubusercontent.com/chinsel/omarchy-screensaver-toggle/main/preview.png) *(or screenshot)*

---

## Features

- **One-Click Toggle**: Left-click the menu bar icon to toggle screensaver availability on or off.
  - **Enabled** (`󱄄`): Screensaver is allowed to run after your configured idle timeout (e.g. 150 seconds).
  - **Disabled** (`󱄅`): Screensaver is suspended during idle (sets Omarchy's `screensaver-off` toggle flag).
  - Native desktop notifications confirm when the screensaver is enabled or disabled.
- **Right-Click Popup Menu**:
  - Displays screensaver state and current idle timeout duration.
  - Interactive toggle switch.
  - **Launch Now** button to test or trigger the screensaver immediately.
- **Middle-Click Quick Launch**: Instant shortcut to launch the screensaver right now (`omarchy launch screensaver`).
- **Live State Sync**: Automatically watches `~/.local/state/omarchy/toggles/` so changes made via CLI or the Omarchy menu update the icon immediately.
- **CLI / IPC Control**: Control or query the widget via Quickshell IPC:
  ```bash
  omarchy-shell screensaver.toggle status
  omarchy-shell screensaver.toggle toggle
  omarchy-shell screensaver.toggle launch
  ```

---

## Installation

### Method 1: Using the Install Script
Clone this repository and run:
```bash
./install.sh
```

### Method 2: Manual Installation
Copy the files into your Omarchy user plugins folder:
```bash
mkdir -p ~/.config/omarchy/plugins/screensaver.toggle
cp manifest.json BarWidget.qml ~/.config/omarchy/plugins/screensaver.toggle/

# Rescan and enable on the bar
omarchy-shell shell rescanPlugins
omarchy plugin enable screensaver.toggle --section right
```

---

## License

MIT License.
