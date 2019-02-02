; #FUNCTION# ====================================================================================================================
; Name ..........: OpeniTools
; Description ...: Opens new iTools instance
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (12-2015) | SpartanUBPT (11-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpeniTools($bRestart = False)

	Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $cmdPar

	SetLog("Starting " & $g_sAndroidEmulator & " and Clash Of Clans", $COLOR_SUCCESS)

	Local $launchAndroid = (WinGetAndroidHandle() = 0 ? True : False)
	If $launchAndroid Then
		; Launch iTools
		$cmdPar = GetAndroidProgramParameter()
		$PID = LaunchAndroid($g_sAndroidProgramPath, $cmdPar, $g_sAndroidPath)
		If $PID = 0 Then
			SetError(1, 1, -1)
			Return False
		EndIf
	EndIf

	SetLog("Please wait while " & $g_sAndroidEmulator & " and CoC start...", $COLOR_SUCCESS)
	$hTimer = __TimerInit()

	; Test ADB is connected
	$connected_to = ConnectAndroidAdb(False, 60 * 1000)
	If Not $g_bRunState Then Return False

	; Wait for device
	;$cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " wait-for-device", $process_killed, 60 * 1000)
	;If Not $g_bRunState Then Return

	; Wait for boot completed
	If WaitForAndroidBootCompleted($g_iAndroidLaunchWaitSec - __TimerDiff($hTimer) / 1000, $hTimer) Then Return False

	If __TimerDiff($hTimer) >= $g_iAndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
		SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
		SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_ERROR)
		SetError(1, @extended, False)
		Return False
	EndIf

	SetLog($g_sAndroidEmulator & " Loaded, took " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_SUCCESS)

	Return True

EndFunc   ;==>OpeniTools

Func IsiToolsCommandLine($CommandLine)
	SetDebugLog("Check iTools command line instance: " & $CommandLine)
	Local $sInstance = ($g_sAndroidInstance = "" ? $g_avAndroidAppConfig[$g_iAndroidConfig][1] : $g_sAndroidInstance)
	$CommandLine = StringReplace($CommandLine, GetiToolsPath(), "")
	If StringRegExp($CommandLine, "/start " & $sInstance & "\b") = 1 Then Return True
	If StringRegExp($CommandLine, "/restart .*\b" & $sInstance & "\b") = 1 Then Return True
	Return False
EndFunc   ;==>IsiToolsCommandLine

Func GetiToolsProgramParameter($bAlternative = False)
	Local $sInstance = ($g_sAndroidInstance = "" ? $g_avAndroidAppConfig[$g_iAndroidConfig][1] : $g_sAndroidInstance)
	If Not $bAlternative Or $g_sAndroidInstance <> $g_avAndroidAppConfig[$g_iAndroidConfig][1] Then
		; should be launched with these parameter
		Return "/start " & $sInstance
	EndIf
	; default instance gets launched when no parameter was specified (this is the alternative way)
	Return ""
EndFunc   ;==>GetiToolsProgramParameter

