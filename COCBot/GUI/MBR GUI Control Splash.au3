; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Splash
; Description ...: This file contains utility functions to update the Splash Screen.
; Syntax ........: #include , Global
; Parameters ....:
; Return values .: None
; Author ........: mikemikemikecoc (2016)
; Modified ......: CodeSlinger69 (2017), MonkeyHunter (05-2017)
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: SplashStep("Loading GUI...") Show the splash status
; ===============================================================================================================================
#include-once

Func SplashStep($status, $bIncreaseStep = True)
	If $bIncreaseStep = True Then $g_iSplashCurrentStep += 1

	SetDebugLog("SplashStep " & $g_iSplashCurrentStep & " of " & $g_iSplashTotalSteps & ": " & $status & "(" & Round(__TimerDiff($g_hSplashTimer) / 1000, 2) & " sec)")

	If $g_bDisableSplash Then Return

	GUICtrlSetData($g_hSplashProgress, ($g_iSplashCurrentStep / $g_iSplashTotalSteps) * 100)
	GUICtrlSetData($g_lSplashStatus, $status)

EndFunc   ;==>SplashStep

Func UpdateSplashTitle($title)
	SetDebugLog("UpdateSplashTitle: " & $title)
	If $g_bDisableSplash Then Return
	GUICtrlSetData($g_lSplashTitle, $title)
EndFunc   ;==>UpdateSplashTitle

Func DestroySplashScreen()
	If IsHWnd($g_hSplash) Then GUIDelete($g_hSplash)
	; allow now other bots to launch
	ReleaseMutex($g_hSplashMutex)
	$g_hSplashMutex = 0
EndFunc   ;==>DestroySplashScreen

Func MoveSplashScreen()
	_WinAPI_PostMessage($g_hSplash, $WM_SYSCOMMAND, 0xF012, 0) ; SC_DRAGMOVE = 0xF012
EndFunc   ;==>MoveSplashScreen
