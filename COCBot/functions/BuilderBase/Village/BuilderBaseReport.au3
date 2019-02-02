; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseReport()
; Description ...: Make Resources report of Builders Base
; Syntax ........: BuilderBaseReport()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BuilderBaseReport($bBypass = False, $bSetLog = True)
	PureClickP($aAway, 1, 0, "#0319") ;Click Away
	If _Sleep($DELAYVILLAGEREPORT1) Then Return
	FuncEnter(BuilderBaseReport)

	Switch $bBypass
		Case False
			If $bSetLog Then SetLog("Builder Base Report", $COLOR_INFO)
		Case True
			If $bSetLog Then SetLog("Updating Builder Base Resource Values", $COLOR_INFO)
		Case Else
			If $bSetLog Then SetLog("Village Report Error, You have been a BAD programmer!", $COLOR_ERROR)
	EndSwitch

	If Not $bSetLog Then SetLog("Village Report", $COLOR_INFO)

	getBuilderCount($bSetLog, True) ; update builder data
	If _Sleep($DELAYRESPOND) Then Return

	$g_aiCurrentLootBB[$eLootTrophyBB] = getTrophyMainScreen(67, 84)
	$g_aiCurrentLootBB[$eLootGoldBB] = getResourcesMainScreen(705, 23)
	If $g_aiCurrentLootBB[$eLootGoldBB] = "" Then getResourcesBonus(705, 23) ; when reach the full Cap the numbers are bigger
	$g_aiCurrentLootBB[$eLootElixirBB] = getResourcesMainScreen(705, 72)
	If $g_aiCurrentLootBB[$eLootElixirBB] = "" Then getResourcesBonus(705, 72) ; when reach the full Cap the numbers are bigger

	Local $aResult = QuickMIS("CX", $g_sImgAvailableAttacks, 20, 625 + $g_iBottomOffsetYNew, 110, 650 + $g_iBottomOffsetYNew, True) ; RC Done
	$g_iAvailableAttacksBB = UBound($aResult)

	If $bSetLog Then SetLog(" [G]: " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB]) & " [E]: " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB]) & "[T]: " & _NumberFormat($g_aiCurrentLootBB[$eLootTrophyBB]), $COLOR_SUCCESS)
	If $bSetLog Then SetLog("No. of Free/Total Builders: " & $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB, $COLOR_SUCCESS)
	If $g_iAvailableAttacksBB <> 0 And $bSetLog Then
		Setlog("Hey, Chief!! You have " & $g_iAvailableAttacksBB & " available attack(s)!", $COLOR_SUCCESS)
		; PushMsg("BB_AvailableAtk")
	EndIf

	If Not $bBypass Then ; update stats
		BuilderBaseStats()
	EndIf
	FuncReturn()
EndFunc   ;==>BuilderBaseReport

Func BuilderBaseStats()
	; $g_hLblBBResultGoldNow
	; $g_hLblBBResultGoldHourNow

	; $g_hLblBBResultElixirNow
	; $g_hLblBBResultElixirHourNow

	; $g_hLblBBResultTrophyNow
	; $g_hLblBBResultBuilderNow

	GUICtrlSetData($g_hLblBBResultGoldNow, _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB], True))
	GUICtrlSetData($g_hLblBBResultElixirNow, _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB], True))
	GUICtrlSetData($g_hLblBBResultTrophyNow, _NumberFormat($g_aiCurrentLootBB[$eLootTrophyBB], True))
	GUICtrlSetData($g_hLblBBResultBuilderNow, $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB)

EndFunc   ;==>BuilderBaseStats

Func BuilderBaseResetStats()
	GUICtrlSetData($g_hLblBBResultGoldNow, "")
	GUICtrlSetData($g_hLblBBResultElixirNow, "")
	GUICtrlSetData($g_hLblBBResultTrophyNow, "")
	GUICtrlSetData($g_hLblBBResultBuilderNow, "")
EndFunc   ;==>BuilderBaseResetStats

