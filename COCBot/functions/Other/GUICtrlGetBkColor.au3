; #FUNCTION# ====================================================================================================================
; Name ..........: GUICtrlGetBkColor
; Description ...: Retrieves the RGB value of the control background.
; Syntax ........: GUICtrlGetBkColor($hWnd)
; Parameters ....: $hWnd                - Control ID/Handle to the control
; Return values .: Success - RGB value
;                  Failure - 0
; Author ........: guinness
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func GUICtrlGetBkColor($hWnd)
	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
	EndIf
	Local $hDC = _WinAPI_GetDC($hWnd)
	Local $iColor = _WinAPI_GetPixel($hDC, 0, 0)
	_WinAPI_ReleaseDC($hWnd, $hDC)
	Return $iColor
EndFunc   ;==>GUICtrlGetBkColor
