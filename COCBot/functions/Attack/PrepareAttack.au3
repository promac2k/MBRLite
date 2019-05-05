; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttack
; Description ...: Checks the troops when in battle, checks for type, slot, and quantity.  Saved in $g_avAttackTroops[SLOT][TYPE/QUANTITY] [OCR X]variable
; Syntax ........: PrepareAttack($pMatchMode[, $Remaining = False])
; Parameters ....: $pMatchMode          - a pointer value.
;                  $Remaining           - [optional] Flag for when checking remaining troops. Default is False.
; Return values .: None
; Author ........:
; Modified ......: Fahid.Mahmood(12-2018)
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func PrepareAttack($pMatchMode, $Remaining = False, $DebugSiege = False) ;Assigns troops

	; Attack CSV has debug option to save attack line image, save have png of current $g_hHBitmap2
	If ($pMatchMode = $DB And $g_aiAttackAlgorithm[$DB] = 1) Or ($pMatchMode = $LB And $g_aiAttackAlgorithm[$LB] = 1) Then
		If $g_bDebugMakeIMGCSV And $Remaining = False And TestCapture() = 0 Then
			If $g_iSearchTH = "-" Then ; If TH is unknown, try again to find as it is needed for filename
				imglocTHSearch(True, False, False)
			EndIf
			DebugImageSave("clean", False, Default, Default, "TH" & $g_iSearchTH & "-") ; make clean snapshot as well
		EndIf
	EndIf

	If $Remaining = False Then ; reset Hero variables before attack if not checking remaining troops
		$g_bDropKing = False ; reset hero dropped flags
		$g_bDropQueen = False
		$g_bDropWarden = False
		$g_aHeroesTimerActivation[$eHeroBarbarianKing] = 0
		$g_aHeroesTimerActivation[$eHeroArcherQueen] = 0
		$g_aHeroesTimerActivation[$eHeroGrandWarden] = 0

		$g_iTotalAttackSlot = 10 ; reset flag - Slot11+
		$g_bDraggedAttackBar = False
	EndIf

	Local $troopsnumber = 0
	If $g_bDebugSetlog Then SetDebugLog("PrepareAttack for " & $pMatchMode & " " & $g_asModeText[$pMatchMode], $COLOR_DEBUG)
	If $Remaining Then
		SetLog("Checking remaining unused troops for: " & $g_asModeText[$pMatchMode], $COLOR_INFO)
	Else
		SetLog("Initiating attack for: " & $g_asModeText[$pMatchMode], $COLOR_ERROR)
		If IsSpecialTroopToBeUsed($pMatchMode, $eWarden) Then ;Check If Warden Is Selected To Drop Only Then Check His Mode
			CheckWardenMode()
		Else
			SetDebugLog("Skip Warden Mode check as use of warden is not checked.")
		EndIf
		SwitchSiegeMachines($pMatchMode, $Remaining, $DebugSiege) ;Check If Siege Machine Switch Needed
	EndIf

	If _Sleep($DELAYPREPAREATTACK1) Then Return

	For $i = 0 To UBound($g_avAttackTroops) - 1
		$g_avAttackTroops[$i][0] = -1
		$g_avAttackTroops[$i][1] = 0
		$g_avAttackTroops[$i][2] = 0
	Next

	Local $Plural = 0
	Local $result = AttackBarCheck($Remaining, $pMatchMode) ; adding $pMatchMode for not checking Slot11+ when DropTrophy attack
	If $g_bDebugSetlog Then SetDebugLog("DLL Troopsbar list: " & $result, $COLOR_DEBUG)
	Local $aTroopDataList = StringSplit($result, "|")
	Local $aTemp[22][4] ; Slot11+
	If $result <> "" Then
		; example : |0#0#2#31|1#1#2#103|2#2#2#175|3#3#2#247|4#4#2#320|6#5#1#392|13#6#2#464|36#7#1#545|21#8#1#624|22#9#1#697|25#10#1#777
		; [0] = Troop Enum Cross Reference [1] = Slot position [2] = Quantities [3] = Slot Starting X-Axis
		For $i = 1 To UBound($aTroopDataList) - 1
			Local $troopData = StringSplit($aTroopDataList[$i], "#", $STR_NOCOUNT)
			If UBound($troopData) > 3 And $troopData[1] >= 0 Then ; Make $troopData[1] Slot position is not negative This can happen in case of slot not recognized
				$aTemp[Number($troopData[1])][0] = $troopData[0]
				$aTemp[Number($troopData[1])][1] = Number($troopData[2])
				$aTemp[Number($troopData[1])][2] = Number($troopData[1])
				$aTemp[Number($troopData[1])][3] = Number($troopData[3])
			Else
				SetDebugLog("Attackbar Wrong Format Return: " & $aTroopDataList[$i], $COLOR_ERROR)
			EndIf
		Next
	EndIf
	For $i = 0 To UBound($aTemp) - 1
		If $aTemp[$i][0] = "" And $aTemp[$i][1] = "" Then
			$g_avAttackTroops[$i][0] = -1
			$g_avAttackTroops[$i][1] = 0
			$g_avAttackTroops[$i][2] = 0
		Else
			Local $troopKind = $aTemp[$i][0]
			If $troopKind < $eKing Then
				;normal troop
				If Not IsTroopToBeUsed($pMatchMode, $troopKind) Then
					If $g_bDebugSetlog Then SetDebugLog("Discard use of troop " & $troopKind & " " & NameOfTroop($troopKind), $COLOR_ERROR)
					$g_avAttackTroops[$i][0] = -1
					$g_avAttackTroops[$i][1] = 0
					$g_avAttackTroops[$i][2] = 0
					$troopKind = -1
				Else
					;use troop
					;Setlog ("troopsnumber = " & $troopsnumber & "+ " &  Number( $aTemp[$i][1]))
					$g_avAttackTroops[$i][0] = $aTemp[$i][0]
					$g_avAttackTroops[$i][1] = $aTemp[$i][1]
					$g_avAttackTroops[$i][2] = $aTemp[$i][3]
					$troopsnumber += $aTemp[$i][1]
				EndIf

			Else ;king, queen, warden , spells , Castle and Sieges
				$g_avAttackTroops[$i][0] = $troopKind
				If IsSpecialTroopToBeUsed($pMatchMode, $troopKind) Then
					$troopsnumber += 1
					;Setlog ("troopsnumber = " & $troopsnumber & "+1")
					$g_avAttackTroops[$i][0] = $aTemp[$i][0]
					$g_avAttackTroops[$i][1] = $aTemp[$i][1]
					$g_avAttackTroops[$i][2] = $aTemp[$i][3]
					If $g_avAttackTroops[$i][0] = $eKing Or $g_avAttackTroops[$i][0] = $eQueen Or $g_avAttackTroops[$i][0] = $eWarden Then $g_avAttackTroops[$i][1] = 1
					$troopKind = $g_avAttackTroops[$i][1]
					$troopsnumber += 1
				Else
					If $g_bDebugSetlog Then SetDebugLog($aTemp[$i][2] & " » Discard use Hero/Spell/Castle/Siege [" & $troopKind & "] " & NameOfTroop($troopKind), $COLOR_ERROR)
					$troopKind = -1
				EndIf
			EndIf

			$Plural = 0
			If $aTemp[$i][1] > 1 Then $Plural = 1
			If $troopKind <> -1 Then SetLog($aTemp[$i][2] & " » " & $g_avAttackTroops[$i][1] & " " & NameOfTroop($g_avAttackTroops[$i][0], $Plural) & " Slot X » " & $g_avAttackTroops[$i][2], $COLOR_SUCCESS)

		EndIf
	Next

	;ResumeAndroid()

	If $g_bDebugSetlog Then SetDebugLog("troopsnumber  = " & $troopsnumber)
	Return $troopsnumber
