PROGRAM_NAME='ModeroListener'




#if_not_defined __MODERO_LISTENER__
#define __MODERO_LISTENER__


define_variable

#if_not_defined dvPanelsToMonitor
dev dvPanelsToMonitor[] = {10001:1:0}
#end_if

#if_not_defined dvIpSocketToMonitorTouchCoordinates
dev dvIpSocketToMonitorTouchCoordinates = 0:2:0
#end_if


/*
#define INCLUDE_MODERO_NOTIFY_TOUCH_COORDINATES_PRESS
// Note: This will get triggered BEFORE a push event handler in a button_event
// Note: If push/release coordinate reporting is enabled a push anywhere on the panel will trigger this function
define_function fnModeroNotifyTouchCoordinatesPress (dev dvPanel, integer nX, integer nY)
{
    
}
*/

/*
#define INCLUDE_MODERO_NOTIFY_TOUCH_COORDINATES_MOVE
// Note: This will get triggered BEFORE a push event handler in a button_event
// Note: If push/release coordinate reporting is enabled a movement in user touch anywhere on the panel will trigger this function
define_function fnModeroNotifyTouchCoordinatesMove (dev dvPanel, integer nX, integer nY)
{
    
}
*/

/*
#define INCLUDE_MODERO_NOTIFY_TOUCH_COORDINATES_RELEASE
// Note: This will get triggered AFTER a release event handler in a button_event
// Note: If push/release coordinate reporting is enabled a release anywhere on the panel will trigger this function
define_function fnModeroNotifyTouchCoordinatesRelease (dev dvPanel, integer nX, integer nY)
{
    
}
*/



define_event

data_event[dvPanelsToMonitor]
{
    string:
    {
	if (find_string(data.text, 'Press,' ,1) == 1)	// Starts with 'Press,'
	{
	    // String is in format 'Press,X,Y' where X and Y are the (X,Y) coordinates of the touch
	    
	    stack_var integer nX
	    stack_var integer nY
	    
	    remove_string (data.text, 'Press,', 1)
	    nX = atoi (data.text)
	    remove_string (data.text, "','", 1)
	    nY = atoi (data.text)
	    
	    #if_defined INCLUDE_MODERO_NOTIFY_TOUCH_COORDINATES_PRESS
	    fnModeroNotifyTouchCoordinatesPress (data.device, nX, nY)
	    #end_if
	    
	}
	
	if (find_string(data.text, 'Move,' ,1) == 1)	// Starts with 'Move,'
	{
	    // String is in format 'Press,X,Y' where X and Y are the (X,Y) coordinates of the touch
	    
	    stack_var integer nX
	    stack_var integer nY
	    
	    send_string 0, '-------------------------------------------------------'
	    send_string 0, "'Received [MOVE] (X,Y) Coordinate Message from Touch panel Notification IP Port'"
	    
	    remove_string (data.text, 'Move,', 1)
	    nX = atoi (data.text)
	    remove_string (data.text, "','", 1)
	    nY = atoi (data.text)
	    
	    //send_string 0, 'DEBUG:: Move coordinate, before call fnModeroNotifyTouchCoordinatesMove'
	    #if_defined INCLUDE_MODERO_NOTIFY_TOUCH_COORDINATES_MOVE
	    //send_string 0, 'DEBUG:: Move coordinate, call fnModeroNotifyTouchCoordinatesMove'
	    fnModeroNotifyTouchCoordinatesMove (data.device, nX, nY)
	    #end_if
	    //send_string 0, 'DEBUG:: Move coordinate, after call fnModeroNotifyTouchCoordinatesMove'
	    
	}
	
	else if (find_string(data.text, 'Release,' ,1) == 1)	// Starts with 'Release,'
	{
	    // String is in format 'Press,X,Y' where X and Y are the (X,Y) coordinates of the release
	    
	    stack_var integer nX
	    stack_var integer nY
	    
	    remove_string (data.text, 'Release,', 1)
	    nX = atoi (data.text)
	    remove_string (data.text, "','", 1)
	    nY = atoi (data.text)
	    
	    #if_defined INCLUDE_MODERO_NOTIFY_TOUCH_COORDINATES_RELEASE
	    fnModeroNotifyTouchCoordinatesRelease (data.device, nX, nY)
	    #end_if
	}
    }
}






