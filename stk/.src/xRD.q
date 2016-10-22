[General]
SyntaxVersion=2
BeginHotkey=0
BeginHotkeyMod=0
PauseHotkey=0
PauseHotkeyMod=0
StopHotkey=123
StopHotkeyMod=2
RunOnce=1
EnableWindow=
MacroID=e8f5d863-47fe-4e6d-badd-94166895409f
Description=xRD
Enable=1
AutoRun=0
[Repeat]
Type=0
Number=1
[SetupUI]
Type=2
QUI=
[Relative]
SetupOCXFile=
[Comment]

[Script]
KeyDown "Win", 1
KeyPress "5", 1
KeyUp "Win", 1
Delay 300
KeyDown "Win", 1
KeyPress "9", 1
KeyUp "Win", 1
Delay 200
KeyPress "Esc", 1
KeyPress "tag0", 1
KeyPress "tag1", 1
KeyPress "tag2", 1
KeyPress "tag3", 1
KeyPress "tag4", 1
KeyPress "tag5", 1
KeyPress "Enter", 1
KeyPress "d", 1
Delay 100
KeyPress "Enter", 1
KeyPress "F1", 1
MoveTo 771, 194
LeftClick 1
KeyPress "PageUp", 1
Delay 100
KeyPress "PageUp", 1
Delay 266
RightClick 1
Delay 100
KeyPress "Down", 3
Delay 100
KeyPress "Down", 2
KeyPress "Right", 1
KeyPress "Enter", 1
KeyDown 18, 1
KeyPress 78, 1
KeyUp 18, 1
Delay 300
KeyDown 18, 1
KeyPress 78, 1
KeyUp 18, 1
Delay 200
LeftClick 1
For 10
Delay 700
IfColor 926,577,"0",0 Then
Delay 300
IfColor 921,580,"0",0 Then
Goto green
End If
End If
Next
Rem green
LeftClick 1

KeyDown "Win", 1
KeyPress "3", 1
KeyUp "Win", 1
KeyDown 17, 1
KeyPress 85, 1
KeyUp 17, 1

KeyPress ".", 1
KeyPress "b", 1
KeyPress "e", 1
KeyPress "l", 1
KeyPress "l", 1
KeyPress ".", 1
KeyPress "x", 1
KeyPress "R", 1
KeyPress "D", 1
KeyPress "Enter", 1
