import QtQuick 2.9
import QtQuick.Window 2.3

Image
{
    id: star
    fillMode: Image.PreserveAspectFit
    source: "img/star0.png"

    property int level: 0
    property bool selected: false

    onSelectedChanged:
    {
        if (selected)
        {
            source = "img/star1.png"
        }
        else
        {
            source = "img/star0.png"
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            if (parent.selected)
            {
                star.parent.complexity = level - 1
            }
            else
            {
                star.parent.complexity = level
            }
        }
    }
}
