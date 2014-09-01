#Persistent
;#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force

#include <TaskDialog>
#include <WindowHandler>
#Include <EDE_XMLConfig>

SetWorkingDir %A_ScriptDir%  

;-------------------------------------------------------------------------------------------------------
;------------------- Global Variables
gEDE := object()
gEDE.State := object()
gEDE.State.Active := object()
gEDE.State.WinList := object()
gEDE.State.Key := object()
gEDE.State.Tab := object()
gEDE.State.Tab.current := object()
gEDE.Info := object()
gEDE.Info.App := object()
gEDE.Config := object()

gEde.State.EDEActive := 0
gEDE.State.Tab.Current.Name := "Tab1"
gEDE.State.Tab.Current.hWnd := 

gEDE.State.Key.Current := ""
gEDE.State.Key.Previous := ""
gEDE.State.Key.Reprise := 0

gEDE.Info.App.Name := "EDE"
gEDE.Info.App.Version := "0.6.0"

gEDE.Info.App.NameVersion := gEDE.Info.App.Name " V" gEDE.Info.App.Version

;-------------------------------------------------------------------------------------------------------
;------------------- Misc task for preparation
LoadConfig()

val := gEDE.config.RepeatedKeypress.Timeout.text
SetTimer, ExpireReprisedKeypress, %val%

;-------------------------------------------------------------------------------------------------------
;------------------- Building up the GUI

; GUI is build from 4 separate GUIs - each represented by a 4x5 array of icons (representing  the NUMPAD)
; Row 0 represents the tab-row. Clicking on icon in row 0 will switch to another pseudo-tab (another GUI)

;  Icon position within the 4x5 array GUI
pos_TAB1    := "x4 y4 w16 h16"
pos_TAB2    := "x24 y4 w16 h16"
pos_TAB3    := "x44 y4 w16 h16"
pos_TAB4    := "x64 y4 w16 h16"
pos_NP_NUM  := "x4 y24 w16 h16"    ; Numpad "NUM"-key
pos_NP_DIV  := "x24 y24 w16 h16"   ; Numpad "%"-key"
pos_NP_MULT := "x44 y24 w16 h16"   ; Numpad "*"-key"
pos_NP_SUB  := "x64 y24 w16 h16"   ; Numpad "-"-key
pos_NP_7    := "x4 y44 w16 h16"    ; Numpad "7"-key
pos_NP_8    := "x24 y44 w16 h16"   ; Numpad "8"-key
pos_NP_9    := "x44 y44 w16 h16"   ; Numpad "9"-key
pos_NP_ADD  := "x64 y44 w16 h38"   ; Numpad "+"-key
pos_NP_ADD1 := "x64 y44 w16 h16"   ; Numpad "+"-key (upper)
pos_NP_ADD2 := "x64 y64 w16 h16"   ; Numpad "+"-key (lower)
pos_NP_ADD3 := "x64 y54 w16 h16"   ; Numpad "+"-key (center)
pos_NP_4    := "x4 y64 w16 h16"    ; Numpad "4"-key
pos_NP_5    := "x24 y64 w16 h16"   ; Numpad "5"-key
pos_NP_6    := "x44 y64 w16 h16"   ; Numpad "6"-key
pos_NP_1    := "x4 y84 w16 h16"    ; Numpad "1"-key
pos_NP_2    := "x24 y84 w16 h16"   ; Numpad "2"-key
pos_NP_3    := "x44 y84 w16 h16"   ; Numpad "3"-key
pos_NP_ENT  := "x64 y84 w16 h36"   ; Numpad "ENTER"-key
pos_NP_ENT1 := "x64 y84 w16 h16"   ; Numpad "ENTER"-key (Upper)
pos_NP_ENT2 := "x64 y104 w16 h16"  ; Numpad "ENTER"-key (lower)
pos_NP_ENT3 := "x64 y94 w16 h16"   ; Numpad "ENTER"-key (center)
pos_NP_0    := "x4 y104 w36 h16"   ; Numpad "0"-key
pos_NP_01   := "x4 y104 w16 h16"   ; Numpad "0"-key (left)
pos_NP_02   := "x24 y104 w16 h16"  ; Numpad "0"-key (right)
pos_NP_03   := "x14 y104 w16 h16"  ; Numpad "0"-key (right)
pos_NP_DOT  := "x44 y104 w16 h16"  ; Numpad ","-key

