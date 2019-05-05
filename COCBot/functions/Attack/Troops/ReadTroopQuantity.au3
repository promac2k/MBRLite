;
; #FUNCTION# ====================================================================================================================
; Name ..........: ReadTroopQuantity
; Description ...: Read the quantity for a given troop
; Syntax ........: ReadTroopQuantity($Troop)
; Parameters ....: $Troop               - an unknown value.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func ReadTroopQuantity($iSlotNumber, $bCheckSelectedSlot = False)
	Local $iAmount = 0
	Local $iGetXPosOfArmySlot = GetXPosOfArmySlot($iSlotNumber, False, True)
	Switch $bCheckSelectedSlot
		Case False
			$iAmount = Number(getTroopCountSmall($iGetXPosOfArmySlot, 640 + $g_iBottomOffsetYNew)) ; RC Done
			If $iAmount = "" Then
				$iAmount = Number(getTroopCountBig($iGetXPosOfArmySlot, 633 + $g_iBottomOffsetYNew)) ; RC Done
			EndIf
		Case Else
			Local $isTheSlotSelected = IsSlotSelected($iSlotNumber)
			If Not $isTheSlotSelected Then
				$iAmount = Number(getTroopCountSmall($iGetXPosOfArmySlot, 640 + $g_iBottomOffsetYNew)) ; RC Done
			Else
				$iAmount = Number(getTroopCountBig($iGetXPosOfArmySlot, 633 + $g_iBottomOffsetYNew)) ; RC Done
			EndIf
	EndSwitch
	If $g_bDebugSetlog Then SetDebugLog("ReadTroopQuantity For Slot: " & $iSlotNumber & " | Qty: " & Number($iAmount))
	Return Number($iAmount)
EndFunc   ;==>ReadTroopQuantity

Func UpdateTroopQuantity($sTroopName)
	; Get the integer index of the troop name specified
	Local $iTroopIndex = TroopIndexLookup($sTroopName)
	If $iTroopIndex = -1 Then
		SetLog("'UpdateTroopQuantity' troop name '" & $sTroopName & "' is unrecognized.")
		Return
	EndIf

	Local $iTroopFoundAt = -1
	For $i = 0 To UBound($g_avAttackTroops) - 1
		If $g_avAttackTroops[$i][0] = $iTroopIndex Then
			$iTroopFoundAt = $i
			ExitLoop
		EndIf
	Next

	If Not $g_bRunState Then Return
	If $iTroopFoundAt <> -1 Then
		Local $iQuantity = ReadTroopQuantity($iTroopFoundAt, True)
		$g_avAttackTroops[$iTroopFoundAt][1] = $iQuantity
	Else
		SetLog("Couldn't find '" & $sTroopName & "' in $g_avAttackTroops", $COLOR_ERROR)
	EndIf
	Return $iTroopFoundAt ; Return Troop Position in the Array, will be the slot of Troop in Attack bar
EndFunc   ;==>UpdateTroopQuantity

Func IsSlotSelected($iSlotNumber)

	Local $iGetXPosOfArmySlot = GetXPosOfArmySlot($iSlotNumber, False, True)

	Local $iY_Spell = 724 + $g_iBottomOffsetYNew ; RC Done ;When Spell Is Selected Whit Pixel is at 636
	Local $iY_Troop_Heroes_CC = 723 + $g_iBottomOffsetYNew ; RC Done ;When Troop,Heroes,CC Is Selected Whit Pixel is at 635

	If _ColorCheck(_GetPixelColor($iGetXPosOfArmySlot, $iY_Spell, True, "IsSpellSlotSelected"), Hex(0xFFFFFF, 6), 10) Or _
			_ColorCheck(_GetPixelColor($iGetXPosOfArmySlot, $iY_Troop_Heroes_CC, True, "IsTroopSlotSelected"), Hex(0xFFFFFF, 6), 10) Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>IsSlotSelected
