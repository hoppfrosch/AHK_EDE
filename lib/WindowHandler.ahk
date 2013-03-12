/*
	Title: WindowHandling class
		Class to handle single window

	Author: 
		hoppfrosch@ahk4.me
		
	License: 
		This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
		
	Changelog:

		0.2.0 - [+] Event-Handling, <rollup>, <__isRolledUp>
		0.1.0 - [+] Initial
		
*/
	
; ****** HINT: Documentation can be extracted to HTML using NaturalDocs ************** */

#include <Rectangle>
#include <MultiMonitorEnv>
#include <_WindowHandlerEvent>

; ******************************************************************************************************************************************
class WindowHandler {
	
	_version := "0.2.0"
	debug := 0
	_hWnd := 0
	
	_hWinEventHook1 := 0
	_hWinEventHook2 := 0
	_HookProcAdr := 0
		
	_bManualMovement := false

	_posStack := 0
/*
===============================================================================
Function: alwaysOnTop
	Toogles "Always On Top" for window

Parameters:
	mode - "on", "off", "toggle" (Default)

See also:  
	<__isAlwaysOnTop>, <__Get>

Author(s):
	20130308 - hoppfrosch@ahk4.me - Initial
===============================================================================
*/
	alwaysOnTop(mode="toggle") {
		if (this.debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> CurrentState:" this.alwaysontop ; _DBG_
		foundpos := RegExMatch(mode, "i)on|off|toggle")
		if (foundpos = 0)
			mode := "toggle"

		StringLower mode,mode	
		val := this._hWnd
		WinSet, AlwaysOnTop, %mode%,  ahk_id %val%
			
		if (this.debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> NewState:" this.alwaysontop ; _DBG_
	}

/*
===============================================================================
Function: hidden
	Toogles "Hidden" for window

Parameters:
	mode - "on", "off", "toggle" (Default)

See also:  
	<show>, <hide>, <__isHidden>

Author(s):
	20130308 - hoppfrosch@ahk4.me - Initial
===============================================================================
*/
	hidden(mode="toggle") {
		if (this.debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> CurrentState:" this.__isHidden() ; _DBG_
		foundpos := RegExMatch(mode, "i)on|off|toggle")
		if (foundpos = 0)
			mode := "toggle"

		StringLower mode,mode

		if (mode = "on")
			this.Hide()
		else if (mode = "off")
			this.Show()
		else {
			if (this.__isHidden())
				this.show()
			else
				this.hide()
		}
		if (this.debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> NewState:" this.__isHidden() ; _DBG_
	}
	
/*
===============================================================================
Function: hide
	Hides the Window. Use <show> to unhide a hidden window

See also:
	<show>, <__isHidden>, <hidden>

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	hide() {
		val := this._hWnd
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])]" ; _DBG_		
		WinHide ahk_id %val%
	}

/*
===============================================================================
Function:   kill
	Kills the Window

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	kill() {
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])]" ; _DBG_		

		prevState := A_DetectHiddenWindows
		DetectHiddenWindows, On
		WinKill % "ahk_id" this._hWnd
		DetectHiddenWindows, %prevState%
	}

/*
===============================================================================
Function: move
	Moves the window

Parameters:
	X,Y,W,H - Position and Width/Height the window has to be moved/resized to

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	move(X,Y,W="",H="") {
		if (this.debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "])(X=" X " ,Y=" Y " ,W=" W " ,H=" H ")]" ; _DBG_		
		if (X = 99999 || Y = 99999 || W = 99999 || H = 9999)
			currPos := this.pos
		
		if (X = 99999)
			X := currPos.X
		
		if (Y = 99999)
			Y := currPos.Y
		
		if (W = 99999)
			W := currPos.W
		
		if (H = 99999)
			H := currPos.H
		
		if (this.debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])(X=" X " ,Y=" Y " ,W=" W " ,H=" H ")]" ; _DBG_		
		WinMove % "ahk_id" this._hWnd, , X, Y, W, H
	}

/*
===============================================================================
Function: rollup
	Toogles "rollup" for window

Parameters:
	mode - "on", "off", "toggle" (Default)

See also:  
	<__isRolledUp>

Author(s):
	20130312 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	rollup(mode="toggle") {
		if (this.debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> CurrentState:" this.rolledUp ; _DBG_
		foundpos := RegExMatch(mode, "i)on|off|toggle")
		if (foundpos = 0)
			mode := "toggle"

		StringLower mode,mode

		roll := 1
		if (mode = "on") 		
			roll := 1
		else if (mode = "off") 
			if (this.rolledUp == true)
				roll := 0 ; Only rolled window can be unrolled
			else
				roll := -1 ; As window is not rolled up, you cannot unroll it as requested ....
		else {
			if (this.rolledUp == true)
				roll := 0
			else
				roll := 1
		}
		
		; Determine the minmal height of a window
		MinWinHeight := this.rolledUpHeight
		; Get size of current window
		hwnd := this._hWnd
		currPos := this.pos
	
		if (roll == 1) { ; Roll
            this.move(currPos.x, currPos.y, currPos.w, MinWinHeight)
		}
		else if (roll = 0) { ; Unroll
			this.__posRestore()			
		}
		
		if (this.debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "], mode=" mode ")] -> NewState:" this.rolledUp ; _DBG_

	}

/*
===============================================================================
Function:   show
	Shows the Window. Used to show a hidden window (see <hide>)
	
See also:
	<hide>, <__isHidden>

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	show() {
		val := this._hWnd
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])]" ; _DBG_		
		WinShow ahk_id %val%
	}


/*
===============================================================================
Function: __centercoords
	Determine center of the window (*INTERNAL*)

Returns:
	<Rectangle> - Rectangle containing the current center and size (0) of the window

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__centercoords() {
		pos := this.Pos
		x := Round((pos.w)/2 + pos.x)
		y := Round((pos.h)/2 + pos.y)
		centerPos := new Rectangle(x,y,0,0,this.debug)
		if (this.debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(pos="pos.dump() " [" this._hWnd "])] -> " centerPos.dump() ; _DBG_
		return centerPos
	}

/*
===============================================================================
Function:   __classname 
	Determines the Window class (*INTERNAL*)

Returns:
	WindowClass

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
=============================================================================== 
*/
	__classname() {
		val := this._hWnd
		WinGetClass, __classname, ahk_id %val%
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "]) -> (" __classname ")]" ; _DBG_		
		return __classname
	}

/*
===============================================================================
Function:   __exist
	Checks if the specified window exists (*INTERNAL*)

Returns:
	true or false

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__exist() {
		val := this._hWnd
		_hWnd := WinExist("ahk_id " val)
		ret := true
		if (_hWnd = 0)
			ret := false
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_		
		return ret
	}

/*
===============================================================================
Function:   __isAlwaysOnTop
	Determine whether window is set to "always on top" (*INTERNAL*)

Returns:
	True or False

See also:  
	<alwaysOnTop>, <__Get>

Author(s):
	20130308 - hoppfrosch@ahk4.me - Initial
===============================================================================
*/
	__isAlwaysOnTop() {
		val := this._hWnd
		ret := (this.styleEx & 0x08) ; WS_EX_TOPMOST
		ret := ret>0?1:0
		
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_
		return ret
	}

/*
===============================================================================
Function:   __isHidden
	Checks whether the window is hidden (*INTERNAL*)

Returns:
	true (window is hidden), false (window is visible) or -1 (window does not exist at all)

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
	
See also:
	<hide>, <show>, <hidden>
===============================================================================
*/
	__isHidden() {
		prevState := A_DetectHiddenWindows
		ret := false
		DetectHiddenWindows, Off
		if this.exist {
			; As HiddenWindows are not detected, the window is not hidden in this case ...
			ret := false
		} 
		else {
			DetectHiddenWindows, On 
			if this.exist {
				; As HiddenWindows are detected, the window is hidden in this case ...
				ret := true
			} 
			else {
				; the window does not exist at all ...
				ret := -1
			}
		}
		
		DetectHiddenWindows, %prevState%
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_		
		return ret
	}


/*
===============================================================================
Function:   __isResizable
    Determine whether window can be resized by user (*INTERNAL*)

Returns:
    True or False
     
Author(s):
    20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__isResizable() {
		ret := true
		if this.__classname in Chrome_XPFrame,MozillaUIWindowClass
			ret := true
		else 
		    ret := (this.style & 0x40000) ; WS_SIZEBOX
		
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_		
		
		return ret
}

/*
===============================================================================
Function:   __isRolledUp
	Checks whether the window is rolled up (*INTERNAL*)

Returns:
	true (window is rolled up), false (window is not rolled up) or -1 (window does not exist at all)

Author(s):
	20130312 - hoppfrosch@ahk4.me - Original
	
See also:
	<rollup>
===============================================================================
*/
	__isRolledUp() {
		ret := 0
		if !this.exist {
			; the window does not exist at all ...
			ret := -1
		}
		else {
			currPos := this.pos
			if (currPos.h <= this.rolledUpHeight) {
				ret := 1
			}
		}
			
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " ret ; _DBG_		
		
		return ret
	}


/*
===============================================================================
Function:  __ monitorID
    Determines ID of monitor the window currently is on (i.e center of window) (*INTERNAL*)

Returns:
    MonitorID
     
Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__monitorID(default=1) {
		mon := default
		c := this.centercoords
		mme := new MultiMonitorEnv(this.debug)
		mon := mme.monGetFromCoord(c.x,c.y,default)
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> " mon ; _DBG_		
		return mon
}
	
/*
===============================================================================
Function: __pos
	Determine current position of the window (*INTERNAL*)

Returns:
	<Rectangle> - Rectangle containing the current position and size of the window

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__pos() {
		currPos := new Rectangle(0,0,0,0,this.debug)
		currPos.fromHWnd(this._hWnd)
		if (this.debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])] -> (" currPos.dump() ")" ; _DBG_
		return currPos
	}

/*
===============================================================================
Function: __posPush
	Pushes current position of the window on position stack (*INTERNAL*)

Author(s):
	20130311 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__posPush() {
		this._posStack.Insert(1, this.pos)
		if (this.debug) { ; _DBG_ 
			this.__posStackDump() ; _DBG_ 
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])] -> (" this._posStack[1].dump() ")" ; _DBG_
		}
	}

/*
===============================================================================
Function: __posStackDump
	Dumps the current position stack via OutputDebug (*INTERNAL*)

Author(s):
	20130312 - hoppfrosch@ahk4.me - Original
===============================================================================
*/	
	__posStackDump() {
		For key,value in this._posStack	; loops through all elements in Stack
		
			OutputDebug % "|[" A_ThisFunc "()] -> (" key "): (" Value.dump() ")" ; _DBG_
		return
	}
	
/*
===============================================================================
Function: __posRestore
	Restores position of the window  from Stack(*INTERNAL*)

Parameters:
	index - Index of position to restore (Default = 2) (1 is the current position)

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__posRestore(index="2") {
		if (this.debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "], index=" index ")]" ; _DBG_
		restorePos := this._posStack[index]
		currPos := this.pos
		
		this.__posStackDump()
		
		this.move(restorePos.x, restorePos.y, restorePos.w, restorePos.h)
		if (this.debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])] LastPos: " currPos.Dump() " - RestoredPos: " restorePos.Dump() ; _DBG_
	}


/*
===============================================================================
Function:   __style
	Determines the current style of the window (*INTERNAL*)
	
Returns:
	Current Style

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__style() {
		val := this._hWnd
		WinGet, currStyle, Style, ahk_id %val%
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> (" currStyle ")" ; _DBG_		
		return currStyle
	}

/*
===============================================================================
Function:   __styleEx
	Determines the current extended style of the window (*INTERNAL*)
	
Returns:
	Current Extended Style

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__styleEx() {
		val := this._hWnd
		WinGet, currExStyle, ExStyle, ahk_id %val%
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])] -> (" currExStyle ")" ; _DBG_		
		return currExStyle
	}

/*
===============================================================================
Function:   __title
	Determines the Window title (*INTERNAL*)
	
Returns:
	WindowTitle

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/
	__title()	{
		val := this._hWnd
		WinGetTitle, title, ahk_id %val%
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "]) -> (" title ")]" ; _DBG_		
		return title
	}

/*
===============================================================================
Function: __debug
	Set or get the debug flag (*INTERNAL*)

Parameters:
	value - Value to set the debug flag to (OPTIONAL)

Returns:
	true or false, depending on current value

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/  
	__debug(value="") { ; _DBG_
		if % (value="") ; _DBG_
			return this.debug ; _DBG_
		value := value<1?0:1 ; _DBG_
		this.debug := value ; _DBG_
		return this.debug ; _DBG_
	} ; _DBG_

/*
===============================================================================
Function: __SetWinEventHook
	Set the hook for certain win-events (*INTERNAL*)

Parameters:
	see siehe http://msdn.microsoft.com/en-us/library/windows/desktop/dd373885(v=vs.85).aspx

Returns:
	true or false, depending on result of dllcall

Author(s):
	20130311 - hoppfrosch@ahk4.me - Original
===============================================================================
*/  
	__SetWinEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags) {
		if (this.debug) ; _DBG_ 
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])(eventMin=" eventMin ", eventMax=" eventMax ", hmodWinEventProc=" hmodWinEventProc ", lpfnWinEventProc=" lpfnWinEventProc ", idProcess=" idProcess ", idThread=" idThread ", dwFlags=" dwFlags ")"  ; _DBG_
		
		ret := DllCall("ole32\CoInitialize", Uint, 0)
		; This is a WinEventProc (siehe http://msdn.microsoft.com/en-us/library/windows/desktop/dd373885(v=vs.85).aspx) - this determines parameters which can be handled by "HookProc"
		ret := DllCall("user32\SetWinEventHook"
			, Uint,eventMin   
			, Uint,eventMax   
			, Uint,hmodWinEventProc
			, Uint,lpfnWinEventProc
			, Uint,idProcess
			, Uint,idThread
			, Uint,dwFlags)   
		return ret
	}
	
	/*
===============================================================================
Function:   __onLocationChange
	Callback on Object-Event <CONST_EVENT.OBJECT.LOCATIONCHANGE> or on <CONST_EVENT.SYSTEM.MOVESIZEEND>
	
	Store windows size/pos on each change

Author(s):
	20130312 - hoppfrosch@ahk4.me - AutoHotkey-Implementation
===============================================================================
*/
	__onLocationChange() {
		if this._hWnd = 0
			return
		
		if (this.debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "([" this._hWnd "])" ; _DBG_
		
		currPos := this.pos
		lastPos := this._posStack[1]
		
		; current size/position is identical with previous Size/position
		if (currPos.equal(lastPos)) {
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])] Position has NOT changed!" ; _DBG_
			return
		}
		
		; size/position has been changed -> store it!
		this.__posPush()
				
		if (this.debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "([" this._hWnd "])] LastPos: " lastPos.Dump() " - NewPos: " currPos.Dump() ; _DBG_
		return
	}

 
/*
===============================================================================
Function: __Delete
	Destructor (*INTERNAL*)

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/     
	__Delete() {
		if (this.__hWinEventHook1)
			DllCall( "user32\UnhookWinEvent", Uint,this._hWinEventHook1 )
		if (this.__hWinEventHook2)
			DllCall( "user32\UnhookWinEvent", Uint,this._hWinEventHook2 )
		if (this._HookProcAdr)
			DllCall( "kernel32\GlobalFree", UInt,&this._HookProcAdr ) ; free up allocated memory for RegisterCallback
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])"  ; _DBG_
		
		; Reset all "dangerous" settings (all windows should be left in a user accessable state)
		if (this.alwaysontop == true) {
			this.alwaysOnTop("off")
		}
		if (this.__isHidden() == 1) {
			this.show()
		}
		if (this.debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "([" this._hWnd "])"  ; _DBG_
		
		ObjRelease(&this)
	}

/*
===============================================================================
Function: __Get
	Custom Getter (*INTERNAL*)

	Supports following attributes:
	* *alwaysontop* - is windows fixed on top of all other windows? (see <__isAlwaysOnTop>)
	* *centercoords* - current coordinates of the center of the window (see <__centercoords>)
	* *classname* - classename of window (see <__classname>)
	* *exist* - does window exist? (see <__exist>)
	* *hidden* - is window hidden? (see <__hidden>)
	* *monitorID* - ID of monitor the window currently is on (i.e center of window) (see <__monitorID>)
	* *pos* - current position of window Returns an object of class <Rectangle> (see <__pos>)
	* *resizable* - is the window resizeable?  Returns a bool containig the Resizeble-state of the window (see <_isResizable>)
	* *rolledUpHeight* - Height of a rolled-up window		
	* *style* - Style of the window (see <__style>)
	* *styleEx* - extended style of window (see <__styleEx>)
	* *title* - title of window (see <__title>)
	
Author(s):
	20121030 - hoppfrosch - Original
===============================================================================
*/     
	__Get(aName) {
		ret := 
		if (this.debug) ; _DBG_
			if (aName != "debug")
				OutputDebug % ">[" A_ThisFunc "(" aName ", [" this._hWnd "])]" ; _DBG_
			
        if (aName = "alwaysontop") {
			ret := this.__isAlwaysOnTop()
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret ; _DBG_
			return ret
		}
		else if (aName = "centercoords") { ; center coordinate of the current window
			ret := this.__centercoords()
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret.Dump() ; _DBG_
			return ret
		}
        else if (aName = "classname") {
			ret := this.__classname()
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret ; _DBG_
			return ret
		}
		else if (aName = "exist") {
			ret := this.__exist()
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret ; _DBG_
			return ret
		}
		else if (aName = "hidden") {
			ret := this.__isHidden()
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret ; _DBG_
			return ret
		}
		else if (aName = "monitorID") {
			ret := this.__monitorID()
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret ; _DBG_
			return ret
		}
		else if (aName = "pos") { ; current position
			ret := this.__pos()
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret.Dump() ; _DBG_
			return ret
		}
		else if (aName = "resizeable") { 
			ret := this.__isResizable()
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret ; _DBG_
			return ret
		}
		else if (aName = "rolledUp") {
			ret := this.__isRolledUp()
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret ; _DBG_
			return ret
		}
		else if (aName = "rolledUpHeight") {
			SysGet, ret, 29
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret ; _DBG_
			return ret
		}
		else if (aName = "style") {
			ret := this.__style()
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret ; _DBG_
			return ret
		}
		else if (aName = "styleEx") {
			ret := this.__styleEx()
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret ; _DBG_
			return ret
		}
		else if (aName = "title") {
			ret :=  this.__title()
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(" aName ", [" this._hWnd "])] -> " ret ; _DBG_
			return ret
		}
		else {
			return
		}
		return ret
	}

/*
===============================================================================
Function: __New
	Constructor (*INTERNAL*)

Parameters:
	hWnd - Window handle (*Obligatory*). If hWnd=0 a test window is created ...
	debug - Flag to enable debugging (Optional - Default: 0)

Returns:
	true or false, depending on current value

Author(s):
	20130308 - hoppfrosch@ahk4.me - Original
===============================================================================
*/     
	__New(_hWnd=-1, debug=0, _test=0) {
		this.debug := debug
		if (this.debug) ; _DBG_
			OutputDebug % ">[" A_ThisFunc "(hWnd=(" _hWnd "))] (version: " this._version ")" ; _DBG_

		if % (A_AhkVersion < "1.1.08.00" && A_AhkVersion >= "2.0") {
			MsgBox 16, Error, %A_ThisFunc% :`n This class is only tested with AHK_L later than 1.1.08.00 (and before 2.0)`nAborting...
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(...) -> ()]: *ERROR* : This class is only tested with AHK_L later than 1.1.08.00 (and before 2.0). Aborting..." ; _DBG_
			return
		}