icoTab1 := A_ScriptDir "\res\arrow-move.ico"
icoTab2 := A_ScriptDir "\res\monitor.ico"
icoTab3 := A_ScriptDir "\res\animal-monkey.ico"
icoTab4 := A_ScriptDir "\res\animal-penguin.ico"

Loop 4 {
	Gui %A_Index%:+LastFound +AlwaysOnTop
	WinSet, Transparent, 200
	Gui %A_Index%:-Caption
	
	; Build the Tab-Row as Row of icons (active tab should have a "pressed" icon)
	if (A_Index == 1) {
		Gui, %A_Index%:Add, Picture, %pos_TAB1% E0x200 gToogleTab vTab1, %icoTab1%
	}
	else {
		Gui, %A_Index%:Add, Picture, %pos_TAB1% 0x800000 gToogleTab vTab1, %icoTab1%
	}
	if (A_Index == 2) {
		Gui, %A_Index%:Add, Picture, %pos_TAB2% E0x200 gToogleTab vTab2, %icoTab2%
	}
	else {
		Gui, %A_Index%:Add, Picture, %pos_TAB2% 0x800000 gToogleTab vTab2, %icoTab2%
	}
	if (A_Index == 3) {
		Gui, %A_Index%:Add, Picture, %pos_TAB3% E0x200 gToogleTab vTab3, %icoTab3%
	}
	else {
		Gui, %A_Index%:Add, Picture, %pos_TAB3% 0x800000 gToogleTab vTab3, %icoTab3%
	}
	
	if (A_Index == 4) {
		Gui, %A_Index%:Add, Picture, %pos_TAB4% E0x200 gToogleTab vTab4, %icoTab4%
	}
	else {
		Gui, %A_Index%:Add, Picture, %pos_TAB4% 0x800000 gToogleTab vTab4, %icoTab4%
	}
}

; Contents of Tab1
tabTmp := 1
Gui, %tabTmp%:Add, Picture, %pos_NP_DOT%   0x800000 glTab%tabTmp% vDot,  %A_ScriptDir%\res\information-frame.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_7%     0x800000 glTab%tabTmp% v7,    %A_ScriptDir%\res\arrow-135.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_4%     0x800000 glTab%tabTmp% v4,    %A_ScriptDir%\res\arrow-180.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_1%     0x800000 glTab%tabTmp% v1,    %A_ScriptDir%\res\arrow-225.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_8%     0x800000 glTab%tabTmp% v8,    %A_ScriptDir%\res\arrow-090.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_5%     0x800000 glTab%tabTmp% v5,    %A_ScriptDir%\res\dot.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_2%     0x800000 glTab%tabTmp% v2,    %A_ScriptDir%\res\arrow-270.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_9%     0x800000 glTab%tabTmp% v9,    %A_ScriptDir%\res\arrow-045.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_6%     0x800000 glTab%tabTmp% v6,    %A_ScriptDir%\res\arrow-000.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_3%     0x800000 glTab%tabTmp% v3,    %A_ScriptDir%\res\arrow-315.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_0%     0x800000 gNYI          v0, 
Gui, %tabTmp%:Add, Picture, %pos_NP_03%             gNYI,                %A_ScriptDir%\res\arrow-circle.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_ADD%   0x800000 glTab%tabTmp% vAdd, 
Gui, %tabTmp%:Add, Picture, %pos_NP_ADD3%           glTab%tabTmp%,       %A_ScriptDir%\res\arrow-out.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_SUB%   0x800000 glTab%tabTmp% vSub,  %A_ScriptDir%\res\arrow-in.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_MULT%  0x800000 glTab%tabTmp% vMult, %A_ScriptDir%\res\Cross.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_DIV%   0x800000 glTab%tabTmp% vDiv,  %A_ScriptDir%\res\Pin.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_ENT%   0x800000 glTab%tabTmp% vEnter, 
Gui, %tabTmp%:Add, Picture, %pos_NP_ENT3%           glTab%tabTmp%,       %A_ScriptDir%\res\arrow-resize-090.ico

