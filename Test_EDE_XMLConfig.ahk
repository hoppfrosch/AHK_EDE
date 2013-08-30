#Persistent
;#Warn All
;#Warn LocalSameAsGlobal, Off
#SingleInstance force

#Include <EDE_XMLConfig>

config := new EDE_XMLConfig()

;MsgBox % strOut
WinWaitClose % "ahk_id " ObjTree(config.contents, "Configuration as AHK-object")
