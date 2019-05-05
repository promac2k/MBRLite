; #FUNCTION# ====================================================================================================================
; Name ..........: CheckVersion
; Description ...: Check and autoupdate MultiBotRun to latest version
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: IceCube (2018-2019)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
#include-once

Func CheckBotVersion()
	If FileExists(@ScriptDir & "\VERSION.txt") Then
		Local $file = FileOpen(@ScriptDir & "\VERSION.txt", 0)
		Local $line = FileReadLine($file)
		If @error = 0 Then 
			SetLog(GetTranslatedFileIni("AutoUpdate", "Msg_AutoUpdate_09", "Version detected"), $COLOR_INFO)
			SetLog($line, $COLOR_INFO)
		EndIf
		FileClose($file)
	EndIf
	If $g_hChkForMBRUpdates Then
		SetDebugLog("MultiBotRun Version Check start")
		If FileExists(@ScriptDir & "\MultiBotRunUpdate.exe") Then
			SetLog(GetTranslatedFileIni("AutoUpdate", "Msg_AutoUpdate_01", "Checking for MultiBotRun version ..."), $COLOR_ACTION)
			SetDebugLog("Starting MultiBotRunUpdate process")
			Local $iPID = Run(@ScriptDir & "\MultiBotRunUpdate.exe versioncheck")
			Local $hRun1 = _ProcessGetHandle($iPID)
			ProcessWaitClose($iPID, 300) ;5 minutes max wait
			Local $iExit1 = _ProcessGetExitCode($hRun1)
			SetDebugLog("Exit code: " &  $iExit1)
			If $iExit1 = 125 Then ;New version found
				SetLog(GetTranslatedFileIni("AutoUpdate", "Msg_AutoUpdate_06", "THERE IS A NEW VERSION"), $COLOR_RED)
				SetLog(GetTranslatedFileIni("AutoUpdate", "Msg_AutoUpdate_07", "Please update to latest version"), $COLOR_RED)
				PushMsg("Update")
				;AutoUpdate
				AutoUpdateBOT()
			ElseIf $iExit1 = 126 Then ;No Update found
				SetLog(GetTranslatedFileIni("AutoUpdate", "Msg_AutoUpdate_04", "You are running the latest version of powerful MultiBotRun BOT."), $COLOR_GREEN)
			ElseIf $iExit1 = 0 Then ;Some issue happend
				SetLog(GetTranslatedFileIni("AutoUpdate", "Msg_AutoUpdate_08", "It wasn't possible to verify the version."), $COLOR_RED)
			EndIf
		Else
			SetLog(GetTranslatedFileIni("AutoUpdate", "Msg_AutoUpdate_05", "MultiBotRun Autoupdate engine is missing."), $COLOR_RED)
			SetDebugLog("MultiBotRunUpdate.exe is missing")
		EndIf
	EndIf
EndFunc ;==>CheckBotVersion


Func CheckAutoUpdateBOT()
	;BOT Autoupdate cycle
	If $g_hChkForMBRUpdates And $g_bChkAutoUpdateBOT Then
		SetDebugLog("Autoupdate BOT Cycle start")
		If $g_iAutoUpdateBOTCount =  0 Then
			If FileExists(@ScriptDir & "\MultiBotRunUpdate.exe") Then
				SetLog(GetTranslatedFileIni("AutoUpdate", "Msg_AutoUpdate_01", "Checking for MultiBotRun updates ..."), $COLOR_ACTION)
				SetDebugLog("Starting MultiBotRunUpdate check process")
				Local $iPID = Run(@ScriptDir & "\MultiBotRunUpdate.exe versioncheck")
				Local $hRun1 = _ProcessGetHandle($iPID)
				ProcessWaitClose($iPID, 300) ;5 minutes max wait
				Local $iExit1 = _ProcessGetExitCode($hRun1)
				SetDebugLog("Exit code: " &  $iExit1)
				If $iExit1 = 125 Then ;New version found
					SetLog(GetTranslatedFileIni("AutoUpdate", "Msg_AutoUpdate_06", "THERE IS A NEW VERSION"), $COLOR_RED)
					PushMsg("Update")
					;AutoUpdate
					AutoUpdateBOT()
				EndIf
			Else
				SetLog(GetTranslatedFileIni("AutoUpdate", "Msg_AutoUpdate_05", "MultiBotRun Autoupdate engine is missing."), $COLOR_RED)
				SetDebugLog("MultiBotRunUpdate.exe is missing")
			EndIf
		Else
			$g_iAutoUpdateBOTCount += 1 ;New cycle
			SetDebugLog("Cycle count: " &  $g_iAutoUpdateBOTCount)
			If $g_iAutoUpdateBOTCount >= $g_iAutoUpdateBOTMax Then
				$g_iAutoUpdateBOTCount = 0 ;Its time to check for update next time
				SetDebugLog("Next Cycle, will run an autoupdate check   (" &  $g_iAutoUpdateBOTCount &  "/" & $g_iAutoUpdateBOTMax)
			EndIf
		EndIf
	EndIf
	;BOT Autoupdate cycle
EndFunc ;==>CheckAutoUpdateBOT

Func AutoUpdateBOT()
	;BOT Autoupdate
	If $g_hChkForMBRUpdates And $g_bChkAutoUpdateBOT Then
		If FileExists(@ScriptDir & "\MultiBotRunUpdate.exe") Then
			SetDebugLog("Starting MultiBotRunUpdate AutoUpdate process")
			Local $iPID = Run(@ScriptDir & "\MultiBotRunUpdate.exe autoupdate " & $g_sTxtRegistrationToken)
			Local $hRun1 = _ProcessGetHandle($iPID)
			ProcessWaitClose($iPID, 300) ;5 minutes max wait
			Local $iExit1 = _ProcessGetExitCode($hRun1)
			SetDebugLog("Exit code: " &  $iExit1)
			If $iExit1 = 123 Then ;Autoupdate engine was updated. Will be checked on next cycle
				SetLog(GetTranslatedFileIni("AutoUpdate", "Msg_AutoUpdate_02", "Autoupdate engine was updated. Will be checked on next cycle."), $COLOR_INFO)
				$g_iAutoUpdateBOTCount = 0 ;Its time to check for update next time
			ElseIf $iExit1 = 126 Then ;No Update found
				SetLog(GetTranslatedFileIni("AutoUpdate", "Msg_AutoUpdate_04", "You are running the latest version of powerful MultiBotRun BOT."), $COLOR_GREEN)
				$g_iAutoUpdateBOTCount += 1 ;New cycle
			EndIf
		Else
			SetLog(GetTranslatedFileIni("AutoUpdate", "Msg_AutoUpdate_05", "MultiBotRun Autoupdate engine is missing."), $COLOR_RED)
			SetDebugLog("MultiBotRunUpdate.exe is missing")
		EndIf
	EndIf
	;BOT Autoupdate
EndFunc ;==>AutoUpdateBOT

Func GetVersionNormalized($VersionString, $Chars = 5)
	If StringLeft($VersionString, 1) = "v" Then $VersionString = StringMid($VersionString, 2)
	Local $a = StringSplit($VersionString, ".", 2)
	Local $i
	For $i = 0 To UBound($a) - 1
		If StringLen($a[$i]) < $Chars Then $a[$i] = _StringRepeat("0", $Chars - StringLen($a[$i])) & $a[$i]
	Next
	Return _ArrayToString($a, ".")
EndFunc   ;==>GetVersionNormalized