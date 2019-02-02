; #FUNCTION# ====================================================================================================================
; Name ..........: FindAButton.au3
; Description ...: Find a specific button; Grouped non-generic functions
; Syntax ........: None
; Parameters ....:
; Return values .: None
; Author ........: MMHK (11-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func FindExitButton($sButtonName)
	Local $aCoor
	Local $sDirectory = "exitbutton-bundle"
	Local $sReturnProps = "objectpoints"
	Local $result = ""
	Local $aPosXY = ""

	$aCoor = StringSplit(GetButtonRectangle($sButtonName), ",", $STR_NOCOUNT)
	_CaptureRegion2($aCoor[0], $aCoor[1], $aCoor[2], $aCoor[3])
	$result = findMultiple($sDirectory ,"FV" ,"FV", 0, 0, 1 , $sReturnProps, False)

	If IsArray($result) then
		$aPosXY = StringSplit(($result[0])[0], ",", $STR_NOCOUNT)
		$aPosXY[0] += $aCoor[0]
		$aPosXY[1] += $aCoor[1]
		If $g_bDebugSetlog Then SetDebugLog("FindExitButton: " & $sButtonName & " Button X|Y = " & $aPosXY[0] & "|" & $aPosXY[1], $COLOR_DEBUG)
		Return $aPosXY
	EndIf

	If $g_bDebugSetlog Then SetDebugLog("FindExitButton: " & $sButtonName & " NOT Found" , $COLOR_DEBUG)
	Return $aPosXY
EndFunc   ;==>FindExitButton

Func FindAdsXButton()
	Local $sCoor
	Local $sDirectory = "adsxbutton-bundle"
	Local $sReturnProps = "objectpoints"
	Local $result = ""
	Local $aPosXY = ""

	$sCoor = GetDiamondFromRect(GetButtonRectangle("AdsX"))
	$result = findMultiple($sDirectory, $sCoor, $sCoor, 0, 0, 1, $sReturnProps, False)

	If IsArray($result) then
		$aPosXY = StringSplit(($result[0])[0], ",", $STR_NOCOUNT)
		If $g_bDebugSetlog Then SetDebugLog("FindAdsXButton: " & $g_sAndroidGameDistributor & " AdsX Button X|Y = " & $aPosXY[0] & "|" & $aPosXY[1], $COLOR_DEBUG)
		Return $aPosXY
	EndIf

	If $g_bDebugSetlog Then SetDebugLog("FindAdsXButton: " & $g_sAndroidGameDistributor & " NOT Found", $COLOR_DEBUG)
	Return $aPosXY
EndFunc   ;==>FindAdsXButton

Func GetButtonRectangle($sButtonName)
	Local $btnRectangle = "0,0," & $g_iGAME_WIDTH & "," & $g_iGAME_HEIGHT

	Switch $sButtonName
		Case "Kunlun", "Huawei", "Kaopu", "Microvirt", "Yeshen"
			$btnRectangle = GetDummyRectangle("345,350", 10) ; RC Done
		Case "Qihoo"
			$btnRectangle = GetDummyRectangle("302,412", 10) ; RC Done
		Case "Baidu"
			$btnRectangle = GetDummyRectangle("464,382", 10) ; RC Done
		Case "OPPO"
			$btnRectangle = GetDummyRectangle("476,368", 10) ; RC Done
		Case "Anzhi"
			$btnRectangle = GetDummyRectangle("328,327", 10) ; RC Done
		Case "Lenovo"
			$btnRectangle = GetDummyRectangle("477,432", 10) ; RC Done
		Case "Aiyouxi"
			$btnRectangle = GetDummyRectangle("468,348", 10) ; RC Done
		Case "9game"
			$btnRectangle = "349,308,369,392" ; RC Done ; 359,362 -- 359,406 + offset 10 + Y 20 counter the moving button
		Case "VIVO", "Xiaomi"
			$btnRectangle = GetDummyRectangle("353,343", 10) ; RC Done
		Case "Guopan"
			$btnRectangle = GetDummyRectangle("409,396", 10) ; RC Done
		Case "AdsX"
			$btnRectangle = ($g_iGAME_WIDTH / 2) & ",0," & $g_iGAME_WIDTH & "," & ($g_iGAME_HEIGHT / 2) ; upper right area of screen
		Case Else
			$btnRectangle = "0,0," & $g_iGAME_WIDTH & "," & $g_iGAME_HEIGHT ; use full image to locate button
	EndSwitch

	Return $btnRectangle
EndFunc   ;==>GetButtonRectangle
