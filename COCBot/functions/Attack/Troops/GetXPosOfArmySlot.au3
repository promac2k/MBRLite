; #FUNCTION# ====================================================================================================================
; Name ..........: GetXPosOfArmySlot
; Description ...:
; Syntax ........: GetXPosOfArmySlot($slotNumber, $xOffsetFor11Slot)
; Parameters ....: $slotNumber          - a string value.
;                  $xOffsetFor11Slot    - an unknown value.
; Return values .: None
; Author ........:
; Modified ......: Promac(12-2016), Fahid.Mahmood(12-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetXPosOfArmySlot($iSlotNumber, $bGetPosXForClick = False, $bGetPosXForOCR = False, $bGetPosXForHeroesAbility = False)

	If $iSlotNumber + 1 > UBound($g_avAttackTroops) Or $iSlotNumber < 0 Then
		If $g_bDebugSetlog Then SetDebugLog("Error: GetXPosOfArmySlot Trying to check Slot: " & $iSlotNumber)
		Return 0
	Else
		Local $iTroopsSlotStartPosX = $g_avAttackTroops[$iSlotNumber][2]
		If $bGetPosXForClick Then
			If $g_bDebugSetlog Then SetDebugLog("[" & NameOfTroop($g_avAttackTroops[$iSlotNumber][0]) & "] GetXPosOfArmySlot » " & $iSlotNumber & " » For Click: " & $iTroopsSlotStartPosX + 32)
			Return $iTroopsSlotStartPosX + 32 ;Nice Center Click
		EndIf
		If $bGetPosXForHeroesAbility Then
			If $g_bDebugSetlog Then SetDebugLog("[" & NameOfTroop($g_avAttackTroops[$iSlotNumber][0]) & "] GetXPosOfArmySlot » " & $iSlotNumber & " » For Heroes Ability: " & $iTroopsSlotStartPosX + 26)
			Return $iTroopsSlotStartPosX + 26 ;For Weak Heroes
		EndIf
		If $bGetPosXForOCR Then
			If $g_bDebugSetlog Then SetDebugLog("[" & NameOfTroop($g_avAttackTroops[$iSlotNumber][0]) & "] GetXPosOfArmySlot » " & $iSlotNumber & " » For Ocr: " & $iTroopsSlotStartPosX + $g_iSlotOCRCompensation)
			Return $iTroopsSlotStartPosX + $g_iSlotOCRCompensation
		EndIf
		If $g_bDebugSetlog Then SetDebugLog("[" & NameOfTroop($g_avAttackTroops[$iSlotNumber][0]) & "] GetXPosOfArmySlot » " & $iSlotNumber & " » Slot Start X: " & $iTroopsSlotStartPosX)
		Return $iTroopsSlotStartPosX ;By Default this function will return slot x
	EndIf

EndFunc   ;==>GetXPosOfArmySlot

