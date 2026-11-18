import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Commons as Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "screensaver.toggle"

  property bool screensaverEnabled: true
  property int screensaverTimeout: 150
  property bool popupOpen: false

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function close() {
    popupOpen = false
  }

  function toggle() {
    screensaverEnabled = !screensaverEnabled
    runCommand("omarchy toggle screensaver")
    delayRefreshTimer.restart()
  }

  function launch() {
    runCommand("omarchy launch screensaver")
  }

  function refresh() {
    if (!toggleProbe.running) {
      toggleProbe.running = true
    }
  }

  function runCommand(cmd) {
    if (root.bar && typeof root.bar.run === "function") {
      root.bar.run(cmd)
    } else {
      cmdProc.command = ["bash", "-lc", cmd]
      cmdProc.running = true
    }
  }

  function formatTimeout(seconds) {
    if (!seconds || seconds <= 0) return "Disabled"
    var mins = Math.floor(seconds / 60)
    var secs = seconds % 60
    if (mins > 0 && secs > 0) return mins + "m " + secs + "s"
    if (mins > 0) return mins + (mins === 1 ? " min" : " mins")
    return seconds + "s"
  }

  Process {
    id: cmdProc
    running: false
  }

  Process {
    id: toggleProbe
    running: true
    command: ["bash", "-c", "omarchy-toggle-enabled screensaver-off && echo disabled || echo enabled; jq -r '.idle.screensaver // 150' ~/.config/omarchy/shell.json 2>/dev/null || echo 150"]
    stdout: SplitParser {
      onRead: function(line) {
        var str = String(line).trim()
        if (str === "enabled") {
          root.screensaverEnabled = true
        } else if (str === "disabled") {
          root.screensaverEnabled = false
        } else if (!isNaN(parseInt(str))) {
          root.screensaverTimeout = parseInt(str)
        }
      }
    }
  }

  FileView {
    path: Quickshell.env("HOME") + "/.local/state/omarchy/toggles"
    watchChanges: true
    printErrors: false
    onFileChanged: root.refresh()
  }

  FileView {
    path: Quickshell.env("HOME") + "/.config/omarchy/shell.json"
    watchChanges: true
    printErrors: false
    onFileChanged: root.refresh()
  }

  Timer {
    id: delayRefreshTimer
    interval: 350
    repeat: false
    onTriggered: root.refresh()
  }

  Timer {
    interval: 15000
    repeat: true
    running: true
    onTriggered: root.refresh()
  }

  ShellIpc {
    target: "screensaver.toggle"

    function toggle(): void {
      root.toggle()
    }

    function refresh(): void {
      root.refresh()
    }

    function launch(): void {
      root.launch()
    }

    function status(): string {
      return root.screensaverEnabled ? "enabled" : "disabled"
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.screensaverEnabled ? "󱄄" : "󱄅"
    active: root.screensaverEnabled
    dimmed: !root.screensaverEnabled
    tooltipText: root.screensaverEnabled
      ? "Screensaver: Enabled\n• Click: Turn off\n• Right-click: Menu / Launch"
      : "Screensaver: Disabled\n• Click: Turn on\n• Right-click: Menu / Launch"

    onPressed: function(b) {
      if (b === Qt.RightButton) {
        root.popupOpen = !root.popupOpen
      } else if (b === Qt.MiddleButton) {
        root.launch()
      } else {
        root.toggle()
      }
    }
  }

  PopupCard {
    id: popup
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.popupOpen
    contentWidth: popup.fittedContentWidth(Style.space(260))
    contentHeight: popup.fittedContentHeight(popupContent.implicitHeight)

    Column {
      id: popupContent
      width: parent ? parent.width : Style.space(260)
      spacing: Style.space(10)

      Row {
        width: parent.width
        spacing: Style.space(8)

        Text {
          textFormat: Text.PlainText
          text: root.screensaverEnabled ? "󱄄" : "󱄅"
          font.family: root.bar ? root.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.title
          color: root.screensaverEnabled ? Commons.Color.accent : Qt.darker(Commons.Color.foreground, 1.4)
          anchors.verticalCenter: parent.verticalCenter
        }

        Column {
          anchors.verticalCenter: parent.verticalCenter
          spacing: Style.space(2)

          Text {
            textFormat: Text.PlainText
            text: "Screensaver"
            font.family: Style.font.family
            font.pixelSize: Style.font.subtitle
            font.bold: true
            color: Commons.Color.foreground
          }

          Text {
            textFormat: Text.PlainText
            text: root.screensaverEnabled ? "Enabled (idle: " + root.formatTimeout(root.screensaverTimeout) + ")" : "Disabled"
            font.family: Style.font.family
            font.pixelSize: Style.font.caption
            color: Qt.darker(Commons.Color.foreground, 1.3)
          }
        }
      }

      PanelSeparator {
        width: parent.width
      }

      Toggle {
        width: parent.width
        label: "Enable Screensaver"
        description: root.screensaverEnabled ? "Runs after idle timeout" : "Suspended during idle"
        checked: root.screensaverEnabled
        onClicked: root.toggle()
      }

      PanelSeparator {
        width: parent.width
      }

      Row {
        width: parent.width
        spacing: Style.space(8)

        Button {
          width: parent.width
          text: "󱄄 Launch Now"
          bordered: true
          onClicked: {
            root.popupOpen = false
            root.launch()
          }
        }
      }
    }
  }
}
