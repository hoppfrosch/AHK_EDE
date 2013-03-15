#Persistent
;#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force


; GUI is build from 4 separate GUIs - each represented by a 4x4 array of icons
; Row 0 represents the tab-row. Clicking on icon in row 0 will switch to another pseudo-tab (another GUI)

;  Icon position within the 4x4 array GUI
pos_0_1 := "x4 y4 w16 h16"
pos_0_2 := "x24 y4 w16 h16"
pos_0_3 := "x44 y4 w16 h16"
pos_0_4 := "x64 y4 w16 h16"
pos_1_1 := "x4 y24 w16 h16"
pos_1_2 := "x24 y24 w16 h16"
pos_1_3 := "x44 y24 w16 h16"
pos_1_4 := "x64 y24 w16 h16"
pos_2_1 := "x4 y44 w16 h16"
pos_2_2 := "x24 y44 w16 h16"
pos_2_3 := "x44 y44 w16 h16"
pos_2_4 := "x64 y44 w16 h16"
pos_3_1 := "x4 y64 w16 h16"
pos_3_2 := "x24 y64 w16 h16"
pos_3_3 := "x44 y64 w16 h16"
pos_3_4 := "x64 y64 w16 h16"


activeTab := "Tab1"  ; Global variable used to store, which GUI-Tab is currently active

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
		Gui, %A_Index%:Add, Picture, %pos_0_1% E0x200 gToogleTab vTab1, %icoTab1%
	}
	else {
		Gui, %A_Index%:Add, Picture, %pos_0_1% 0x800000 gToogleTab vTab1, %icoTab1%
	}
	if (A_Index == 2) {
		Gui, %A_Index%:Add, Picture, %pos_0_2% E0x200 gToogleTab vTab2, %icoTab2%
	}
	else {
		Gui, %A_Index%:Add, Picture, %pos_0_2% 0x800000 gToogleTab vTab2, %icoTab2%
	}
	if (A_Index == 3) {
		Gui, %A_Index%:Add, Picture, %pos_0_3% E0x200 gToogleTab vTab3, %icoTab3%
	}
	else {
		Gui, %A_Index%:Add, Picture, %pos_0_3% 0x800000 gToogleTab vTab3, %icoTab3%
	}
	
	if (A_Index == 4) {
		Gui, %A_Index%:Add, Picture, %pos_0_4% E0x200 gToogleTab vTab4, %icoTab4%
	}
	else {
		Gui, %A_Index%:Add, Picture, %pos_0_4% 0x800000 gToogleTab vTab4, %icoTab4%
	}
}

; Contents of Tab1
Gui, 1:Add, Picture, %pos_1_1% gPad, res\arrow-135.ico
Gui, 1:Add, Picture, %pos_2_1% gPad, res\arrow-180.ico
Gui, 1:Add, Picture, %pos_3_1% gPad, res\arrow-225.ico
Gui, 1:Add, Picture, %pos_1_2% gPad, res\arrow-090.ico
Gui, 1:Add, Picture, %pos_2_2% gPad, res\dot.ico
Gui, 1:Add, Picture, %pos_3_2% gPad, res\arrow-270.ico
Gui, 1:Add, Picture, %pos_1_3% gPad, res\arrow-045.ico
Gui, 1:Add, Picture, %pos_2_3% gPad, res\arrow-000.ico
Gui, 1:Add, Picture, %pos_3_3% gPad, res\arrow-315.ico
Gui, 1:Add, Picture, %pos_1_4% gRestore, res\arrow-circle.ico

return 

#F1::
	ShowGui(activeTab)
	return

Esc:: 
    TabId := RegExReplace(activeTab, "i)Tab(\d+)", "$1")
	Gui, %TabId%:hide
	return 


ToogleTab:
	; MsgBox % "A_Gui:" A_Gui "`nA_GuiControl:" A_GuiControl "`nA_GuiEvent:" A_GuiEvent "`nA_EventInfo" A_EventInfo
	ShowGui(A_GuiControl)
	return

GuiEscape:
	MsgBox % "Escape pressed while " activeTab " is active"
    TabId := RegExReplace(activeTab, "i)Tab(\d+)", "$1")
	Gui, hide
	return 
	
GuiClose: 
   ExitApp
   
Pad:
	Pad()
	return
	

Restore:
    return
   
ShowGui(tab := "Tab1") {
	Global activeTab
	TabId := RegExReplace(activeTab , "i)Tab(\d+)", "$1")
	Gui, %TabId%:hide
	activeTab := tab
	MouseGetPos, xpos, ypos 
	;xpos := xpos-42
	;ypos := ypos-42
	TabId := RegExReplace(tab, "i)Tab(\d+)", "$1")
	Gui, %TabId%:Show, x%xpos% y%ypos% h84 w84, EDE 
	return
}

Pad() {
	MsgBox % "A_Gui:" A_Gui "`nA_GuiControl:" A_GuiControl "`nA_GuiEvent:" A_GuiEvent "`nA_EventInfo" A_EventInfo "`nXX" XX
	return
}