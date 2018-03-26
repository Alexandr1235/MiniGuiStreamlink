#NoEnv
;#NoTrayIcon
#SingleInstance
Menu, Tray, Click, 1
Menu, Tray, NoStandard
Menu, Tray, NoDefault
Menu, Tray, Add, Show MiniGuiStreamlink, Show
Menu, Tray, Default, Show MiniGuiStreamlink
Menu Tray,Check, Show MiniGuiStreamlink
Menu, Tray, Add, Exit, GuiExit

IfNotExist, %A_ScriptDir%\bin\streamlink.exe
{
MsgBox, Not found streamlink.exe
ExitApp
}
IfNotExist, download
{
FileCreateDir, download
}
IfNotExist, streamlinkrc.ini
{ 
FileAppend, 
(
# Here is a few examples of players:

# mplayer
player="%A_ScriptDir%\bin\mpv\mpv.exe" -cache 8192
#player="%A_ScriptDir%\bin\mplayer\mplayer.exe" -cache 8192

# VLC
#player="C:\Program Files (x86)\VideoLAN\VLC\vlc.exe"
#player="C:\Program Files\VideoLAN\VLC\vlc.exe"
# Using --file-caching is recommended, but is only supported in VLC 2.0+
#player="C:\Program Files (x86)\VideoLAN\VLC\vlc.exe" --file-caching=5000
#player="C:\Program Files\VideoLAN\VLC\vlc.exe" --file-caching=5000

# MPC-HC, must be at least version 1.7 to be used
#player="C:\Program Files (x86)\MPC-HC\mpc-hc.exe"
#player="C:\Program Files\MPC-HC\mpc-hc64.exe"

# played parametrs 
# best
http-no-ssl-verify
player-no-close
http-disable-dh 
force
# parameters cookie vc.com
http-cookie "remixrefkey=0;remixsid=0;remixstid=0"

# RTMP streams are downloaded using rtmpdump. Full path or relative path
# to the rtmpdump exe should be specified here.
#rtmpdump=C:\Program Files (x86)\Streamlink\rtmpdump\rtmpdump.exe
rtmpdump=%A_ScriptDir%\rtmpdump\rtmpdump.exe

# FFMPEG is used to mux separate video and audio streams in to a single
# stream so that they can be played. The full or relative path to ffmpeg
# or avconv should be specified here.
#ffmpeg-ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe
ffmpeg-ffmpeg=%A_ScriptDir%\ffmpeg\ffmpeg.exe -vsync 0 

# Log level Valid levels are: "none", "error", "warning", "info" and "debug", default is info
#loglevel=debug

)
, %A_ScriptDir%\streamlinkrc.ini
}
gosub LoadSettings
ErrorLevelnp:=0
ErrorLevelnd:=0
if Start2=On 
AvtoStartMinimized=Start download %StartHH%h%StartMM%m%Startdatadd%d%StartdataMM%M
if StartMinimized=1
TrayTip, MiniGuiStreamlink is Still Running in the Background, %AvtoStartMinimized%%A_Space%, 3
gosub dd_label
menu, tray, tip, Start: %StartHH%h%StartMM%m%Startdatadd%d%StartdataMM%M`nStop: %StopHH%h%StopMM%m%Stopdatadd%d%StopdataMM%M`nAvtoplay %Start1% `nAvtoDownload %Start2%
if Start1=On
gosub Start1
if Start2=On
gosub Start2
if StartMinimized=0
Goto, MiniGuiStreamlink

Return

Show:
if Show=1
Goto GuiClose
Goto MiniGuiStreamlink
Return

MiniGuiStreamlink:
Show:=1
gui, submit, nohide
Gui, Destroy
Gui, +LastFound
WinSet, TransColor, 0Xcccccc
Gui, Margin, 0, 0
Gui, Font, bold c000000 S10, Trebuchet MS
Gui, Add, edit, w325 r1 vUrl, %Url%
gui, add, DDL, y+5 vdd_var gdd_label, Best|Worst
Gui, Add, Button, x+5 gPlayed, Play
Gui, Add, Button, x+5 gAvto, Avto
Gui, Add, Button, x+5 gDownload, Download
GuiControl, Choose, dd_var, %dd_var%
Gui, Show,,MiniGuiStreamlink 2
Return

Avto:
gui, submit, nohide
Gui, Destroy
Gui, +LastFound
WinSet, TransColor, 0Xcccccc
Gui, Margin, 0, 0
Gui, Font, bold c000000 S10, Trebuchet MS
Gui, Add, edit, w325 r1 vUrl, %Url%
gui, add, DDL, y+5 vdd_var gdd_label, Best|Worst
Gui, Add, Button, x+5 gStart1, Play
Gui, Add, Button, x+5 gMiniGuiStreamlink, Back
Gui, Add, Button, x+5 gstart2, Download
Gui, Add, Text, x1, Start time:
Gui, Add, edit, Limit2 x+5 w25 r1 vStartHH, %StartHH%
Gui, Add, edit, Limit2 x+5 w25 r1 vStartMM, %StartMM%
Gui, Add, Text,x+5 , Stop time:
Gui, Add, edit, Limit2 x+5 w25 r1 vStopHH, %StopHH%
Gui, Add, edit, Limit2 x+5 w25 r1 vStopMM, %StopMM%
Gui, Add, Button, x+5 gAbout, About
gui, add, Text, x2, Start data:
Gui, Add, edit, Limit2 x+5 w25 r1 vStartdatadd, %Startdatadd%
Gui, Add, edit, Limit2 x+5 w25 r1 vStartdataMM, %StartdataMM%
Gui, Add, Text, x+6, Stop data:
Gui, Add, edit, Limit2 x+5 w25 r1 vStopdatadd, %Stopdatadd%
Gui, Add, edit, Limit2 x+5 w25 r1 vStopdataMM, %StopdataMM%
Gui, Add, Button, x+5 gAbort, Abort
Gui, Add, GroupBox, x5 w325 h86, AvtoStart
Gui, Add, Text,  x10 y137 vAvtoStart , AvtoPlay %Start1% `nAvtoDownload %Start2%
Gui, Add, Checkbox, y+5 vStartup Checked%Startup% gStartup, Startup
Gui, Add, Checkbox, x+5 vStartMinimized Checked%StartMinimized%, StartMinimized
Gui, Show,,MiniGuiStreamlink 2
GuiControl, Choose, dd_var, %dd_var%
Return

