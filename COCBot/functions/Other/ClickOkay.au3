
; #FUNCTION# ====================================================================================================================
; Name ..........: ClickOkay
; Description ...: checks for window with "Okay" button, and clicks it
; Syntax ........: ClickOkay($FeatureName)
; Parameters ....: $FeatureName         - [optional] String with name of feature calling. Default is "Okay".
; ...............; $bCheckOneTime       - (optional) Boolean flag - only checks for Okay button once
; Return values .: Returns True if button found, if button not found, then returns False and sets @error = 1
; Author ........: MonkeyHunter (2015-12)
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func ClickOkay($FeatureName = "Okay", $bCheckOneTime = False)
	Local $i = 0
	If _Sleep($DELAYSPECIALCLICK1) Then Return False ; Wait for Okay button window

	While 1 ; Wait for window with Okay Button

		If QuickMIS("BC1", $g_sImgImgLocOkay, 440, 280, 590, 480, True, False) Then
			PureClick($g_iQuickMISWOffSetX, $g_iQuickMISWOffSetY, 2, 50, "#0117") ; Click Okay Button
			If $g_bDebugSetlog Then SetDebugLog("Clicked at : " & $g_iQuickMISWOffSetX & "x" & $g_iQuickMISWOffSetY)
			ExitLoop
		EndIf

		If $bCheckOneTime Then Return False ; enable external control of loop count or follow on actions, return false if not clicked
		If $i > 5 Then
			SetLog("Can not find button for " & $FeatureName & ", giving up", $COLOR_ERROR)
			If $g_bDebugImageSave Then DebugImageSave($FeatureName & "_ButtonCheck_")
			SetError(1, @extended, False)
			Return
		EndIf
		$i += 1
		If _Sleep($DELAYSPECIALCLICK3) Then Return False ; improve pause button response
	WEnd
	Return True
EndFunc   ;==>ClickOkay
