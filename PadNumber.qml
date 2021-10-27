import QtQuick 2.9
import QtQuick.Window 2.3

Rectangle
{
    radius: height / 2
    border.color: value.text === board.outlined_value ? "#a8b39d" : "#dbe9cd"
    border.width: height / 15

    property alias value: value.text

    Text
    {
        id: value
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
        anchors.fill: parent
        onClicked:
        {
            var outline = value.text !== board.outlined_value
            board.point_value_positions(value.text, outline)
        }
    }
}
