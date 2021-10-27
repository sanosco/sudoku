import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.4

Popup
{
    id: helpPopup
    dim: true
    modal: true

    background: Rectangle
    {
        id: background
        color: "#ffffff"
        anchors.fill: parent
        border.color: "#ffffff"
        border.width: 1
        radius: 3
    }

    CloseButton
    {
        mouse_area.onClicked: helpPopup.close()
    }

    Item
    {
        id: rowTitle
        width: 18 * parent.width / 20
        height: width / 15
        anchors.top: parent.top
        anchors.topMargin: height / 2
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20

        Text
        {
            id: textTitle
            anchors.fill: parent
            text: qsTr("Snow Sparkle Sudoku 1.1.3")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: parent.width / 25
        }
    }

    Item
    {
        id: rowDescription
        width: 18 * parent.width / 20
        height: 2 * width / 5
        anchors.top: rowTitle.top
        anchors.topMargin: height / 4
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20

        Text
        {
            id: textDescription
            anchors.fill: parent
            text: qsTr(" This sudoku version has original generation\nalgorithm and four hardness levels. It satisfies\nclassic sudoku rules.\n Just start game and try to solve the puzzle.\nPick desired position and select value from\nappearing selection window. Also you can use\nextra pad to select number for desired hint in\ncase hints are turned on and set up.")
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.width / 25
        }
    }

    Row
    {
        id: rowCommonTitle
        width: 18 * parent.width / 20
        height: width / 10
        anchors.top: rowDescription.bottom
        anchors.topMargin: height / 2
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        spacing: width / 15

        Text
        {
            id: textCommonTitle
            text: qsTr("\tGeneral functions:")
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.width / 25
        }
    }

    Row
    {
        id: rowNewGame
        width: 18 * parent.width / 20
        height: width / 10
        anchors.top: rowCommonTitle.bottom
        anchors.topMargin: height / 3
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        spacing: width / 15

        Rectangle
        {
            id: rectangleNewGame
            width: parent.height
            height: parent.height
            color: "#dbe9cd"
            radius: 3

            Image
            {
                id: newGame
                width: 3 * parent.width / 4
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "img/run.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Text
        {
            id: element
            text: qsTr("Start a new game.")
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.width / 25
        }
    }

    Row
    {
        id: rowComlexityLevel
        width: 18 * parent.width / 20
        height: width / 10
        anchors.top: rowNewGame.bottom
        anchors.topMargin: height / 3
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        spacing: width / 15

        Rectangle
        {
            id: rectangleComlexityLevel
            width: parent.height
            height: parent.height
            color: "#dbe9cd"
            radius: 3

            Image
            {
                id: comlexityLevel
                width: 3 * parent.width / 4
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "img/star0.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Text
        {
            id: textComlexityLevel
            text: qsTr("Select complexity level.")
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.width / 25
        }
    }

    Row
    {
        id: rowHint
        width: 18 * parent.width / 20
        height: width / 10
        anchors.top: rowComlexityLevel.bottom
        anchors.topMargin: height / 3
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        spacing: width / 15

        Rectangle
        {
            id: rectangleHint
            width: parent.height
            height: parent.height
            color: "#dbe9cd"
            radius: 3

            Image
            {
                id: hint
                width: 3 * parent.width / 4
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "img/hint0.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Text
        {
            id: textHint
            text: qsTr("Turn on/off hints.")
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.width / 25
        }
    }

    Row
    {
        id: rowSettings
        width: 18 * parent.width / 20
        height: width / 10
        anchors.top: rowHint.bottom
        anchors.topMargin: height / 3
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        spacing: width / 15

        Rectangle
        {
            id: rectangleSettings
            width: parent.height
            height: parent.height
            color: "#dbe9cd"
            radius: 3

            Image
            {
                id: settings
                width: 3 * parent.width / 4
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "img/settings.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Text
        {
            id: textSettings
            text: qsTr("Select preferable hints.")
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.width / 25
        }
    }

    Row
    {
        id: rowScores
        width: 18 * parent.width / 20
        height: width / 10
        anchors.top: rowSettings.bottom
        anchors.topMargin: height / 3
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        spacing: width / 15

        Rectangle
        {
            id: rectangleScores
            width: parent.height
            height: parent.height
            color: "#dbe9cd"
            radius: 3

            Image
            {
                id: scores
                width: 3 * parent.width / 4
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "img/info.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Text
        {
            id: textScores
            text: qsTr("Show game statistics.")
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.width / 25
        }
    }

    Row
    {
        id: rowHelp
        width: 18 * parent.width / 20
        height: width / 10
        anchors.top: rowScores.bottom
        anchors.topMargin: height / 3
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        spacing: width / 15

        Rectangle
        {
            id: rectangleHelp
            width: parent.height
            height: parent.height
            color: "#dbe9cd"
            radius: 3

            Image
            {
                id: help
                width: 3 * parent.width / 4
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "img/help.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Text
        {
            id: textHelp
            text: qsTr("Show this help.")
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.width / 25
        }
    }

    Row
    {
        id: rowLicense
        width: 18 * parent.width / 20
        height: width / 10
        anchors.top: rowHelp.bottom
        anchors.topMargin: 2 * height / 3
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        spacing: width / 15

        Text
        {
            id: textLicense
            text: qsTr(" GUI is developed using Qt and distributed\nunder LGPL version 3 license term.")
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.width / 25
        }
    }
}
