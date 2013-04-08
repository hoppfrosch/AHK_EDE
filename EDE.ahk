#Persistent
;#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force

#include <TaskDialog>
#include <WindowHandler>
#Include <EDE_XMLConfig>


;-------------------------------------------------------------------------------------------------------
;------------------- Global Variables
gEDE := object()
gEDE.State := object()
gEDE.State.Active := object()
gEDE.State.WinList := object()
gEDE.Info := object()
gEDE.Info.App := object()
gEDE.Config := object()

gEde.State.EDEActive := 0
gEDE.State.Active.Tab := "Tab1"
gEDE.State.Active.hWnd := 

gEDE.Info.App.Name := "EDE"
gEDE.Info.App.Version := "0.3.1"

gEDE.Info.App.NameVersion := gEDE.Info.App.Name " V" gEDE.Info.App.Version

;-------------------------------------------------------------------------------------------------------
;------------------- Misc task for preparation
SetTimer, ExpireRepeatedKeypress, 4000
LoadConfig()

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

icoTab1 := "res\arrow-move.ico"
icoTab2 := "res\animal-dog.ico"
icoTab3 := "res\animal-monkey.ico"
icoTab4 := "res\animal-penguin.ico"

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
Gui, %tabTmp%:Add, Picture, %pos_NP_SUB%  0x800000 glTab%tabTmp% vSub, res\information-frame.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_7%    0x800000 glTab%tabTmp% v7,   res\arrow-135.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_4%    0x800000 glTab%tabTmp% v4,   res\arrow-180.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_1%    0x800000 glTab%tabTmp% v1,   res\arrow-225.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_8%    0x800000 glTab%tabTmp% v8,   res\arrow-090.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_5%    0x800000 glTab%tabTmp% v5,   res\dot.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_2%    0x800000 glTab%tabTmp% v2,   res\arrow-270.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_9%    0x800000 glTab%tabTmp% v9,   res\arrow-045.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_6%    0x800000 glTab%tabTmp% v6,   res\arrow-000.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_3%    0x800000 glTab%tabTmp% v3,   res\arrow-315.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_ADD%  0x800000 gNYI          vAdd, 
Gui, %tabTmp%:Add, Picture, %pos_NP_ADD3%          gNYI,               res\arrow-circle.ico

; Contents of tab 4
tabTmp := 4
Gui, %tabTmp%:Add, Picture, %pos_NP_SUB%  0x800000 glTab%tabTmp% vSub, res\information-white.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_1%    0x800000 glTab%tabTmp% v1,   res\puzzle--pencil.ico
Gui, %tabTmp%:Add, Picture, %pos_NP_2%    0x800000 glTab%tabTmp% v2,   res\puzzle--exclamation.ico

Menu, Tray, Icon, res\EDE.ico

return 



$ESC::
	; Hide EDE-window if mouse is over EDE-GUI 
	MouseGetPos, , , id, control
	WinGetTitle, title, ahk_id %id%
	if (title == "EDE") {
		gEDE.State.Active.hWnd := 
		HideGUI()
	}
	else {
		Send, {Esc}
	}
	return 
	

#F1::
	OutputDebug % ">[EDE] [Win-F1] pressed"
	; Get current window
	WinGet, hWnd, ID, A 
	if (gEDE.State.WinList[hwnd] == "" ) {
		gEDE.State.WinList[hwnd] := new WindowHandler(hwnd, 1)
	}
	; gEDE.State.WinList[0] contains always windowsHandler of currently active window
	gEDE.State.WinList[0] := gEDE.State.WinList[hwnd]
	ShowGui(gEDE.State.Active.Tab, 1)
	OutputDebug % "<[EDE] [Win-F1] done"
	return


$1::
	if (gEde.State.EDEActive == 1) {
		ShowGui("Tab1",1)
	}
	else {
		Send, 1
	}
	return
	
$2::
	if (gEde.State.EDEActive == 1) {
		ShowGui("Tab2",1)
	}
	else {
		Send, 2
	}
	return

$3::
	if (gEde.State.EDEActive == 1) {
		ShowGui("Tab3",1)
	}
	else {
		Send, 3
	}
	return

$4::
	if (gEde.State.EDEActive == 1) {
		ShowGui("Tab4",1)
	}
	else {
		Send, 4
	}
	return

$NumpadMult::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("Mult")
	}
	else {
		Send, {NumpadMult}
	}
	return

$NumpadSub::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("Sub")
	}
	else {
		Send, {NumpadSub}
	}
	return

$NumpadAdd::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("Add")
	}
	else {
		Send, {NumpadAdd}
	}
	return


$NumpadEnter::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("Enter")
	}
	else {
		Send, {NumpadEnter}
	}
	return

$NumpadDot::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("Dot")
	}
	else {
		Send, {NumpadDot}
	}
	return
	
$Numpad0::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("0")
	}
	else {
		Send, {Numpad0}
	}
	return
	
$Numpad1::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("1")
	}
	else {
		Send, {Numpad1}
	}
	return

$Numpad2::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("2")
	}
	else {
		Send, {Numpad2}
	}
	return

$Numpad3::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("3")
	}
	else {
		Send, {Numpad3}
	}
	return

$Numpad4::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("4")
	}
	else {
		Send, {Numpad4}
	}
	return

$Numpad5::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("5")
	}
	else {
		Send, {Numpad5}
	}
	return

