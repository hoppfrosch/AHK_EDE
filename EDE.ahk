; created by DerRaphael 
; updated by Drugwash 

#Persistent
;#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force

#include <Tab>

MyImageList := IL_Create() 
IL_Add(MyImageList, "res\arrow-move.ico")
IL_Add(MyImageList, "shell32.dll", 2)
IL_Add(MyImageList, "shell32.dll", 3)
IL_Add(MyImageList, "shell32.dll", 4)
IL_Add(MyImageList, "shell32.dll", 5)
IL_Add(MyImageList, "shell32.dll", 6)
IL_Add(MyImageList, "shell32.dll", 7)
IL_Add(MyImageList, "shell32.dll", 8)
IL_Add(MyImageList, "shell32.dll", 9)
IL_Add(MyImageList, "shell32.dll", 10)

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


Gui, Add, Tab2, x0 y0 w84 h84 0x38 -Wrap gShoutActiveTab vMyIconTab 
Tab_AttachImageList( MyImageList, "MyIconTab" )
Gui +LastFound +AlwaysOnTop
WinSet, Transparent, 200
Gui -Caption

Tab_AppendWithIcon( "", 1 ) 
Tab_AppendWithIcon( "", 2 ) 
Tab_AppendWithIcon( "", 3 ) 

Gui, Tab, 1
Gui, Add , Picture, %pos_1_1% gPad, res\arrow-135.ico
Gui, Add , Picture, %pos_2_1% gPad, res\arrow-180.ico
Gui, Add , Picture, %pos_3_1% gPad, res\arrow-225.ico
Gui, Add , Picture, %pos_1_2% gPad, res\arrow-090.ico
Gui, Add , Picture, %pos_2_2% gPad, res\dot.ico
Gui, Add , Picture, %pos_3_2% gPad, res\arrow-270.ico
Gui, Add , Picture, %pos_1_3% gPad, res\arrow-045.ico
Gui, Add , Picture, %pos_2_3% gPad, res\arrow-000.ico
Gui, Add , Picture, %pos_3_3% gPad, res\arrow-315.ico
Gui, Add , Picture, %pos_1_4% gRestore, res\arrow-circle.ico

Gui, Tab, 2
Gui, Add, Button,, Test Button
Gui, Tab, 3
Gui, Add, Edit,, Test Edit

return 

#F1::ShowGui()


ShoutActiveTab: 
;   GuiControlGet, label,, MyIconTab 
;   GuiControl,,Edit1, The Selected Tab is labeled with "%label%" 
return 

GuiEscape:
	Gui, hide
	return 
	
GuiClose: 
   IL_Destroy(MyImageList)  ; Required for image lists used by tab controls. 
   ExitApp
   
Pad:
	Pad()
	return
	
Restore:
    return
   
ShowGui() {
	MouseGetPos, xpos, ypos 
	xpos := xpos-42
	ypos := ypos-42
	Gui, Show, x%xpos% y%ypos% h84 w84, EDE 
	return
}

Pad() {
	MsgBox % "A_Gui:" A_Gui "`nA_GuiControl:" A_GuiControl "`nA_GuiEvent:" A_GuiEvent "`nA_EventInfo" A_EventInfo
	return
}