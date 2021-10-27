import QtQuick 2.9
import QtQuick.Window 2.3

Rectangle
{
    color: "#000000"
    visible: false
    enabled: false
    opacity: 0.35

    AnimatedImage
    {
        id: wait
        fillMode: Image.PreserveAspectFit
        source: "img/wait.gif"
    }

    MouseArea
    {
        id: newGameGenerationSplashMouseArea
        anchors.fill: parent
        enabled: false
    }

    Behavior on visible
    {
        NumberAnimation
        {
            duration: 200
        }
    }

    function show()
    {
        visible = true
        enabled = true
        newGameGenerationSplashMouseArea.enabled = true
    }

    function hide()
    {
        visible = false
        enabled = false
        newGameGenerationSplashMouseArea.enabled = false
    }
}
