import QtQuick 2.9
import QtQuick.Window 2.3

Image
{
    id: settings
    fillMode: Image.PreserveAspectFit
    source: "img/settings.png"

    MouseArea
    {
        anchors.fill: parent
        onClicked: settingsPopup.open()
    }
}
