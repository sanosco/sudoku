import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.4

Popup
{
    id: settingsPopup
    dim: true
    modal: true

    property alias show_dependent_positions: dependentPositions.checked
    property alias hide_unacceptable_values: unacceptableValues.checked
    property alias check_entered_value: checking.checked
    property alias show_extra_number_pad: extra.checked
    property alias show_value_occupied_positions: occupied.selected
    property alias show_value_possible_positions: potential.selected

    property int childwidth: 8 * width / 10
    property int childheight: childwidth / 5
    property int xoffset: width / 10
    property int yoffset: height / 20


    background: Rectangle
    {
        id: background
        anchors.fill: parent
        border.color: "#dbe9cd"
        border.width: 1
        radius: 3
    }

    CloseButton
    {
        mouse_area.onClicked: settingsPopup.close()
    }

    Text
    {
        id: settinsTitle
        text: qsTr("Settings")
        width: settingsPopup.childwidth
        height: settingsPopup.childheight
        horizontalAlignment: Text.AlignHCenter
        x: settingsPopup.xoffset
        y: settingsPopup.yoffset
        font.family: "Arial"
        font.pixelSize: width / 14
        anchors.top: settingsPopup.top
    }

    Checkbox
    {
        id: dependentPositions
        text: qsTr("Show dependent\npositions.")
        width: settingsPopup.childwidth
        height: settingsPopup.childheight
        x: settingsPopup.xoffset
        y: 2 * settingsPopup.yoffset
        anchors.top: settinsTitle.bottom
    }

    Checkbox
    {
        id: unacceptableValues
        text: qsTr("Hide unacceptable\nvalues from selection\nwindow.")
        width: settingsPopup.childwidth
        height: 4 * settingsPopup.childheight / 3
        x: settingsPopup.xoffset
        y: settingsPopup.yoffset
        anchors.top: dependentPositions.bottom
    }

    Checkbox
    {
        id: checking
        text: qsTr("Check entered\nvalues.")
        width: settingsPopup.childwidth
        height: settingsPopup.childheight
        x: settingsPopup.xoffset
        y: settingsPopup.yoffset
        anchors.top: unacceptableValues.bottom

        onCheckedChanged:
        {
            if (checked && controls.hint.selected)
            {
                sudoku.check_board()
            }
            else
            {
                sudoku.clear_marked_contradicting_positions()
            }
        }
    }

    Checkbox
    {
        id: extra
        text: qsTr("Use extra selection\nline to")
        width: settingsPopup.childwidth
        height: settingsPopup.childheight
        x: settingsPopup.xoffset
        y: settingsPopup.yoffset
        anchors.top: checking.bottom

        mousearea.onClicked:
        {
            if (checked && controls.hint.selected)
            {
                controls.adjust()
                extrapad.visible = true
            }
            else
            {
                controls.adjust()
                extrapad.visible = false
                board.point_value_positions("", false)
            }
        }
    }

    Radiobutton
    {
        id: occupied
        selected: true;
        siblings: [potential]
        text: qsTr("show positions with\nvalue selected.")
        width: settingsPopup.childwidth
        height: settingsPopup.childheight
        x: 3 * settingsPopup.xoffset / 2
        y: settingsPopup.yoffset
        anchors.top: extra.bottom

        mousearea.onClicked:
        {
            if (controls.hint.selected && board.outlined_value !== "null")
            {
                board.point_value_positions(board.outlined_value, true)
            }
        }
    }

    Radiobutton
    {
        id: potential
        siblings: [occupied]
        text: qsTr("show potential\npositions for\nvalue selected.")
        width: settingsPopup.childwidth
        height: 4 * settingsPopup.childheight / 3
        x: 3 * settingsPopup.xoffset / 2
        y: settingsPopup.yoffset
        anchors.top: occupied.bottom

        mousearea.onClicked:
        {
            if (controls.hint.selected && board.outlined_value !== "null")
            {
                board.point_value_positions(board.outlined_value, true)
            }
        }
    }

    onClosed:
    {
        if (controls.hint.selected &&
           (settingsPopup.show_dependent_positions      ||
            settingsPopup.check_entered_value           ||
            settingsPopup.show_value_occupied_positions ||
            settingsPopup.show_value_possible_positions))
        {
            sudoku.hints_were_enabled = true;
        }
    }
}
