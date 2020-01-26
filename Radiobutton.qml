import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.4

Item
{
	id: radiobutton

    property bool selected: false
    property var siblings: []
    property alias text: label.text
    property alias mousearea: mousearea

    onSelectedChanged: image.source = selected ? "img/rb1.png" : "img/rb0.png"

    Image
    {
        id: image
        width: 2 * parent.width / 25
        height: width
        source: "img/rb0.png"
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
        onClicked:
        {
            if (!parent.selected)
            {
                parent.selected = true;

                for (var i = 0; i < parent.siblings.length; i++)
                {
                    parent.siblings[i].selected = false
                }
            }
        }
    }
}
