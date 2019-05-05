; #FUNCTION# ====================================================================================================================
; Name ..........: dropHeroes
; Description ...: Will drop heroes in a specific coordinates, only if slot is not -1,Only drops when option is clicked.
; Syntax ........: dropHeroes($x, $y[, $KingSlot = -1[, $QueenSlot = -1[, $WardenSlot = -1]]])
; Parameters ....: $x                   - an unknown value.
;                  $y                   - an unknown value.
;                  $KingSlot            - [optional] an unknown value. Default is -1.
;                  $QueenSlot           - [optional] an unknown value. Default is -1.
;                  $WardenSlot          - [optional] an unknown value. Default is -1.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func dropHeroes($x, $y, $KingSlot = -1, $QueenSlot = -1, $WardenSlot = -1) ;Drops for king and queen and Grand Warden
	If $g_bDebugSetlog Then SetDebugLog("dropHeroes KingSlot " & $KingSlot & " QueenSlot " & $QueenSlot & " WardenSlot " & $WardenSlot & " matchmode " & $g_iMatchMode, $COLOR_DEBUG)
	If _Sleep($DELAYDROPHEROES1) Then Return

	Local $bDropKing = False
	Local $bDropQueen = False
	Local $bDropWarden = False

	;Force to check settings of matchmode =$DB if you attack $TS after milkingattack
	Local $MatchMode
	If $g_iMatchMode = $TS And $g_bDuringMilkingAttack = True Then
		$MatchMode = $DB
	Else
		$MatchMode = $g_iMatchMode
	EndIf

	;use hero if  slot (detected ) and ( (matchmode <>DB and <>LB  ) or (check user GUI settings) )
	If $KingSlot <> -1 And (($MatchMode <> $DB And $MatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$MatchMode], $eHeroKing) = $eHeroKing) Then $bDropKing = True
	If $QueenSlot <> -1 And (($MatchMode <> $DB And $MatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$MatchMode], $eHeroQueen) = $eHeroQueen) Then $bDropQueen = True
	If $WardenSlot <> -1 And (($MatchMode <> $DB And $MatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$MatchMode], $eHeroWarden) = $eHeroWarden) Then $bDropWarden = True

	If $g_bDebugSetlog Then SetDebugLog("drop KING = " & $bDropKing, $COLOR_DEBUG)
	If $g_bDebugSetlog Then SetDebugLog("drop QUEEN = " & $bDropQueen, $COLOR_DEBUG)
	If $g_bDebugSetlog Then SetDebugLog("drop WARDEN = " & $bDropWarden, $COLOR_DEBUG)

	If $bDropKing And Not $g_bDropKing Then ; Check '$g_bDropKing' global flag that if King is already dropped
		Local $hTimer = __TimerInit()
		SetLog("Dropping King", $COLOR_INFO)
		Local $iKingSlotClickX = GetXPosOfArmySlot($KingSlot, True)
		Click($iKingSlotClickX, 595 + $g_iBottomOffsetY, 1, 0, "#0092") ;Select King 860x780
		If _Wait4Pixel($iKingSlotClickX, 723 + $g_iBottomOffsetYNew, 0xFFFFFF, 1, 2000, "IsKingSlotSelected", 100) Then ; RC Done ;Chcek Hero Slot Selected White Pixel
			AttackClick($x, $y, 1, 0, 0, "#0093")
			If _Wait4PixelGone($iKingSlotClickX, 723 + $g_iBottomOffsetYNew, 0xFFFFFF, 1, 1500, "IsKingDropped", 100) Then ; RC Done ;Check White Selected Pixel Gone When Hero Got Dropped
				SetDebugLog("King Took " & Round(__TimerDiff($hTimer)) & " ms To Get Dropped", $COLOR_SUCCESS)
				$g_bCheckKingPower = True ; Only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bDropKing = True ; Set global flag hero dropped
				$g_aHeroesTimerActivation[$eHeroBarbarianKing] = __TimerInit() ; initialize fixed activation timer
			Else
				SetLog("Something Happened King Not Dropped", $COLOR_INFO)
			EndIf
		Else
			SetLog("Something Happened Bot Unable To Select King Slot", $COLOR_INFO)
		EndIf
	ElseIf $bDropKing And $g_bDropKing And $g_bCheckKingPower Then
		SetLog("Forcing King's ability on request", $COLOR_INFO)
		SelectDropTroop($KingSlot)
		$g_iCSVLastTroopPositionDropTroopFromINI = $g_iKingSlot
		$g_bCheckKingPower = False ; Reset check power flag
	ElseIf $bDropKing Then
		SetDebugLog("Do nothing as King already dropped.")
	EndIf

	If $bDropQueen And Not $g_bDropQueen Then ; Check '$g_bDropQueen' global flag that if Queen is already dropped
		Local $hTimer = __TimerInit()
		SetLog("Dropping Queen", $COLOR_INFO)
		Local $iQueenSlotClickX = GetXPosOfArmySlot($QueenSlot, True)
		Click($iQueenSlotClickX, 595 + $g_iBottomOffsetY, 1, 0, "#0094") ;Select Queen 860x780
		If _Wait4Pixel($iQueenSlotClickX, 723 + $g_iBottomOffsetYNew, 0xFFFFFF, 1, 2000, "IsQueenSlotSelected", 100) Then ; RC Done ;Chcek Hero Slot Selected White Pixel
			AttackClick($x, $y, 1, 0, 0, "#0095")
			If _Wait4PixelGone($iQueenSlotClickX, 723 + $g_iBottomOffsetYNew, 0xFFFFFF, 1, 1500, "IsQueenDropped", 100) Then ; RC Done ;Check White Selected Pixel Gone When Hero Got Dropped
				SetDebugLog("Queen Took " & Round(__TimerDiff($hTimer)) & " ms To Get Dropped", $COLOR_SUCCESS)
				$g_bCheckQueenPower = True ; Only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bDropQueen = True ; Set global flag hero dropped
				$g_aHeroesTimerActivation[$eHeroArcherQueen] = __TimerInit() ; initialize fixed activation timer
			Else
				SetLog("Something Happened Queen Not Dropped", $COLOR_INFO)
			EndIf
		Else
			SetLog("Something Happened Bot Unable To Select Queen Slot", $COLOR_INFO)
		EndIf
	ElseIf $bDropQueen And $g_bDropQueen And $g_bCheckQueenPower Then
		SetLog("Forcing Queen's ability on request", $COLOR_INFO)
		SelectDropTroop($QueenSlot)
		$g_iCSVLastTroopPositionDropTroopFromINI = $g_iQueenSlot
		$g_bCheckQueenPower = False ; Reset check power flag
	ElseIf $bDropQueen Then
		SetDebugLog("Do nothing as Queen already dropped.")
	EndIf

	If $bDropWarden And Not $g_bDropWarden Then ; Check '$g_bDropWarden' global flag that if Warden is already dropped
		Local $hTimer = __TimerInit()
		SetLog("Dropping Grand Warden", $COLOR_INFO)
		Local $iWardenSlotClickX = GetXPosOfArmySlot($WardenSlot, True)
		Click($iWardenSlotClickX, 595 + $g_iBottomOffsetY, 1, 0, "#X998") ;Select Warden 860x780
		If _Wait4Pixel($iWardenSlotClickX, 723 + $g_iBottomOffsetYNew, 0xFFFFFF, 1, 2000, "IsWardenSlotSelected", 100) Then ; RC Done ;Chcek Hero Slot Selected White Pixel
			AttackClick($x, $y, 1, 0, 0, "#x999")
			If _Wait4PixelGone($iWardenSlotClickX, 723 + $g_iBottomOffsetYNew, 0xFFFFFF, 1, 1500, "IsWardenDropped", 100) Then ; RC Done ;Check White Selected Pixel Gone When Hero Got Dropped
				SetDebugLog("Queen Took " & Round(__TimerDiff($hTimer)) & " ms To Get Dropped", $COLOR_SUCCESS)
				$g_bCheckWardenPower = True ; Only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bDropWarden = True ; Set global flag hero dropped
				$g_aHeroesTimerActivation[$eHeroGrandWarden] = __TimerInit() ; initialize fixed activation timer
			Else
				SetLog("Something Happened Warden Not Dropped", $COLOR_INFO)
			EndIf
		Else
			SetLog("Something Happened Bot Unable To Select Warden Slot", $COLOR_INFO)
		EndIf
	ElseIf $bDropWarden And $g_bDropWarden And $g_bCheckWardenPower Then
		SetLog("Forcing Warden's ability on request", $COLOR_INFO)
		SelectDropTroop($WardenSlot)
		$g_iCSVLastTroopPositionDropTroopFromINI = $g_iWardenSlot
		$g_bCheckWardenPower = False ; Reset check power flag
	ElseIf $bDropWarden Then
		SetDebugLog("Do nothing as Warden already dropped.")
	EndIf

EndFunc   ;==>dropHeroes
