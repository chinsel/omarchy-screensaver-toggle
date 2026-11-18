import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Commons as Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "screensaver.toggle"

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function launch() {
    runCommand("omarchy launch screensaver &")
  }

  function runCommand(cmd) {
    if (root.bar && typeof root.bar.run === "function") {
      root.bar.run(cmd)
    } else {
      cmdProc.command = ["bash", "-c", cmd]
      cmdProc.running = true
    }
  }

  Process {
    id: cmdProc
    running: false
  }

  ShellIpc {
    target: "screensaver.toggle"

    function launch(): void {
      root.launch()
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "󱄄"
    tooltipText: "Launch Screensaver"

    onPressed: function() {
      root.launch()
    }
  }
}
