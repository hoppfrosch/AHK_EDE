#Persistent
;#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force

#Include <EDE_XMLConfig>
#include <Windy\Windy>

config := new EDE_XMLConfig()

;MsgBox % strOut
WinWaitClose % "ahk_id " ObjTree(config.contents, "Configuration as AHK-object")

Run, notepad.exe
WinWait, ahk_class Notepad, , 2
WinMove, ahk_class Notepad,, 10, 10, 300, 300
_hWnd := WinExist("ahk_class Notepad")
w := new Windy(_hwnd)
AlignConfig := config.transformAlignConfig(w)
WinWaitClose % "ahk_id " ObjTree(AlignConfig, "Transformed Aligment Configuration")
w.kill()

ExitApp