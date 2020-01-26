import QtQuick 2.9
import QtQuick.Window 2.3

Item
{
    property alias cells: cells
    property string outlined_value: "null"

    Repeater
    {
        id: cells
        model: 81

        Cell
        {
            function arrange()
            {
                var cell_space = parent.width / 120
                var block_space = 1.2 * cell_space

                width = (parent.width - 2 * block_space - 10 * cell_space) / 9
                height = width

                var i = index % 9
                var j = Math.floor(index / 9)
                x = parent.x + i * (width + cell_space) + Math.floor(i / 3) * block_space
                y = parent.y + j * (height + cell_space) + Math.floor(j / 3) * block_space
            }
        }
    }

    Component.onCompleted: arrange()
    onWidthChanged: arrange()

    function arrange()
    {
        var margin = parent.width / 100
        x = margin
        y = margin

        width = parent.width - 2 * margin
        height = width

        for (var c = 0; c < 81; c++)
        {
            cells.itemAt(c).arrange()
        }
    }

    function point_value_positions(val, mark)
    {
        outlined_value = mark ? val : "null"

        for(var c = 0; c < 81; c++)
        {
            var current_cell = cells.itemAt(c)
            var outline = false

            if (mark)
            {
                if (settingsPopup.show_value_occupied_positions)
                {
                    outline = current_cell.content.text === val
                }
                else if (settingsPopup.show_value_possible_positions)
                {
                    outline = current_cell.content.text === "" && sudoku.check_value(c, val)
                }
            }

            current_cell.outlined = outline
        }
    }
}
