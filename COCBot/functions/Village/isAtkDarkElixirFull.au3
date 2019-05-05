; #FUNCTION# ====================================================================================================================
; Name ..........: isAtkDarkElixirFull
; Description ...: Checks if your Gold Storages are maxed out
; Syntax ........: isAtkDarkElixirFull()
; Parameters ....:
; Return values .: True or False
; Author ........: Code Monkey #57 (send more bananas please!)
; Modified ......: MonkeyHunter (2015-12), Boju 04-2017
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================

Func isAtkDarkElixirFull()
	If isAttackPage() And _CheckPixel($aIsAtkDarkElixirFull, $g_bCapturePixel) Then ;Check for black/purple pixel in full bar
 		SetLog("Dark Elixir Storages is full!", $COLOR_SUCCESS)
 		Return True
	EndIf
	Return False
EndFunc   ;==>isAtkDarkElixirFull
