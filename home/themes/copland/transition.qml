pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
    id: shellRoot
    readonly property real transitionDuration: 2.4
    readonly property real firstWindowDeadline: 7
    property double startedAtMs: Date.now()
    property double clockMs: startedAtMs
    readonly property real elapsed: Math.max(0, (clockMs - startedAtMs) / 1000)
    property real finishAt: transitionDuration
    property bool firstWindowReady: false

    Component.onCompleted: console.info("Copland transition started")

    Timer {
        interval: 16
        repeat: true
        running: true
        onTriggered: {
            shellRoot.clockMs = Date.now()
            if (shellRoot.firstWindowReady && shellRoot.elapsed >= shellRoot.finishAt) {
                console.info("Copland transition finished")
                Qt.quit()
            } else if (!shellRoot.firstWindowReady && shellRoot.elapsed >= shellRoot.firstWindowDeadline) {
                console.error("Copland transition timed out waiting for a monitor window")
                Qt.quit()
            }
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: root

            required property var modelData
            screen: modelData
            anchors {
                left: true
                right: true
                top: true
                bottom: true
            }
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            color: "#0b1423"

            property real startedAt: 0
            readonly property real elapsed: Math.max(0, shellRoot.elapsed - startedAt)
            readonly property bool leaving: Quickshell.env("COPLAND_TRANSITION_MODE") === "logout"
            readonly property real progress: Math.min(elapsed / shellRoot.transitionDuration, 1)
            readonly property real logoOpacity: leaving
                ? 1 - Math.max(0, Math.min((elapsed - (shellRoot.transitionDuration - 0.6)) / 0.6, 1))
                : Math.max(0, Math.min(elapsed / 0.45, 1))
            readonly property real coreTravel: Math.min(elapsed / 1.8, 1)
            readonly property real coreOpacity: leaving
                ? Math.max(0, 1 - Math.max(0, Math.min((elapsed - (shellRoot.transitionDuration - 0.6)) / 0.6, 1)))
                : 1 - logoOpacity * 0.48
            readonly property real satelliteDeployment: leaving
                ? 1 - Math.max(0, Math.min((elapsed - (shellRoot.transitionDuration - 1.0)) / 1.0, 1))
                : Math.max(0, Math.min((elapsed - 0.5) / 1.1, 1))
            readonly property real centerX: width / 2
            readonly property real centerY: height * 0.40
            readonly property real emblemSize: Math.min(width * 0.34, height * 0.43, 360)
            readonly property real statusPhaseDuration: shellRoot.transitionDuration / 2
            readonly property real statusPhaseTime: elapsed % statusPhaseDuration
            readonly property real statusOpacity: Math.min(statusPhaseTime / 0.16, 1)
                * Math.min((statusPhaseDuration - statusPhaseTime) / 0.16, 1)
            readonly property string statusText: leaving
                ? (elapsed < statusPhaseDuration ? "Salvando o estado da sessao..."
                    : "Navi: encerrando a sessao com seguranca...")
                : (elapsed < statusPhaseDuration ? "Inicializando Copland OS Enterprise..."
                    : "Sessao pronta. Bem-vindo.")

            Component.onCompleted: {
                startedAt = shellRoot.elapsed
                shellRoot.firstWindowReady = true
                shellRoot.finishAt = Math.max(
                    shellRoot.finishAt,
                    shellRoot.elapsed + shellRoot.transitionDuration
                )
                console.info("Copland transition window opened:", leaving ? "logout" : "login")
            }

            Rectangle {
                anchors.fill: parent
                color: "#0b1423"
            }

            Image {
                id: ripple
                source: Qt.resolvedUrl("ripple.svg")
                width: root.emblemSize * (0.35 + (root.leaving ? 1 - root.progress : root.progress) * 1.3)
                height: width * 0.375
                x: root.centerX - width / 2
                y: root.centerY - height / 2
                opacity: root.leaving
                    ? Math.min(root.elapsed / 0.5, 1) * (1 - root.progress) * 0.75
                    : Math.max(0, 1 - root.progress) * 0.65
                fillMode: Image.PreserveAspectFit
                transform: Rotation {
                    origin.x: ripple.width / 2
                    origin.y: ripple.height / 2
                    angle: root.elapsed * 4
                }
            }

            Repeater {
                model: 3

                Rectangle {
                    id: satelliteRay
                    required property int index
                    width: root.emblemSize * 0.40 * root.satelliteDeployment
                    height: 1
                    x: root.centerX
                    y: root.centerY
                    color: "#5d9bbd"
                    opacity: root.satelliteDeployment * 0.35
                    transform: Rotation {
                        origin.x: 0
                        origin.y: 0
                    angle: root.elapsed * 1.4 + satelliteRay.index * 120
                    }
                }
            }

            Image {
                id: emblem
                source: Qt.resolvedUrl("logo.svg")
                width: root.emblemSize
                height: width
                x: root.centerX - width / 2
                y: root.centerY - height / 2
                opacity: root.logoOpacity
                scale: root.leaving ? 1 + root.progress * 0.08 : 0.91 + root.logoOpacity * 0.09
                fillMode: Image.PreserveAspectFit
            }

            Image {
                id: core
                source: Qt.resolvedUrl("orb.svg")
                property real size: root.emblemSize * 0.22
                width: size
                height: size
                x: root.centerX - width / 2
                y: root.centerY - height / 2 - (1 - root.coreTravel) * root.height * 0.50
                opacity: root.coreOpacity
                fillMode: Image.PreserveAspectFit
            }

            Repeater {
                model: 3

                Image {
                    id: satelliteOrb
                    required property int index
                    source: Qt.resolvedUrl("orb.svg")
                    property real size: root.emblemSize * 0.075
                    width: size
                    height: size
                    x: root.centerX + Math.sin(root.elapsed * 0.9 + satelliteOrb.index * 2.094)
                        * root.emblemSize * 0.4 * root.satelliteDeployment - width / 2
                    y: root.centerY + Math.cos(root.elapsed * 0.9 + satelliteOrb.index * 2.094)
                        * root.emblemSize * 0.4 * root.satelliteDeployment - height / 2
                    opacity: root.satelliteDeployment * 0.72
                    fillMode: Image.PreserveAspectFit
                }
            }

            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                y: root.centerY + root.emblemSize * 0.51
                spacing: 7
                opacity: root.logoOpacity

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Copland OS"
                    color: "#b9d8ed"
                    font.family: "Inter"
                    font.pixelSize: 27
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "ENTERPRISE"
                    color: "#5d9bbd"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                y: root.centerY + root.emblemSize * 0.68
                width: root.width * 0.84
                horizontalAlignment: Text.AlignHCenter
                text: root.statusText
                color: "#9abbd0"
                opacity: root.statusOpacity
                font.family: "Inter"
                font.pixelSize: 16
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
            }

            Image {
                anchors.fill: parent
                source: Qt.resolvedUrl("scanlines.svg")
                opacity: 0.11
                fillMode: Image.Stretch
            }

        }
    }
}
