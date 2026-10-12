import QtQuick
import QtQuick.Shapes
import qs.Commons

// Bar icon: a thin monochrome outline (rounded square + plus, drawn from SVG
// path data) in the bar foreground, like every native Omarchy bar icon.
// State lives in one plain corner dot (no count text — unreadable at bar
// height): red/amber when something needs you, no dot when all good,
// dimmed glyph when not checked yet.
Item {
    id: root
    property string state: "unknown"
    property int count: 0
    property bool busy: false
    property var bar: null
    property color ink: bar ? bar.barForeground : Color.foreground
    readonly property color badFill: bar ? bar.urgent : "#e5484d"
    readonly property color warnFill: "#d4a017"
    readonly property real glyphBase: root.state === "unknown" ? 0.45 : 1.0

    Item {
        id: glyph
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height)
        height: width
        opacity: root.glyphBase

        // 100-unit SVG box scaled to fit: visual size always equals glyph.
        Item {
            width: 100; height: 100
            scale: glyph.width / 100
            transformOrigin: Item.TopLeft
            Shape {
                width: 100; height: 100
                antialiasing: true
                layer.enabled: true
                layer.samples: 4
                ShapePath {
                    fillColor: "transparent"
                    strokeColor: root.ink
                    strokeWidth: 6
                    PathSvg { path: "M 32 10 H 68 A 22 22 0 0 1 90 32 V 68 A 22 22 0 0 1 68 90 H 32 A 22 22 0 0 1 10 68 V 32 A 22 22 0 0 1 32 10 Z" }
                }
                ShapePath {
                    fillColor: "transparent"
                    strokeColor: root.ink
                    strokeWidth: 10
                    capStyle: ShapePath.RoundCap
                    PathSvg { path: "M 50 34 V 66 M 34 50 H 66" }
                }
            }
        }

        SequentialAnimation on opacity {
            running: root.busy; loops: Animation.Infinite
            NumberAnimation { to: 0.45; duration: 600; easing.type: Easing.InOutSine }
            NumberAnimation { to: root.glyphBase; duration: 600; easing.type: Easing.InOutSine }
            onRunningChanged: if (!running) glyph.opacity = root.glyphBase
        }
    }

    Rectangle {
        visible: root.count > 0
        anchors.right: parent.right; anchors.bottom: parent.bottom
        width: Math.max(7, Math.round(parent.width * 0.30)); height: width
        radius: width / 2
        color: root.state === "bad" ? root.badFill : root.warnFill
    }
}
