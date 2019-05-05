; #FUNCTION# ====================================================================================================================
; Name ..........: StartClockTowerBoost
; Description ...:
; Syntax ........: StartClockTowerBoost($bSwitchToBB = False, $bSwitchToNV = False)
; Parameters ....: $bSwitchToBB: Switch from Normal Village to Builder Base - $bSwitchToNV: Switch back to normal Village after Function ran
; Return values .: None
; Author ........: Fliegerfaust (06-2017), MMHK (07-2017)
; Modified ......:
; Remarks .......: This file is part of MultiBot, previously known as Mybot and ClashGameBot. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
#include-once

Func TestStartClockTowerBoost()
	Setlog("** TestStartClockTowerBoost START**", $COLOR_DEBUG)
	Local $iAvailableAttacksBB = $g_iAvailableAttacksBB
	Local $DebugSetlog = $g_bDebugSetlog
	$g_bDebugSetlog = True
	$g_iAvailableAttacksBB = 2
	Local $Status = $g_bRunState
	$g_bRunState = True
	StartClockTowerBoost()
	$g_iAvailableAttacksBB = $iAvailableAttacksBB
	$g_bDebugSetlog = $DebugSetlog
	$g_bRunState = $Status
	Setlog("** TestStartClockTowerBoost END**", $COLOR_DEBUG)
EndFunc   ;==>TestStartClockTowerBoost

Func StartClockTowerBoost()

	If Not $g_bChkStartClockTowerBoost Then Return
	If Not $g_bRunState Then Return
	Local $result = False

	ClickP($aAway, 1, 0, "#0332")

	If Not isOnBuilderIsland2() Then Return

	FuncEnter(StartClockTowerBoost)

	Local $bCTBoost = True
	If $g_bChkCTBoostBlderBz Then
		getBuilderCount(True, True) ; Update Builder Variables for Builders Base
		If $g_iFreeBuilderCountBB = $g_iTotalBuilderCountBB Then $bCTBoost = False ; Builder is not busy, skip Boost
	ElseIf $g_bChkCTBoostAtkAvailable Then
		If $g_iAvailableAttacksBB = 0 Then $bCTBoost = False ; Attack not avalible, skip Boost
	EndIf

	If Not $bCTBoost And $g_bChkCTBoostBlderBz Then
		SetLog("Skip Clock Tower Boost as no Building is currently under Upgrade!", $COLOR_INFO)
	ElseIf Not $bCTBoost And $g_bChkCTBoostAtkAvailable Then
		SetLog("Skip Clock Tower Boost as no attack available", $COLOR_INFO)
	Else ; Start Boosting
		SetLog("Boosting Clock Tower", $COLOR_INFO)
		If _Sleep($DELAYCOLLECT2) Then Return

		Local $sCTCoords, $aCTCoords, $aCTBoost
		$sCTCoords = findImage("ClockTowerAvailable", $g_sImgStartCTBoost, "FV", 1, True) ; Search for Clock Tower
		If $sCTCoords <> "" Then
			$aCTCoords = StringSplit($sCTCoords, ",", $STR_NOCOUNT)
			$aCTCoords[1] = $aCTCoords[1] + 5 ;Add 5 Pixels To Y-axis Fix For Clock Tower Misclicking walls By This It will Click On Clock Tower Center
			ClickP($aCTCoords)
			If _Sleep($DELAYCLOCKTOWER1) Then Return
			If Not QuickMIS("BC1", $g_sImgPathIsCTBoosted, 200, 500, 200 + 460, 580, True, False) Then ; RC Done
				$aCTBoost = findButton("BoostCT") ; Search for Start Clock Tower Boost Button
				If IsArray($aCTBoost) Then
					ClickP($aCTBoost)
					If _Sleep($DELAYCLOCKTOWER1) Then Return
					$aCTBoost = findButton("BOOSTBtn") ; Search for Boost Button
					If IsArray($aCTBoost) Then
						ClickP($aCTBoost)
						If _Sleep($DELAYCLOCKTOWER2) Then Return
						SetLog("Boosted Clock Tower successfully!", $COLOR_SUCCESS)
						$result = True
					Else
						SetLog("Failed to find the BOOST window button", $COLOR_ERROR)
						$result = False
					EndIf
				Else
					SetLog("Cannot find the Boost Button of Clock Tower", $COLOR_ERROR)
				EndIf
			Else
				SetLog("Clock Tower is already Boosted, Skip It!", $COLOR_INFO)
			EndIf
		Else
			SetLog("Clock Tower boost is not available!")
		EndIf

	EndIf
	ClickP($aAway, 2, 0, "#0329")
	FuncReturn()

	Return $result
EndFunc   ;==>StartClockTowerBoost
