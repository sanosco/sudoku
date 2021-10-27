import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.4

Popup
{
    id: popupYesNo
    dim: true
    modal: true

    property bool yes: false

    background: Rectangle
    {
        id: background
        anchors.fill: parent
        border.color: "#dbe9cd"
        border.width: 1
        radius: 3
    }

    Text
    {
        id: title
        anchors.top: parent.top
        anchors.topMargin: parent.height / 20
        anchors.leftMargin: parent.width / 20
        anchors.rightMargin: parent.width / 20
        width: parent.width
        height: 2 * parent.height / 3 - anchors.topMargin
        text: qsTr("Do you really want\nto clear statistics?")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: parent.height / 10
    }

    Text
    {
        id: yesLabel
        color: "#0000ff"
        anchors.top: title.bottom
        anchors.left: parent.left
        anchors.topMargin: parent.height / 20
        anchors.leftMargin: parent.width / 20
        anchors.bottomMargin: parent.height / 20
        width: parent.width / 2 - anchors.leftMargin
        height: parent.height / 3 - anchors.bottomMargin
        text: qsTr("Yes")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: parent.height / 10

        MouseArea
        {
            anchors.fill: parent

            onClicked:
            {
                yes = true;
                popupYesNo.close()
            }
        }
    }

    Text
    {
        color: "#0000ff"
        anchors.top: title.bottom
        anchors.right: parent.right
        anchors.topMargin: parent.height / 20
        anchors.rightMargin: parent.width / 20
        anchors.bottomMargin: parent.height / 20
        width: parent.width / 2 - anchors.rightMargin
        height: parent.height / 3 - anchors.bottomMargin
        text: qsTr("No")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: parent.height / 10

        MouseArea
        {
            anchors.fill: parent

            onClicked:
            {
                popupYesNo.close()
            }
        }
    }

    onOpened:
    {
        yes = false
    }
}
