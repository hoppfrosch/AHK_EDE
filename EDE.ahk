#Persistent
;#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force

#include %A_ScriptDir%
#include lib\EDE
#include Point.ahk
#include Rectangle.ahk
#include Mouse.ahk
#include MultiMonitorEnv.ahk
#include WindowHandler.ahk
#include %A_ScriptDir%
#include lib
#include TaskDialog.ahk
#include %A_ScriptDir%
#include lib\TT
#include TT.ahk

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
gEDE.Info.App.Version := "0.8.1"

gEDE.Info.App.NameVersion := gEDE.Info.App.Name " V" gEDE.Info.App.Version

;-------------------------------------------------------------------------------------------------------
;------------------- Misc task for preparation
LoadConfig()

; Setup various timers
val := gEDE.config.RepeatedKeypress.Timeout.text
SetTimer, lExpireReprisedKeypress, %val%

; Timer to AutoHide-EDE GUI
val := gEDE.config.AutoHide.Timeout.text
if (val >= 0 )
	SetTimer, lExpireAutoHide, %val%

; Timer to check for newly created windows
val = 200
SetTimer, lCheckWinExistsTrigger, %CheckPeriod%


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

TT:=TT("Parent=1")
Loop 4 {
	Gui %A_Index%:+LastFound +AlwaysOnTop
	WinSet, Transparent, 200
	Gui %A_Index%:-Caption
	
	; Build the Tab-Row as Row of icons (active tab should have a "pressed" icon)
	if (A_Index == 1) {
		Gui, %A_Index%:Add, Picture, %pos_TAB1% E0x200 gToogleTab HwndhwTab%A_index% vTab1, %icoTab1%
	}
	else {
		Gui, %A_Index%:Add, Picture, %pos_TAB1% 0x800000 gToogleTab HwndhwTab%A_index% vTab1, %icoTab1%
	}
	if (A_Index == 2) {
		Gui, %A_Index%:Add, Picture, %pos_TAB2% E0x200 gToogleTab HwndhwTab%A_index% vTab2, %icoTab2%
	}
	else {
		Gui, %A_Index%:Add, Picture, %pos_TAB2% 0x800000 gToogleTab HwndhwTab%A_index% vTab2, %icoTab2%
	}
	if (A_Index == 3) {
		Gui, %A_Index%:Add, Picture, %pos_TAB3% E0x200 gToogleTab HwndhwTab%A_index% vTab3, %icoTab3%
	}
	else {
		Gui, %A_Index%:Add, Picture, %pos_TAB3% 0x800000 gToogleTab HwndhwTab%A_index% vTab3, %icoTab3%
	}
	
	if (A_Index == 4) {
		Gui, %A_Index%:Add, Picture, %pos_TAB4% E0x200 gToogleTab HwndhwTab%A_index% vTab4, %icoTab4%
	}
	else {
		Gui, %A_Index%:Add, Picture, %pos_TAB4% 0x800000 gToogleTab HwndhwTab%A_index% vTab4, %icoTab4%
	}
	TT.Add(hwTab1,"Move/Resize active window","",1)
	TT.Add(hwTab2,"Multi Monitor actions","",1)
	TT.Add(hwTab3,"","",1)
	TT.Add(hwTab4,"Misc","",1)
	
}

