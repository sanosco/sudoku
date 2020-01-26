import QtQuick 2.9
import QtQuick.Window 2.3

Row
{
	id: extrapad
    spacing: width / 50

	property int margin: gameArea.width / 50
    property alias numbers: repeater
	
	Repeater
	{
		id: repeater
		model: 9
		PadNumber
		{
			value: index + 1
			
			function arrange()
			{
                width = (parent.width - extrapad.margin) / 9 - parent.spacing
				height = width
			}
		}
		
		function arrange()
		{
			for (var i = 0; i < count; i++)
			{
				itemAt(i).arrange()
			}
		}
	}
	
	Behavior on visible
	{
		NumberAnimation
		{
			duration: 200
		}
    }
}
