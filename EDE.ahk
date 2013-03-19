#Persistent
;#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force


; GUI is build from 4 separate GUIs - each represented by a 4x5 array of icons (representing  the NUMPAD)
; Row 0 represents the tab-row. Clicking on icon in row 0 will switch to another pseudo-tab (another GUI)

;  Icon position within the 4x5 array GUI
pos_TAB1    := "x4 y4 w16 h16"
pos_TAB2    := "x24 y4 w16 h16"
pos_TAB3    := "x44 y4 w16 h16"
pos_TAB4    := "x64 y4 w16 h16"
pos_NP_NUM  := "x4 y24 w16 h16"    ; Numpad "NUM"-key
pos_NP_DIV  := "x24 y24 w16 h16"   ; Numpad "%"-key"
pos_NP_MUL  := "x44 y24 w16 h16"   ; Numpad "*"-key"
pos_NP_MIN  := "x64 y24 w16 h16"   ; Numpad "-"-key
pos_NP_7    := "x4 y44 w16 h16"    ; Numpad "7"-key
pos_NP_8    := "x24 y44 w16 h16"   ; Numpad "8"-key
pos_NP_9    := "x44 y44 w16 h16"   ; Numpad "9"-key
pos_NP_PLU  := "x64 y44 w16 h38"   ; Numpad "+"-key
pos_NP_PLU1 := "x64 y44 w16 h16"   ; Numpad "+"-key (upper)
pos_NP_PLU2 := "x64 y64 w16 h16"   ; Numpad "+"-key (lower)
pos_NP_PLU3 := "x64 y54 w16 h16"   ; Numpad "+"-key (center)
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
pos_NP_SEP  := "x44 y104 w16 h16"  ; Numpad ","-key


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
Gui, 1:Add, Picture, %pos_NP_7% 0x800000 gPad, res\arrow-135.ico
Gui, 1:Add, Picture, %pos_NP_4% 0x800000 gPad, res\arrow-180.ico
Gui, 1:Add, Picture, %pos_NP_1% 0x800000 gPad, res\arrow-225.ico
Gui, 1:Add, Picture, %pos_NP_8% 0x800000 gPad, res\arrow-090.ico
Gui, 1:Add, Picture, %pos_NP_5% 0x800000 gPad, res\dot.ico
Gui, 1:Add, Picture, %pos_NP_2% 0x800000 gPad, res\arrow-270.ico
Gui, 1:Add, Picture, %pos_NP_9% 0x800000 gPad, res\arrow-045.ico
Gui, 1:Add, Picture, %pos_NP_6% 0x800000 gPad, res\arrow-000.ico
Gui, 1:Add, Picture, %pos_NP_3% 0x800000 gPad, res\arrow-315.ico
Gui, 1:Add, Picture, %pos_NP_PLU% 0x800000 gRestore, 
Gui, 1:Add, Picture, %pos_NP_PLU3% gRestore, res\arrow-circle.ico

return 



$ESC::
	; Hide EDE-window if mouse is over EDE-GUI 
	MouseGetPos, , , id, control
	WinGetTitle, title, ahk_id %id%
	if (title == "EDE") {
		TabId := RegExReplace(activeTab, "i)Tab(\d+)", "$1")
		Gui, %TabId%:hide
	}
	else {
		SendInput $ESC
	}
	return 


#F1::
	ShowGui(activeTab, 1)
	return

; ----------------------------------------------------------------------------
; --- Labels -----------------------------------------------------------------
ToogleTab:
	; MsgBox % "A_Gui:" A_Gui "`nA_GuiControl:" A_GuiControl "`nA_GuiEvent:" A_GuiEvent "`nA_EventInfo" A_EventInfo
	ShowGui(A_GuiControl)
	return
	
GuiClose: 
   ExitApp
   
Pad:
	Pad()
	return
	

Restore:
    return
   
ShowGui(tab := "Tab1", updatePos = 0) {
	Global activeTab
	TabId := RegExReplace(activeTab , "i)Tab(\d+)", "$1")
	Gui, %TabId%:hide
	activeTab := tab
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
		Gui, %TabId%:Show, x%x% y%y% h%h% w%w% ,EDE
	}
	return
}

Pad() {
	MsgBox % "A_Gui:" A_Gui "`nA_GuiControl:" A_GuiControl "`nA_GuiEvent:" A_GuiEvent "`nA_EventInfo" A_EventInfo "`nXX" XX
	return
}