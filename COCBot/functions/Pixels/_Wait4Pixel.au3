; #FUNCTION# ====================================================================================================================
; Name ..........: _Wait4Pixel
; Description ...:
; Author ........: Samkie, ProMac
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Samkie Method
Func _Wait4Pixel($x, $y, $sColor, $iColorVariation, $iWait = 1000, $sMsglog = Default, $iDelay = 100)
	Local $hTimer = __TimerInit()
	Local $iMaxCount = Int($iWait / $iDelay)
	Local $aTemp[4] = [$x, $y, $sColor, $iColorVariation]
	For $i = 1 To $iMaxCount
		;ForceCaptureRegion()
		If _CheckPixel($aTemp, $g_bCapturePixel, Default, $sMsglog) Then Return True
		If _Sleep($iDelay) Then Return False
		If __TimerDiff($hTimer) >= $iWait Then ExitLoop
	Next
	Return False
EndFunc   ;==>_Wait4Pixel

; Samkie Method
Func _Wait4PixelGone($x, $y, $sColor, $iColorVariation, $iWait = 1000, $sMsglog = Default, $iDelay = 100)
	Local $hTimer = __TimerInit()
	Local $iMaxCount = Int($iWait / $iDelay)
	Local $aTemp[4] = [$x, $y, $sColor, $iColorVariation]
	For $i = 1 To $iMaxCount
		;ForceCaptureRegion()
		If Not _CheckPixel($aTemp, $g_bCapturePixel, Default, $sMsglog) Then Return True
		If _Sleep($iDelay) Then Return False
		If __TimerDiff($hTimer) >= $iWait Then ExitLoop
	Next
	Return False
EndFunc   ;==>_Wait4PixelGone


; Old Methods from Mybot
Func _WaitForCheckPixel($aScreenCode, $bNeedCapture = Default, $Ignore = Default, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default, $iWaitLoop = Default)
	If $iWaitLoop = Default Then $iWaitLoop = 250 ; if default wait time per loop, then wait 250ms
	Local $wCount = 0
	While _CheckPixel($aScreenCode, $bNeedCapture, $Ignore, $sLogText, $LogTextColor, $bSilentSetLog) = False
		If _Sleep($iWaitLoop) Then Return
		$wCount += 1
		If $wCount > 20 Then ; wait for 20*250ms=5 seconds for pixel to appear
			SetLog($sLogText & " not found!", $COLOR_ERROR)
			Return False
		EndIf
	WEnd
	Return True
EndFunc   ;==>_WaitForCheckPixel

; Old Methods from Mybot - ProMac
Func WaitforPixel($iLeft, $iTop, $iRight, $iBottom, $firstColor, $iColorVariation, $maxDelay = 10) ; $maxDelay is in 1/2 second
	For $i = 1 To $maxDelay * 10
		Local $result = _PixelSearch($iLeft, $iTop, $iRight, $iBottom, $firstColor, $iColorVariation)
		If IsArray($result) Then Return True
		If _Sleep(50) Then Return
	Next
	Return False
EndFunc   ;==>WaitforPixel


; New Method using new Image detetion - ProMac
Func _WaitForCheckXML($pathImage, $SearchZone, $ForceArea = True, $iWait = 10000, $iDelay = 250)
	Local $Timer = __TimerInit()
	Local $DebugWait4XMLImag = ($g_bDebugSetlog Or $g_bDebugImageSave) ? True : False
	For $i = 0 To 600 ; if detection takes 100ms will be >60s + delay's
		If __TimerDiff($Timer) > $iWait Then ExitLoop
		Local $a_Array = _ImageSearchXMLMultibot($pathImage, 1000, $SearchZone, $ForceArea, $DebugWait4XMLImag)
		If $a_Array <> -1 And IsArray($a_Array) And UBound($a_Array) > 0 And $a_Array[0][0] <> "" Then
			If $DebugWait4XMLImag Then SetDebugLog("_WaitForCheckXML found " & $a_Array[0][0] & " at (" & $a_Array[0][1] & "x" & $a_Array[0][2] & ")")
			Return True
		EndIf
		If _Sleep($iDelay) Then ExitLoop
	Next
	If $DebugWait4XMLImag Then SetDebugLog("_WaitForCheckXML not found at " & $SearchZone, $COLOR_ERROR)
	Return False
EndFunc   ;==>_WaitForCheckXML
