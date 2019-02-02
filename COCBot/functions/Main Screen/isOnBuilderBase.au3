; #FUNCTION# ====================================================================================================================
; Name ..........: isOnBuilderBase.au3
; Description ...: Check if Bot is currently on Normal Village or on Builder Base
; Syntax ........: isOnBuilderBase($bNeedCaptureRegion = False)
; Parameters ....: $bNeedCaptureRegion
; Return values .: True if is on Builder Base
; Author ........: Fliegerfaust (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $imgPathIsBB = @ScriptDir & "\imgxml\BuildersBase\IsBuilderBase"

Func isOnBuilderBase($bNeedCaptureRegion = False)
	_Sleep($DELAYISBUILDERBASE)

	Local $ImagePath = @ScriptDir & "\imgxml\village\Page\BuilderIsland\"
	If QuickMIS("BC1", $ImagePath, 260, 0, 406, 54, $bNeedCaptureRegion, $g_bDebugSetlog) Then
		If $g_bDebugSetlog Then SetDebugLog("Builder Base Builder detected", $COLOR_DEBUG)
		Return True
	Else
		Return False
	EndIf
EndFunc

Func isOnBuilderIsland2()
	_Sleep($DELAYISBUILDERISLAND)

	If QuickMIS("BC1", $imgPathIsBB, 350, 10, 425, 53, True, False) Then
		If $g_bDebugSetlog Then SetDebugLog("Builder Island detected", $COLOR_DEBUG)
		Return True
	Else
		If $g_bDebugSetlog Then SetDebugLog("No Builder Island detected", $COLOR_DEBUG)
	EndIf
	Return False
EndFunc