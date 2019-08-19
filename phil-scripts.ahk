#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force
#Persistent

; VARIABLES - YOUR SIGNATURE
; For use in the signature hotstrings
name := "Philip Ho"
title := "Sr. BTA"

; VARIABLES - CITRIX/SKYPE FOR BUSINESS
citrixTitle := "PowerVS Desktop - Google Chrome"
skypeX := 195
skypeY := 1028

; Whether or not we are currently checking for new messages
checkForMessagesTimerActive := False

; Keep Numlock on forever.
SetNumLockState, AlwaysOn

; Reload this script, if you make any changes
^r::
    Reload
Return

; HOTSTRINGS

; Because I haven't yet found a suitable emoji that expresses this feeling
:*:/fliptable::
    Send, (ノಠ益ಠ)ノ彡┻━┻
Return

; Replaces "sig1" with your whole name
:*:sig1::
    Send, %name%
Return

; Replaces "sig2" with your name, title, "Yes", and current date
; for use in filling out forms.
:*:sig2::
    FormatTime, timestamp, A_Now, M/d/yyyy
    Send, %name%{Tab}%title%{Tab}Yes{Tab}%timestamp%
Return

; Replaces "tdt" with the current date in American format.
:*:tdt::
    FormatTime, timestamp, A_Now, M/d/yyyy
    Send, %timestamp%
Return


; HOTKEYS

; Check to see the location of the mouse and what color it is returning.
; Use this when you need to recalibrate the checking for new messages
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
    if (checkForMessagesTimerActive)
    {
        checkForMessagesTimerActive := false
        SetTimer, CheckForNewMessages, Off
        MsgBox, No longer searching for messages
    }
    Else
    {
        checkForMessagesTimerActive := true
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
#k::
    Run, calc.exe
Return

; Control the volume by holding down Shift and moving the mouse wheel up or down
; Volume down
+WheelDown::
    SoundSet, -1
Return
; Volume up
+WheelUp::
    SoundSet, +1
Return

; Change the volume quicker by holding down Ctrl+Shift and moving the mouse wheel up or down
; Volume down
^+WheelDown::
    SoundSet, -10
Return

; Volume up
^+WheelUp::
    SoundSet, +10
Return

; Use spacebar to mute/unmute the microphone when Skype is the foremost window
#IfWinActive, Skype
Space::
    Send, ^m
Return
#IfWinActive

; Checks the Citrix desktop to see if any new IMs have arrived and plays a sound
; because the sound from Citrix doesn't always play or doesn't always play loud enough
; to be heard.
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