		if  % (_hWnd = 0) {
			; Create a Testwindow ...
			Run, notepad.exe
			WinWait, ahk_class Notepad, , 2
			WinMove, ahk_class Notepad,, 10, 10, 300, 300
			_hWnd := WinExist("ahk_class Notepad")
		} else if % (_hWnd = -1) {
			; hWnd is missing
			MsgBox  16, Error, %A_ThisFunc% :`n Required parameter is missing`nAborting...
			if (this.debug) ; _DBG_
				OutputDebug % "<[" A_ThisFunc "(...) -> ()] *ERROR*: Required parameter is missing. Aborting..." ; _DBG_
			return
		}
		this._hWnd := _hWnd
		this._posStack := Object() ; creates initially empty stack
		
		; initially store the position to detect movement of window and allow window restoring
		this.__posPush()
		
		; Registering global callback and storing adress (&this) within A_EventInfo
		ObjAddRef(&this)
		this._HookProcAdr := RegisterCallback("ClassWindowHandler_EventHook", "", "", &this)
		; Setting Callback on Adress <_HookProcAdr> on appearance of any event out of certain range
		this._hWinEventHook1 := this.__SetWinEventHook( CONST_EVENT.SYSTEM.SOUND, CONST_EVENT.SYSTEM.DESKTOPSWITCH, 0, this._HookProcAdr, 0, 0, 0 )	
		this._hWinEventHook2 := this.__SetWinEventHook( CONST_EVENT.OBJECT.SHOW, CONST_EVENT.OBJECT.CONTENTSCROLLED, 0, this._HookProcAdr, 0, 0, 0 )	
		
