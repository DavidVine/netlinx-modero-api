PROGRAM_NAME='ModeroControl'




#if_not_defined __MODERO_CONTROL__
#define __MODERO_CONTROL__



/******
Special undocumented Modero commands:

    ^TOP
    ^SKT
    
******/


// Enables the reporting of (X,Y) touch coordinates from the panel for push and release
define_function fnModeroEnableTouchCoordinateTrackingPressRelease (dev dvPanel)
{
    send_command dvPanel, '^TOP-1'
}

// Enables the reporting of (X,Y) touch coordinates from the panel for moves
define_function fnModeroEnableTouchCoordinateTrackingMoveOnly (dev dvPanel)
{
    send_command dvPanel, '^TOP-2'
}

// Enables the reporting of (X,Y) touch coordinates from the panel for push, move, and release
define_function fnModeroEnableTouchCoordinateTrackingPressReleaseMove (dev dvPanel)
{
    send_command dvPanel, '^TOP-3'
}

// Disables the reporting of (X,Y) touch coordinates from the panel for push and release
define_function fnModeroDisableTouchCoordinateTracking (dev dvPanel)
{
    send_command dvPanel, '^TOP-0'
}



// Open a local socket on a port for 3rd party devices to receive press, move, or release commands.
// Output is text based and follows the same format as ^TOP.
// Note: Only 1 client at a time will be serviced.
// Note: Calling this function does not create the connection, it simply allows the panel to accept
//       TCP/IP client requests to connect on that port.
// nTcpIpPort (1024...65535)
define_function fnModeroEnableTouchNotificationIpPort (dev dvPanel, integer nTcpIpPort)
{
    if ( (nTcpIpPort >= 1024) AND (nTcpIpPort <= 65535) )
	send_command dvPanel, "'^SKT-',itoa(nTcpIpPort)"
}

// Disables the local port for 3rd party devices to retrieve press, move, or release commands.
define_function fnModeroDisableTouchNotificationIpPort (dev dvPanel)
{
    send_command dvPanel, '^SKT-0'
}

define_function fnModeroConnectToTouchNotificationPort (dev dvIpSocket, char cPanelIpAddress[], integer nTcpIpPort)
{
    ip_client_open (dvIpSocket.PORT, cPanelIpAddress, nTcpIpPort, IP_TCP)
}

define_function fnModeroDisconnectFromTouchNotificationPort (dev dvIpSocket)
{
    ip_client_close (dvIpSocket.PORT)
}


///////////////////////// Page flips
define_function fnModeroSetPage (dev dvPanel, char cPageName[])
{
    send_command dvPanel, "'PAGE-',cPageName"
}

///////////////////////// Popup control
define_function fnModeroEnablePopup (dev dvPanel, char cPopupName[])
{
    send_string 0, "'DEBUG::::fnModeroEnablePopup ("',cPopupName,'")'"
    send_command dvPanel, "'PPON-',cPopupName"
}

define_function fnModeroDisablePopup (dev dvPanel, char cPopupName[])
{
    send_command dvPanel, "'PPOF-',cPopupName"
}

define_function fnModeroDisableAllPopups (dev dvPanel)
{
    send_command dvPanel, "'@PPX'"
}

define_constant

char cMODERO_HIDE_EFFECT_NONE[]			= 'None'
char cMODERO_HIDE_EFFECT_FADE[]			= 'Fade'
char cMODERO_HIDE_EFFECT_SLIDE_TO_LEFT[]	= 'Slide To Left'
char cMODERO_HIDE_EFFECT_SLIDE_TO_RIGHT[]	= 'Slide To Right'
char cMODERO_HIDE_EFFECT_SLIDE_TO_TOP[]		= 'Slide To Top'
char cMODERO_HIDE_EFFECT_SLIDE_TO_BOTTOM[]	= 'Slide To Bottom'
char cMODERO_HIDE_EFFECT_SLIDE_TO_LEFT_FADE[]	= 'Slide To Left Fade'
char cMODERO_HIDE_EFFECT_SLIDE_TO_RIGHT_FADE[]	= 'Slide To Right Fade'
char cMODERO_HIDE_EFFECT_SLIDE_TO_TOP_FADE[]	= 'Slide To Top Fade'
char cMODERO_HIDE_EFFECT_SLIDE_TO_BOTTOM_FADE[]	= 'Slide To Bottom Fade'

