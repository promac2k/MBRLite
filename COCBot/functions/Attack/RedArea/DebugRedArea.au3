; #FUNCTION# ====================================================================================================================
; Name ..........: debugRedArea
; Description ...:
; Syntax ........: debugRedArea($string)
; Parameters ....: $string              - a string value.
; Return values .: None
; Author ........: didipe
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func debugRedArea($string)
	If $g_bDebugRedArea Then
		Local $hFile = FileOpen($g_sProfileLogsPath & "debugRedArea.log", $FO_APPEND)
		_FileWriteLog($hFile, $string)
		FileClose($hFile)
	EndIf
EndFunc   ;==>debugRedArea
