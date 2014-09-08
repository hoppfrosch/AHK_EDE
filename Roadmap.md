# Ideas/ToDo/Roadmap: #

## Class WindowHandler ##
 
- [E] - Enhanced/modified `maximize(monID)` - Toogles windows maximization (monID=-1 : Virtual Screen, monID=0 : Current Monitor, monID>0 ...) (WinEvent should be considered!)
- [N] - User defined maximum coordinates for `maximize() `- perhaps this could be part of Class WindowHandler (see [MaxMax](http://www.kmtools.win-os.pl/omaxmax.php?lang=ang) or [Hawkeye ShellInit](http://www.majorgeeks.com/files/details/hawkeye_shellinit.html))
- [N] - Attribute `trayMinimized` - Get/Set Tray-Minimization of window
- [#8](https://github.com/hoppfrosch/AHK_EDE/issues/8) - [N] - Attribute `iconized` - Implement iconizing a window to a desktop icon (see: [Iconize App](http://www.autohotkey.com/board/topic/86748-iconize-app/))
- [#9](https://github.com/hoppfrosch/AHK_EDE/issues/9) - [N] - `fadeIn/fadeOut()` - 
 *FadeIn/FadeOut*- Windows-Animation (see [[Function] Smart WinFade[In|Out]](http://ahkscript.org/boards/viewtopic.php?f=6&t=512))
- [E] - Check whether given hWnd (on Constructor) is actually a true window (see [List open windows to quickly select and close them ](http://www.autohotkey.com/board/topic/91918-list-open-windows-to-quickly-select-and-close-them/))
- [N] - Attribute `resizePercentual` - flag to indicate, whether to resize the window proportional to monitorsize on moving from monitor to monitor (window filling 50% on the first monitor should fill 50% on the second monitor as well ...)
  - [E] Moving from Monitor to monitor should have an option to resize the windows percentual [Flinging Windows Across a Multi-Monitor System](http://www.autohotkey.com/board/topic/51956-flinging-windows-across-a-multi-monitor-system/)
- [N] Don't allow window dragging off screen (see  [WinLimit (aka XP Snap): don't drag a window go off screen](http://www.autohotkey.com/board/topic/92169-winlimit-aka-xp-snap-dont-drag-a-window-go-off-screen/))
- [N] [XPSnap V1.1 Drag window to edges (Aero Snap)](http://www.autohotkey.com/board/topic/61033-xpsnap-v11-drag-window-to-edges-aero-snap/)
- ***V 0.7.3*** - <strike>[#14](https://github.com/hoppfrosch/AHK_EDE/issues/13) - [N] Attributes `processName` and  `processID` - Get Name and ID of associated process</strike>
- <strike>[N] - `pad(xfact, yfact, wfact, hfact)` - Windows padding/move-resizing, xfact ... are percentual values relative to size of current screen</strike>.
- <strike>[N] - Attribute `minimized` - Toogles windows minimization (WinEvent should be considered!)</strike>
- <strike>[N] - Attribute `monitorId` - get or set the current monitor</strike>
 
- <strike>[#2](https://github.com/hoppfrosch/AHK_EDE/issues/2) - [N] - Attribute `transparency`- get/set transparency of window</strike>



## Class Mouse ##
Class to handle several requests/actions concerning mouse

- [#10](https://github.com/hoppfrosch/AHK_EDE/issues/10) - [N] - Initial
- [#10](https://github.com/hoppfrosch/AHK_EDE/issues/10) - [N] `locate()` -> see `MouseLocator()` in *WindowPadX/WPXA.ahk*
- [N] Property `monitorID()` - monitorID - Property with getter/setter
- [N] `clip()` -> see `wp_ClipCursor()` in *WindowPadX/WPXA.ahk*
- [N] `clipCursorToMonitor()` - Clips (Restricts) mouse to given monitor (see *WindowPadX/WPXA.ahk*)
- Rename class from MouseTools to Mouse
- [N] `pos` - mouse position - Property with getter/setter (based on class EDE\Point)
- [N] Property `showTrace` to show mouse trace during movement
- [N] `isOverHwnd()` - to determine the HWND of window the 

## Class Point ##
New class to handle 2D points

- [#15](https://github.com/hoppfrosch/AHK_EDE/issues/15) - [N] - Initial

## Class WindowStack ##
Class to handle relation between several windows

- [N] Initial
- [N] Z-Ordering
- [N] Minimize all windows on a certain monitor
- [N] Gather all windows on a certain monitor
- [N] `fromSnapshot()` - build up class from current situation
	
## EDE application ##
- [E] - Expose more windowHandler-functions to EDE-Interface 
  - [#7](https://github.com/hoppfrosch/AHK_EDE/issues/7): `MoveToNextScreen`
- [N] - Provide Tray-Tooltips on actions
- [N] - Restore wondow properties on window creation
- **V 0.7.2** - <strike>[N] Checking for newly created windows and register new Windows within AHK-EDE</strike>
- **V 0.7.1** - <strike>[#12](https://github.com/hoppfrosch/AHK_EDE/issues/12) - [N] - Autohide EDE-GUI after timeout</strike> 
- **V 0.7.0** - <strike>[#5](https://github.com/hoppfrosch/AHK_EDE/issues/5) - [N] - Tooltips on mouseover EDE-buttons</strike> - 
- <strike>[#6](https://github.com/hoppfrosch/AHK_EDE/issues/6) - [E] - Allow tab-switching using Numpad-1 .. 4</strike>

## General ##

- [E] - move all existing lib-moduls into subfolder EDE
   - Rectangle.ahk
   - WindowHandler.ahk.ahk
   - _WindowHandlerEvent.ahk
   - MultiMonitorEnv.ahk
   - Mouse.ahk
- [E] - Better documentation process
- [N] - Publish documentation of classes and EDE on github

----
### Legend ###
- [N] - New feature
- [E] - Enhancement of existing feature
- [-] - Delete existing feature