define_function fnModeroSetPopupHideEffect (dev dvPanel, char cPopupName[], char cHideEffect[])
{
    switch (cHideEffect)
    {
	case cMODERO_HIDE_EFFECT_NONE:
	case cMODERO_HIDE_EFFECT_FADE:
	case cMODERO_HIDE_EFFECT_SLIDE_TO_LEFT:
	case cMODERO_HIDE_EFFECT_SLIDE_TO_RIGHT:
	case cMODERO_HIDE_EFFECT_SLIDE_TO_TOP:
	case cMODERO_HIDE_EFFECT_SLIDE_TO_BOTTOM:
	case cMODERO_HIDE_EFFECT_SLIDE_TO_LEFT_FADE:
	case cMODERO_HIDE_EFFECT_SLIDE_TO_RIGHT_FADE:
	case cMODERO_HIDE_EFFECT_SLIDE_TO_TOP_FADE:
	case cMODERO_HIDE_EFFECT_SLIDE_TO_BOTTOM_FADE:
	{
	    send_command dvPanel, "'@PHE-',cPopupName,';',cHideEffect"
	}
    }
}

define_function fnModeroSetPopupHideEffectPosition (dev dvPanel, char cPopupName[], integer nCoordX, integer nCoordY)
{
    send_command dvPanel, "'@PHP-',cPopupName,';',itoa(nCoordX),',',itoa(nCoordY)"
}

define_function fnModeroSetPopupHideEffectTime (dev dvPanel, char cPopupName[], integer nTimeInTenthsOfSeconds)
{
    send_command dvPanel, "'@PHT-',cPopupName,';',itoa(nTimeInTenthsOfSeconds)"
}



///////////////////////// Button Control

define_constant

integer nMODERO_BUTTON_STATE_ALL = 0
integer nMODERO_BUTTON_STATE_OFF = 1
integer nMODERO_BUTTON_STATE_ON = 2

define_function fnModeroSetButtonShow (dev dvPanel, integer nBtnAdrCde)
{
    send_command dvPanel, "'^SHO-',itoa(nBtnAdrCde),',1'"
}

define_function fnModeroSetButtonHide (dev dvPanel, integer nBtnAdrCde)
{
    send_command dvPanel, "'^SHO-',itoa(nBtnAdrCde),',0'"
}

define_function fnModeroSetButtonText (dev dvPanel, integer nBtnAdrCde, integer nBtnState, char cText[])
{
    send_command dvPanel, "'^TXT-',itoa(nBtnAdrCde),',',itoa(nBtnState),',',cText"
}


define_function fnModeroSetButtonPositionAndSize (dev dvPanel, integer nBtnAdrCde, integer nLeft, integer nTop, integer nWidth, integer nHeight)
{
    SEND_COMMAND dvPanel,"'^BMF-',itoa(nBtnAdrCde),',0,%R',itoa(nLeft),',',itoa(nTop),',',itoa(nLeft+nWidth),',',itoa(nTop+nHeight)"
}


define_function fnModeroSetButtonBitmap (dev dvPanel, integer nBtnAdrCde, integer iBtnState, char cImageFileName[])
{
    send_command dvPanel, "'^BMP-',itoa(nBtnAdrCde),',',itoa(iBtnState),',',cImageFileName"
}


define_function fnPanelPlaySoundFile(dev dvTp, char cSoundFilename[])
{
	send_command dvTp, "'@SOU-',cSoundFilename"
}

define_function fnPanelSetFillColour(dev dvTp, integer iBtnAdrCde, integer iBtnState, char cColourValue[])
{
	send_command dvTp, "'^BCF-',itoa(iBtnAdrCde),',',itoa(iBtnState),',',cColourValue"
}

define_function fnPanelUpdateButtonBitmap(dev dvTp, integer iBtnAdrCde, integer iBtnState, char cImageFileName[])
{
	send_command dvTp, "'^BMP-',itoa(iBtnAdrCde),',',itoa(iBtnState),',',cImageFileName"
}

/*define_function fnPanelTurnLedOn(dev dvTp,integer iLedColour)
{
	switch(iLedColour)
	{
		case iLED_COLOUR_GREEN:	send_command dvTp, '^WLD-2,1'
		case iLED_COLOUR_RED:	send_command dvTp, '^WLD-0,1'
		case iLED_COLOUR_BOTH:
		{
			send_command dvTp, '^WLD-0,1'
			send_command dvTp, '^WLD-2,1'
		}
	}
}*/

