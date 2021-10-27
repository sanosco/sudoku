import QtQuick 2.9
import QtQuick.Window 2.3

Image
{
    id: help
    fillMode: Image.PreserveAspectFit
    source: "img/help.png"

    MouseArea
    {
        anchors.fill: parent
        onClicked: helpPopup.open()
    }
}
