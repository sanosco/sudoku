import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.4

Popup
{
    id: retry
    dim: true
    modal: true

    background: Rectangle
    {
        id: background
        anchors.fill: parent
        border.color: "#dbe9cd"
        border.width: 1
        radius: 3
    }

    CloseButton
    {
        mouse_area.onClicked: retry.close()
    }

    Image
    {
        anchors.fill: parent
        source: "img/no.png"
    }

    Text
    {
        anchors.fill: parent
        text: qsTr("Puzzle is not\ncompleted. Try\nonce again.")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: parent.height / 10
    }

    function arrange()
    {
        width = 2 * parent.width / 3
        height = 2 * parent.height / 3
        x = Math.round((parent.width - width) / 2)
        y = Math.round((parent.height - height) / 2)
    }
}
