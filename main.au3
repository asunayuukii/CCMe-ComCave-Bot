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
#include <Date.au3>
#include <Misc.au3>

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListBox.au3>

$autostart = 0
$LP_X = 0
$LP_Y = 0
$screenshot = 0
$logopenonstart = 1
$tol = 100
$ccpath = 0
$cclog = 0
$ccusr = 0
$ccpsw = 0
$EvenBetterCCPort = 1
$CCme = 1

_CheckIni()

$Form1 = GUICreate("Log", 466, 170, $LP_X, $LP_Y)
$List1 = GUICtrlCreateList("", 8, 8, 449, 123)
$Button1 = GUICtrlCreateButton("Start", 352, 136, 107, 25)
$Checkbox1 = GUICtrlCreateCheckbox("Autostart", 280, 136, 65, 25)
$Checkbox2 = GUICtrlCreateCheckbox("Screenshots behalten", 144, 136, 129, 25)
$Checkbox3 = GUICtrlCreateCheckbox("Log beim starten öffnen", 8, 136, 129, 25)
GUISetState(@SW_HIDE, $Form1)

opt("TrayAutoPause",0)
opt("TrayMenuMode",3)
Opt("TrayOnEventMode", 1)

Opt("GUIOnEventMode", 1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exithwnd")
GUICtrlSetOnEvent($Button1, "_Start")
GUICtrlSetOnEvent($Checkbox1, "_ChangeAutostart")
GUICtrlSetOnEvent($Checkbox2, "_ChangeScreenshot")
GUICtrlSetOnEvent($Checkbox3, "_ChangeLogOnStart")

OnAutoItExitRegister("_OnExit")

$tr_opt = TrayCreateItem("Start")
$TE_opt = TrayItemSetOnEvent($tr_opt, "_Start")

$traylog = TrayCreateItem("Log")
$event_traylog = TrayItemSetOnEvent($traylog, "_traylog")

$tEXIT = TrayCreateItem("Exit")
$TE_EXIT = TrayItemSetOnEvent($tEXIT, "_Exit")

local $runtime = False
local $debug = False
local $erno = 0
local $force = False

If _Singleton("Log", 1) == 0 Then
	MsgBox($MB_SYSTEMMODAL, "CCme", "CCme Bereits gestartet.", 15)
	Exit
EndIf

If FileExists(@WorkingDir & "\debug.true") Then
	$debug = True
EndIf

If (FileExists(@WorkingDir & "\log.txt")) Then
	FileOpen(@WorkingDir & "\log.txt")
	FileWriteLine(@WorkingDir & "\log.txt", "#######################################")
	FileWriteLine(@WorkingDir & "\log.txt", "Programm Start")
	FileWriteLine(@WorkingDir & "\log.txt", _NowDate() & " - " & _NowTime())
	FileWriteLine(@WorkingDir & "\log.txt", "#######################################")
	FileClose(@WorkingDir & "\log.txt")
EndIf

_LogAdd("Programm gestartet.")

If _CheckInstall() == False Then
	MsgBox(0, "CCme", "Ordner/Dateien Fehlen. Bitte alle Dateien entpacken.")
	Exit(0)
EndIf

If $autostart == "1" Then
	_LogAdd("Autostart...")
	GUICtrlSetState($Checkbox1, $GUI_CHECKED)
	_opt()
EndIf

If $screenshot == "1" Then
	GUICtrlSetState($Checkbox2, $GUI_CHECKED)
EndIf

If $logopenonstart == "1" Then
	GUICtrlSetState($Checkbox3, $GUI_CHECKED)
	GUISetState(@SW_SHOW, $Form1)
EndIf

If $autostart == 1 And $EvenBetterCCPort == 1 Then
	_LogAdd("EvenBetterCC: Autostart von CC.")
	If WinExists("CC Launcher 3.0") == 0 Then
		$result = _EvenBetterCCPort(True)
		If $result == -1 Or $result == 0 Then
			_LogAdd("EvenBetterCC: Autostart von CC fehlgeschlagen.")
		EndIf
	Else
		_LogAdd("EvenBetterCC: Autostart nicht notwendig. CC bereits gestartet.")
	EndIf
EndIf

Func _Start()
	_opt()
EndFunc

Func _CheckInstall()
	$img1 = FileExists(@WorkingDir & "\img\1.png")
	$img2 = FileExists(@WorkingDir & "\img\2.png")
	$img3 = FileExists(@WorkingDir & "\img\3.png")
	$img4 = FileExists(@WorkingDir & "\img\4.png")
	$img5 = FileExists(@WorkingDir & "\img\5.png")
	$img6 = FileExists(@WorkingDir & "\img\6.png")
	$img7 = FileExists(@WorkingDir & "\img\7.png")
	$img8 = FileExists(@WorkingDir & "\img\8.png")
	$img9 = FileExists(@WorkingDir & "\img\9.png")
	$img0 = FileExists(@WorkingDir & "\img\0.png")
	$imgAB = FileExists(@WorkingDir & "\img\absenden.png")
	$tempf = FileExists(@WorkingDir & "\temp\")

	If $img0 And $img1 And $img2 And $img3 And $img4 And $img5 And $img6 And $img7 And $img8 And $img9 And $imgAB And $tempf Then
		_LogAdd("Install Check erfolgreich.")
		Return True
	Else
		Return False
	EndIf	
EndFunc

Func _CheckIni()
	If FileExists("config.ini") Then
		$autostart = IniRead("config.ini", "Settings", "autostart", "0")
		$LP_X = IniRead("config.ini", "Settings", "LP_X", "0")
		$LP_Y = IniRead("config.ini", "Settings", "LP_Y", "0")
		$screenshot = IniRead("config.ini", "Settings", "screenshot", "0")
		$logopenonstart = IniRead("config.ini", "Settings", "logopenonstart", "1")
		$tol = IniRead("config.ini", "Settings", "toleranz", "100")
		$ccpath = IniRead("config.ini", "CCInfo", "CC_Pfad", "0")
		$cclog = IniRead("config.ini", "CCInfo", "CC_Log", "0")
		$ccusr = IniRead("config.ini", "CCInfo", "CC_Nutzername", "0")
		$ccpsw = IniRead("config.ini", "CCInfo", "CC_Passwort", "0")
		$EvenBetterCCPort = IniRead("config.ini", "Funktionen", "EvenBetterCCPort", "1")
		$CCme = IniRead("config.ini", "Funktionen", "CCme", "1")
	Else
		IniWrite("config.ini", "Settings", "autostart", 0)
		IniWrite("config.ini", "Settings", "LP_X", 0)
		IniWrite("config.ini", "Settings", "LP_Y", 0)
		IniWrite("config.ini", "Settings", "screenshot", 0)
		IniWrite("config.ini", "Settings", "logopenonstart", 1)
		IniWrite("config.ini", "Settings", "toleranz", 100)
		IniWrite("config.ini", "CCInfo", "CC_Pfad", 0)
		IniWrite("config.ini", "CCInfo", "CC_Log", 0)
		IniWrite("config.ini", "CCInfo", "CC_Nutzername", 0)
		IniWrite("config.ini", "CCInfo", "CC_Passwort", 0)
		IniWrite("config.ini", "Funktionen", "EvenBetterCCPort", 1)
		IniWrite("config.ini", "Funktionen", "CCme", 1)
	EndIf

	If Not ($CCme == 1 Or $CCme == 0) Then
		$CCme = 1
	EndIf

	If Not ($EvenBetterCCPort == 1 Or $EvenBetterCCPort == 0) Then
		$EvenBetterCCPort = 1
	EndIf

	If $CCme == 0 And $EvenBetterCCPort == 0 Then
		$CCme = 1
	EndIf

	If IsInt($tol) == 0 Then
		$tol = 100
	EndIf

	If $tol < 0 Or $tol > 255 Then
		$tol = 100
	EndIf

	If Not FileExists($ccpath) Then
		$ccpath = 0
	EndIf

	If Not FileExists($cclog) Then
		$cclog = 0
	EndIf

	If $ccusr == "" Or $ccusr == Null Then
		$ccusr = 0
	EndIf

	If $ccpsw == "" Or $ccpsw == Null Then
		$ccpsw = 0
	EndIf
EndFunc

Func _ChangeAutostart()
	_CheckIni()
	$value = 0
	If GUICtrlRead($Checkbox1) == $GUI_CHECKED Then
		$value = 1
	EndIf
	IniWrite("config.ini", "Settings", "autostart", $value)
EndFunc

Func _ChangeScreenshot()
	_CheckIni()
	$value = 0
	If GUICtrlRead($Checkbox2) == $GUI_CHECKED Then
		$value = 1
	EndIf
	IniWrite("config.ini", "Settings", "screenshot", $value)
EndFunc

Func _ChangeLogOnStart()
	_CheckIni()
	$value = 0
	If GUICtrlRead($Checkbox3) == $GUI_CHECKED Then
		$value = 1
	EndIf
	IniWrite("config.ini", "Settings", "logopenonstart", $value)
EndFunc

Func _GetText($path)
    Local $sOCRTextResult = _UWPOCR_GetText($path)
    Return $sOCRTextResult
EndFunc

Func _traylog()
	GUISetState(@SW_SHOW, $Form1)
EndFunc

Func _Exit()
	Exit(0)
EndFunc

Func _OnExit()
	_opt(True)
	_LogAdd("Programm wird durch Benutzer beendet. Routine wird gestoppt und aufgeräumt.")
	Sleep(6000)
	If $screenshot == "0" Then
		_ClearTemp(@WorkingDir & "\temp\")
	EndIf
EndFunc

Func _Exithwnd()
	_CheckIni()
	$size = WinGetPos($Form1)
	IniWrite("config.ini", "Settings", "LP_X", $size[0])
	IniWrite("config.ini", "Settings", "LP_Y", $size[1])
	GUISetState(@SW_HIDE, $Form1)
EndFunc

Func _opt($ForceOff = False)
	If $runtime == True Or $ForceOff Then
		TrayItemSetText($tr_opt, "Start")
		GUICtrlSetData($Button1, "Start")
		$runtime = False
	Else
		_CheckIni()
		TrayItemSetText($tr_opt, "Stop")
		GUICtrlSetData($Button1, "Stop")
		$runtime = True
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

Func _AwayCheck($timeout = 5, $tickrate = 500)
	$lastpos = MouseGetPos()
	$newpos = MouseGetPos()

	If ($timeout < 1) Then
		$timeout = 1
	EndIf

	If ($tickrate < 250) Then
		$tickrate = 250
	EndIf
	
	If ($tickrate > $timeout*1000) Then
		$tickrate = $timeout*1000
	EndIf

	$x = Ceiling((($timeout*1000) / $tickrate))
	$i = 0

	While ($i <= $x And ($lastpos[0] == $newpos[0] And $lastpos[1] == $newpos[1]))
		Sleep($tickrate)
		$newpos = MouseGetPos()
		$i += 1
	WEnd

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
		$f = _ImageSearch_Area(@WorkingDir & "\img\absenden.png", $wgp[0], $wgp[1], ($wgp[0] + $wgp[2]), ($wgp[1] + $wgp[3]), $tol, True)
	Else
		$f = _ImageSearch_Area(@WorkingDir & "\img\" & $int & ".png", $wgp[0], $wgp[1], ($wgp[0] + $wgp[2]), ($wgp[1] + $wgp[3]), $tol, True)
	EndIf
	Return $f
EndFunc

Func _LogAdd($text)
	If $text == "" Then
		Return
	EndIf

	If (FileExists(@WorkingDir & "\log.txt")) Then
		FileOpen(@WorkingDir & "\log.txt")
		FileWriteLine(@WorkingDir & "\log.txt", _NowTime() & ": " & $text)
		FileClose(@WorkingDir & "\log.txt")
	EndIf

	_GUICtrlListBox_InsertString($List1,_NowTime() & ": " & $text, -1)
	_GUICtrlListBox_SetCurSel($List1,_GUICtrlListBox_GetCount($List1) - 1)
EndFunc

Func _Run($hwndname)
	If $runtime And Not (_ExistsCC() == 1) Then
		_LogAdd("Programm: ComCave Launcher nicht gestartet. Warte auf Start...")

		If $EvenBetterCCPort == 1 Then
			$a = MsgBox(4, "CCMe", "ComCave Launcher nicht gestartet." & @CRLF & "Möchtest du den ComCave Launcher selbst starten?" & @CRLF & "Nach 60 Sekunden Inaktivität wird CCLauncher gestartet.", 60)
			If $a == 7 Or $a == -1 Then
				If Not (_EvenBetterCCPort(True) == 1) Then
					Return 0
				EndIf
			EndIf
		EndIf

		While(_WinWaitC("CC Launcher 3.0", 5, 1000) == 0)
			If $runtime == False Then
				_LogAdd("Programm: Durch Nutzer gestoppt.")
				Return 0
			EndIf
		WEnd
	EndIf

	If ($runtime And $CCme == "1") Or ($runtime And $force) Then
		_LogAdd("-----------------------------------")
		_LogAdd("CCme gestartet. Warte auf Fenster " & $hwndname & "...")

		_CheckIni()
		$randtime = Random(120, 135, 1)
		$lastCC = _NowCalc()
		$lastCheck = $lastCC
		$lastHWND = $lastCC
		
		While(_WinWaitC($hwndname, 5, 1000) == 0)
			$now = _NowCalc()

			If $runtime == False Then
				_LogAdd("CCme: Durch Nutzer gestoppt.")
				Return 0
			EndIf

			If _DateDiff("n", $lastHWND, $now) >= $randtime And $EvenBetterCCPort == 1 Then
				_LogAdd("CCme: Fenster seit 2 Stunden nicht gefunden.")
				_LogAdd("CCme: Mit EvenBetterCC wird CCLauncher neu gestartet...")
				_EvenBetterCCPort()
				$lastHWND = _NowCalc()
				Return 0
			EndIf

			If (WinExists("CC Launcher 3.0") == 0) Then
				_LogAdd("CCme: CCLauncher nicht gestartet. Routine wird neugestartet.")
				Return 0
			EndIf

			If _DateDiff("n", $lastCheck, $now) >= 3 Then
				$lastCheck = $now
				If _CheckCCLog($cclog) == 1 Then
					If $debug Then
						_LogAdd("DEBUG: PingCheck erfolgreich!")
					EndIf
					$lastCC = $now
				EndIf
			EndIf

			If _DateDiff("n", $lastCC, $now) >= 10 And $EvenBetterCCPort == 1 Then
				_LogAdd("CCme: CheckCCLog seit über 10 Minuten keinen Ping gelesen.")
				_LogAdd("CCme: Mit EvenBetterCC wird CCLauncher neu gestartet...")
				If _EvenBetterCCPort() == 1 Then
					$lastCC = $now
					Return 0
				EndIf
			EndIf
		WEnd

		_LogAdd("CCme: Fenster gefunden.")
		$lastHWND =_NowCalc()

		$result = _CCme($hwndname)

		If $result == 1 Then
			_LogAdd("CCme: Kontrollprüfung. 60 Sekunden warten.")
			Sleep(60000)
			If WinExists($hwndname) Then
				_LogAdd("CCme: Kontrollprüfung gescheitert. PIN Eingabe Fehler möglich.")
				Return -1
			EndIf
			_LogAdd("CCme: Kontrollprüfung erfolgreich.")
		EndIf

		Return $result
	EndIf

	If $runtime And $EvenBetterCCPort == "1" And $CCme == "0" Then
		_LogAdd("-----------------------------------")
		_LogAdd("EvenBetterCC gestartet. Warte auf Fenster " & $hwndname & "...")

		_CheckIni()
		$randtime = Random(120, 122, 1)
		$lastCC = _NowCalc()
		$lastCheck = $lastCC
		$lastHWND = $lastCC

		While(_WinWaitC($hwndname, 5, 1000) == 0)
			$now = _NowCalc()

			If $runtime == False Then
				_LogAdd("EvenBetterCC: Durch Nutzer gestoppt.")
				Return 0
			EndIf

			If _DateDiff("n", $lastHWND, $now) >= $randtime  Then
				_LogAdd("EvenBetterCC: Fenster seit 2 Stunden nicht gefunden.")
				_LogAdd("EvenBetterCC: Mit EvenBetterCC wird CCLauncher neu gestartet...")
				_EvenBetterCCPort()
				$lastHWND = $now
				Return 0
			EndIf

			If (WinExists("CC Launcher 3.0") == 0) Then
				_LogAdd("EvenBetterCC: CCLauncher nicht gestartet. Routine wird neugestartet.")
				Return 0
			EndIf

			If _DateDiff("n", $lastCheck, $now) >= 3 Then
				$lastCheck = $now
				If _CheckCCLog($cclog) == 1 Then
					If $debug Then
						_LogAdd("DEBUG: PingCheck erfolgreich!")
					EndIf
					$lastCC = $now
				EndIf
			EndIf

			If _DateDiff("n", $lastCC, $now) >= 10 And $EvenBetterCCPort == 1 Then
				_LogAdd("EvenBetterCC: CheckCCLog seit über 10 Minuten keinen Ping gelesen.")
				_LogAdd("EvenBetterCC: Mit EvenBetterCC wird CCLauncher neu gestartet...")
				If _EvenBetterCCPort() == 1 Then
					$lastCC = $now
					Return 0
				EndIf
			EndIf
		WEnd

		_LogAdd("EvenBetterCC: Fenster gefunden.")
		$lastHWND = _NowCalc()

		$result = _EvenBetterCCPort()

		If $result == 1 Then
			_LogAdd("EvenBetterCC: Kontrollprüfung. 60 Sekunden warten.")
			Sleep(60000)
			If WinExists($hwndname) Then
				_LogAdd("EvenBetterCC: Kontrollprüfung gescheitert. Fehler möglich.")
				Return -1
			EndIf
			_LogAdd("EvenBetterCC: Kontrollprüfung erfolgreich.")
		EndIf

		Return $result
	EndIf

	Return 1
EndFunc

Func _KillCC()
	Local $pid = ProcessExists("java.exe")
	If $pid == 0 Then
		Return 0
	EndIf
	Return ProcessClose($pid)
EndFunc

Func _StartCC()
	_CheckIni()
	If $ccpath == 0 Or FileExists($ccpath) == False Then
		Return 0
	EndIf
	Return Run($ccpath)
EndFunc

Func _LoginCC()
	If WinExists("Login") == 0 Then
		Return 0
	EndIf

	If $ccusr == 0 Or $ccpsw == 0 Then
		Return 0
	EndIf

	Sleep(1000)

	$cchwnd = _GetHWND("Login")

	If $cchwnd == False Then
		Return 0
	EndIf

	Sleep(500)

	Send($ccusr)
	Sleep(500)
	Send("{TAB}")
	Sleep(500)
	Send($ccpsw)
	Sleep(500)
	Send("{ENTER}")

	Return 1
EndFunc

Func _ExistsCC()
	$value = 0

	If WinExists("Login") Then
		$value = -1
	EndIf

	If WinExists("CC Launcher 3.0") Then
		$value = 1
	EndIf

	Return $value
EndFunc

Func _WinWaitC($hwndname, $timeout = 1, $tickrate = 500)
	If ($hwndname == "") Then
		Return -1
	EndIf

	If ($timeout < 1) Then
		$timeout = 1
	EndIf

	If ($tickrate < 250) Then
		$tickrate = 250
	EndIf
	
	If ($tickrate > $timeout*1000) Then
		$tickrate = $timeout*1000
	EndIf

	$x = Ceiling((($timeout*1000) / $tickrate))
	$i = 0

	While ($i <= $x And Not (WinExists($hwndname)))
		Sleep($tickrate)
		$i += 1
	WEnd

	$r = 0
	If (WinExists($hwndname)) Then
		$r = 1
	EndIf

	Return $r
EndFunc

Func _CheckCCLog($logpath)
	If $logpath == "" Or $logpath == Null Or $logpath == 0 Then
		Return 1
	EndIf

	$x = 0
	$iLines = _FileCountLines($logpath)
	For $i = 0 to 5 Step +1
		If ($iLines - $i > 0) Then
			If Not (StringInStr(FileReadLine($logpath, $iLines - $i), "Ping erfolgreich") == 0) Then
				$x = 1
				ExitLoop
			EndIf
		EndIf
	Next

	Return $x
EndFunc

Func _CCme($hwndname, $ByPassAC = False)
	If $runtime == False Then
		_LogAdd("CCme: Durch Nutzer gestoppt.")
		Return 0
	EndIf

	$ac = True

	If Not ($ByPassAC) Then
		_LogAdd("CCme: Anwesenheit wird geprüft.")
		$ac = _AwayCheck()
	EndIf

	$i = 0
	While $ac == False
		If $runtime == False Then
			_LogAdd("CCme: Durch Nutzer gestoppt.")
			Return 0
		EndIf
		_LogAdd("CCme: Nutzer Bewegung erkannt. Warten...")
		Sleep(3000)
		$ac = _AwayCheck()
		$i += 1
		If $i >= 3 Then
			$a = MsgBox(4, "CCMe", "Nutzer Bewegung erkannt." & @CRLF & "Möchtest du die Eingabe selbst vornehmen?", 60)
			If($a == 6) Then
				Sleep(60000)
				_LogAdd("CCme: Nutzer möchte Eingabe selbst durchführen.")
				Return 0
			Else
				_LogAdd("CCme: Programm führt Eingabe durch.")
				Sleep(1000)
				$ac = True
			EndIf
		EndIf
	WEnd

	If (WinExists($hwndname) == 0) Then
		_LogAdd("CCme: Fenster konnte nach Anwesenheitsprüfung nicht gefunden werden.")
		Return 0
	EndIf

	$hwnd = _GetHWND($hwndname)

	If $hwnd == False Then
		_LogAdd("CCme: Screenshot konnte nicht erstellt werden. ABBRUCH.")
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
		_LogAdd("CCme: Screenshot konnte nicht erstellt werden. ABBRUCH.")
		Return -1
	EndIf

	_LogAdd("CCme: Screenshot wurde erstellt.")

	$r = _GetText($fname)
	_LogAdd("CCme: Text wurde aus Screenshot gelesen.")

	$numbers = StringRegExpReplace($r, "\D", "")

	If StringLen($numbers) > 4 Then
		$numbers = StringTrimRight($numbers, StringLen($numbers) - 4)
	EndIf

	If StringLen($numbers) < 4 Then
		_LogAdd("CCme: Es wurden weniger als 4 Zahlen gelesen. ABBRUCH.")
		Return -1
	EndIf

	If $runtime == False Then
		_LogAdd("CCme: Durch Nutzer gestoppt.")
		Return 0
	EndIf

	_LogAdd("CCme: Ausgelesen Zahlen sind: " & $numbers & ".")
	$splitnumbers = StringSplit($numbers, "",2)

	$first = _Find($splitnumbers[0], $hwnd)
	Sleep(500)
	$second = _Find($splitnumbers[1], $hwnd)
	Sleep(500)
	$third = _Find($splitnumbers[2], $hwnd)
	Sleep(500)
	$fourth = _Find($splitnumbers[3], $hwnd)
	Sleep(500)
	$send = _Find(-1, $hwnd)

	If $first[0] == 0 Then
		_LogAdd("CCme: Die Taste " & $splitnumbers[0] & " konnte NICHT gefunden werden.")
	Else
		_LogAdd("CCme: Die Taste " & $splitnumbers[0] & " konnte gefunden werden.")
	EndIf

	If $second[0] == 0 Then
		_LogAdd("CCme: Die Taste " & $splitnumbers[1] & " konnte NICHT gefunden werden.")
	Else
		_LogAdd("CCme: Die Taste " & $splitnumbers[1] & " konnte gefunden werden.")
	EndIf

	If $third[0] == 0 Then
		_LogAdd("CCme: Die Taste " & $splitnumbers[2] & " konnte NICHT gefunden werden.")
	Else
		_LogAdd("CCme: Die Taste " & $splitnumbers[2] & " konnte gefunden werden.")
	EndIf

	If $fourth[0] == 0 Then
		_LogAdd("CCme: Die Taste " & $splitnumbers[3] & " konnte NICHT gefunden werden.")
	Else
		_LogAdd("CCme: Die Taste " & $splitnumbers[3] & " konnte gefunden werden.")
	EndIf

	If $send[0] == 0 Then
		_LogAdd("CCme: Die Taste " & "Absenden" & " konnte NICHT gefunden werden.")
	Else
		_LogAdd("CCme: Die Taste " & "Absenden" & " konnte gefunden werden.")
	EndIf

	If $send[0] == 0 Or $first[0] == 0 Or $second[0] == 0 Or $third[0] == 0 Or $fourth[0] == 0 Then
		_LogAdd("CCme: Mindestens eine Taste konnte nicht gefunden werden. ABBRUCH.")
		Return -1
	EndIf

	_LogAdd("CCme: Maus wird bewegt.")
	MouseClick($MOUSE_CLICK_LEFT, Random(-3, 3,1) + $first[1], Random(-3, 3,1) + $first[2], 1,Random(20,40,1))
	Sleep(Random(800,1200,1))
	MouseClick($MOUSE_CLICK_LEFT, Random(-3, 3,1) + $second[1], Random(-3, 3,1) + $second[2], 1,Random(20,40,1))
	Sleep(Random(800,1200,1))
	MouseClick($MOUSE_CLICK_LEFT, Random(-3, 3,1) + $third[1], Random(-3, 3,1) + $third[2], 1,Random(20,40,1))
	Sleep(Random(800,1200,1))
	MouseClick($MOUSE_CLICK_LEFT, Random(-3, 3,1) + $fourth[1], Random(-3, 3,1) + $fourth[2], 1,Random(20,40,1))
	Sleep(Random(800,1200,1))
	MouseClick($MOUSE_CLICK_LEFT, Random(-3, 3,1) + $send[1], Random(-3, 3,1) + $send[2], 1,Random(20,40,1))
	_LogAdd("CCme: Eingabe wurde beendet.")
	Sleep(Random(4000,8000,1))

	Return 1
EndFunc

Func _EvenBetterCCPort($ByPassAC = False)
	If $EvenBetterCCPort == 0 Then
		Return 0
	EndIf

	If $ccpath == 0 Or $ccusr == 0 Or $ccpsw == 0 Then
		_LogAdd("EvenBetterCC: Pfad oder Login fehlen in der Config.ini.")
		Return -1
	EndIf

	If FileExists($ccpath) == 0 Then
		_LogAdd("EvenBetterCC: Pfad ist nicht korrekt hinterlegt in der Config.ini.")
		Return -1
	EndIf

	$ac = True

	If Not ($ByPassAC) Then
		_LogAdd("EvenBetterCC: Anwesenheit wird geprüft.")
		$ac = _AwayCheck()
	EndIf

	$i = 0
	While $ac == False
		If $runtime == False Then
			_LogAdd("CCme: Durch Nutzer gestoppt.")
			Return 0
		EndIf
		_LogAdd("EvenBetterCC: Nutzer Bewegung erkannt. Warten...")
		Sleep(3000)
		$ac = _AwayCheck()
		$i += 1
		If $i >= 3 Then
			$a = MsgBox(4, "EvenBetterCC", "Nutzer Bewegung erkannt." & @CRLF & "Möchtest du die Eingabe selbst vornehmen?", 60)
			If($a == 6) Then
				Sleep(60000)
				_LogAdd("EvenBetterCC: Nutzer möchte Eingabe selbst durchführen.")
				Return 0
			Else
				_LogAdd("EvenBetterCC: Programm führt Eingabe durch.")
				Sleep(1000)
				$ac = True
			EndIf
		EndIf
	WEnd

	While (WinExists("Login") Or WinExists("CC Launcher 3.0"))
		_LogAdd("EvenBetterCC: CC wird beendet.")
		
		_KillCC()
		
		$rl = WinWaitClose("Login", "", 10)
		$rc = WinWaitClose("CC Launcher 3.0", "", 10)
		
		If $rl == 0 Then
			ProcessClose(WinGetProcess("Login"))
		EndIf

		If $rc == 0 Then
			ProcessClose(WinGetProcess("CC Launcher 3.0"))
		EndIf
	WEnd

	If $runtime == False Then
		_LogAdd("EvenBetterCC: Durch Nutzer gestoppt.")
		Return 0
	EndIf

	_LogAdd("EvenBetterCC: CC ist beendet.")

	$start = _StartCC()

	If $start == 0 Then
		_LogAdd("EvenBetterCC: Fehler beim starten von CC.")
		Return -1
	EndIf

	_LogAdd("EvenBetterCC: CC erfolgreich gestartet.")

	If _WinWaitC("Login", 60, 1000) == 0 Then
		_LogAdd("EvenBetterCC: Fehler beim starten von CC.")
		Return -1
	EndIf

	_LogAdd("EvenBetterCC: CC Login gefunden...")

	$login = _LoginCC()

	If $login == 0 Then
		_LogAdd("EvenBetterCC: Fehler beim Login von CC.")
		Return -1
	EndIf

	_LogAdd("EvenBetterCC: CC Logindaten eingegeben...")
	_LogAdd("EvenBetterCC: Warte auf das Fenster CC Launcher 3.0...")

	_WinWaitC("CC Launcher 3.0", 60, 1000)

	If $runtime == False Then
		_LogAdd("EvenBetterCC: Durch Nutzer gestoppt.")
		Return 0
	EndIf

	$logincheck = _ExistsCC()

	If Not ($logincheck == 1) Then
		If $logincheck == -1 Then
			_LogAdd("EvenBetterCC: Fehler beim Login von CC. Falsche Logindaten möglich.")
			Return -1
		Else
			_LogAdd("EvenBetterCC: Fehler beim Login von CC. Fenster konnte nicht gefunden werden.")
			Return -1
		EndIf
	EndIf

	_LogAdd("EvenBetterCC: CC Login erfolgreich...")

	_LogAdd("EvenBetterCC: Neustart und Login durchgeführt.")
	Return 1
EndFunc

While 1
	Sleep(5000)
	$runres = _Run("Anwesenheitskontrolle")

	If $runres == 1 Then
		$erno = 0
		$force = False
	ElseIf $runres == -1 Then
		$erno += 1
	EndIf

	If $erno >= 3 Then
		If $CCme == 0 Then
			$force = True
		EndIf
		If $EvenBetterCCPort == 1 Then
			_LogAdd("Ausfallsicherung: EvenbetterComCave gestartet.")
			$res = _EvenBetterCCPort()
			If $res == 1 Then
				$erno = 0
				$force = False
			Else
				_LogAdd("Ausfallsicherung: EvenbetterComCave gescheitert. Probiere es weiter mit CCme...")
			EndIf
		Else
			_LogAdd("Ausfallsicherung: Deaktiviert. Probiere es weiter mit CCme...")
		EndIf
	EndIf
WEnd
