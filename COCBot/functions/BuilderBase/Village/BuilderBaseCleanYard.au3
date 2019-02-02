; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseCleanYard
; Description ...: This file is used to automatically clear Yard from Trees, Trunks etc. from builder base
; Author ........: Fahid.Mahmood
; Modified ......:
; Remarks .......: This file is part of MultiBot, previously known as Mybot and ClashGameBot. Copyright 2015-2018
;                  MultiBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func TestrunCleanYardBB()
	SetDebugLog("** TestrunCleanYardBB START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	Local $wasCleanYardBB = $g_bChkCleanYardBB
	$g_bRunState = True
	$g_bChkCleanYardBB = True
	CleanYardBB()
	$g_bRunState = $Status
	$g_bChkCleanYardBB = $wasCleanYardBB
	SetDebugLog("** TestrunCleanYardBB END**", $COLOR_DEBUG)
EndFunc   ;==>TestrunCleanYardBB

Func CleanYardBB() ;Call this function After ClockTower So It can benfit from builder boost
	; Early exist if noting to do
	If Not $g_bRunState Then Return
	If Not $g_bChkCleanYardBB And Not TestCapture() Then Return

	FuncEnter(CleanYardBB)

	Local $bBuilderBase = True

	If isOnBuilderIsland2() Then ; Double Check to see if Bot is on builder base
		SetLog("Going to check Builder Base Yard For Obstacles!", $COLOR_INFO)
		; Timer
		Local $hObstaclesTimer = __TimerInit()

		; Get Builders available
		If Not getBuilderCount(False, $bBuilderBase) Then Return ; update builder data, return if problem

		If $g_aiCurrentLootBB[$eLootElixirBB] = 0 Then BuilderBaseReport() ; BB elixer is 0 then check builderbase report

		If _Sleep($DELAYRESPOND) Then Return


		; For new image detection
		Local $hStarttime = _Timer_Init()
		Local $iObstacleRemoved = 0
		Local $bNoBuilders = $g_iFreeBuilderCountBB < 1

		If $g_iFreeBuilderCountBB > 0 And $g_bChkCleanYardBB = True And Number($g_aiCurrentLootBB[$eLootElixirBB]) > 50000 Then
			; Reurn an Array [xx][0] = Name , [xx][1] = Xaxis , [xx][2] = Yaxis , [xx][3] = Level
			Local $CleanYardBBNXY = _ImageSearchBundlesMultibot($g_sBundleCleanYardBB, $g_aBundleCleanYardBBParms[0], $g_aBundleCleanYardBBParms[1], $g_aBundleCleanYardBBParms[2], $g_bDebugBBattack)
			If $g_bDebugSetlog Then SetDebugLog("Benchmark Image Detection Of Builder Base Clean Yard: " & Round(_Timer_Diff($hStarttime), 2) & "'ms")
			If IsArray($CleanYardBBNXY) And UBound($CleanYardBBNXY) > 0 Then
				SetDebugLog("Total Obstacles Found: " & UBound($CleanYardBBNXY))
				For $i = 0 To UBound($CleanYardBBNXY) - 1
					$iObstacleRemoved += 1
					SetLog("Going to remove Builder Base Obstacle: " & $iObstacleRemoved, $COLOR_SUCCESS)
					If $g_bDebugSetlog Then SetDebugLog($CleanYardBBNXY[$i][0] & " found at (" & $CleanYardBBNXY[$i][1] & "," & $CleanYardBBNXY[$i][2] & ")", $COLOR_SUCCESS)
					If IsMainPageBuilderBase() Then Click($CleanYardBBNXY[$i][1], $CleanYardBBNXY[$i][2], 1, 0, "#0430")
					If _Sleep($DELAYCOLLECT3) Then Return
					If IsMainPageBuilderBase() Then GemClick($aCleanYard[0], $aCleanYard[1], 1, 0, "#0431") ; Click Obstacles button to clean
					If _Sleep($DELAYCHECKTOMBS2) Then Return
					ClickP($aAway, 2, 300, "#0329") ;Click Away
					If _Sleep($DELAYCHECKTOMBS1) Then Return
					If getBuilderCount(False, $bBuilderBase) = False Then Return ; update builder data, return if problem
					If _Sleep($DELAYRESPOND) Then Return
					If $g_iFreeBuilderCountBB = 0 Then
						SetLog("No More Builders available in Builder Base to remove Obstacles!")
						ExitLoop
					EndIf
					; Check Elixer for more then one Obstacle.
					BuilderBaseReport() ; check builderbase report before removing other Obstacles
					If _Sleep($DELAYRESPOND) Then Return
					If Number($g_aiCurrentLootBB[$eLootElixirBB]) < 50000 Then
						SetLog("Remove Obstacles stopped due to insufficient Elixer!", $COLOR_INFO)
						ExitLoop
					EndIf
				Next
			EndIf
		ElseIf $g_iFreeBuilderCountBB > 0 And $g_bChkCleanYardBB = True And Number($g_aiCurrentLootBB[$eLootElixirBB]) < 50000 Then
			SetLog("Sorry, Low Builder Base Elixer(" & $g_aiCurrentLootBB[$eLootElixirBB] & ") Skip remove Obstacles check!", $COLOR_INFO)
		EndIf

		If $bNoBuilders Then
			SetLog("Builder not available to remove Builder Base Obstacles!")
		Else
			If $iObstacleRemoved = 0 And $g_bChkCleanYardBB And Number($g_aiCurrentLootBB[$eLootElixirBB]) > 50000 Then SetLog("No Obstacles found, Builder Base Yard is clean!", $COLOR_SUCCESS)
			If $g_bDebugSetlog Then SetDebugLog("Took Time: " & Round(__TimerDiff($hObstaclesTimer) / 1000, 2) & "'s", $COLOR_SUCCESS)
		EndIf
		ClickP($aAway, 1, 300, "#0329") ;Click Away
	EndIf
	FuncReturn()
EndFunc   ;==>CleanYardBB

Func chkCleanYardBB()
	If GUICtrlRead($g_hChkCleanYardBB) = $GUI_CHECKED Then
		$g_bChkCleanYardBB = True
	Else
		$g_bChkCleanYardBB = False
	EndIf
EndFunc   ;==>chkCleanYardBB
