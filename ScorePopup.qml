import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.4

Popup
{
    id: scorePopup
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
        mouse_area.onClicked: scorePopup.close()
    }

    Text
    {
        id: scoreTitle
        width: 18 * parent.width / 20
        height: width / 10
        anchors.top: parent.top
        anchors.topMargin: height / 2
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        text: qsTr("Scores")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: parent.width / 22
    }

    Item
    {
        id: currentGameProfile
        width: 18 * parent.width / 20
        height: width / 15
        anchors.top: scoreTitle.bottom
        anchors.topMargin: height / 3
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20

        Text
        {
            id: currentGameProfileText
            anchors.fill: parent
            text: ""
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.width / 25
        }
    }

    Component
    {
        id: scoreDelegate
        Row
        {
            width: parent.width

            Text
            {
                id: scoreLevelText
                width: 35 * parent.width / 100
                text: level
                font.pixelSize: parent.width / 25
            }

            Text
            {
                id: scoreWinsText
                width: 25 * parent.width / 100
                text: wins
                font.pixelSize: parent.width / 25
            }

            Text
            {
                id: scoreFailsText
                width: 25 * parent.width / 100
                text: loses
                font.pixelSize: parent.width / 25
            }

            Text
            {
                id: scoreTotalText
                width: 25 * parent.width / 100
                text: wins + loses
                font.pixelSize: parent.width / 25
            }
        }
    }

    ListModel
    {
        id: scoreListWithoutHintsModel
    }

    Item
    {
        id: scoreListWithoutHintsTitle
        width: scoreListWithoutHints.width
        height: scoreListWithoutHints.parent.height / 15
        anchors.top: currentGameProfile.bottom
        anchors.topMargin: 9 * scoreListWithoutHints.height / 100
        anchors.left: scoreListWithoutHints.left
        anchors.leftMargin: scoreListWithoutHints.leftMargin

        Text
        {
            anchors.top: parent.top
            height: parent.height / 2
            id: scoreWithoutHintsHeader
            text: qsTr("Games without hints")
            font.pixelSize: parent.width / 25
        }

        Row
        {
            anchors.top: scoreWithoutHintsHeader.bottom
            height: parent.height / 2
            width: parent.width

            Text
            {
                width: 35 * parent.width / 100
                text: qsTr("Complexity")
                font.pixelSize: parent.width / 25
            }

            Text
            {
                width: 25 * parent.width / 100
                text: qsTr("Win")
                font.pixelSize: parent.width / 25
            }

            Text
            {
                width: 25 * parent.width / 100
                text: qsTr("Fail")
                font.pixelSize: parent.width / 25
            }

            Text
            {
                width: 25 * parent.width / 100
                text: qsTr("Total")
                font.pixelSize: parent.width / 25
            }
        }
    }

    ListView
    {
        id: scoreListWithoutHints
        width: 18 * parent.width / 20
        height: 3 * parent.height / 10
        clip: true
        anchors.top: scoreListWithoutHintsTitle.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        model: scoreListWithoutHintsModel
        delegate: scoreDelegate
        ScrollBar.vertical: ScrollBar { active: true; policy: ScrollBar.AlwaysOn }
    }

    ListModel
    {
        id: scoreListWithHintsModel
    }

    Item
    {
        id: scoreListWithHintsTitle
        width: scoreListWithHints.width
        height: scoreListWithHints.parent.height / 15
        anchors.top: scoreListWithoutHints.bottom
        anchors.topMargin: 9 * scoreListWithHints.height / 100
        anchors.left: scoreListWithHints.left
        anchors.leftMargin: scoreListWithHints.leftMargin

        Text
        {
            anchors.top: parent.top
            height: parent.height / 2
            id: scoreWithHintsHeader
            text: qsTr("Games with hints")
            font.pixelSize: parent.width / 25
        }

        Row
        {
            anchors.top: scoreWithHintsHeader.bottom
            height: parent.height / 2
            width: parent.width

            Text
            {
                width: 35 * parent.width / 100
                text: qsTr("Complexity")
                font.pixelSize: parent.width / 25
            }

            Text
            {
                width: 25 * parent.width / 100
                text: qsTr("Win")
                font.pixelSize: parent.width / 25
            }

            Text
            {
                width: 25 * parent.width / 100
                text: qsTr("Fail")
                font.pixelSize: parent.width / 25
            }

            Text
            {
                width: 25 * parent.width / 100
                text: qsTr("Total")
                font.pixelSize: parent.width / 25
            }
        }
    }

    ListView
    {
        id: scoreListWithHints
        width: 18 * parent.width / 20
        height: 3 * parent.height / 10
        clip: true
        anchors.top: scoreListWithHintsTitle.bottom
        anchors.left: parent.left
        anchors.leftMargin: parent.width / 20
        model: scoreListWithHintsModel
        delegate: scoreDelegate
        ScrollBar.vertical: ScrollBar { active: true; policy: ScrollBar.AlwaysOn  }
    }

    onOpened:
    {
        var current_profile = qsTr("Current game layout (hidden / open): ")
        current_profile += sudoku.get_current_game_profile_string()
        current_profile += '\n'

        if (sudoku.hints_were_enabled)
            current_profile += qsTr("Hints were enabled.")
        else
            current_profile += qsTr("No hints were enabled.")

        currentGameProfileText.text = current_profile
        fill_score_stats()
    }

    function fill_score_stats()
    {
        fill_score_without_hints()
        fill_score_with_hints()
    }

    function fill_score_without_hints()
    {
        scoreListWithoutHintsModel.clear()
        sudoku.start_score_listing_without_hints()
        var i = 2
        var result = sudoku.get_current_score_record_without_hints()
        while (result.fwd)
        {
            i++
            var c = result.complexity
            var lvl = c + " / " + (81 - c)
            scoreListWithoutHintsModel.append({"level": lvl, "wins": result.wins, "loses": result.loses})
            result = sudoku.get_current_score_record_without_hints()
        }
    }

    function fill_score_with_hints()
    {
        scoreListWithHintsModel.clear()
        sudoku.start_score_listing_with_hints()
        var i = 2
        var result = sudoku.get_current_score_record_with_hints()
        while (result.fwd)
        {
            i++
            var c = result.complexity
            var lvl = c + " / " + (81 - c)
            scoreListWithHintsModel.append({"level": lvl, "wins": result.wins, "loses": result.loses})
            result = sudoku.get_current_score_record_with_hints()
        }
    }
}