EndFunc   ;==>PrepareAttack

Func IsTroopToBeUsed($pMatchMode, $pTroopType)
	If $pMatchMode = $DT Or $pMatchMode = $TB Then Return True
	If $pMatchMode = $MA Then
		Local $tempArr = $g_aaiTroopsToBeUsed[$g_aiAttackTroopSelection[$DB]]
	Else
		Local $tempArr = $g_aaiTroopsToBeUsed[$g_aiAttackTroopSelection[$pMatchMode]]
	EndIf
	For $x = 0 To UBound($tempArr) - 1
		If $tempArr[$x] = $pTroopType Then
			If $pMatchMode = $MA And $pTroopType = $eGobl Then ;exclude goblins in $MA
				Return False
			Else
				Return True
			EndIf
		EndIf
	Next
	Return False
EndFunc   ;==>IsTroopToBeUsed

Func IsSpecialTroopToBeUsed($pMatchMode, $pTroopType)
	Local $iTempMode = ($pMatchMode = $MA ? $DB : $pMatchMode)

	If $pMatchMode <> $DB And $pMatchMode <> $LB And $pMatchMode <> $TS And $pMatchMode <> $MA Then
		Return True
	Else
		Switch $pTroopType
			Case $eKing
				If (BitAND($g_aiAttackUseHeroes[$iTempMode], $eHeroKing) = $eHeroKing) Then Return True
			Case $eQueen
				If (BitAND($g_aiAttackUseHeroes[$iTempMode], $eHeroQueen) = $eHeroQueen) Then Return True
			Case $eWarden
				If (BitAND($g_aiAttackUseHeroes[$iTempMode], $eHeroWarden) = $eHeroWarden) Then Return True
			Case $eCastle
				If $g_abAttackDropCC[$iTempMode] Then Return True
			Case $eLSpell
				If $g_abAttackUseLightSpell[$iTempMode] Or $g_bSmartZapEnable = True Then Return True
			Case $eHSpell
				If $g_abAttackUseHealSpell[$iTempMode] Then Return True
			Case $eRSpell
				If $g_abAttackUseRageSpell[$iTempMode] Then Return True
			Case $eJSpell
				If $g_abAttackUseJumpSpell[$iTempMode] Then Return True
			Case $eFSpell
				If $g_abAttackUseFreezeSpell[$iTempMode] Then Return True
			Case $ePSpell
				If $g_abAttackUsePoisonSpell[$iTempMode] Then Return True
			Case $eESpell
				If $g_abAttackUseEarthquakeSpell[$iTempMode] = 1 Or $g_bSmartZapEnable = True Then Return True
			Case $eHaSpell
				If $g_abAttackUseHasteSpell[$iTempMode] Then Return True
			Case $eCSpell
				If $g_abAttackUseCloneSpell[$iTempMode] Then Return True
			Case $eSkSpell
				If $g_abAttackUseSkeletonSpell[$iTempMode] Then Return True
			Case $eBaSpell
				If $g_abAttackUseBatSpell[$iTempMode] Then Return True
			Case $eWallW
				If $g_abAttackDropCC[$iTempMode] Then Return True
			Case $eBattleB
				If $g_abAttackDropCC[$iTempMode] Then Return True
			Case $eStoneS
				If $g_abAttackDropCC[$iTempMode] Then Return True
			Case Else
				Return False
		EndSwitch
		Return False
	EndIf
