import QtQuick 2.9
import QtQuick.Window 2.3

Image
{
    id: hint
    fillMode: Image.PreserveAspectFit
    source: "img/hint0.png"

    property bool selected: false

    onSelectedChanged:
    {
        if (selected)
        {
            source = "img/hint1.png"

            if (settingsPopup.show_extra_number_pad)
            {
                controls.adjust()
                extrapad.visible = true
            }

            if (settingsPopup.check_entered_value)
            {
                sudoku.check_board()
            }

            if (settingsPopup.show_dependent_positions      ||
                settingsPopup.check_entered_value           ||
                settingsPopup.show_extra_number_pad)
            {
                sudoku.hints_were_enabled = true
            }
        }
        else
        {
            source = "img/hint0.png"
            sudoku.clear_marked_contradicting_positions()
            selection.set_all_visible()
            board.point_value_positions("", false)
            controls.adjust()
            extrapad.visible = false
        }
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked: parent.selected = !parent.selected
    }
}
