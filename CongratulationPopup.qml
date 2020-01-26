import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.4

Popup
{
    id: congratulation
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
        mouse_area.onClicked: congratulation.close()
    }

    Image
    {
        id: win
        width: 4 * parent.width / 5
        height: 4 * parent.height / 5
        x: (parent.width - width) / 2
        y: (parent.height - height) / 3
        source: "img/win.png"
    }

    Text
    {
        color: "#035703"
        text: qsTr("Congratulations!")
        anchors.right: parent.right
        anchors.top: win.bottom
        anchors.left: parent.left
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: parent.height / 15
    }

    function arrange()
    {
        width = 2 * parent.width / 3
        height = 2 * parent.height / 3
        x = Math.round((parent.width - width) / 2)
        y = Math.round((parent.height - height) / 2)
    }
}
