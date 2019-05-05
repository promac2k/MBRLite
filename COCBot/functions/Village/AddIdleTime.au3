; #FUNCTION# ====================================================================================================================
; Name ..........: AddIdleTime.au3
; Description ...: Increases the waiting time in the idle phase during training
; Syntax ........: AddIdleTime()
; Parameters ....:
; Return values .: None
; Author ........: Sardo (2916-09)
; Modified ......: Boju (2016-11), MMHK (2017-02)
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func AddIdleTime()
	If $g_bTrainAddRandomDelayEnable = False Then Return
	Local $iTimeToWait
	If $g_iTrainAddRandomDelayMin < $g_iTrainAddRandomDelayMax Then
		$iTimeToWait = Random($g_iTrainAddRandomDelayMin, $g_iTrainAddRandomDelayMax, 1)
	Else
		$iTimeToWait = Random($g_iTrainAddRandomDelayMax, $g_iTrainAddRandomDelayMin, 1)
	EndIf
	SetLog("Waiting, Add random delay of " & $iTimeToWait & " seconds.", $COLOR_INFO)
	If _SleepStatus($iTimeToWait * 1000) Then Return
	_GUICtrlStatusBar_SetTextEx($g_hStatusBar, "")
EndFunc   ;==>AddIdleTime
