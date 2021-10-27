import QtQuick 2.9
import QtQuick.Window 2.3

Item
{
    property int complexity: 0

    Star
    {
        id: easy
        level: 1
        anchors.verticalCenter: parent.verticalCenter
    }

    Star
    {
        id: medium
        level: 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: easy.right
        anchors.leftMargin: 0
    }

    Star
    {
        id: hard
        level: 3
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: medium.right
        anchors.leftMargin: 0
    }

    onWidthChanged:
    {
        easy.width = height
        easy.height = height

        medium.width = height
        medium.height = height

        hard.width = height
        hard.height = height
    }

    onComplexityChanged:
    {
        switch(complexity)
        {
        case 0:
            easy.selected = false
            medium.selected = false
            hard.selected = false
            break

        case 1:
            easy.selected = true
            medium.selected = false
            hard.selected = false
            break

        case 2:
            easy.selected = true
            medium.selected = true
            hard.selected = false
            break

        case 3:
            easy.selected = true
            medium.selected = true
            hard.selected = true
            break
        }
    }
}
