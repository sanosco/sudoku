import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.4

Popup
{
    id: selection
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    width: 2 * parent.width / 3
    height: 3 * width / 4 - width / 25
    dim: true
    modal: true

    property var cell

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
        mouse_area.onClicked: selection.close()
    }

    Grid
    {
        id: numbers
        x: parent.width / 25
        y: parent.height / 25
        spacing: parent.width / 50
        width: parent.width - 2 * parent.width / 25 - 30
        columns: 4
        rows: 3

        property alias set: repeater

        Repeater
        {
            id: repeater
            model: 10
            SelectionPopupCell
            {
                label: index

                function arrange()
                {
                    width = numbers.width / 4 - numbers.spacing
                    height = width
                }
            }

            Component.onCompleted: itemAt(0).label = ""
        }

        function arrange()
        {
            for (var i = 0; i < set.count; i++)
            {
                set.itemAt(i).arrange()
            }
        }
    }

    onOpened:
    {
        arrange()

        if (controls.hint.selected)
        {
            for (var n = 1; n < 10; n++)
            {
                set_item_visibility(cell.position, numbers.set.itemAt(n))
            }
        }
    }

    function arrange()
    {
        numbers.arrange()
    }

    function set_item_visibility(pos, item)
    {
        if (!settingsPopup.hide_unacceptable_values || sudoku.check_value(pos, item.label))
        {
            item.visible = true;
        }
        else
        {
            item.visible = false;
        }
    }

    function set_all_visible()
    {
        for (var n = 1; n < 10; n++)
        {
            numbers.set.itemAt(n).visible = true;
        }
    }
}
