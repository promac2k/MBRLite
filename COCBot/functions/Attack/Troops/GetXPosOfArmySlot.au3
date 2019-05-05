; #FUNCTION# ====================================================================================================================
; Name ..........: GetXPosOfArmySlot
; Description ...:
; Syntax ........: GetXPosOfArmySlot($slotNumber, $xOffsetFor11Slot)
; Parameters ....: $slotNumber          - a string value.
;                  $xOffsetFor11Slot    - an unknown value.
; Return values .: None
; Author ........:
; Modified ......: Promac(12-2016), Fahid.Mahmood(12-2018)
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================

Func GetXPosOfArmySlot($iSlotNumber, $bGetPosXForClick = False, $bGetPosXForOCR = False, $bGetPosXForHeroesAbility = False)

	If $iSlotNumber + 1 > UBound($g_avAttackTroops) Or $iSlotNumber < 0 Then
		If $g_bDebugSetlog Then SetDebugLog("Error: GetXPosOfArmySlot Trying to check Slot: " & $iSlotNumber)
		Return 0
	Else
		Local $sTroopName = NameOfTroop($g_avAttackTroops[$iSlotNumber][0])
		;This Logic Is For Handling Slot 11+ Need To Calculate New Pos X When Attackbar is dragged
		If $g_bDraggedAttackBar And $iSlotNumber > -1 Then
			Local $i2ndPageSlotStartXSpace = 27
			Local $iSlotNewNumber = $iSlotNumber - ($g_iTotalAttackSlot - 10)
			If $g_bDebugSetlog Then SetDebugLog("[" & $sTroopName & "] Dragged GetXPosOfArmySlot » " & $iSlotNumber & " » 2nd Page Slot No : " & $iSlotNewNumber)
			;When Slot 11+ There 2nd Page Starting X is already stored in array.
			If ($iSlotNumber > 10) Then
				Local $iTroopsSlotStartPosX = $g_avAttackTroops[$iSlotNumber][2]
			Else
				;On 2nd Page, Page 1 Slots X got changed by this we can know what is the X on 2nd page of page 1 troops.
				Local $iTroopsSlotStartPosX = $g_avAttackTroops[$iSlotNumber][2] - $g_avAttackTroops[$iSlotNumber - $iSlotNewNumber][2] + $i2ndPageSlotStartXSpace
			EndIf
			$iSlotNumber = $iSlotNewNumber
		Else
			Local $iTroopsSlotStartPosX = $g_avAttackTroops[$iSlotNumber][2]
		EndIf

		If $bGetPosXForClick Then
			If $g_bDebugSetlog Then SetDebugLog("[" & $sTroopName & "] GetXPosOfArmySlot » " & $iSlotNumber & " » For Click: " & $iTroopsSlotStartPosX + 32)
			Return $iTroopsSlotStartPosX + 32 ;Nice Center Click
		EndIf
		If $bGetPosXForHeroesAbility Then
			If $g_bDebugSetlog Then SetDebugLog("[" & $sTroopName & "] GetXPosOfArmySlot » " & $iSlotNumber & " » For Heroes Ability: " & $iTroopsSlotStartPosX + 26)
			Return $iTroopsSlotStartPosX + 28 ;For Weak Heroes
		EndIf
		If $bGetPosXForOCR Then
			If $g_bDebugSetlog Then SetDebugLog("[" & $sTroopName & "] GetXPosOfArmySlot » " & $iSlotNumber & " » For Ocr: " & $iTroopsSlotStartPosX + $g_iSlotOCRCompensation)
			Return $iTroopsSlotStartPosX + $g_iSlotOCRCompensation
		EndIf
		If $g_bDebugSetlog Then SetDebugLog("[" & $sTroopName & "] GetXPosOfArmySlot » " & $iSlotNumber & " » Slot Start X: " & $iTroopsSlotStartPosX)
		Return $iTroopsSlotStartPosX ;By Default this function will return slot x
	EndIf

EndFunc   ;==>GetXPosOfArmySlot

