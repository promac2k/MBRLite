; #FUNCTION# ====================================================================================================================
; Name ..........: CheckZoomOut
; Description ...:
; Syntax ........: CheckZoomOut()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #12
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func CheckZoomOut($sSource = "CheckZoomOut", $bCheckOnly = False, $bForecCapture = True)
	; SearchZoomOut($aCenterHomeVillageClickDrag, $UpdateMyVillage = True, $sSource = "SearchZoomOut", $CaptureRegion = True, $DebugLog = False, $debugwithImage = False)
	Local $aVillageResult = SearchZoomOut(False, True, $sSource, $bForecCapture, $g_bDebugGetVillageSize, $g_bDebugGetVillageSize)
	If IsArray($aVillageResult) = 0 Or $aVillageResult[0] = "" Then
		; not zoomed out, Return
		If $bCheckOnly = False Then
			SetLog("Not Zoomed Out! Exiting to MainScreen...", $COLOR_ERROR)
			For $i = 0 To 10
				If checkMainScreen() Then ExitLoop ;exit battle screen
				If $i = 10 Or isProblemAffect(True) Or checkObstacles_Network(True, True) Then
					SetLog("CheckZoomOut - Cannot return home.", $COLOR_ERROR)
					checkObstacles_ReloadCoC()
				EndIf
				If _sleep($DELAYRETURNHOME1) Then ExitLoop
			Next
			$g_bRestart = True ; Restart Attack
			$g_bIsClientSyncError = True ; quick restart
		EndIf
		Return False
	EndIf
	Return True
EndFunc   ;==>CheckZoomOut