; Contents of Tab1
tabTmp := 1
Gui, %tabTmp%:Add, Picture, %pos_NP_DOT%   0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_Dot   vDot, %A_ScriptDir%\res\information-frame.ico
TT.Add(hwTab%tabTmp%_Dot,"Info","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_7%     0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_7       v7,  %A_ScriptDir%\res\arrow-135.ico
TT.Add(hwTab%tabTmp%_7,"Move active window to nordwest","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_4%     0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_4       v4,  %A_ScriptDir%\res\arrow-180.ico
TT.Add(hwTab%tabTmp%_4,"Move active window to west","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_1%     0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_1       v1,  %A_ScriptDir%\res\arrow-225.ico
TT.Add(hwTab%tabTmp%_1,"Move active window to southwest","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_8%     0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_8       v8,  %A_ScriptDir%\res\arrow-090.ico
TT.Add(hwTab%tabTmp%_8,"Move active window to north","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_5%     0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_5       v5,  %A_ScriptDir%\res\dot.ico
TT.Add(hwTab%tabTmp%_5,"Move active window to center","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_2%     0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_2       v2, %A_ScriptDir%\res\arrow-270.ico
TT.Add(hwTab%tabTmp%_2,"Move active window to south","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_9%     0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_9       v9, %A_ScriptDir%\res\arrow-045.ico
TT.Add(hwTab%tabTmp%_9,"Move active window to northeast","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_6%     0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_6       v6, %A_ScriptDir%\res\arrow-000.ico
TT.Add(hwTab%tabTmp%_6,"Move active window to east","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_3%     0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_3       v3, %A_ScriptDir%\res\arrow-315.ico
TT.Add(hwTab%tabTmp%_3,"Move active window to southeast","",%tabTmp%)


Gui, %tabTmp%:Add, Picture, %pos_NP_0%     0x800000 gNYI HwndhwTab%tabTmp%_0                v0, 
TT.Add(hwTab%tabTmp%_0,"Not yet implemented","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_03%             gNYI                                      , %A_ScriptDir%\res\arrow-circle.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_ADD%   0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_Add   vAdd, 
TT.Add(hwTab%tabTmp%_Add,"Maximize","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_ADD3%           glTab%tabTmp%                             , %A_ScriptDir%\res\arrow-out.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_SUB%   0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_Sub   vSub, %A_ScriptDir%\res\arrow-in.ico
TT.Add(hwTab%tabTmp%_Sub,"Minimize","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_MULT%  0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_Mult vMult, %A_ScriptDir%\res\Cross.ico
TT.Add(hwTab%tabTmp%_Mult,"Kill","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_DIV%   0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_Div   vDiv, %A_ScriptDir%\res\Pin.ico
TT.Add(hwTab%tabTmp%_Div, "Toggle AlwaysOnTop","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_ENT%   0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_Ent vEnter, 
TT.Add(hwTab%tabTmp%_Ent, "Toggle RollUp","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_ENT3%           glTab%tabTmp%                             , %A_ScriptDir%\res\arrow-resize-090.ico

; Contents of tab 2
tabTmp :=  2
Gui, %tabTmp%:Add, Picture, %pos_NP_ADD%   0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_Add   vAdd,
TT.Add(hwTab%tabTmp%_Add,"Move to next screen","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_ADD3%           glTab%tabTmp%                             ,       %A_ScriptDir%\res\monitor--arrow.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_ENT%   0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_Ent vEnter,
TT.Add(hwTab%tabTmp%_Ent,"Locate Mousepointer","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_ENT3%           glTab%tabTmp%                             ,       %A_ScriptDir%\res\marker.ico

; Contents of tab 4
tabTmp := 4
Gui, %tabTmp%:Add, Picture, %pos_NP_SUB%  0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_Sub    vSub, %A_ScriptDir%\res\information-white.ico
TT.Add(hwTab%tabTmp%_Sub,"Info on active window","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_1%    0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_1       v1, %A_ScriptDir%\res\puzzle--pencil.ico
TT.Add(hwTab%tabTmp%_1,"Not yet implemented","",%tabTmp%)
Gui, %tabTmp%:Add, Picture, %pos_NP_2%    0x800000 glTab%tabTmp% HwndhwTab%tabTmp%_2       v2, %A_ScriptDir%\res\puzzle--exclamation.ico
TT.Add(hwTab%tabTmp%_2,"Debug - Dump main data structure","",%tabTmp%)


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

#NumpadDot:: ; <--- MouseLocator
	obj := new Mouse()
	obj.locate()
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
	if (gEDE.config.AutoHide.Timeout.text > 0)
		SetTimer, lExpireAutoHide
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

lExpireReprisedKeypress:
	if (gEDE.State.waitForReprisedKeyPress == 1) {
		OutputDebug % ">>>>>>>>>>>>>>>>Reprised Keypress expired<<<<<<<<<<<<<<<<<<<<<<<<<<<"
		gEDE.State.waitForReprisedKeyPress := 0
		gEDE.State.Key.Reprise := 0
		gEDE.State.Key.Previous := ""
		SetTimer, lExpireReprisedKeypress
	}
	return

lExpireAutoHide: ;Hide GUI automatically when losing focus
	If (gEde.State.EDEActive == 1) {
		Global gEDE
		TabId := activeTabId()
		Gui, %TabId%:hide
		gEde.State.EDEActive := 0
	}
	return

lCheckWinExistsTrigger: ; Check for new windows and at them to administrative data structure
	; Register all existing windows within EDE 
	O_DHW := A_DetectHiddenWindows, O_BL := A_BatchLines ;Save original states
	DetectHiddenWindows, % "off" 
	SetBatchLines, -1
	WinGet, all, list ;get all hwnd
	Loop, %all% {
		hwnd := all%A_Index%
		if (gEDE.State.WinList[hwnd] == "" ) {
			gEDE.State.WinList[hwnd] := new WindowHandler(hwnd, 0)
		}
	}
	DetectHiddenWindows, %O_DHW% ;back to original state
	SetBatchLines, %O_BL% ;back to original state
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
		SetTimer, lExpireReprisedKeypress
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