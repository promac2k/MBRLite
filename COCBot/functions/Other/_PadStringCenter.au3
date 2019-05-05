; #FUNCTION# ====================================================================================================================
; Name ..........: _PadStringCenter
; Description ...:
; Syntax ........: _PadStringCenter([$String = ""[, $Width = 50[, $PadChar = "="]]])
; Parameters ....: $String              - [optional] an unknown value. Default is "".
;                  $Width               - [optional] an unknown value. Default is 50.
;                  $PadChar             - [optional] an unknown value. Default is "=".
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func _PadStringCenter($String = "", $Width = 50, $PadChar = "=")

	If $String = "" Then Return ""

	Local $Odd = Mod(($Width - StringLen($String)), 2)
	Local $Count = ($Width - StringLen($String)) / 2
	Local $Pad = ""

	For $i = 0 To $Count - 1
		$Pad &= $PadChar
	Next

	Local $Out = ""
	If $Odd Then
		$Out = $Pad & $String & $Pad & $PadChar ; Odd
	Else
		$Out = $Pad & $String & $Pad ; Even
	EndIf

	Return $Out

EndFunc   ;==>_PadStringCenter