Func GetiToolsPath()
	Local $iTools_Path = EnvGet("iToolsPath") ;RegRead($g_sHKLM & "\SOFTWARE\iTools\", "InstallDir") ; Doesn't exist (yet)
	If FileExists($iTools_Path & "iToolsAVM.exe") = 0 Then ; work-a-round
		Local $InstallLocation = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\ThinkSky\iToolsAVM\", "InstallLocation")
		If @error = 0 And FileExists($InstallLocation & "\iToolsAVM.exe") = 1 Then
			$iTools_Path = $InstallLocation
		Else
			Local $DisplayIcon = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\ThinkSky\iToolsAVM\", "DisplayIcon")
			If @error = 0 Then
				Local $iLastBS = StringInStr($DisplayIcon, "\", 0, -1)
				$iTools_Path = StringLeft($DisplayIcon, $iLastBS)
				If StringLeft($iTools_Path, 1) = """" Then $iTools_Path = StringMid($iTools_Path, 2)
			Else
				$iTools_Path = @ProgramFilesDir & "\ThinkSky\iToolsAVM\"
				SetError(0, 0, 0)
			EndIf
		EndIf
	EndIf
	$iTools_Path = StringReplace($iTools_Path, "\\", "\")
	Return $iTools_Path
EndFunc   ;==>GetiToolsPath

Func GetiToolsAdbPath()
	Local $adbPath = EnvGet("iToolsADB")
	If FileExists($adbPath & "adb.exe") = 0 Then ; work-a-round
		Local $ADBLocation = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\ThinkSky\iToolsAVM", "ADBLocation")
		If @error = 0 And FileExists($ADBLocation & "\adb.exe") = 1 Then
			$adbPath = $ADBLocation
		Else
			Local $DisplayIcon = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\ThinkSky\iToolsAVM", "DisplayIcon")
			If @error = 0 Then
				Local $iLastBS = StringInStr($DisplayIcon, "", 0, -1)
				$adbPath = StringLeft($DisplayIcon, $iLastBS)
				If StringLeft($adbPath, 1) = """" Then $adbPath = StringMid($adbPath, 2) & "\tools"
			Else
				$adbPath = @ProgramFilesDir & "\ThinkSky\iToolsAVM\tools"
				SetError(0, 0, 0)
			EndIf
		EndIf
	EndIf
	$adbPath &= "\adb.exe"
	$adbPath = StringReplace($adbPath, "\\", "\")
	Return $adbPath
EndFunc   ;==>GetiToolsAdbPath

Func GetiToolsBackgroundMode()
	Local $iDirectX = $g_iAndroidBackgroundModeDirectX
	Local $iOpenGL = $g_iAndroidBackgroundModeOpenGL

	; get OpenGL/DirectX config
	Local $graphics_render_mode = $g_iAndroidBackgroundModeDirectX = 1 ? 2 : 1
	If @error = 0 Then
		SetDebugLog($g_sAndroidEmulator & " instance " & $g_sAndroidInstance & " rendering mode is " & $graphics_render_mode)
		Switch $graphics_render_mode
			Case "1" ; OpenGL
				Return $iOpenGL
			Case "2" ; DirectX
				Return $iDirectX
			Case Else ; fallback to OpenGL
				Return $iOpenGL
		EndSwitch
	EndIf

	; fallback to OpenGL
	Return $iOpenGL
EndFunc   ;==>GetiToolsBackgroundMode

Func InitiTools($bCheckOnly = False)
	Local $process_killed, $aRegExResult, $g_sAndroidAdbDeviceHost, $g_sAndroidAdbDevicePort, $oops = 0
	Local $iToolsVersion = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\ThinkSky\iToolsAVM\", "DisplayVersion")
	SetError(0, 0, 0)
	; Could also read iTools paths from environment variables iToolsPath and VBOX_MSI_INSTALL_PATH
	Local $iTools_Path = GetiToolsPath()
	Local $adbPath = GetiToolsAdbPath()
	Local $iTools_Manage_Path = EnvGet("VBOX_MSI_INSTALL_PATH") & "VboxManage.exe"
	If FileExists($iTools_Manage_Path) = 0 Then ; work-a-round
		Local $VirtualBox_Path = RegRead($g_sHKLM & "\SOFTWARE\Oracle\VirtualBox\", "InstallDir")
		If @error = 0 And FileExists($VirtualBox_Path & "VboxManage.exe") = 1 Then
			$iTools_Manage_Path = $VirtualBox_Path & "VBoxManage.exe"
		Else
			$VirtualBox_Path = @ProgramFilesDir & "\Oracle\VirtualBox\"
			SetError(0, 0, 0)
			$VirtualBox_Path = StringReplace($VirtualBox_Path, "\\", "\")
			$iTools_Manage_Path = $VirtualBox_Path & "VBoxManage.exe"
		EndIf
	EndIf

	Local $TempiToolsPath = $iTools_Path & "\iToolsAVM.exe"
	$TempiToolsPath = StringReplace($TempiToolsPath, "\\", "\")

	If FileExists($TempiToolsPath) = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($iTools_Path & "iToolsAVM.exe", $COLOR_ERROR)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	Local $sPreferredADB = FindPreferredAdbPath()
	If $sPreferredADB = "" And FileExists($adbPath) = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($adbPath & "adb.exe", $COLOR_ERROR)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	If FileExists($iTools_Manage_Path) = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find VboxManage:", $COLOR_ERROR)
			SetLog($iTools_Manage_Path, $COLOR_ERROR)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	; Read ADB host and Port
	If Not $bCheckOnly Then
		InitAndroidConfig(True) ; Restore default config
		If Not GetAndroidVMinfo($__VBoxVMinfo, $iTools_Manage_Path) Then Return False
		; update global variables
		$g_sAndroidProgramPath = $iTools_Path & "\iToolsAVM.exe"
		$g_sAndroidProgramPath = StringReplace($g_sAndroidProgramPath, "\\", "\")
		$g_sAndroidAdbPath = $sPreferredADB
		If $g_sAndroidAdbPath = "" Then $g_sAndroidAdbPath = $adbPath
		$g_sAndroidVersion = $iToolsVersion
		$__iTools_Path = $iTools_Path
		$g_sAndroidPath = $__iTools_Path
		$__VBoxManage_Path = $iTools_Manage_Path
		$aRegExResult = StringRegExp($__VBoxVMinfo, "name = ADB_PORT.*host ip = ([^,]+),", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$g_sAndroidAdbDeviceHost = $aRegExResult[0]
			If $g_bDebugAndroid Then SetDebugLog("Func LaunchConsole: Read $g_sAndroidAdbDeviceHost = " & $g_sAndroidAdbDeviceHost, $COLOR_DEBUG)
		Else
			$oops = 1
			SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Host", $COLOR_ERROR)
		EndIf

		$aRegExResult = StringRegExp($__VBoxVMinfo, "name = ADB_PORT.*host port = (\d{3,5}),", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$g_sAndroidAdbDevicePort = $aRegExResult[0]
			If $g_bDebugAndroid Then SetDebugLog("Func LaunchConsole: Read $g_sAndroidAdbDevicePort = " & $g_sAndroidAdbDevicePort, $COLOR_DEBUG)
		Else
			$oops = 1
			SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Port", $COLOR_ERROR)
		EndIf

		If $oops = 0 Then
			$g_sAndroidAdbDevice = $g_sAndroidAdbDeviceHost & ":" & $g_sAndroidAdbDevicePort
		Else ; use defaults
			SetLog("Using ADB default device " & $g_sAndroidAdbDevice & " for " & $g_sAndroidEmulator, $COLOR_ERROR)
		EndIf

		; get screencap paths: Name: 'picture', Host path: 'C:\Users\Public\Pictures\iTools Photo' (machine mapping), writable
		$g_sAndroidPicturesPath = "/mnt/shared/picture/"
		$aRegExResult = StringRegExp($__VBoxVMinfo, "Name: 'picture', Host path: '(.*)'.*", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$g_sAndroidPicturesHostPath = $aRegExResult[0] & "\"
			If Not FileExists($g_sAndroidPicturesHostPath) Then DirCreate($g_sAndroidPicturesHostPath)
		Else
			$oops = 1
			$g_bAndroidAdbScreencap = False
			$g_sAndroidPicturesHostPath = ""
			SetLog($g_sAndroidEmulator & " Minimize Mode is not available", $COLOR_DEBUG)
		EndIf

		$__VBoxGuestProperties = LaunchConsole($__VBoxManage_Path, "guestproperty enumerate " & $g_sAndroidInstance, $process_killed)
	EndIf

	Return SetError($oops, 0, True)

EndFunc   ;==>InitiTools

Func SetScreeniTools()

	If Not InitAndroid() Then Return False

	Local $cmdOutput, $process_killed

	; Set width and height
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_graph_mode " & $g_iAndroidClientWidth & "x" & $g_iAndroidClientHeight & "-16", $process_killed)

	; Set dpi
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_dpi 160", $process_killed)

	Return True

EndFunc   ;==>SetScreeniTools

Func RebootiToolsSetScreen()

	Return RebootAndroidSetScreenDefault()

EndFunc   ;==>RebootiToolsSetScreen

Func CloseiTools()

	Return CloseVboxAndroidSvc()

EndFunc   ;==>CloseiTools

Func CheckScreeniTools($bSetLog = True)

	If Not InitAndroid() Then Return False

	Local $aValues[2][2] = [ _
			["vbox_dpi", "160"], _
			["vbox_graph_mode", $g_iAndroidClientWidth & "x" & $g_iAndroidClientHeight & "-16"] _
			]
	Local $i, $Value, $iErrCnt = 0, $process_killed, $aRegExResult

	For $i = 0 To UBound($aValues) - 1
		$aRegExResult = StringRegExp($__VBoxGuestProperties, "Name: " & $aValues[$i][0] & ", value: (.+), timestamp:", $STR_REGEXPARRAYMATCH)
		If @error = 0 Then $Value = $aRegExResult[0]
		If $Value <> $aValues[$i][1] Then
			If $iErrCnt = 0 Then
				If $bSetLog Then
					SetLog("MultiBot doesn't work with " & $g_sAndroidEmulator & " screen configuration!", $COLOR_ERROR)
				Else
					SetDebugLog("MultiBot doesn't work with " & $g_sAndroidEmulator & " screen configuration!", $COLOR_ERROR)
				EndIf
			EndIf
			If $bSetLog Then
				SetLog("Setting of " & $aValues[$i][0] & " is " & $Value & " and will be changed to " & $aValues[$i][1], $COLOR_ERROR)
			Else
				SetDebugLog("Setting of " & $aValues[$i][0] & " is " & $Value & " and will be changed to " & $aValues[$i][1], $COLOR_ERROR)
			EndIf
			$iErrCnt += 1
		EndIf
	Next
	If $iErrCnt > 0 Then Return False
	Return True

EndFunc   ;==>CheckScreeniTools

Func HideiToolsWindow($bHide = True, $hHWndAfter = Default)
	Return EmbediTools($bHide, $hHWndAfter)
EndFunc   ;==>HideiToolsWindow

Func EmbediTools($bEmbed = Default, $hHWndAfter = Default)

	If $bEmbed = Default Then $bEmbed = $g_bAndroidEmbedded
	If $hHWndAfter = Default Then $hHWndAfter = $HWND_TOPMOST

	; Find QTool Parent Window
	Local $aWin = _WinAPI_EnumProcessWindows(GetAndroidPid(), False)
	Local $i
	Local $hToolbar = 0
	Local $hAddition = []

	For $i = 1 To UBound($aWin) - 1
		Local $h = $aWin[$i][0]
		Local $c = $aWin[$i][1]
		If $c = "CHWindow" Then
			Local $aPos = WinGetPos($h)
			If UBound($aPos) > 2 Then
				If ($aPos[2] = 38 Or $aPos[2] = 21) Then
					; found toolbar
					$hToolbar = $h
				EndIf
				If $aPos[2] = 10 Or $aPos[3] = 10 Then
					; found additional window to hide
					ReDim $hAddition[UBound($hAddition) + 1]
					$hAddition[UBound($hAddition) - 1] = $h
				EndIf
			EndIf
		EndIf
	Next

	If $hToolbar = 0 Then
		SetDebugLog("EmbediTools(" & $bEmbed & "): toolbar Window not found, list of windows:" & $c, Default, True)
		For $i = 1 To UBound($aWin) - 1
			Local $h = $aWin[$i][0]
			Local $c = $aWin[$i][1]
			SetDebugLog("EmbediTools(" & $bEmbed & "): Handle = " & $h & ", Class = " & $c, Default, True)
		Next
	Else
		SetDebugLog("EmbediTools(" & $bEmbed & "): $hToolbar=" & $hToolbar, Default, True)
		If $bEmbed Then WinMove2($hToolbar, "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
		_WinAPI_ShowWindow($hToolbar, ($bEmbed ? @SW_HIDE : @SW_SHOWNOACTIVATE))
		If Not $bEmbed Then
			WinMove2($hToolbar, "", -1, -1, -1, -1, $hHWndAfter, 0, False)
			If $hHWndAfter = $HWND_TOPMOST Then WinMove2($hToolbar, "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
		EndIf
		For $i = 0 To UBound($hAddition) - 1
			If $bEmbed Then WinMove2($hAddition[$i], "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
			_WinAPI_ShowWindow($hAddition[$i], ($bEmbed ? @SW_HIDE : @SW_SHOWNOACTIVATE))
			If Not $bEmbed Then
				WinMove2($hAddition[$i], "", -1, -1, -1, -1, $hHWndAfter, 0, False)
				If $hHWndAfter = $HWND_TOPMOST Then WinMove2($hAddition[$i], "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
			EndIf
		Next
	EndIf

EndFunc   ;==>EmbediTools
