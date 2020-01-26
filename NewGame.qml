import QtQuick 2.9
import QtQuick.Window 2.3

Image
{
    id: newGame
    fillMode: Image.PreserveAspectFit
    source: "img/run.png"

    MouseArea
    {
        id: newGameMouseArea
        anchors.fill: parent
        onClicked:
        {
            board.point_value_positions("", false)
            create_new_puzzle()
        }
    }
}