/*define_function fnPanelTurnLedOff(dev dvTp,integer iLedColour)
{
	switch(iLedColour)
	{
		case iLED_COLOUR_GREEN:	send_command dvTp, '^WLD-2,0'
		case iLED_COLOUR_RED:	send_command dvTp, '^WLD-0,0'
		case iLED_COLOUR_BOTH:
		{
			send_command dvTp, '^WLD-0,0'
			send_command dvTp, '^WLD-2,0'
		}
	}
}*/


define_constant

integer nMODERO_ALIGNMENT_OPTION_ABSOLUTE		= 0
integer nMODERO_ALIGNMENT_OPTION_TOP_LEFT		= 1
integer nMODERO_ALIGNMENT_OPTION_TOP_MIDDLE		= 2
integer nMODERO_ALIGNMENT_OPTION_TOP_RIGHT		= 3
integer nMODERO_ALIGNMENT_OPTION_CENTER_LEFT		= 4
integer nMODERO_ALIGNMENT_OPTION_CENTER_MIDDLE		= 5
integer nMODERO_ALIGNMENT_OPTION_CENTER_RIGHT		= 6
integer nMODERO_ALIGNMENT_OPTION_BOTTOM_LEFT		= 7
integer nMODERO_ALIGNMENT_OPTION_BOTTOM_MIDDLE		= 8
integer nMODERO_ALIGNMENT_OPTION_BOTTOM_RIGHT		= 9


define_function fnModeroSetButtonBitmapPositionAbsolute (dev dvPanel, integer nBtnAdrCde, integer nLeft, integer nTop)
{
    send_command dvPanel, "'^JSB-',itoa(nBtnAdrCde),',0,',itoa(nMODERO_ALIGNMENT_OPTION_ABSOLUTE),',',itoa(nLeft),',',itoa(nTop)"
}

define_function fnModeroSetButtonBitmapPositionJustified (dev dvPanel, integer nBtnAdrCde, integer nAlignmentOption)
{
    switch (nAlignmentOption)
    {
	case nMODERO_ALIGNMENT_OPTION_TOP_LEFT:
	case nMODERO_ALIGNMENT_OPTION_TOP_MIDDLE:
	case nMODERO_ALIGNMENT_OPTION_TOP_RIGHT:
	case nMODERO_ALIGNMENT_OPTION_CENTER_LEFT:
	case nMODERO_ALIGNMENT_OPTION_CENTER_MIDDLE:
	case nMODERO_ALIGNMENT_OPTION_CENTER_RIGHT:
	case nMODERO_ALIGNMENT_OPTION_BOTTOM_LEFT:
	case nMODERO_ALIGNMENT_OPTION_BOTTOM_MIDDLE:
	case nMODERO_ALIGNMENT_OPTION_BOTTOM_RIGHT:
	{
	    send_command dvPanel, "'^JSB-',itoa(nBtnAdrCde),',0,',itoa(nAlignmentOption)"
			//SEND_COMMAND dvPanel,"'^BMF-',itoa(nBtnAdrCde),',0,%R',itoa(nLeft),',',itoa(nTop),',',itoa(nLeft+nWidth),',',itoa(nTop+nHeight)"
	}
    }
}



define_constant

char cMODERO_BUTTON_ATTRIBUTE_BITMAP[]				= 'BM'
char cMODERO_BUTTON_ATTRIBUTE_BORDER[]				= 'BR'
char cMODERO_BUTTON_ATTRIBUTE_BORDER_COLOR[]			= 'CB'
char cMODERO_BUTTON_ATTRIBUTE_FILL_COLOR[]			= 'CF'
char cMODERO_BUTTON_ATTRIBUTE_TEXT_COLOR[]			= 'CT'
char cMODERO_BUTTON_ATTRIBUTE_TEXT_EFFECT_COLOR[]		= 'EC'
char cMODERO_BUTTON_ATTRIBUTE_TEXT_EFFECT[]			= 'EF'
char cMODERO_BUTTON_ATTRIBUTE_FONT[]				= 'FT'
char cMODERO_BUTTON_ATTRIBUTE_ICON[]				= 'IC'
char cMODERO_BUTTON_ATTRIBUTE_BITMAP_ALIGNMENT[]		= 'JB'
char cMODERO_BUTTON_ATTRIBUTE_ICON_ALIGNMENT[]			= 'JI'
char cMODERO_BUTTON_ATTRIBUTE_TEXT_ALIGNMENT[]			= 'JT'
char cMODERO_BUTTON_ATTRIBUTE_LINES_OF_VIDEO_REMOVED[]		= 'LN'
char cMODERO_BUTTON_ATTRIBUTE_OPACITY[]				= 'OP'
char cMODERO_BUTTON_ATTRIBUTE_BUTTON_SOUND[]			= 'SO'
char cMODERO_BUTTON_ATTRIBUTE_TEXT[]				= 'TX'
char cMODERO_BUTTON_ATTRIBUTE_VIDEO_SLOT_ID[]			= 'VI'
char cMODERO_BUTTON_ATTRIBUTE_WORD_WRAP[]			= 'WW'


