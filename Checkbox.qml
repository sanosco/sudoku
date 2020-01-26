import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.4

Item
{
    id: checkbox

    property bool checked: false
    property alias text: label.text
    property alias mousearea: mousearea

    onCheckedChanged: image.source = checked ? "img/checkbox1.png" : "img/checkbox0.png"

    Image
    {
        id: image
        width: 2 * parent.width / 25
        height: width
        source: "img/checkbox0.png"
        fillMode: Image.PreserveAspectFit
    }

    Text
    {
        id: label
        width: parent.width - image.width
        height: parent.height
        text: qsTr("")
        font.family: "Arial"
        font.pixelSize: parent.width / 15
        font.bold: false
        anchors.left: image.right
        anchors.leftMargin: image.width / 2
    }

    MouseArea
    {
        id: mousearea
        anchors.fill: parent
        onClicked: parent.checked = !parent.checked
    }
}




















