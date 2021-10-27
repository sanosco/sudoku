import QtQuick 2.9
import QtQuick.Window 2.3

Image
{
	id: info
    fillMode: Image.PreserveAspectFit
    source: "img/info.png"

    MouseArea
    {
        anchors.fill: parent
        onClicked: scorePopup.open()
    }
}
