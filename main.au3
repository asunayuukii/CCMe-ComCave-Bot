#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         Unknown

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <Array.au3>
#include <UWPOCR.au3>
#include <ScreenCapture.au3>
#include <File.au3>
#include <GDIPlus.au3>
#include <MsgBoxConstants.au3>
#include <_ImageSearch_UDF.au3>
 
opt("TrayAutoPause",0)
opt("TrayMenuMode",3)
Opt("TrayOnEventMode", 1)

OnAutoItExitRegister("_Exit")
 
$tr_opt = TrayCreateItem("Start")
$TE_opt = TrayItemSetOnEvent($tr_opt, "_opt")

$tEXIT = TrayCreateItem("Exit")
$TE_EXIT = TrayItemSetOnEvent($tEXIT, "_Exit")

local $runtime = False

Func _GetText($path)
    Local $sOCRTextResult = _UWPOCR_GetText($path)
    Return $sOCRTextResult
EndFunc

Func _Exit()
	$runtime = False
	Sleep(1500)
	_ClearTemp(@WorkingDir & "\temp\")
	Exit(0)
EndFunc

Func _opt()
	If $runtime == False Then
		TrayItemSetText($tr_opt, "Stop")
		$runtime = True
	Else
		TrayItemSetText($tr_opt, "Start")
		$runtime = False
	EndIf
EndFunc

Func _ClearTemp($path)
	$files = _FileListToArray($path, "*.png", 1, False)
	for $i = 1 to UBound($files) -1
		If FileExists($path & $files[$i]) Then
			FileDelete($path & $files[$i])
		EndIf
	Next
EndFunc

Func _GetHWND($hwndname)
	$hwnd = WinGetHandle($hwndname)
	If @error Then
		$hwnd = False
		Return $hwnd
	EndIf
	WinActivate($hwnd)
	Return $hwnd
EndFunc

Func _GetScreenShot($hwnd, $fname)
	$lastmouse = MouseGetPos()
	MouseMove(Random(0,10,1),Random(0,10,1))
	Sleep(150)
	$r = _ScreenCapture_CaptureWnd($fname, $hwnd)
	If @error Then
		$r = False
	EndIf
	MouseMove($lastmouse[0], $lastmouse[1])
	Sleep(150)
	Return $r
EndFunc

Func _AwayCheck()
	$lastpos = MouseGetPos()
	Sleep(5000)
	$newpos = MouseGetPos()
	$r = False
	If $lastpos[0] == $newpos[0] And $lastpos[1] == $newpos[1] Then
		$r = True
	EndIf
	Return $r
EndFunc

Func _Find($int, $hwnd)
	$f = Null
	$wgp = WinGetPos($hwnd)
	If $int == -1 Then
		$f = _ImageSearch_Area(@WorkingDir & "\img\absenden.png", $wgp[0], $wgp[1], ($wgp[0] + $wgp[2]), ($wgp[1] + $wgp[3]), 100, True)
	Else
		$f = _ImageSearch_Area(@WorkingDir & "\img\" & $int & ".png", $wgp[0], $wgp[1], ($wgp[0] + $wgp[2]), ($wgp[1] + $wgp[3]), 100, True)
	EndIf
	Return $f
EndFunc

Func _Run($hwndname)
	If $runtime Then
		WinWait($hwndname)
		
		If $runtime == False Then
			Return -1
		EndIf
		
		$ac = _AwayCheck()
		
		$i = 0
		While $ac == False
			$ac = _AwayCheck()
			$i += 1
			If $i >= 2 Then
				$a = MsgBox(4, "CCMe", "Nutzer Bewegung erkannt." & @CRLF & "Möchtest du die Eingabe selbst vornehmen?", 60)
				If($a == 6)Then
					Sleep(60000)
					Return -1
				Else
					Sleep(1000)
					$ac == True
				EndIf
			EndIf
		WEnd
		
		$hwnd = _GetHWND($hwndname)
		
		If $hwnd == False Then
			MsgBox(0, "CCMe", "ERROR - Fenster wurde gefunden und wurde wieder verloren." & @CRLF & "Fenster schließt nach 60 Sekunden und dann geht es weiter.", 60)
			Return -1
		EndIf
		
		$fpath = @WorkingDir & "\temp\temp"
		$i = 0
		If FileExists($fpath & $i & ".png") Then
			$file = FileExists($fpath & $i & ".png")
			While $file
				$i += 1
				$file = FileExists($fpath & $i & ".png")
			WEnd
		EndIf
		$fname = $fpath & $i & ".png"
		
		$gss = _GetScreenShot($hwnd, $fname)
		
		If $gss == False Then
			MsgBox(0, "CCMe", "ERROR - Screenshot konnte nicht erstellt werden." & @CRLF & "Fenster schließt nach 60 Sekunden und dann geht es weiter.", 60)
			Return -1
		EndIf
		
		$r = _GetText($fname)
		
		$numbers = StringRegExpReplace($r, "\D", "")
		
		If StringLen($numbers) > 4 Then
			$numbers = StringTrimRight($numbers, StringLen($numbers) - 4) 
		EndIf
		
		If StringLen($numbers) < 4 Then
			MsgBox(0, "CCMe", "ERROR - Pin konnte nicht gelesen werden." & @CRLF & "Fenster schließt nach 60 Sekunden und dann geht es weiter.", 60)
			Return -1
		EndIf
			
		$splitnumbers = StringSplit($numbers, "",2)
		
		$first = _Find($splitnumbers[0], $hwnd)
		$second = _Find($splitnumbers[1], $hwnd)
		$third = _Find($splitnumbers[2], $hwnd)
		$fourth = _Find($splitnumbers[3], $hwnd)
		
		$send = _Find(-1, $hwnd)
		
		If $send[0] == 0 Or $first[0] == 0 Or $second[0] == 0 Or $third[0] == 0 Or $fourth[0] == 0 Then
			MsgBox(0, "CCMe", "ERROR - Zahlenfeld konnte nicht gelesen werden." & @CRLF & "Fenster schließt nach 60 Sekunden und dann geht es weiter.", 60)
			Return -1
		EndIf
		
		MouseClick($MOUSE_CLICK_LEFT, Random(-3, 3,1) + $first[1], Random(-3, 3,1) + $first[2], 1,Random(20,40,1))
		Sleep(Random(800,1200,1))
		MouseClick($MOUSE_CLICK_LEFT, Random(-3, 3,1) + $second[1], Random(-3, 3,1) + $second[2], 1,Random(20,40,1))
		Sleep(Random(800,1200,1))
		MouseClick($MOUSE_CLICK_LEFT, Random(-3, 3,1) + $third[1], Random(-3, 3,1) + $third[2], 1,Random(20,40,1))
		Sleep(Random(800,1200,1))
		MouseClick($MOUSE_CLICK_LEFT, Random(-3, 3,1) + $fourth[1], Random(-3, 3,1) + $fourth[2], 1,Random(20,40,1))
		Sleep(Random(800,1200,1))
		MouseClick($MOUSE_CLICK_LEFT, Random(-3, 3,1) + $send[1], Random(-3, 3,1) + $send[2], 1,Random(20,40,1))
		Sleep(Random(8000,12000,1))
	EndIf
	Sleep(1000)
EndFunc

While 1
	Sleep(1000)
	_Run("Anwesenheitskontrolle")
WEnd
