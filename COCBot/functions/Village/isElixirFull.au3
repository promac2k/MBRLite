; #FUNCTION# ====================================================================================================================
; Name ..........: isElixirFull
; Description ...: Checks if your Elixir Storages are maxed out
; Syntax ........: isElixirFull()
; Parameters ....:
; Return values .: True or False
; Author ........: Code Monkey #34 (yes, the good looking one!)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================

Func isElixirFull($CapturePixel = False)
	SetDebugLog("isElixirFull")
	If _CheckPixel($aIsElixirFull, $CapturePixel) Then ;Hex if color of elixir (purple)
		SetLog("Elixir Storages are full!", $COLOR_SUCCESS)
		Return True
	EndIf
	Return False
EndFunc   ;==>isElixirFull
