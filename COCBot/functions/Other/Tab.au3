; #FUNCTION# ====================================================================================================================
; Name ..........: Tab
; Description ...:
; Syntax ........: Tab($a, $b)
; Parameters ....: $a                   - a string
;                  $b                   - an unknown value
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func Tab($a, $b)
	Local $Tab = ""
	For $i = StringLen($a) To $b Step 1
		$Tab &= " "
	Next
	Return $Tab
EndFunc   ;==>Tab