data_event[dvIpSocketToMonitorTouchCoordinates]
{
    online:
    {
	send_string 0, '-------------------------------------------------------'
	send_string 0, 'Connected to ModeroX Touch Notification IP Port:'
    }
    offline:
    {
	send_string 0, '-------------------------------------------------------'
	send_string 0, 'Disconnected from to ModeroX Touch Notification IP Port:'
	
	
	wait 20
	{
	    nTcpIpPortModeroTouchCoordinatesNotifications++
	    fnModeroDisableTouchNotificationIpPort (dvTpBoardroomTableMain)
	    wait 20
	    {
		fnModeroEnableTouchNotificationIpPort (dvTpBoardroomTableMain, nTcpIpPortModeroTouchCoordinatesNotifications)
		wait 20
		{
		    fnModeroConnectToTouchNotificationPort (data.device.port, cPanelIpAddress, nTcpIpPortModeroTouchCoordinatesNotifications)
		}
	    }
	}
    }
    onerror:
    {
	switch (data.number)
	{
	    case 6:	// connection refused
	    case 7:	// connection timed out
	    case 8:	// unknown connection error
	    {
	    
		wait 20
		{
		    nTcpIpPortModeroTouchCoordinatesNotifications++
		    fnModeroDisableTouchNotificationIpPort (dvTpBoardroomTableMain)
		    wait 20
		    {
			fnModeroEnableTouchNotificationIpPort (dvTpBoardroomTableMain, nTcpIpPortModeroTouchCoordinatesNotifications)
			wait 20
			{
			    fnModeroConnectToTouchNotificationPort (data.device.port, cPanelIpAddress, nTcpIpPortModeroTouchCoordinatesNotifications)
			}
		    }
		}
	    }
	}
    }
    string:
    {
	//send_string 0, '-------------------------------------------------------'
	//send_string 0, 'Received message on ModeroX Touch Notification IP Port:'
	//send_string 0, "'     DATA.TEXT="',data.text,'"'"
	
	while ( find_string(data.text,"$0A",1) )
	{
	    stack_var char cMessage[50]
	    
	    cMessage = remove_string(data.text, "$0A",1)
	    //send_string 0, "'     Message="',cMessage,'"'"
	    
	    if (find_string(cMessage, 'Press,' ,1) == 1)	// Starts with 'Press,'
	    {
		// String is in format 'Press,X,Y' where X and Y are the (X,Y) coordinates of the touch
		
		stack_var integer nX
		stack_var integer nY
		
		send_string 0, '-------------------------------------------------------'
		send_string 0, "'Received [PUSH] (X,Y) Coordinate Message from Touch panel Notification IP Port'"
	    
		remove_string (cMessage, 'Press,', 1)
		nX = atoi (cMessage)
		remove_string (cMessage, "','", 1)
		nY = atoi (cMessage)
		
		//send_string 0, 'DEBUG:: Press coordinate, before call fnModeroNotifyTouchCoordinatesPress'
		#if_defined INCLUDE_MODERO_NOTIFY_TOUCH_COORDINATES_PRESS
		//send_string 0, 'DEBUG:: Press coordinate, call fnModeroNotifyTouchCoordinatesPress'
		fnModeroNotifyTouchCoordinatesPress (data.device, nX, nY)
		#end_if
		//send_string 0, 'DEBUG:: Press coordinate, after call fnModeroNotifyTouchCoordinatesPress'
		
	    }
	    
	    if (find_string(cMessage, 'Move,' ,1) == 1)	// Starts with 'Move,'
	    {
		// String is in format 'Press,X,Y' where X and Y are the (X,Y) coordinates of the touch
		
		stack_var integer nX
		stack_var integer nY
		
		send_string 0, '-------------------------------------------------------'
		send_string 0, "'Received [MOVE] (X,Y) Coordinate Message from Touch panel Notification IP Port'"
		
		remove_string (cMessage, 'Move,', 1)
		nX = atoi (cMessage)
		remove_string (cMessage, "','", 1)
		nY = atoi (cMessage)
		
		//send_string 0, 'DEBUG:: Move coordinate, before call fnModeroNotifyTouchCoordinatesMove'
		#if_defined INCLUDE_MODERO_NOTIFY_TOUCH_COORDINATES_MOVE
		//send_string 0, 'DEBUG:: Move coordinate, call fnModeroNotifyTouchCoordinatesMove'
		fnModeroNotifyTouchCoordinatesMove (data.device, nX, nY)
		#end_if
		//send_string 0, 'DEBUG:: Move coordinate, after call fnModeroNotifyTouchCoordinatesMove'
		
	    }
	    
	    else if (find_string(cMessage, 'Release,' ,1) == 1)	// Starts with 'Release,'
	    {
		// String is in format 'Press,X,Y' where X and Y are the (X,Y) coordinates of the release
		
		stack_var integer nX
		stack_var integer nY
		
		send_string 0, "'Received [RELEASE] (X,Y) Coordinate Message from Touch panel Notification IP Port'"
		
		remove_string (cMessage, 'Release,', 1)
		nX = atoi (cMessage)
		remove_string (cMessage, "','", 1)
		nY = atoi (cMessage)
		
		#if_defined INCLUDE_MODERO_NOTIFY_TOUCH_COORDINATES_RELEASE
		fnModeroNotifyTouchCoordinatesRelease (data.device, nX, nY)
		#end_if
	    }
	
	}
    }
}



















#end_if __MODERO_LISTENER__