# Omarchy Screensaver Launcher Plugin

A clean menu bar widget for [Omarchy Linux](https://omarchy.org/) (Hyprland / Quickshell) that allows you to instantly launch the Omarchy screensaver with a single click.

---

## Features

- **One-Click Launch**: Click the screensaver icon (`󱄄`) in the menu bar to immediately launch the Omarchy screensaver.
- **Fast & Lightweight**: Minimal widget that triggers `omarchy-launch-screensaver force` without unnecessary popups or toggle overhead.
- **CLI / IPC Control**: Can also be triggered via Quickshell IPC:
  ```bash
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