; Contents of tab 2
tabTmp :=  2
Gui, %tabTmp%:Add, Picture, %pos_NP_ADD%   0x800000 glTab%tabTmp% vAdd, 
Gui, %tabTmp%:Add, Picture, %pos_NP_ADD3%           glTab%tabTmp%,       %A_ScriptDir%\res\monitor--arrow.ico

; Contents of tab 4
tabTmp := 4
Gui, %tabTmp%:Add, Picture, %pos_NP_SUB%  0x800000 glTab%tabTmp% vSub, %A_ScriptDir%\res\information-white.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_1%    0x800000 glTab%tabTmp% v1,   %A_ScriptDir%\res\puzzle--pencil.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_2%    0x800000 glTab%tabTmp% v2,   %A_ScriptDir%\res\puzzle--exclamation.ico

Menu, Tray, Icon, %A_ScriptDir%\res\EDE.ico

return 


;-------------------------------------------------------------------------------------------------------
;------------------- Hotkeys
$ESC:: ; <--- Hide
	; Hide EDE-window if mouse is over EDE-GUI 
	MouseGetPos, , , id, control
	WinGetTitle, title, ahk_id %id%
	if (title == "EDE") {
		gEDE.State.Tab.Current.hWnd := 
		HideGUI()
	}
	else {
		Send, {Esc}
	}
	return 
	

#Numpad1:: ; <--- Activate/toggles EDE-Tab 1
#Numpad2:: ; <--- Activate/toggles EDE-Tab 2
#Numpad3:: ; <--- Activate/toggles EDE-Tab 3
#Numpad4:: ; <--- Activate/toggles EDE-Tab 4
	OutputDebug % ">[EDE] " A_ThisHotkey " pressed"
	; Get current window
	WinGet, hWnd, ID, A 
	if (gEDE.State.WinList[hwnd] == "" ) {
		gEDE.State.WinList[hwnd] := new WindowHandler(hwnd, 1)
	}
	; gEDE.State.WinList[0] contains always windowsHandler of currently active window
	gEDE.State.WinList[0] := gEDE.State.WinList[hwnd]
	id := SubStr(A_ThisHotkey,0)
	Tab := "Tab" id
	OutputDebug % ">[EDE] Activating Tab <" Tab ">"
	ShowGui(Tab, 1)
	OutputDebug % "<[EDE] " A_ThisHotkey " done"
	return
	
; Numpad-Keypress on a certain tab
#If (gEde.State.EDEActive == 1)
$NumLock:: ; <--- Action on the current activ EDE-Tab
$NumpadDiv:: ; <--- Action on the current activ EDE-Tab
$NumpadMult:: ; <--- Action on the current activ EDE-Tab
$NumpadSub:: ; <--- Action on the current activ EDE-Tab
$NumpadAdd:: ; <--- Action on the current activ EDE-Tab
$NumpadEnter:: ; <--- Action on the current activ EDE-Tab
$NumpadDot:: ; <--- Action on the current activ EDE-Tab
$Numpad0:: ; <--- Action on the current activ EDE-Tab
$Numpad1:: ; <--- Action on the current activ EDE-Tab
$Numpad2:: ; <--- Action on the current activ EDE-Tab
$Numpad3:: ; <--- Action on the current activ EDE-Tab
$Numpad4:: ; <--- Action on the current activ EDE-Tab
$Numpad5:: ; <--- Action on the current activ EDE-Tab
$Numpad6:: ; <--- Action on the current activ EDE-Tab
$Numpad7:: ; <--- Action on the current activ EDE-Tab
$Numpad8:: ; <--- Action on the current activ EDE-Tab
$Numpad9:: ; <--- Action on the current activ EDE-Tab
	id := activeTabId()
	Tab%id%(SubStr(A_ThisHotkey,8)) ; 
	Return

; ----------------------------------------------------------------------------
; --- Labels -----------------------------------------------------------------
ToogleTab:
	ShowGui(A_GuiControl)
	return
	