EndFunc   ;==>IsSpecialTroopToBeUsed

Func AttackRemainingTime($bInitialze = Default)
	If $bInitialze = True Then
		$g_hAttackTimer = __TimerInit()
		$g_iAttackTimerOffset = Default
		SuspendAndroidTime(True) ; Reset suspend Android time for compensation when Android is suspended
		Return
	EndIf

	Local $iPrepareTime = 29 * 1000

	If $g_iAttackTimerOffset = Default Then

		; now attack is really starting (or it has already after 30 Seconds)

		; set offset
		$g_iAttackTimerOffset = __TimerDiff($g_hAttackTimer) - SuspendAndroidTime()

		If $g_iAttackTimerOffset > $iPrepareTime Then
			; adjust offset by remove "lost" attack time
			$g_iAttackTimerOffset = $iPrepareTime - $g_iAttackTimerOffset
		EndIf

	EndIf

	If $bInitialze = False Then Return

	; Return remaining attack time
	Local $iAttackTime = 3 * 60 * 1000
	Local $iRemaining = $iAttackTime - (__TimerDiff($g_hAttackTimer) - SuspendAndroidTime() - $g_iAttackTimerOffset)
	If $iRemaining < 0 Then Return 0
	Return $iRemaining

EndFunc   ;==>AttackRemainingTime

