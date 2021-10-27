import QtQuick 2.9
import QtQuick.Window 2.3

Rectangle
{
    id: closeButton
    x: parent.width - width
    width: 20
    height: 20
    radius: 10
    border.width: 1
    color: "#f24040"
    border.color: "#f24040"

    property alias mouse_area: close_btn_mouse_area

    Image
    {
        anchors.fill: parent
        source: "img/x.png"
    }

    MouseArea
    {
        id: close_btn_mouse_area
        anchors.fill: parent
    }
}
