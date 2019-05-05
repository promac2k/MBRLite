; #FUNCTION# ====================================================================================================================
; Name ..........: GetPixelSide
; Description ...:
; Syntax ........: GetPixelSide($listPixel, $index)
; Parameters ....: $listPixel           - an unknown value.
;                  $index               - an integer value.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func GetPixelSide($listPixel, $index)
	If $g_bDebugSetlog Then SetDebugLog("GetPixelSide " & $index & " = " & StringReplace($listPixel[$index], "-", ","))
	Return GetListPixel($listPixel[$index])
EndFunc   ;==>GetPixelSide
