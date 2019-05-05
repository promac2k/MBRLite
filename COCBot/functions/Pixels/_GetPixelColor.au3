
; #FUNCTION# ====================================================================================================================
; Name ..........: _GetPixelColor
; Description ...: Returns color of pixel in the coordinations
; Syntax ........: _GetPixelColor($iX, $iY[, $bNeedCapture = False])
; Parameters ....: $iX                  - x location.
;                  $iY                  - y location.
;                  $bNeedCapture        - [optional] a boolean flag to get new screen capture
;                  $sLogText            - [optional] a string value for text of log message. Default is Default.
;                  $LogTextColor        - [optional] an integer value for log text color. Default is Default.
;                  $bSilentSetLog       - [optional] a boolean value to suppress user log of text. Default is Default.
; Return values .: None
; Author ........:
; Modified ......: MonkeyHunter (08-2015)
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================

Func _GetPixelColor($iX, $iY, $bNeedCapture = False, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default)
	Local $aPixelColor = 0

	If $iY < 0 Or $iY > $g_iGAME_HEIGHT Or $iX < 0 Or $iX > $g_iGAME_WIDTH Then
		SetLog($sLogText & " Requested X:" & $iX & " Or Y:" & $iY & " Is Outside 860x644 Cords, Please FIX Cords", $COLOR_ERROR)
	Else
		If Not $bNeedCapture Or Not $g_bRunState Then
			$aPixelColor = _GDIPlus_BitmapGetPixel($g_hBitmap, $iX, $iY)
		Else
			;Correct Values Just In Case If x,y=0 or x=$g_iGAME_WIDTH,$g_iGAME_HEIGHT there plus or subtract can be -1 or exceed Width/Height To Avoid Any issue
			If $iX - 1 < 0 Then $iX += 1
			If $iY - 1 < 0 Then $iY += 1
			If $iX + 1 > $g_iGAME_WIDTH Then $iX -= 1
			If $iY + 1 > $g_iGAME_HEIGHT Then $iY -= 1
			_CaptureRegion($iX - 1, $iY - 1, $iX + 1, $iY + 1)
			$aPixelColor = _GDIPlus_BitmapGetPixel($g_hBitmap, 1, 1)
		EndIf
		If $sLogText <> Default And IsString($sLogText) Then
			Local $String = $sLogText & " at X,Y: " & $iX & "," & $iY & " Found: " & Hex($aPixelColor, 6)
			SetDebugLog($String, $LogTextColor, $bSilentSetLog)
		EndIf
	EndIf
	Return Hex($aPixelColor, 6)
EndFunc   ;==>_GetPixelColor

Func IsPixelColorGray($sPixelColorRgbHex)
	If StringLen($sPixelColorRgbHex) <> 6 Then Return False
	Local $sRed = StringLeft($sPixelColorRgbHex, 2)
	Local $sBlue = StringRight($sPixelColorRgbHex, 2)
	Return $sRed = $sBlue And $sRed = StringMid($sPixelColorRgbHex, 3, 2)
EndFunc   ;==>IsPixelColorGray
