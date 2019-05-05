; #FUNCTION# ====================================================================================================================
; Name ..........: DropTroopFromINI
; Description ...:
; Syntax ........: DropTroopFromINI($vectors, $indexStart, $indexEnd, $qtaMin, $qtaMax, $troopName, $delayPointmin,
;                  $delayPointmax, $delayDropMin, $delayDropMax, $sleepafterMin, $sleepAfterMax[, $debug = False])
; Parameters ....: $vectors             -
;                  $indexStart          -
;                  $indexEnd            -
;                  $qtaMin              -
;                  $qtaMax              -
;                  $troopName           -
;                  $delayPointmin       -
;                  $delayPointmax       -
;                  $delayDropMin        -
;                  $delayDropMax        -
;                  $sleepafterMin       -
;                  $sleepAfterMax       -
;                  $debug               - [optional] Default is False.
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: MonkeyHunter (03-2017)
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func DropTroopFromINI($vectors, $indexStart, $indexEnd, $indexArray, $qtaMin, $qtaMax, $troopName, $delayPointmin, $delayPointmax, $delayDropMin, $delayDropMax, $sleepafterMin, $sleepAfterMax, $debug = False)
	If IsArray($indexArray) = 0 Then
		debugAttackCSV("drop using vectors " & $vectors & " index " & $indexStart & "-" & $indexEnd & " and using " & $qtaMin & "-" & $qtaMax & " of " & $troopName)
	Else
		debugAttackCSV("drop using vectors " & $vectors & " index " & _ArrayToString($indexArray, ",") & " and using " & $qtaMin & "-" & $qtaMax & " of " & $troopName)
	EndIf
	debugAttackCSV(" - delay for multiple troops in same point: " & $delayPointmin & "-" & $delayPointmax)
	debugAttackCSV(" - delay when  change deploy point : " & $delayDropMin & "-" & $delayDropMax)
	debugAttackCSV(" - delay after drop all troops : " & $sleepafterMin & "-" & $sleepAfterMax)

	;how many vectors need to manage...
	Local $temp = StringSplit($vectors, "-")
	Local $numbersOfVectors
	If UBound($temp) > 0 Then
		$numbersOfVectors = $temp[0]
	Else
		$numbersOfVectors = 0
	EndIf

	;name of vectors...
	Local $vector1, $vector2, $vector3, $vector4
	If UBound($temp) > 0 Then
		If $temp[0] >= 1 Then $vector1 = "ATTACKVECTOR_" & $temp[1]
		If $temp[0] >= 2 Then $vector2 = "ATTACKVECTOR_" & $temp[2]
		If $temp[0] >= 3 Then $vector3 = "ATTACKVECTOR_" & $temp[3]
		If $temp[0] >= 4 Then $vector4 = "ATTACKVECTOR_" & $temp[4]
	Else
		$vector1 = $vectors
	EndIf

	;Qty to drop
	If $qtaMin <> $qtaMax Then
		Local $qty = Random($qtaMin, $qtaMax, 1)
	Else
		Local $qty = $qtaMin
	EndIf
	debugAttackCSV(">> qty to deploy: " & $qty)

	;number of troop to drop in one point...
	Local $qtyxpoint = Int($qty / ($indexEnd - $indexStart + 1))
	Local $extraunit = Mod($qty, ($indexEnd - $indexStart + 1))
	debugAttackCSV(">> qty x point: " & $qtyxpoint)
	debugAttackCSV(">> qty extra: " & $extraunit)

	; Get the integer index of the troop name specified
	Local $iTroopIndex = TroopIndexLookup($troopName, "DropTroopFromINI")
	If $iTroopIndex = -1 Then
		SetLog("CSV troop name '" & $troopName & "' is unrecognized.")
		Return
	EndIf

	;search slot where is the troop...
	Local $iTroopSlotConstNo = -1 ; $iTroopSlotConstNo = xx/22 (the unique slot number of troop) - Slot11+
	For $i = 0 To UBound($g_avAttackTroops) - 1
		If $g_avAttackTroops[$i][0] = $iTroopIndex And $g_avAttackTroops[$i][1] > 0 Then
			debugAttackCSV("Found troop position " & $i & ". " & $troopName & " x" & $g_avAttackTroops[$i][1])
			$iTroopSlotConstNo = $i
			ExitLoop
		EndIf
	Next

	; Slot11+
	debugAttackCSV("Troop position / Total slots: " & $iTroopSlotConstNo & " / " & $g_iTotalAttackSlot)
	If $iTroopSlotConstNo >= 0 And $iTroopSlotConstNo < $g_iTotalAttackSlot - 10 Then ; can only be selected when in 1st page of troopbar
		If $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, True) ; return drag
	ElseIf $iTroopSlotConstNo > 10 Then ; can only be selected when in 2nd page of troopbar
		If $g_bDraggedAttackBar = False Then DragAttackBar($g_iTotalAttackSlot, False) ; drag forward
	EndIf
	;This Below 4 lines is just for log main logic is getting handled in GetXPosOfArmySlot
	If $g_bDraggedAttackBar And $iTroopSlotConstNo > -1 Then
		Local $iTroopSlotNewNo = $iTroopSlotConstNo - ($g_iTotalAttackSlot - 10)
		debugAttackCSV("New troop position: " & $iTroopSlotNewNo)
	EndIf

	Local $usespell = True
	Switch $iTroopIndex
		Case $eLSpell
			If $g_abAttackUseLightSpell[$g_iMatchMode] = False Then $usespell = False
		Case $eHSpell
			If $g_abAttackUseHealSpell[$g_iMatchMode] = False Then $usespell = False
		Case $eRSpell
			If $g_abAttackUseRageSpell[$g_iMatchMode] = False Then $usespell = False
		Case $eJSpell
			If $g_abAttackUseJumpSpell[$g_iMatchMode] = False Then $usespell = False
		Case $eFSpell
			If $g_abAttackUseFreezeSpell[$g_iMatchMode] = False Then $usespell = False
		Case $eCSpell
			If $g_abAttackUseCloneSpell[$g_iMatchMode] = False Then $usespell = False
		Case $ePSpell
			If $g_abAttackUsePoisonSpell[$g_iMatchMode] = False Then $usespell = False
		Case $eESpell
			If $g_abAttackUseEarthquakeSpell[$g_iMatchMode] = False Then $usespell = False
		Case $eHaSpell
			If $g_abAttackUseHasteSpell[$g_iMatchMode] = False Then $usespell = False
		Case $eSkSpell
			If $g_abAttackUseSkeletonSpell[$g_iMatchMode] = False Then $usespell = False
		Case $eBaSpell
			If $g_abAttackUseBatSpell[$g_iMatchMode] = False Then $usespell = False
	EndSwitch

	If $iTroopSlotConstNo = -1 Or $usespell = False Then

		If $usespell = True Then
			SetLog("No " & NameOfTroop($iTroopIndex) & "  found in your attack troops list")
			debugAttackCSV("No " & NameOfTroop($iTroopIndex) & " found in your attack troops list")
		Else
			If $g_bDebugSetlog Then SetDebugLog("Discard use " & NameOfTroop($iTroopIndex), $COLOR_DEBUG)
		EndIf

	Else

		;Local $SuspendMode = SuspendAndroid()

		If $g_iCSVLastTroopPositionDropTroopFromINI <> $iTroopSlotConstNo Then
			ReleaseClicks()
			SelectDropTroop($iTroopSlotConstNo) ; select the troop...
			$g_iCSVLastTroopPositionDropTroopFromINI = $iTroopSlotConstNo
			ReleaseClicks()
		EndIf
		;Using This Varible For Heroes and CC that when more vector drop points given just drop them one time and exit loop otherwise bot will try to drop them many times or even mis triger ability
		Local $IsSpeicalTroopDropped = False
		;drop
		For $i = $indexStart To $indexEnd
			Local $delayDrop = 0
			Local $index = $i
			Local $indexMax = $indexEnd
			If IsArray($indexArray) = 1 Then
				; adjust $index and $indexMax based on array
				$index = $indexArray[$i]
				$indexMax = $indexArray[$indexEnd]
			EndIf
			If $index <> $indexMax Then
				;delay time between 2 drops in different point
				If $delayDropMin <> $delayDropMax Then
					$delayDrop = Random($delayDropMin, $delayDropMax, 1)
				Else
					$delayDrop = $delayDropMin
				EndIf
				debugAttackCSV(">> delay change drop point: " & $delayDrop)
			EndIf

			For $j = 1 To $numbersOfVectors
				;delay time between 2 drops in different point
				Local $delayDropLast = 0
				If $j = $numbersOfVectors Then $delayDropLast = $delayDrop
				If $index <= UBound(Execute("$" & Eval("vector" & $j))) Then
					Local $pixel = Execute("$" & Eval("vector" & $j) & "[" & $index - 1 & "]")
					Local $qty2 = $qtyxpoint
					If $index < $indexStart + $extraunit Then $qty2 += 1

					;delay time between 2 drops in same point
					If $delayPointmin <> $delayPointmax Then
						Local $delayPoint = Random($delayPointmin, $delayPointmax, 1)
					Else
						Local $delayPoint = $delayPointmin
					EndIf

					Switch $iTroopIndex
						Case $eBarb To $eIceG ; drop normal troops
							If $debug = True Then
								SetLog("AttackClick( " & $pixel[0] & ", " & $pixel[1] & " , " & $qty2 & ", " & $delayPoint & ",#0666)")
							Else
								AttackClick($pixel[0], $pixel[1], $qty2, $delayPoint, $delayDropLast, "#0666")
							EndIf
						Case $eKing
							If $debug = True Then
								SetLog("dropHeroes(" & $pixel[0] & ", " & $pixel[1] & ", " & $iTroopSlotConstNo & ", -1, -1) ")
							Else
								dropHeroes($pixel[0], $pixel[1], $iTroopSlotConstNo, -1, -1) ; was $g_iKingSlot, Slot11+
							EndIf
							$IsSpeicalTroopDropped = True
						Case $eQueen
							If $debug = True Then
								SetLog("dropHeroes(" & $pixel[0] & ", " & $pixel[1] & ",-1," & $iTroopSlotConstNo & ", -1) ")
							Else
								dropHeroes($pixel[0], $pixel[1], -1, $iTroopSlotConstNo, -1) ; was $g_iQueenSlot, Slot11+
							EndIf
							$IsSpeicalTroopDropped = True
						Case $eWarden
							If $debug = True Then
								SetLog("dropHeroes(" & $pixel[0] & ", " & $pixel[1] & ", -1, -1," & $iTroopSlotConstNo & ") ")
							Else
								dropHeroes($pixel[0], $pixel[1], -1, -1, $iTroopSlotConstNo) ; was $g_iWardenSlot, Slot11+
							EndIf
							$IsSpeicalTroopDropped = True
						Case $eCastle, $eWallW, $eBattleB, $eStoneS
							If $debug = True Then
								SetLog("dropCC(" & $pixel[0] & ", " & $pixel[1] & ", " & $iTroopSlotConstNo & ")")
							Else
								dropCC($pixel[0], $pixel[1], $iTroopSlotConstNo)
							EndIf
							$IsSpeicalTroopDropped = True
						Case $eLSpell To $eBaSpell
							If $debug = True Then
								SetLog("Drop Spell AttackClick( " & $pixel[0] & ", " & $pixel[1] & " , " & $qty2 & ", " & $delayPoint & ",#0666)")
							Else
								AttackClick($pixel[0], $pixel[1], $qty2, $delayPoint, $delayDropLast, "#0667")
							EndIf
							; assume spells get always dropped: adjust count so CC spells can be used without recalc
							If UBound($g_avAttackTroops) > $iTroopSlotConstNo And $g_avAttackTroops[$iTroopSlotConstNo][1] > 0 And $qty2 > 0 Then ; Slot11 - Demen_S11_#9003
								$g_avAttackTroops[$iTroopSlotConstNo][1] -= $qty2
								debugAttackCSV("Adjust quantity of spell use: " & $g_avAttackTroops[$iTroopSlotConstNo][0] & " x" & $g_avAttackTroops[$iTroopSlotConstNo][1])
							EndIf
						Case Else
							SetLog("Error parsing line")
					EndSwitch
					debugAttackCSV($troopName & " qty " & $qty2 & " in (" & $pixel[0] & "," & $pixel[1] & ") delay " & $delayPoint)
					;Using This Varible For Heroes and CC that when more vector drop points given just drop them one time and exit loop otherwise bot will try to drop them many times or even mis triger ability
					If $IsSpeicalTroopDropped Then ExitLoop 2
				EndIf
				;;;;if $j <> $numbersOfVectors Then _sleep(5) ;little delay by passing from a vector to another vector
			Next
		Next

		ReleaseClicks()
		;SuspendAndroid($SuspendMode)

		;sleep time after deploy all troops
		Local $sleepafter = 0
		If $sleepafterMin <> $sleepAfterMax Then
			$sleepafter = Random($sleepafterMin, $sleepAfterMax, 1)
		Else
			$sleepafter = Int($sleepafterMin)
		EndIf
		If $sleepafter > 0 And IsKeepClicksActive() = False Then
			debugAttackCSV(">> delay after drop all troops: " & $sleepafter)
			If $sleepafter <= 1000 Then ; check SLEEPAFTER value is less than 1 second?
				If _Sleep($sleepafter) Then Return
				CheckHeroesHealth()
			Else ; $sleepafter is More than 1 second, then improve pause/stop button response with max 1 second delays
				For $z = 1 To Int($sleepafter / 1000) ; Check hero health every second while while sleeping
					If _Sleep(980) Then Return ; sleep 1 second minus estimated herohealthcheck time when heroes not activiated
					CheckHeroesHealth() ; check hero health == does nothing if hero not dropped
				Next
				If _Sleep(Mod($sleepafter, 1000)) Then Return ; $sleepafter must be integer for MOD function return correct value!
				CheckHeroesHealth() ; check hero health == does nothing if hero not dropped
			EndIf
		EndIf
	EndIf

EndFunc   ;==>DropTroopFromINI
