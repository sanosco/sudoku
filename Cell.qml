import QtQuick 2.9
import QtQuick.Window 2.3

Rectangle
{
    id: cell
    color: "#dbe9cd"
    radius: 3

    property alias content: content
    property int position: 0
    property bool active: false
    property bool marked: false
    property bool outlined: false
    property bool highlighted: false

    onActiveChanged:
    {
        var color = active ? "#0574e3" : "#000000"
        content.color = color
    }

    onMarkedChanged:
    {
        var color = marked ? "#ff0000" : "#dbe9cd"
        border.color = color
    }

    onOutlinedChanged:
    {
        var color = outlined ? "#0000ff" : marked ? "#ff0000" : "#dbe9cd"
        border.color = color
    }

    onHighlightedChanged:
    {
        var color = highlighted ? "#bfd5a9" : "#dbe9cd"
        cell.color = color
    }

    Text
    {
        id: content
        color: "#000000"
        text: qsTr("")
        renderType: Text.NativeRendering
        font.capitalization: Font.SmallCaps
        fontSizeMode: Text.VerticalFit
        font.bold: false
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent
        font.family: "Arial"
        font.pixelSize: parent.height / 2
    }

    MouseArea
    {
        id: cellMouseArea
        anchors.fill: parent
        hoverEnabled: true

        onClicked:
        {
            if (parent.active)
            {
                selection.cell = cell
                selection.open()
            }
        }

        onEntered:
        {
            if (controls.hint.selected && settingsPopup.show_dependent_positions)
            {
                sudoku.highlight_related_positions(cell.position, true)
            }
        }

        onExited:
        {
            if (controls.hint.selected && settingsPopup.show_dependent_positions)
            {
                sudoku.highlight_related_positions(cell.position, false)
            }
        }
    }
}