		if (this.debug) ; _DBG_
			OutputDebug % "<[" A_ThisFunc "(hWnd=(" _hWnd "))]" ; _DBG_
		
		
		return this
	}
	
}


/*
===============================================================================
Function:   ClassWindowHandler_EventHook
	Callback on System Events. Used as dispatcher to detect window manipulation and calling the appropriate member-function within class <WindowHandler>
	
Author(s):
	20120629 - hoppfrosch - Original

See also:
	http://www.autohotkey.com/community/viewtopic.php?t=35659
	http://www.autohotkey.com/community/viewtopic.php?f=1&t=88156
===============================================================================
*/
ClassWindowHandler_EventHook(hWinEventHook, Event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime ) {
	; ClassWindowHandler_EventHook is used as WindowsEventHook - it's registered as callback within <__SetWinEventHook> of class <WindowHandler>.
	; ClassWindowHandler_EventHook is a WinEventProc (see http://msdn.microsoft.com/en-us/library/windows/desktop/dd373885(v=vs.85).aspx) and has those Parameter ...	

	; This function is called on the registered event(s) on every window - regardless whether it's an object instance or not
	; We have to check whether the current call refers to the current instance of the class WindowHandler
	; HINT: A_EventInfo currently holds the address of the current WindowsHandler object instance (set during RegisterCallback ... see <__New>)
	
	; Don't handle any windows, that are not class instances ...
	if (hWnd != Object(A_EventInfo)._hWnd)
		return
	self := Object(A_EventInfo)

	if (Object(A_EventInfo).debug) ; _DBG_
		OutputDebug % ">[" A_ThisFunc "([" Object(A_EventInfo)._hWnd "])(hWinEventHook=" hWinEventHook ", Event=" Event2Str(Event) ", hWnd=" hWnd ", idObject=" idObject ", idChild=" idChild ", dwEventThread=" dwEventThread ", dwmsEventTime=" dwmsEventTime ") -> A_EventInfo: " A_EventInfo ; _DBG_
	
	; ########## START: Handling window movement ##################################################
	; We want to detect when the window movement has finished finally, as onLocationChanged() has only to be called at the END of the movement
	;
	; It has to be detected whether the location change was initiated by user dragging/rezizing ("manual movement") or any other window event ("non-manual movement").
	; * Manual movement triggers the following sequence: CONST_EVENT.SYSTEM.MOVESIZESTART - N times CONST_EVENT.OBJECT.LOCATIONCHANGE - CONST_EVENT.SYSTEM.MOVESIZEEND
	; * Non-manual movement by for example AHK WinMove only triggers: 1 time CONST_EVENT.OBJECT.LOCATIONCHANGE
	
	; +++ MANUAL MOVEMENT
	; The window is moved manually - as the movement isn't finished, don't call callback. Just store that we are in middle of manual movement
	if (Event == CONST_EVENT.SYSTEM.MOVESIZESTART) {
		Object(A_EventInfo)._bManualMovement := true
		return
	}
	; Manual movement has finished - trigger onLocationChange callback now
	if (Event == CONST_EVENT.SYSTEM.MOVESIZEEND) {
		Object(A_EventInfo)._bManualMovement := false
		Object(A_EventInfo).__onLocationChange()
		return
	}
	
	; +++ NON-MANUAL MOVEMENT
	; OutputDebug % "|[" A_ThisFunc "([" Object(A_EventInfo)._hWnd "])] -> Manual Movement " Object(A_EventInfo)._bManualMovement
	
	if (Event == CONST_EVENT.OBJECT.LOCATIONCHANGE) {
		if (Object(A_EventInfo)._bManualMovement == false) {
			; As its no manual movement, trigger onLocationChange callback now
			Object(A_EventInfo).__onLocationChange()
			return
		}
	}
	; ########## END: Handling window movement ####################################################
	return
}