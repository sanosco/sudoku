import QtQuick 2.9
import QtQuick.Window 2.3

Rectangle
{
	id: controls
    color: "#dbe9cd"
    radius: 3

    property int spacing: parent.width / 18
    property alias hint: hint
    property alias controlsanimation: controlsanimation
    property alias levelselector: levelselector
	
	NewGame
	{
        id: newGame
		anchors.verticalCenter: parent.verticalCenter

        function arrange()
        {
            x = parent.x + spacing
            height = 7 * parent.height / 10
            width = height
        }
	}
	
	LevelSelector
	{
        id: levelselector
		anchors.verticalCenter: parent.verticalCenter

        function arrange()
        {
            x = newGame.x + newGame.width + spacing
            height = 7 * parent.height / 10
            width = 3 * height
        }
	}
	
	Hint
	{
        id: hint
		anchors.verticalCenter: parent.verticalCenter

        function arrange()
        {
            x = levelselector.x + levelselector.width + spacing
            height = 7 * parent.height / 10
            width = height
        }
	}
	
	Settings
	{
        id: settings
		anchors.verticalCenter: parent.verticalCenter

        function arrange()
        {
            x = hint.x + hint.width + spacing
            height = 7 * parent.height / 10
            width = height
        }
	}

    Info
    {
        id: info
        anchors.verticalCenter: parent.verticalCenter

        function arrange()
        {
            x = settings.x + settings.width + spacing
            height = 7 * parent.height / 10
            width = height
        }
    }

    Help
    {
        id: help
        anchors.verticalCenter: parent.verticalCenter

        function arrange()
        {
            x = info.x + info.width + spacing
            height = 7 * parent.height / 10
            width = height
        }
    }

    Behavior on y
    {
        id: controlsanimation
        enabled: false

        NumberAnimation
        {
            duration: 200
        }
    }

    function updateLayout()
    {
        spacing = parent.width / 18
        newGame.arrange()
        levelselector.arrange()
        hint.arrange()
        settings.arrange()
        info.arrange()
        help.arrange()
    }
}
