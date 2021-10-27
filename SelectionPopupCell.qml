import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.4

Rectangle
{
    radius: 3
    border.color: "#dbe9cd"

    property alias label: label.text

    Text
    {
        id: label
        font.pixelSize: parent.height / 2
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.family: "Arial"
        fontSizeMode: Text.VerticalFit
        renderType: Text.NativeRendering
    }

    MouseArea
    {
        anchors.fill: parent

        onClicked:
        {
            selection.close()
            selection.cell.content.text = label.text

            var blank = label.text === ""

            if (blank)
            {
                sudoku.set_value(selection.cell.position, "*")
            }
            else
            {
                sudoku.set_value(selection.cell.position, label.text)
            }

            if (controls.hint.selected)
            {
                if (settingsPopup.check_entered_value)
                {
                    sudoku.check_entered_position(selection.cell.position)
                }

                if (settingsPopup.show_value_occupied_positions)
                {
                    selection.cell.outlined = !blank && board.outlined_value === label.text
                }
                else if (settingsPopup.show_value_possible_positions && board.outlined_value !== "null")
                {
                    board.point_value_positions(board.outlined_value, true)
                }
            }

            if (sudoku.is_completed())
            {
                sudoku.board_was_completed = true;

                var success = sudoku.check_solution()

                if (success)
                {
                    congratulation.open()
                }
                else
                {
                    retry.open()
                }

                sudoku.update_scores(success)
            }
        }
    }
}
