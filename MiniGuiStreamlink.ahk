#NoEnv
#NoTrayIcon
#SingleInstance

IfNotExist, bin\streamlink.exe
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
, streamlinkrc.ini
}
quali = best
Gui, +LastFound +AlwaysOnTop
WinSet, TransColor, 0Xcccccc
Gui, Color, ffffff
Gui, Margin, 0, 0
Gui, Font, bold c000000 S10, Trebuchet MS
Gui, Add, edit, w325 r1 vUrl,
gui, add, DDL, y+5 vdd_var gdd_label ,Best|Worst
GuiControl, Choose, dd_var, 1
Gui, Add, Button, x+5 gstart1, Play
Gui, Add, Button, x+5 gstart3, About
Gui, Add, Button, x+5 gstart2, Download
Gui, Show,,MiniGuiStreamlink Build 1.01
Return

start1:
gui, submit, nohide
;MsgBox %A_ScriptDir%\bin\streamlink.exe %Url% %quali%
   Run "bin\streamlink.exe" %Url% %quali% --config streamlinkrc.ini -f,Hide
Return

start2:
gui, submit, nohide
FormatTime, TimeString,, yyyy_dd_mm_HH_mm_ss
MsgBox %TimeString%.mp4
   Run bin\streamlink.exe "%Url%" %quali% --config streamlinkrc.ini -f -o "%A_ScriptDir%\Download\%TimeString%.mp4",Hide
Return

start3:
MsgBox Create 2018 by Alexandr1235. Build 1.01`nThanks for using this FREE program.`nalexandr1235@ya.ru
Return
GuiClose:
ExitApp
Return

dd_label:
gui, submit, nohide
if dd_var = Best
	quali = best
if dd_var = Worst
	quali = worst
