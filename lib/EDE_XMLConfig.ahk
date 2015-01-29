#Include <xml>

/*
	Title: EDE_XMLConfig
		Class to handle configuration for EDE (Parse XML configuration and offer access to configuration items)

	Author: 
		hoppfrosch (hoppfrosch@gmx.de)
		
	License: 
		This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2, as published by Sam Hocevar. See http://www.wtfpl.net/ for more details.
		
*/
	
; ****** HINT: Documentation can be extracted to HTML using NaturalDocs ************** */

; Global Varibles

; ******************************************************************************************************************************************
class EDE_XMLConfig {
	
	_version := "0.2.0"
	_debug := 0 ; _DBG_	
	filename := ""
	contents := object()
	
	parse() {
		; create an XMLDOMDocument object and load the XML string
		this.xml := new xml(this.filename)
		
		this.parseAlign()
		this.parseGeneral()
	}
	
	parseGeneral() {
		this.contents.RepeatedKeypress := object()
		this.contents.RepeatedKeypress.Timeout := object()
		if this.xml.documentElement {
			this.contents.RepeatedKeypress.Timeout.unit := this.xml.getAtt("//General/RepeatedKeypress/Timeout", "unit")
		    this.contents.RepeatedKeypress.Timeout.text := this.xml.getText("//General/RepeatedKeypress/Timeout")
		}
		else {
			this.contents.RepeatedKeypress.Timeout.unit := "ms"
			this.contents.RepeatedKeypress.Timeout.text := 5000
		}

		this.contents.AutoHide := object()
		this.contents.AutoHide.Timeout := object()
		if this.xml.documentElement {
			if ( this.xml.getChildren("//General/AutoHide/Timeout", "text")) {
				this.contents.AutoHide.Timeout.unit := this.xml.getAtt("//General/AutoHide/Timeout", "unit")
		    	this.contents.AutoHide.Timeout.text := this.xml.getText("//General/AutoHide/Timeout")
			}
			else {
				this.contents.AutoHide.Timeout.unit := "ms"
				this.contents.AutoHide.Timeout.text := -1
			}
		}
			
	}
	
	parseAlignOld() {
		if this.xml.documentElement {
			Dirs := this.xml.getChildren("//AlignOld", "element")
		
			configPos := Object()
			iDir := 0
			for currDir in Dirs {
				iDir++
				this.contents.align[iDir] := object()
				Positions := this.xml.getChildren("//AlignOld/Dir[" iDir "]", "element")
				iPositions := 0
				for v in Positions {
					iPositions++
				}
				key := this.xml.getAtt("//AlignOld/Dir[" iDir "]", "kp") ; getAtt() method
				compass := this.xml.getAtt("//AlignOld/Dir[" iDir "]", "compass") ; getAtt() method
		
				iPos := 0
				for currPos in Positions {
					oPos := Object()
					iPos++
					oPos.x := this.xml.getAtt("//AlignOld/Dir[" iDir "]/Pos[" iPos "]", "x")
					oPos.y := this.xml.getAtt("//AlignOld/Dir[" iDir "]/Pos[" iPos "]", "y")
					oPos.width := this.xml.getAtt("//AlignOld/Dir[" iDir "]/Pos[" iPos "]", "width")
					oPos.height := this.xml.getAtt("//AlignOld/Dir[" iDir "]/Pos[" iPos "]", "height")
					this.contents.align[iDir].pos[iPos] := oPos
				}
				this.contents.align[iDir].cnt := iPos
				this.contents.align[iDir].compass := this.xml.getAtt("//AlignOld/Dir[" iDir "]", "compass") ; getAtt() method
			}
		}
	}
	parseAlign() {
		if this.xml.documentElement {
			Dirs := this.xml.getChildren("//Align", "element")
		
			configPos := Object()
			iDir := 0
			for currDir in Dirs {
				iDir++
				this.contents.alignInitial[iDir] := object()
				Positions := this.xml.getChildren("//Align/Dir[" iDir "]", "element")
				iPositions := 0
				for v in Positions {
					iPositions++
				}
				key := this.xml.getAtt("//Align/Dir[" iDir "]", "kp") ; getAtt() method
				compass := this.xml.getAtt("//Align/Dir[" iDir "]", "compass") ; getAtt() method
		
				iPos := 0
				for currPos in Positions {
					oPos := Object()
					iPos++
					postype := this.xml.getAtt("//Align/Dir[" iDir "]/Pos[" iPos "]", "type")
					oPos.type := postype
					oPos.data := Object()
					if (RegExMatch(postype, "i)^original$")) {
					}
					else if (RegExMatch(postype, "i)^border$")) {
						oPos.data.border :=  this.xml.getText("//Align/Dir[" iDir "]/Pos[" iPos "]/border")
					}
					else if (RegExMatch(postype, "i)^percent$")) {
						oPos.data.x :=  this.xml.getText("//Align/Dir[" iDir "]/Pos[" iPos "]/x")
						oPos.data.y :=  this.xml.getText("//Align/Dir[" iDir "]/Pos[" iPos "]/y")
						oPos.data.width :=  this.xml.getText("//Align/Dir[" iDir "]/Pos[" iPos "]/w")
						oPos.data.height :=  this.xml.getText("//Align/Dir[" iDir "]/Pos[" iPos "]/h")
						
					
					}
					this.contents.alignInitial[iDir].pos[iPos] := oPos
				}
				this.contents.alignInitial[iDir].cnt := iPos
				this.contents.alignInitial[iDir].compass := this.xml.getAtt("//Align/Dir[" iDir "]", "compass") ; getAtt() method
			}
		}
	}
/*
===============================================================================
Function: __New
	Constructor (*INTERNAL*)

Parameters:
	filename - name of configuration file to parse
	debug - Flag to enable debugging (Optional - Default: 0)

Author(s):
	20130404 - hoppfrosch - Original
===============================================================================
*/     
	__New(filename="EDE.xml", debug=false) {
		this._debug := debug ; _DBG_
		if (this._debug) ; _DBG_
			OutputDebug % "|[" A_ThisFunc "(filename=" filename ", _debug=" debug ")] (version: " this._version ")" ; _DBG_
		
		this.filename := filename
		
		if (!FileExist(filename)) {
			throw { what: "Configuration file <" filename "> does not exist", file: A_LineFile, line: A_LineNumber }
		}
		
		this.parse()
		
		return this
	}
}