define_function fnModeroButtonCopyAttribute (dev dvPanel, integer nBtnPortSource, nBtnAdrCdeSource, integer nBtnStateSource, integer nBtnAdrCdeDest, integer nBtnStateDest, char cAttribute[])
{
    switch (cAttribute)
    {
	case cMODERO_BUTTON_ATTRIBUTE_BITMAP:
	case cMODERO_BUTTON_ATTRIBUTE_BORDER:
	case cMODERO_BUTTON_ATTRIBUTE_BORDER_COLOR:
	case cMODERO_BUTTON_ATTRIBUTE_FILL_COLOR:
	case cMODERO_BUTTON_ATTRIBUTE_TEXT_COLOR:
	case cMODERO_BUTTON_ATTRIBUTE_TEXT_EFFECT_COLOR:
	case cMODERO_BUTTON_ATTRIBUTE_TEXT_EFFECT:
	case cMODERO_BUTTON_ATTRIBUTE_FONT:
	case cMODERO_BUTTON_ATTRIBUTE_ICON:
	case cMODERO_BUTTON_ATTRIBUTE_BITMAP_ALIGNMENT:
	case cMODERO_BUTTON_ATTRIBUTE_ICON_ALIGNMENT:
	case cMODERO_BUTTON_ATTRIBUTE_TEXT_ALIGNMENT:
	case cMODERO_BUTTON_ATTRIBUTE_LINES_OF_VIDEO_REMOVED:
	case cMODERO_BUTTON_ATTRIBUTE_OPACITY:
	case cMODERO_BUTTON_ATTRIBUTE_BUTTON_SOUND:
	case cMODERO_BUTTON_ATTRIBUTE_TEXT:
	case cMODERO_BUTTON_ATTRIBUTE_VIDEO_SLOT_ID:
	case cMODERO_BUTTON_ATTRIBUTE_WORD_WRAP:
	{
	    send_command dvPanel, "'^BMC-',itoa(nBtnAdrCdeDest),',',itoa(nBtnStateDest),',',itoa(nBtnPortSource),',',itoa(nBtnAdrCdeSource),',',itoa(nBtnStateSource),',%',cAttribute"
	}
    }
}



// Force a refresh for a given resource, if the resource is visible onscreen.
define_function fnModeroRefreshResourceIfVisibleOnScreen (dev dvPanel, char cResourceName[])
{
    send_command dvPanel, "'^RFR-',cResourceName"
}

// Force a refresh of the given resource. The command will "prefetch" the resource even if it is not currently visible.
define_function fnModeroResourceForceRefreshPrefetchCache (dev dvPanel, char cResourceName[])
{
    send_command dvPanel, "'^RFRP-',cResourceName,',off'"
}

/*define_function fnModeroModifyResourceProtocol (dev dvPanel, char cResourceName[], char cProtocol[], char cHostName[], char cFilePath[], char cFileName[], char cUserName[], char cPassword[], integer nRefreshRateInSeconds, integer nDynamoImageFlag)
{
    send_command dvPanel, "'^RMF-',cResourceName,'',"
}*/


define_function fnModeroSetResourceHostName (dev dvPanel, char cResourceName[], char cHostName[])
{
    send_command dvPanel, "'^RMF-',cResourceName,'%H',cHostName"
}


define_function fnModeroSetResourceFilePath (dev dvPanel, char cResourceName[], char cFilePath[])
{
    send_command dvPanel, "'^RMF-',cResourceName,'%A',cFilePath"
}


define_function fnModeroSetResourceFileName (dev dvPanel, char cResourceName[], char cFileName[])
{
    send_command dvPanel, "'^RMF-',cResourceName,'%F',cFileName"
}


define_function fnModeroSetResourceRefreshRate (dev dvPanel, char cResourceName[], integer nRefreshRate)
{
    send_command dvPanel, "'^RMF-',cResourceName,'%V',itoa(nRefreshRate)"
}







#end_if __MODERO_CONTROL__