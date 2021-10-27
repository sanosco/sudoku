import QtQuick 2.9
import QtQuick.Window 2.3
import sanosco.snowsparkle.sudoku 1.1

Window
{
    id: window
    visible: true
    width: 480
    height: 640
    title: qsTr("Snow Sparkle Sudoku")

    Component.onCompleted:
    {
        try
        {
            var content = sudoku.restore_config()
            var config = JSON.parse(content)
            controls.levelselector.complexity = config.levelselector
            controls.hint.selected = config.hint
            settingsPopup.show_dependent_positions = config.show_dependent_positions
            settingsPopup.hide_unacceptable_values = config.hide_unacceptable_values
            settingsPopup.check_entered_value = config.check_entered_value
            settingsPopup.show_extra_number_pad = config.show_extra_number_pad
            settingsPopup.show_value_occupied_positions = config.show_value_occupied_positions
            settingsPopup.show_value_possible_positions = config.show_value_possible_positions
        }
        catch (e)
        {
            /* Do nothing */
        }
    }

    Component.onDestruction:
    {
        var config = JSON
        config.levelselector = controls.levelselector.complexity
        config.hint = controls.hint.selected
        config.show_dependent_positions = settingsPopup.show_dependent_positions
        config.hide_unacceptable_values = settingsPopup.hide_unacceptable_values
        config.check_entered_value = settingsPopup.check_entered_value
        config.show_extra_number_pad = settingsPopup.show_extra_number_pad
        config.show_value_occupied_positions = settingsPopup.show_value_occupied_positions
        config.show_value_possible_positions = settingsPopup.show_value_possible_positions
        sudoku.store_config(JSON.stringify(config));
    }

    SettingsPopup
    {
        id: settingsPopup
        width: 2 * parent.width / 3
        height: 3 * width / 2
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
    }

    ScorePopup
    {
        id: scorePopup
        width: 4 * parent.width / 5
        height: 3 * width / 2
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
    }

    HelpPopup
    {
        id: helpPopup
        width: 4 * parent.width / 5
        height: 3 * width / 2
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
    }

    Controls
    {
        id: controls

        function arrange()
        {
            var offset = controls.hint.selected && settingsPopup.show_extra_number_pad ? 5 * extrapad.height / 4 : Math.round(extrapad.height / 3)
            y = extrapad.y + offset
            x = extrapad.x
            width = extrapad.width - 2 * extrapad.margin
            height = extrapad.width / 10

            updateLayout()
        }

        function adjust()
        {
            controlsanimation.enabled = true
            var offset = controls.hint.selected && settingsPopup.show_extra_number_pad ? 5 * extrapad.height / 4 : Math.round(extrapad.height / 3)
            y = extrapad.y + offset
            controlsanimation.enabled = false
        }
    }

    ExtraPad
    {
        id: extrapad
        visible: controls.hint.selected && settingsPopup.show_extra_number_pad ? true : false

        function arrange()
        {
            margin = gameArea.width / 50
            x = gameArea.x + margin
            y = gameArea.y + gameArea.height + gameArea.height / 30
            width = gameArea.width
            height = gameArea.width / 10
            numbers.arrange()
        }
    }

    Item
    {
        id: gameArea
        width: parent.width
        height: width

        Board
        {
            id: board

            Component.onCompleted:
            {
                init_board()

                if (!sudoku.restore_board())
                {
                    sudoku.board_was_completed = true
                    create_new_puzzle()
                }
                else
                {
                    if (controls.hint.selected && settingsPopup.check_entered_value)
                    {
                        sudoku.check_board()
                    }

                    update_board()
                }
            }

            Component.onDestruction: sudoku.store_board()
        }

        SelectionPopup
        {
            id: selection
        }

        CongratulationPopup
        {
            id: congratulation
        }

        RetryPopup
        {
            id: retry
        }

        onWidthChanged:
        {
            height = width
            board.width = width
            extrapad.arrange()
            controls.arrange()
            congratulation.arrange()
            retry.arrange()
        }
    }

    NewGameGenerationSplash
    {
        id: newGameGenerationSplash
        height: window.height
        width: window.width
    }

    SudokuItem
    {
        id: sudoku

        onNewGameCreated:
        {
            newGameGenerationSplash.hide()
            window.update_board()
        }

        onContradictingPositionChecked:
        {
            board.cells.itemAt(cell).marked = marked
        }

        onRelatedPositionHighlighted:
        {
            board.cells.itemAt(cell).highlighted = highlighted
        }

        Component.onCompleted:
        {
            restore_scores()
        }

        Component.onDestruction:
        {
            store_scores()
        }
    }

    onWidthChanged:
    {
        gameArea.width = width
        controls.arrange()
        selection.arrange()
    }

    function create_new_puzzle()
    {
        if (!sudoku.board_was_completed)
        {
            sudoku.update_scores(false)
        }

        newGameGenerationSplash.show()
        sudoku.create_new_puzzle(controls.levelselector.complexity)
        sudoku.score_is_recorded = false
        sudoku.board_was_completed = false
        sudoku.hints_were_enabled = controls.hint.selected &&
                                    (settingsPopup.show_dependent_positions      ||
                                     settingsPopup.check_entered_value           ||
                                     settingsPopup.show_value_occupied_positions ||
                                     settingsPopup.show_value_possible_positions)
    }

    function init_board()
    {
        for(var c = 0; c < 81; c++)
        {
            board.cells.itemAt(c).position = c
        }
    }

    function update_board()
    {
        var sudoku_puzzle = sudoku.puzzle;
        var sudoku_board = sudoku.board;

        for (var c = 0; c < 81; c++)
        {
            if (sudoku_puzzle[c] === '*')
            {
                board.cells.itemAt(c).content.text = sudoku_board[c] === '*' ? "" : sudoku_board[c]
                board.cells.itemAt(c).active = true
            }
            else
            {
                board.cells.itemAt(c).content.text = sudoku_board[c]
                board.cells.itemAt(c).active = false
            }
        }
    }
}