GuiClose: 
   ExitApp

lTab1:
	Tab1(A_GuiControl)
	return

lTab2:
	Tab2(A_GuiControl)
	return
	
lTab3:
	Tab3(A_GuiControl)
	return
	
lTab4:
	Tab4(A_GuiControl)
	return
	
NYI:
    NotYetImplemented()
    return
	
ExpireReprisedKeypress:
	if (gEDE.State.waitForReprisedKeyPress == 1) {
		OutputDebug % ">>>>>>>>>>>>>>>>Reprised Keypress expired<<<<<<<<<<<<<<<<<<<<<<<<<<<"
		gEDE.State.waitForReprisedKeyPress := 0
		gEDE.State.Key.Reprise := 0
		gEDE.State.Key.Previous := ""
		SetTimer, ExpireReprisedKeypress
	}
	return
   
; ----------------------------------------------------------------------------
; --- Functions --------------------------------------------------------------
ShowGui(tab := "Tab1", updatePos = 0) {
	Global gEDE
	TabId := RegExReplace(gEDE.State.Tab.Current.Name , "i)Tab(\d+)", "$1")
	Gui, %TabId%:hide
	gEDE.State.Tab.Current.Name := tab
	gEDE.State.Tab.Current.Id := TabId
	gEde.State.EDEActive := 1
	TabId := RegExReplace(tab, "i)Tab(\d+)", "$1")
	if (updatePos == 1) {
		; GUI is shown at current mouseposition
		CoordMode, Mouse, Screen
		MouseGetPos, xpos, ypos 
		Gui, %TabId%:Show, x%xpos% y%ypos% h124 w84,EDE
	}
	else {
		; GUI stays on current position - used when changing the tab
		WinGetPos, x, y, w, h,
		Gui, %TabId%:Show
	}
	
	WinGet, hWnd, ID, A 
	gEDE.State.Tab.Current.hWnd := hWnd
	return
}

HideGui() {
	Global gEDE
	TabId := activeTabId()
	Gui, %TabId%:hide
	gEde.State.EDEActive := 0
}

NotYetImplemented() {
    Global gEDE
    TaskDialog(0, gEDE.Info.App.NameVersion "|Not yet implemented|A_Gui: <" A_Gui ">`nA_GuiControl: <" A_GuiControl ">`nA_GuiEvent: <" A_GuiEvent ">`nA_EventInfo: <" A_EventInfo ">", "", 1, "WARNING")
}

Tab1(GuiControl) {
	Global gEDE
	
	gEDE.State.Key.Previous := gEDE.State.Key.Current
	gEDE.State.Key.Current := GuiControl
	OutputDebug % "[EDE-Keypress] Tab: <" gEDE.State.Tab.Current.Id "> - Key: <" gEDE.State.Key.Current "> - Previous: <" gEDE.State.Key.Previous ">"
	
	; If a Numpad-Key is pressed repeatedly, cycle through the configuration ....
	if (gEDE.State.Key.Previous == gEDE.State.Key.Current) {
		gEDE.State.Key.Reprise := gEDE.State.Key.Reprise + 1
		if (gEDE.State.Key.Reprise > gEDE.Config.align[gEDE.State.Key.Current].cnt) {
			gEDE.State.Key.Reprise := 1
		}
	}
	else {
		gEDE.State.Key.Reprise := 1
	}
	
	if (gEDE.State.Key.Current == "Dot") {
		HideGUI()
		TaskDialog(gEDE.State.WinList[0]._hwnd, gEDE.Info.App.NameVersion " - WindowsInfo|hWnd: <" gEDE.State.WinList[0]._hwnd ">|Title: <" gEDE.State.WinList[0].title ">`nGuiControl: <" gEDE.State.Key.Current ">`n", "", 1, "INFO")
	}
	else if(gEDE.State.Key.Current >= "1" && gEDE.State.Key.Current <= "9") { ; Any key of Numpad1 to Numpad9 is pressed ...
		factors := gEDE.Config.align[gEDE.State.Key.Current].pos[gEDE.State.Key.Reprise]		
		OutputDebug % "*** Key "gEDE.State.Key.Current "- Reprise:" gEDE.State.Key.Reprise ":" factors.x "-" factors.y "-" factors.width "-" factors.height
		gEDE.State.WinList[0].movePercental(factors.x, factors.y, factors.width, factors.height)
		gEDE.State.waitForReprisedKeyPress := 1
		SetTimer, ExpireReprisedKeypress
	}
	else if(gEDE.State.Key.Current == "Add") {
		HideGUI()
		gEDE.State.WinList[0].maximized := 1
	}
	else if(gEDE.State.Key.Current == "Sub") {
		HideGUI()
		gEDE.State.WinList[0].minimized := 1
	}
	else if(gEDE.State.Key.Current == "Mult") {
		HideGUI()
		gEDE.State.WinList[0].kill()
	}
	else if(gEDE.State.Key.Current == "Div") {
		HideGUI()
		gEDE.State.WinList[0].alwaysOnTop := !gEDE.State.WinList[0].alwaysOnTop
	}
	else if(gEDE.State.Key.Current == "Enter") {
		HideGUI()
		gEDE.State.WinList[0].rolledUp := !gEDE.State.WinList[0].rolledUp
	}
	else {
		HideGUI()
		NotYetImplemented()
	}
    return
}

