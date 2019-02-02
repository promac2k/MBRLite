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
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
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
		SetLog("Dropping King", $COLOR_INFO)
		Local $iKingSlotClickX = GetXPosOfArmySlot($KingSlot, True)
		Click($iKingSlotClickX, 595 + $g_iBottomOffsetY, 1, 0, "#0092") ;Select King 860x780
		If _Wait4Pixel($iKingSlotClickX, 723 + $g_iBottomOffsetYNew, 0xFFFFFF, 10, 2000, "IsKingSlotSelected", 50) Then ; RC Done ;Chcek Hero Slot Selected White Pixel
			AttackClick($x, $y, 1, 0, 0, "#0093")
			Local $iKingSlotStartX = GetXPosOfArmySlot($KingSlot)
			If _Wait4PixelGone($iKingSlotStartX + 56, 633 + $g_iBottomOffsetYNew, 0x010100, 25, 1500, "IsKingDropped", 50) Then ; RC Done ;Check Slot Black Pixel Which Got Changed When Hero Got Dropped
				;Small Delay Before activitng Ability Check Just To be Sure That Green Bar Got Appeared
				If _Sleep($DELAYDROPHEROES1) Then Return
				$g_bCheckKingPower = True ; Only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bDropKing = True ; Set global flag hero dropped
				If $g_iActivateKing = 1 Or $g_iActivateKing = 2 Then $g_aHeroesTimerActivation[$eHeroBarbarianKing] = __TimerInit() ; initialize fixed activation timer
			Else
				SetLog("Something Happened King Not Dropped", $COLOR_INFO)
			EndIf
		Else
			SetLog("Something Happened Bot Unable To Select King Slot", $COLOR_INFO)
		EndIf
	ElseIf $bDropKing Then
		SetDebugLog("Do nothing as King already dropped.")
	EndIf

	If $bDropQueen And Not $g_bDropQueen Then ; Check '$g_bDropQueen' global flag that if Queen is already dropped
		SetLog("Dropping Queen", $COLOR_INFO)
		Local $iQueenSlotClickX = GetXPosOfArmySlot($QueenSlot, True)
		Click($iQueenSlotClickX, 595 + $g_iBottomOffsetY, 1, 0, "#0094") ;Select Queen 860x780
		If _Wait4Pixel($iQueenSlotClickX, 723 + $g_iBottomOffsetYNew, 0xFFFFFF, 10, 2000, "IsQueenSlotSelected", 50) Then ; RC Done ;Chcek Hero Slot Selected White Pixel
			AttackClick($x, $y, 1, 0, 0, "#0095")
			Local $iQueenSlotStartX = GetXPosOfArmySlot($QueenSlot)
			If _Wait4PixelGone($iQueenSlotStartX + 56, 633 + $g_iBottomOffsetYNew, 0x010100, 25, 1500, "IsQueenDropped", 50) Then ; RC Done ;Check Slot Black Pixel Which Got Changed When Hero Got Dropped
				;Small Delay Before activitng Ability Check Just To be Sure That Green Bar Got Appeared
				If _Sleep($DELAYDROPHEROES1) Then Return
				$g_bCheckQueenPower = True ; Only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bDropQueen = True ; Set global flag hero dropped
				If $g_iActivateQueen = 1 Or $g_iActivateQueen = 2 Then $g_aHeroesTimerActivation[$eHeroArcherQueen] = __TimerInit() ; initialize fixed activation timer
			Else
				SetLog("Something Happened Queen Not Dropped", $COLOR_INFO)
			EndIf
		Else
			SetLog("Something Happened Bot Unable To Select Queen Slot", $COLOR_INFO)
		EndIf
	ElseIf $bDropQueen Then
		SetDebugLog("Do nothing as Queen already dropped.")
	EndIf

	If $bDropWarden And Not $g_bDropWarden Then ; Check '$g_bDropWarden' global flag that if Warden is already dropped
		SetLog("Dropping Grand Warden", $COLOR_INFO)
		Local $iWardenSlotClickX = GetXPosOfArmySlot($WardenSlot, True)
		Click($iWardenSlotClickX, 595 + $g_iBottomOffsetY, 1, 0, "#X998") ;Select Warden 860x780
		If _Wait4Pixel($iWardenSlotClickX, 723 + $g_iBottomOffsetYNew, 0xFFFFFF, 10, 2000, "IsWardenSlotSelected", 50) Then ; RC Done ;Chcek Hero Slot Selected White Pixel
			AttackClick($x, $y, 1, 0, 0, "#x999")
			Local $iWardenSlotStartX = GetXPosOfArmySlot($WardenSlot)
			If _Wait4PixelGone($iWardenSlotStartX + 56, 633 + $g_iBottomOffsetYNew, 0x010100, 25, 1500, "IsWardenDropped", 50) Then ; RC Done ;Check Slot Black Pixel Which Got Changed When Hero Got Dropped
				;Small Delay Before activitng Ability Check Just To be Sure That Green Bar Got Appeared
				If _Sleep($DELAYDROPHEROES1) Then Return
				$g_bCheckWardenPower = True ; Only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bDropWarden = True ; Set global flag hero dropped
				If $g_iActivateWarden = 1 Or $g_iActivateWarden = 2 Then $g_aHeroesTimerActivation[$eHeroGrandWarden] = __TimerInit() ; initialize fixed activation timer
			Else
				SetLog("Something Happened Warden Not Dropped", $COLOR_INFO)
			EndIf
		Else
			SetLog("Something Happened Bot Unable To Select Warden Slot", $COLOR_INFO)
		EndIf
	ElseIf $bDropWarden Then
		SetDebugLog("Do nothing as Warden already dropped.")
	EndIf

EndFunc   ;==>dropHeroes



