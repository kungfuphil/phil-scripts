#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force
#Persistent

; VARIABLES - CITRIX/SKYPE FOR BUSINESS
citrixTitle := "PowerVS Desktop - Google Chrome"
skypeX := 195
skypeY := 1028

; Keep Numlock on forever.
SetNumLockState, AlwaysOn

timerIsActive := False

; Reload this script, if you make any changes
^r::
    Reload
Return

; Because I haven't yet found a suitable emoji that expresses this feeling
:*:/fliptable::
    Send, (ノಠ益ಠ)ノ彡┻━┻
Return

; Check to see the location of the mouse and what color it is returning.
^y::
    WinGetActiveTitle, currentWindow
    IfWinExist, %citrixTitle%
        WinActivate
    Else
        Return
    
    Sleep, 250
    PixelGetColor, imWindowColor, %skypeX%, %skypeY%, RGB
    MouseMove, %skypeX%, %skypeY%
    
    MsgBox, %imWindowColor%

    WinActivate, %currentWindow%
Return

; Toggle checking to see if there are any new Skype for Business IMs waiting.
; You need to make sure that the Citrix Desktop is the active tab on Chrome.
^q::
    if (timerIsActive)
    {
        timerIsActive := false
        SetTimer, CheckForNewMessages, Off
        MsgBox, No longer searching for messages
    }
    Else
    {
        timerIsActive := true
        SetTimer, CheckForNewMessages, 10000
        MsgBox, Now searching for messages
    }
Return

; Close that stupid popup if it appears and makes itself full screen
^p::
    IfWinExist, MICROSOFT SECURITY WARNING
        WinClose, MICROSOFT SECURITY WARNING
Return

; Open the calculator
^k::
    Run, calc.exe
Return

; Use spacebar to mute/unmute the microphone when Skype is the foremost window
#IfWinActive, Skype
Space::
    Send, ^m
Return
#IfWinActive

CheckForNewMessages:
    WinGetActiveTitle, currentWindow
    IfWinExist, %citrixTitle%
        WinActivate
    Else
        Return
    
    PixelGetColor, imWindowColor, %skypeX%, %skypeY%, RGB
    
    if (imWindowColor = "0xB06225") or (imWindowColor = "0xA7591B") or (imWindowColor = "0xB15E1A")
    {
        SoundPlay, %A_WinDir%\Media\Alarm02.wav
    }

    WinActivate, %currentWindow%
Return