About:
MsgBox Create 2018 by Alexandr1235. Build 2.`nThanks for using this FREE program.`nalexandr1235@ya.ru
Return

Abort:
SetTimer, starttimer1, Off
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, start1, Off
start1=Off
SetTimer, starttimer2, Off
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, start2, Off
start2=Off
SetTimer, stoptimer, Off
Goto write
Return

dd_label:
gui, submit, nohide
if dd_var = Best
	quali = best
if dd_var = Worst
	quali = worst
	return	

write:	
if (StartHH > 23 || StartHH < 0)
StartHH=0
GuiControl ,, StartHH, %StartHH%
if (StopHH > 23 || StopHH < 0)
StopHH=0
GuiControl ,, StopHH, %StopHH%
if (StartMM > 59 || StartMM < 0)
StartMM=0
GuiControl ,, StartMM, %StartMM%
if (StopMM > 59 || StopMM < 0)
StopMM=0
GuiControl ,, StopMM, %StopMM%
if (StartdataMM > 12 || StartdataMM < 1)
StartdataMM=1
GuiControl ,, StartdataMM, %StartdataMM%
if (Startdatadd > 31 || Startdatadd < 1)
Startdatadd=1
GuiControl ,, Startdatadd, %Startdatadd%
if (StopdataMM > 12 || StopdataMM < 1)
StopdataMM=1
GuiControl ,, StopdataMM, %StopdataMM%
if (Stopdatadd > 31 || Stopdatadd < 1)
Stopdatadd=1
GuiControl ,, Stopdatadd, %Stopdatadd%
GuiControl ,, AvtoStart , Avtoplay %Start1% `nAvtoDownload %Start2%
menu, tray, tip, Start: %StartHH%h%StartMM%m%Startdatadd%d%StartdataMM%M`nStop: %StopHH%h%StopMM%m%Stopdatadd%d%StopdataMM%M`nAvtoplay %Start1% `nAvtoDownload %Start2%
return	

