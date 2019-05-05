; #FUNCTION# ====================================================================================================================
; Name ..........: ConvertOCRTime
; Description ...: This function will update the statistics in the GUI.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Boju (11-2016)
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......:
; ===============================================================================================================================

Func ConvertOCRTime($WhereRead, $ToConvert, $bSetLog = True, $bResultInSec = False)
	Local $iRemainTimer = 0, $aResult, $iDay = 0, $iHour = 0, $iMinute = 0, $iSecond = 0

	If $ToConvert <> "" Then
		If StringInStr($ToConvert, "d") > 1 Then
			$aResult = StringSplit($ToConvert, "d", $STR_NOCOUNT)
			; $aResult[0] will be the Day and the $aResult[1] will be the rest
			$iDay = Number($aResult[0])
			$ToConvert = $aResult[1]
		EndIf
		If StringInStr($ToConvert, "h") > 1 Then
			$aResult = StringSplit($ToConvert, "h", $STR_NOCOUNT)
			$iHour = Number($aResult[0])
			$ToConvert = $aResult[1]
		EndIf
		If StringInStr($ToConvert, "m") > 1 Then
			$aResult = StringSplit($ToConvert, "m", $STR_NOCOUNT)
			$iMinute = Number($aResult[0])
			$ToConvert = $aResult[1]
		EndIf
		If StringInStr($ToConvert, "s") > 1 Then
			$aResult = StringSplit($ToConvert, "s", $STR_NOCOUNT)
			$iSecond = Number($aResult[0])
			;When $ToConvert=0s Happens in getPBTime when Guard is over it shows 0s in that case return 1 sec so Bot go to PB otherwise bot goes in attack
			If $iSecond = 0 And $ToConvert = "0s" Then $iSecond = 1
		EndIf

		If Not $bResultInSec Then
			;Return Result In Minutes
			$iRemainTimer = Round($iDay * 24 * 60 + $iHour * 60 + $iMinute + $iSecond / 60, 0)
			If $bSetLog Or $g_bDebugSetlog And $iRemainTimer > 0 Then SetDebugLog($WhereRead & " time: " & StringFormat("%.2f", $iRemainTimer) & " min", $COLOR_INFO)
		Else
			;Return Result In Seconds
			$iRemainTimer = $iDay * 24 * 60 * 60 + $iHour * 60 * 60 + $iMinute * 60 + $iSecond
			If $bSetLog Or $g_bDebugSetlog And $iRemainTimer > 0 Then SetDebugLog($WhereRead & " time: " & $iRemainTimer & " sec", $COLOR_INFO)
		EndIf

		If $iRemainTimer = 0 And $g_bDebugSetlog Then SetDebugLog($WhereRead & ": Bad OCR string ('" & $ToConvert & "')", $COLOR_ERROR)

	Else
		If Not $g_bFullArmySpells Then
			If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetDebugLog("Can not read remaining time for " & $WhereRead, $COLOR_ERROR)
		EndIf
	EndIf
	Return $iRemainTimer
EndFunc   ;==>ConvertOCRTime