$Numpad6::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("6")
	}
	else {
		Send, {Numpad6}
	}
	return

$Numpad7::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("7")
	}
	else {
		Send, {Numpad7}
	}
	return

$Numpad8::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("8")
	}
	else {
		Send, {Numpad8}
	}
	return

$Numpad9::
	if (gEde.State.EDEActive == 1) {
		id := activeTabId()
		Tab%id%("9")
	}
	else {
		Send, {Numpad9}
	}
	return


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
	
ExpireRepeatedKeypress:
	if (gEDE.State.waitForRepeatedKeyPress == 1) {
		MsgBox % "Repeated Keypress expired"
		SetTimer, ExpireRepeatedKeypress
		gEDE.State.waitForRepeatedKeyPress := 0
	}
	return
   
ShowGui(tab := "Tab1", updatePos = 0) {
	Global gEDE
	TabId := RegExReplace(gEDE.State.Active.Tab , "i)Tab(\d+)", "$1")
	Gui, %TabId%:hide
	gEDE.State.Active.Tab := tab
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
	gEDE.State.Active.hWnd := hWnd
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
	
	gEDE.State.currentTab := 1
	gEDE.State.currentKey := GuiControl
	
	OutputDebug % "[EDE-Keypress] Tab <" gEDE.State.currentTab "> - Key <" gEDE.State.currentKey ">"
	
	if (GuiControl == "Sub") {
		TaskDialog(gEDE.State.WinList[0]._hwnd, gEDE.Info.App.NameVersion " - WindowsInfo|hWnd: <" gEDE.State.WinList[0]._hwnd ">|Title: <" gEDE.State.WinList[0].title ">`nGuiControl: <" GuiControl ">`n", "", 1, "INFO")
	}
	else if(GuiControl == "1") {
		gEDE.State.WinList[0].movePercental(0, 50, 50, 50)
		gEDE.State.waitForRepeatedKeyPress := 1
	}
	else if(GuiControl == "2") {
		gEDE.State.WinList[0].movePercental(0, 50, 100, 50)
		gEDE.State.waitForRepeatedKeyPress := 1
	}
	else if(GuiControl == "3") {
		gEDE.State.WinList[0].movePercental(50, 50, 50, 50)
		gEDE.State.waitForRepeatedKeyPress := 1
	}
	else if(GuiControl == "4") {
		gEDE.State.WinList[0].movePercental(0, 0, 50, 100)
		gEDE.State.waitForRepeatedKeyPress := 1
	}
	else if(GuiControl == "5") {
		gEDE.State.WinList[0].movePercental(25, 25, 50, 50)
		gEDE.State.waitForRepeatedKeyPress := 1
	}
	else if(GuiControl == "6") {
		gEDE.State.WinList[0].movePercental(50, 0, 50, 100)
		gEDE.State.waitForRepeatedKeyPress := 1
	}
	else if(GuiControl == "7") {
		gEDE.State.WinList[0].movePercental(0, 0, 50, 50)
		gEDE.State.waitForRepeatedKeyPress := 1
	}
	else if(GuiControl == "8") {
		gEDE.State.WinList[0].movePercental(0, 0, 100, 50)
		gEDE.State.waitForRepeatedKeyPress := 1
	}
	else if(GuiControl == "9") {
		gEDE.State.WinList[0].movePercental(50, 0, 50, 50)
		gEDE.State.waitForRepeatedKeyPress := 1
	}
	else {
		NotYetImplemented()
	}
	HideGUI()
    return
}

Tab2(GuiControl) {
	Global gEDE
	gEDE.State.currentTab := 1
	gEDE.State.currentKey := GuiControl
	
	OutputDebug % "[EDE-Keypress] Tab <" gEDE.State.currentTab "> - Key <" gEDE.State.currentKey ">"
	
   	NotYetImplemented()
	HideGUI()
    return
}

Tab3(GuiControl) {
	Global gEDE
	gEDE.State.currentTab := 1
	gEDE.State.currentKey := GuiControl
	
	OutputDebug % "[EDE-Keypress] Tab <" gEDE.State.currentTab "> - Key <" gEDE.State.currentKey ">"
	
	NotYetImplemented()
	HideGUI()
    return
}

Tab4(GuiControl) {
	Global gEDE
	gEDE.State.currentTab := 1
	gEDE.State.currentKey := GuiControl
	
	OutputDebug % "[EDE-Keypress] Tab <" gEDE.State.currentTab "> - Key <" gEDE.State.currentKey ">"
	
	if (GuiControl == "Sub") {
		TaskDialog(0, gEDE.Info.App.NameVersion " - About|hWnd: <" gEDE.State.WinList[0]._hwnd ">|Title: <" gEDE.State.WinList[0].title ">`nGuiControl: <" GuiControl ">`n", "", 1, "INFO")
	}
	else if(GuiControl == "1") {
		LoadConfig()
	}
	else if(GuiControl == "2") {
		ShowgEDE()
	}
	else {
    	NotYetImplemented()
	}
	HideGUI()
    return
}

activeTabID() {
	Global gEDE
	TabId := RegExReplace(gEDE.State.Active.Tab, "i)Tab(\d+)", "$1")
	return TabId
}

LoadConfig() {
	Global gEDE
	config := new EDE_XMLConfig()
	gEde.Config := config.contents
}

ShowgEDE() {
	Global gEde
	WinWaitClose % "ahk_id " ObjTree(gEde, "EDE-Global configuration/state")
}