; #FUNCTION# ====================================================================================================================
; Name ..........: ReArm.au3
; Description ...: Rearms and reloads traps that have been triggered.
; Syntax ........: ReArm()
; Parameters ....:
; Return values .:
; Authors .......: Saviart, Hervidero
; Modified ......: Hervidero, ProMac, KnowJack (05-2015), Sardo (08-2015) , ProMac (01-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func btnTestRearm()
	SetLog("Test ReArm/Tombs Started", $COLOR_DEBUG)

	Local $wasRunState = $g_bRunState
	Local $wasbTrap = $g_bChkTrap
	Local $wasbTombstones = $g_bChkTombstones
	Local $wasNotNeedAllTime1 = $g_abIsToProccedWith[0]
	Local $wasNotNeedAllTime2 = $g_abIsToProccedWith[1]
	;For Debug Purpose set these values temporarily
	$g_bRunState = True
	$g_bChkTrap = True
	$g_bChkTombstones = True
	$g_abIsToProccedWith[0] = True
	$g_abIsToProccedWith[1] = True
	_GUICtrlTab_ClickTab($g_hTabMain, 0)
	checkMainScreen()
	ReArm()
	CheckTombs()
	;Reset to orignal state
	$g_bRunState = $wasRunState
	$g_bChkTrap = $wasbTrap
	$g_bChkTombstones = $wasbTombstones
	$g_abIsToProccedWith[0] = $wasNotNeedAllTime1
	$g_abIsToProccedWith[1] = $wasNotNeedAllTime2

	SetLog("Test ReArm/Tombs Ended", $COLOR_DEBUG)
EndFunc   ;==>btnTestRearm

Func ReArm()

	If Not $g_bChkTrap Then Return ; If re-arm is not enable in GUI return and skip this code
	If Not $g_abIsToProccedWith[0] Then
		If $g_bDebugSetlog Then SetDebugLog("Village Don't Need Re-Arm. Skipping It!", $COLOR_DEBUG)
		Return
	EndIf

	SetLog("Checking if Village needs Rearming..", $COLOR_INFO)

	Local $bIsTownhallFound = VerifyAndClickTownHall()

	If $bIsTownhallFound Then

		Local $bReArmed = False
		Local $sDiamond = GetButtonDiamond("Rearm")
		Local $aTempArray, $aTempBtnCoords
		Local $aRearmedAlready[1] = ["None"] ;None is a dummy value
		Local $aRearmOptions = findMultiple($g_sImgRearm, $sDiamond, $sDiamond, 0, 1000, 3, "objectname,objectpoints", True)

		If $aRearmOptions <> "" And IsArray($aRearmOptions) Then
			For $i = 0 To UBound($aRearmOptions, $UBOUND_ROWS) - 1
				$aTempArray = $aRearmOptions[$i]
				SetDebugLog("Rearm() $aRearmOptions[" & $i & "]: " & _ArrayToString($aTempArray))
				If UBound($aTempArray) >= 2 Then
					If _ArraySearch($aRearmedAlready, $aTempArray[0]) <> -1 Then ContinueLoop
					$aTempBtnCoords = StringSplit($aTempArray[1], ",", $STR_NOCOUNT)
					If IsMainPage() Then ClickP($aTempBtnCoords, 1, 0, "#0330")
					If _Sleep($DELAYREARM1) Then Return
					Click(515, 400, 1, 0, "#0226")
					If _Sleep($DELAYREARM4) Then Return
					If isGemOpen(True) Then
						SetLog("Not enough loot to rearm traps.....", $COLOR_ERROR)
						Click(585, 252, 1, 0, "#0227") ; Click close gem window "X"
						If _Sleep($DELAYREARM1) Then Return
					Else
						Local $sVerb = StringInStr($aTempArray[0], "Trap") ? "Rearmed" : "Reloaded"
						SetLog($sVerb & " " & $aTempArray[0] & "(s)", $COLOR_SUCCESS)
						$g_abIsToProccedWith[0] = False
						$bReArmed = True
						If _Sleep($DELAYREARM1) Then Return
					EndIf
					_ArrayAdd($aRearmedAlready, $aTempArray[0])
				EndIf
			Next
		EndIf

		If Not $bReArmed Then
			SetLog("Rearm not needed!", $COLOR_SUCCESS)
			$g_abIsToProccedWith[0] = False
		EndIf
	Else
		SetLog("Skipping ReArm Due To Townhall Location is wrong.", $COLOR_INFO)
	EndIf

	ClickP($aAway, 1, 0, "#0234") ; Click away
	If _Sleep($DELAYREARM2) Then Return
	checkMainScreen(False) ; check for screen errors while running function

EndFunc   ;==>ReArm