Start1:
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, start1, On
gui, submit, nohide
start1=On
gosub write
SetTimer, starttimer1, 500
;MsgBox Play, %quali% Stream.`n%Url%`nStart time: %StartHH%h%StartMM%m`nStop time: %StopHH%h%StopMM%m
return

start2:
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, start2, On
gui, submit, nohide
start2=On
gosub write
SetTimer, starttimer2, 500
;MsgBox Download %quali% Stream.`n%Url%`nStart time: %StartHH%h%StartMM%m`nStop time: %StopHH%h%StopMM%m`n
return

starttimer1:
{
if (A_Hour=StartHH&&A_Min=StartMM&&A_DD=Startdatadd&&A_MM=StartdataMM) {
	gui, submit, nohide
SetTimer, starttimer1, Off
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, start1, Off
start1=Off
gosub write
SetTimer, stoptimer, 500
goto Played
}
}
return

starttimer2:
{
if (A_Hour=StartHH&&A_Min=StartMM&&A_DD=Startdatadd&&A_MM=StartdataMM) {
	gui, submit, nohide
SetTimer, starttimer2, Off
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, start2, Off
start1=Off
gosub write
SetTimer, stoptimer, 500
Goto Download
}}
return

stoptimer:
{
if (A_Hour=StopHH&&A_Min=StopMM&&A_MM=StopdataMM&&A_DD=Stopdatadd)  {
SetTimer, stoptimer, Off
gosub write
TrayTip, Stop , %A_Space% , 2
Run, taskkill /im streamlink.exe
} 
}
return

Played:
gui, submit, nohide
TrayTip, Play %quali%, %Url% , 3
Run %A_ScriptDir%\bin\streamlink.exe %Url% %quali% --config %A_ScriptDir%\streamlinkrc.ini -f
Sleep 8000
Process, Exist, streamlink.exe
If !ErrorLevel
{
ErrorLevelnp:=ErrorLevelnp+1
if ErrorLevelnp<3
{
goto Played
}
else
ErrorLevelnp:=0
MsgBox Not Play.
}
return

Download:
gui, submit, nohide
FormatTime, TimeString,, yyyy_dd_mm_HH_mm_ss
TrayTip, Download %Url% %quali%, %A_ScriptDir%\Download\%TimeString%.mp4 , 3
   Run %A_ScriptDir%\bin\streamlink.exe %Url% %quali% --config %A_ScriptDir%\streamlinkrc.ini -f -o %A_ScriptDir%\Download\%TimeString%.mp4
Sleep 9000
Process, Exist, streamlink.exe
If !ErrorLevel
{
ErrorLevelnd:=ErrorLevelnd+1
if ErrorLevelnd<4
{
goto Download
}
else
ErrorLevelnd:=0
MsgBox Not Download.
}
   return

LoadSettings:
RegRead, dd_var, HKCU, Software\MiniGuiStreamlink, dd_var
if dd_var=
dd_var=Best
RegRead, StartHH, HKCU, Software\MiniGuiStreamlink, StartHH
if StartHH=
StartHH=H
RegRead, StartMM, HKCU, Software\MiniGuiStreamlink, StartMM
if StartMM=
StartMM=m
RegRead, StopHH, HKCU, Software\MiniGuiStreamlink, StopHH
if StopHH=
StopHH=H
RegRead, StopMM, HKCU, Software\MiniGuiStreamlink, StopMM
if StopMM=
StopMM=m
RegRead, StartdataMM, HKCU, Software\MiniGuiStreamlink, StartdataMM
if StartdataMM=
StartdataMM=M
RegRead, Startdatadd, HKCU, Software\MiniGuiStreamlink, Startdatadd
if Startdatadd=
Startdatadd=d
RegRead, StopdataMM, HKCU, Software\MiniGuiStreamlink, StopdataMM
if StopdataMM=
StopdataMM=M
RegRead, Stopdatadd, HKCU, Software\MiniGuiStreamlink, Stopdatadd
if Stopdatadd=
Stopdatadd=d
RegRead, Startup, HKCU, Software\MiniGuiStreamlink, Startup
if Startup=
Startup=0
RegRead, StartMinimized, HKCU, Software\MiniGuiStreamlink, StartMinimized
if StartMinimized=
StartMinimized=0
RegRead, start1, HKCU, Software\MiniGuiStreamlink, start1
if start1=
start1=Off
RegRead, start2, HKCU, Software\MiniGuiStreamlink, start2
if start2=
start2=Off
RegRead, Url, HKCU, Software\MiniGuiStreamlink, Url
return

SaveSettings:
gui, submit, nohide
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, dd_var, %dd_var%
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, StartHH, %StartHH%
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, StartMM, %StartMM%
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, StopHH, %StopHH%
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, StopMM, %StopMM%
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, StartdataMM, %StartdataMM%
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, Startdatadd, %Startdatadd%
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, StopdataMM, %StopdataMM%
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, Stopdatadd, %Stopdatadd%
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, Startup, %Startup%
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, Url, %Url%
RegWrite, REG_SZ, HKCU, Software\MiniGuiStreamlink, StartMinimized, %StartMinimized%
return

Startup:
gui, submit, nohide
if Startup=1
RegWrite, REG_SZ, HKCU, Software\Microsoft\Windows\CurrentVersion\Run, MiniGuiStreamlink, %A_ScriptFullPath%
if Startup=0
RegWrite, REG_SZ, HKCU, Software\Microsoft\Windows\CurrentVersion\Run, MiniGuiStreamlink,
return

GuiClose:
Show:=0
TrayTip, MiniGuiStreamlink is Still Running in the Background, %A_Space% , 2
gosub SaveSettings
Gui, Destroy
;ExitApp
return

GuiExit:
gosub SaveSettings
Gui, Destroy
ExitApp
return