Tab2(GuiControl) {
	Global gEDE
	gEDE.State.Key.Previous := gEDE.State.Key.Current
	gEDE.State.Key.Current := GuiControl
	OutputDebug % "[EDE-Keypress] Tab: <" gEDE.State.Tab.Current.Id "> - Key: <" gEDE.State.Key.Current "> - Previous: <" gEDE.State.Key.Previous ">"

	 if(gEDE.State.Key.Current == "Add") {
		HideGUI()
		obj := new MultiMonitorEnv()
		newID := gEDE.State.WinList[0].monitorID + 1

		; Wrap on last monitor
		if (newID> obj.monCount()) {
			newID := 1
		}
		gEDE.State.WinList[0].monitorID := newID
	}
	else {
   		NotYetImplemented()
		HideGUI()
	}
    return
}

Tab3(GuiControl) {
	Global gEDE
	gEDE.State.Key.Previous := gEDE.State.Key.Current
	gEDE.State.Key.Current := GuiControl
	
	OutputDebug % "[EDE-Keypress] Tab: <" gEDE.State.Tab.Current.Id "> - Key: <" gEDE.State.Key.Current "> - Previous: <" gEDE.State.Key.Previous ">"
	
	NotYetImplemented()
	HideGUI()
    return
}

Tab4(GuiControl) {
	Global gEDE
	gEDE.State.Key.Previous := gEDE.State.Key.Current
	gEDE.State.Key.Current := GuiControl
	
	OutputDebug % "[EDE-Keypress] Tab: <" gEDE.State.Tab.Current.Id "> - Key: <" gEDE.State.Key.Current "> - Previous: <" gEDE.State.Key.Previous ">"
	
	if (gEDE.State.Key.Current == "Sub") {
		HideGUI()
		TaskDialog(0, gEDE.Info.App.NameVersion " - About|hWnd: <" gEDE.State.WinList[0]._hwnd ">|Title: <" gEDE.State.WinList[0].title ">`nGuiControl: <" GuiControl ">`n", "", 1, "INFO")
	}
	else if(gEDE.State.Key.Current == "1") {
		LoadConfig()
	}
	else if(gEDE.State.Key.Current == "2") {
		ShowgEDE()
		HideGUI()
	}
	else {
		HideGUI()
    	NotYetImplemented()
	}
    return
}

activeTabID() {
	Global gEDE
	TabId := RegExReplace(gEDE.State.Tab.Current.Name, "i)Tab(\d+)", "$1")
	return TabId
}

LoadConfig() {
	Global gEDE
	config := new EDE_XMLConfig(A_ScriptDir "\EDE.xml")
	gEde.Config := config.contents
}

ShowgEDE() {
	Global gEde
	WinWaitClose % "ahk_id " ObjTree(gEde, "EDE-Global configuration/state")
}