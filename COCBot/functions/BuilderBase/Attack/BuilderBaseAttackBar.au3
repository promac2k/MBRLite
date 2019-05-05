; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseAttack
; Description ...: Use on Builder Base attack
; Syntax ........: BuilderBaseAttack()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018)
; Modified ......: Fahid.Mahmood(12-2018)
; Remarks .......: This file is part of MultiBot, previously known as Mybot and ClashGameBot. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================

Func TestBuilderBaseAttackBar()
	Setlog("** TestBuilderBaseAttackBar START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	$g_bRunState = True
	Local $TempDebug = $g_bDebugOcr
	$g_bDebugOcr = True
	BuilderBaseAttackBar()
	$g_bRunState = $Status
	$g_bDebugOcr = $TempDebug
	Setlog("** TestBuilderBaseAttackBar END**", $COLOR_DEBUG)
EndFunc   ;==>TestBuilderBaseAttackBar

Func BuilderBaseAttackBar($bIfMachineWasDeployed = False, $bIfMachineHasAbility = False, $aMachineSlot_XYA = Null, $bRemaining = False)

	If Not $bRemaining Then $g_bIsMachinePresent = False

	If Not $g_bRunState Then Return

	For $i = 0 To 15
		If Not $g_bRunState Then Return
		If $bIfMachineWasDeployed Then TriggerMachineAbility($bIfMachineHasAbility, $aMachineSlot_XYA)
		If _Sleep(1000) Then Return -1
		Local $aAttacker = _ImageSearchXMLMultibot($g_sXMLOpponentVillageVisible, $g_aXMLOpponentVillageVisibleParms[0], $g_aXMLOpponentVillageVisibleParms[1], $g_aXMLOpponentVillageVisibleParms[2], False)
		If IsArray($aAttacker) And UBound($aAttacker) > 0 Then ExitLoop
		If $i = 15 Then
			SetLog("Builder Base Attack Screen is not visible!", $COLOR_WARNING)
			Return -1
		EndIf
	Next
	Local $hStarttime = _Timer_Init()

	; Reurn an Array [xx][0] = Name , [xx][1] = Xaxis , [xx][2] = Yaxis , [xx][3] = Level
	Local $aResultsUnSelected = _ImageSearchBundlesMultibot($g_sBundleAttackBarBB, $g_aBundleAttackBarBBParms[0], $g_aBundleAttackBarBBParms[1], $g_aBundleAttackBarBBParms[2], $g_bDebugBBattack)

	SetDebugLog("Benchmark Attack bar: " & (Round(_Timer_Diff($hStarttime), 2)) & "'ms")

	If Not IsArray($aResultsUnSelected) Then
		_DebugFailedImageDetection("Attackbar")
		Return -1
	EndIf
	SetDebugLog("$aResultsUnSelected " & UBound($aResultsUnSelected))

	Local $aAllResults = $aResultsUnSelected
	; Sort by X axis
	_ArraySort($aAllResults, 0, 0, 0, 1)

	For $i = 0 To UBound($aAllResults) - 1
		SetDebugLog(" - " & $aAllResults[$i][0] & " at " & $aAllResults[$i][1] & "x" & $aAllResults[$i][2])
		If $aAllResults[$i][0] = "Machine" Then $g_bIsMachinePresent = True
	Next

	; [0] = Troops Name , [1] = OCR X-axis , [2] - Quantities
	Local $aSlots[11][3]

	For $i = 0 To UBound($aSlots) - 1 ;Empty Initilize All Slots
		If Not $g_bRunState Then Return
		$aSlots[$i][0] = ""
		$aSlots[$i][1] = 0
		$aSlots[$i][2] = 0
	Next

	Local $bScreenCapture = False
	Local $iLastSlotX = 0 ;Store Last Processed Slot X-Axis Need for getting space between two slots
	Local $iTotalSpaceBetweenSlot = 0 ;Contains Total Space Between Processed Slot
	For $i = 0 To UBound($aAllResults) - 1
		Local $aTempSlot
		Local $iTroopQty
		If $aAllResults[$i][1] > 0 Then
			SetDebugLog(" - [X]:" & $aAllResults[$i][1] & " - " & $aAllResults[$i][0] & " - [Y]:" & $aAllResults[$i][2])
			; $aTempSlot = [0] = OCR X-Axis [1] = Slot position
			$aTempSlot = BuilderBaseAttackBarSlot(Number($aAllResults[$i][1]), $bScreenCapture, $iLastSlotX, $iTotalSpaceBetweenSlot)
			If UBound($aTempSlot) = 2 Then

				If $aAllResults[$i][0] = "Machine" Then
					$iTroopQty = 1
				Else
					$iTroopQty = Number(_getTroopCountSmall($aTempSlot[0], 640 + $g_iBottomOffsetYNew)) ; RC Done ; For small numbers when the troop isn't selected
					If $iTroopQty < 1 Then $iTroopQty = Number(_getTroopCountBig($aTempSlot[0], 633 + $g_iBottomOffsetYNew)) ; RC Done ; For Big numbers when the troop is selected
				EndIf

				If $g_bDebugSetlog Then SetDebugLog("OCR : " & $aTempSlot[0] & "|SLOT: " & $aTempSlot[1] & "|QTY: " & $iTroopQty, $COLOR_DEBUG) ;Debug
				$aSlots[$aTempSlot[1]][0] = $aAllResults[$i][0] ; Troop Enum Cross Reference
				$aSlots[$aTempSlot[1]][1] = $aTempSlot[0] ; OCR X axis
				$aSlots[$aTempSlot[1]][2] = $iTroopQty ;Quantities
			Else
				SetDebugLog("Error while detecting BB Attackbar", $COLOR_ERROR)
				SetDebugLog(" - [X]:" & $aAllResults[$i][1] & " - " & $aAllResults[$i][0] & " - [Y]:" & $aAllResults[$i][2])
			EndIf
		Else
			SetDebugLog("Error while detecting BB Attackbar", $COLOR_ERROR)
			SetDebugLog(" - [X]:" & $aAllResults[$i][1] & " - " & $aAllResults[$i][0] & " - [Y]:" & $aAllResults[$i][2])
		EndIf
		If $g_bRunState = False Then Return
	Next

	Local $Emtpy = True
	Setlog("Attack Bar:", $COLOR_SUCCESS)
	For $i = 0 To UBound($aSlots) - 1
		If Not $g_bRunState Then Return
		If $aSlots[$i][0] <> "" Then
			SetLog("[" & $i + 1 & "] - " & $aSlots[$i][2] & "x " & FullNametroops($aSlots[$i][0]), $COLOR_SUCCESS)
			$Emtpy = False
		EndIf
	Next

	If $Emtpy Then Return -1
	Return $aSlots

EndFunc   ;==>BuilderBaseAttackBar

Func BuilderBaseAttackBarSlot($iTroopsSlotPosX, ByRef $bScreenCapture, ByRef $iLastSlotX, ByRef $iTotalSpaceBetweenSlot)
	Local $Slottemp[2] = [0, 0]
	Local $iSpaceBetweenSlot = 0
	Local $iMaxSelectedSlotSize = 65 ;65 is for unselected slot
	Local $iSlot0XAxis = $g_bIsMachinePresent = True ? 65 : 69

	If Not $bScreenCapture Then
		If $g_bDebugSetlog Then SetDebugLog("_CaptureRegion 1 Time Only")
		_CaptureRegion()
		$bScreenCapture = True
	EndIf
	For $iTroopsSlotStartPosX = $iTroopsSlotPosX To $iTroopsSlotPosX - $iMaxSelectedSlotSize Step -1
		If ($iTroopsSlotStartPosX > 0) Then ;Just in case of 12 slot's this value can be in negative
			If _ColorCheck(_GetPixelColor($iTroopsSlotStartPosX, 722 + $g_iBottomOffsetYNew, False), Hex(0x000000, 6), 20) Then ExitLoop ; RC Done
		Else
			ExitLoop
		EndIf
		If $g_bRunState = False Then Return
	Next
	If ($iLastSlotX <> 0) Then
		; Space Between Two Slots (CurrentSlotX - LastSlotX - SlotSize) Will Give Space Between Slots.
		$iSpaceBetweenSlot = $iTroopsSlotStartPosX - $iLastSlotX - $iMaxSelectedSlotSize
		; FOR REMAIN TROOPS: Slot Was Missed Take Mod With SlotSize Then We Will Have Space Between Slots.
		$iSpaceBetweenSlot = Mod($iSpaceBetweenSlot, $iMaxSelectedSlotSize)
		; Plus Slots Difference
		$iTotalSpaceBetweenSlot = $iTotalSpaceBetweenSlot + $iSpaceBetweenSlot
		; Let's reserve the Slot Position
		$iLastSlotX = $iTroopsSlotStartPosX
	Else
		; Store The Last Slot Starting Position
		$iLastSlotX = $iTroopsSlotStartPosX
	EndIf
	; Slot OCR X
	$Slottemp[0] = $iTroopsSlotStartPosX + 14 ;For Reading Troops Quantity need to add 14 in Slot Starting X-Axis
	; Slot Number = Current slot X coordinate - Total Black Space Between Slots - 1st Slot Start X/ by slot size
	Local $iSlotNo = ($iTroopsSlotStartPosX - $iTotalSpaceBetweenSlot - $iSlot0XAxis) / $iMaxSelectedSlotSize
	$Slottemp[1] = Int(Ceiling($iSlotNo)) ;Round Up Just In Case 0.98
	If $g_bDebugSetlog Then SetDebugLog("Slot: " & $Slottemp[1] & "|" & Round($iSlotNo, 2) & " |SltStrtPosX: " & $iTroopsSlotStartPosX & " |SpcBtwenSlot:" & $iSpaceBetweenSlot & " |TtlSpcBtwen:" & $iTotalSpaceBetweenSlot)
	Return $Slottemp
EndFunc   ;==>BuilderBaseAttackBarSlot


Func BuilderBaseSelectCorrectScript(ByRef $AvailableTroops)

	If Not $g_bRunState Then Return

	Static $lastScript
	If Not $g_bChkBBRandomAttack Then
		$g_iBuilderBaseScript = 0
		$lastScript = $g_iBuilderBaseScript
		Setlog("Attack using the " & $g_sAttackScrScriptNameBB[$g_iBuilderBaseScript] & " script.", $COLOR_INFO)
		Return
	EndIf

	; Random script , but not the last
	For $i = 0 To 10
		$g_iBuilderBaseScript = Random(0, 2, 1)
		If $lastScript <> $g_iBuilderBaseScript Then
			$lastScript = $g_iBuilderBaseScript
			ExitLoop
		EndIf
	Next

	Local $aCamps[0]

	; Move backwards through the array deleting the blanks
	For $i = UBound($AvailableTroops) - 1 To 0 Step -1
		If $AvailableTroops[$i][0] = "" Then
			_ArrayDelete($AvailableTroops, $i)
		EndIf
	Next

	; Let's get the correct number of Army camps
	Local $CampsQuantities = 0
	For $i = 0 To UBound($AvailableTroops) - 1
		If $AvailableTroops[$i][0] <> "Machine" Then $CampsQuantities += 1
	Next

	Setlog("Attack using the " & $g_sAttackScrScriptNameBB[$g_iBuilderBaseScript] & " script.", $COLOR_INFO)
	Setlog("Available " & $CampsQuantities & " Camps.", $COLOR_INFO)

	Local $SwicthBtn[6] = [105, 180, 252, 324, 397, 469]

	; Let load the Command [Troop] from CSV
	Local $FileNamePath = @ScriptDir & "\CSV\BuilderBase\" & $g_sAttackScrScriptNameBB[$g_iBuilderBaseScript] & ".csv"
	If FileExists($FileNamePath) Then
		Local $aLines = FileReadToArray($FileNamePath)
		; Loop for every line on CSV
		For $iLine = 0 To UBound($aLines) - 1
			If Not $g_bRunState Then Return
			Local $aSplitLine = StringSplit($aLines[$iLine], "|", $STR_NOCOUNT)
			Local $command = StringStripWS(StringUpper($aSplitLine[0]), $STR_STRIPALL)
			If $command = "CAMP" Then
				For $i = 1 To UBound($aSplitLine) - 1
					If $aSplitLine[$i] = "" Or StringIsSpace($aSplitLine[$i]) Then ExitLoop
					ReDim $aCamps[UBound($aCamps) + 1]
					$aCamps[UBound($aCamps) - 1] = StringStripWS($aSplitLine[$i], $STR_STRIPALL)
				Next
				; Select the correct CAMP [cmd line] to use according with the first attack bar detection = how many camps do you have
				If $CampsQuantities = UBound($aCamps) Then
					If $g_bDebugSetlog Then Setlog(_ArrayToString($aCamps, "-", -1, -1, "|", -1, -1))
					ExitLoop
				Else
					Local $aCamps[0]
				EndIf
			EndIf
		Next
	EndIf

	If UBound($aCamps) < 1 Then Return

	; $g_asBBTroopShortNames[$eBBTroopCount] = ["Barb", "Arch", "Giant", "Beta", "Bomb", "BabyDrag", "Cannon", "Night", "Drop", "Pekka", "Machine"]

	;Result Of BelowCode e.g $aCamps
	;$aCamps Before :Giant-Barb-Barb-Bomb-Cannon-Cannon

	;First Find The Correct Index Of Camps In Attack Bar
	For $i = 0 To UBound($aCamps) - 1
		;Just In Case Someone Mentioned Wrong Troop Name Select Default Barb Troop
		$aCamps[$i] = _ArraySearch($g_asBBTroopShortNames, $aCamps[$i]) < 0 ? 0 : _ArraySearch($g_asBBTroopShortNames, $aCamps[$i])
	Next
	;After populate with the new priority position let's sort ascending column 1
	_ArraySort($aCamps, 0, 0, 0, 1)
	;Just Assign The Short Names According to new priority positions
	For $i = 0 To UBound($aCamps) - 1
		$aCamps[$i] = $g_asBBTroopShortNames[$aCamps[$i]]
	Next
	;$aCamps Will Become :Barb-Barb-Giant-Bomb-Cannon-Cannon

	; [0] = Troops Name , [1] - Priority position
	Local $NewAvailableTroops[UBound($AvailableTroops)][2]

	For $i = 0 To UBound($AvailableTroops) - 1
		$NewAvailableTroops[$i][0] = $AvailableTroops[$i][0]
		$NewAvailableTroops[$i][1] = _ArraySearch($g_asBBTroopShortNames, $AvailableTroops[$i][0])
	Next

	If $g_bDebugSetlog Then setlog(_ArrayToString($NewAvailableTroops, "-", -1, -1, "|", -1, -1))

	Local $Waschanged = False
	Local $avoidInfLoop = 0

	For $i = 0 To $CampsQuantities - 1
		If StringCompare($NewAvailableTroops[$i][0], $aCamps[$i]) <> 0 Then
			$Waschanged = True
			Setlog("Incorrect troop On Camp " & $i + 1 & " - " & $NewAvailableTroops[$i][0] & " -> " & $aCamps[$i])
			Local $PointSwitch = [$SwicthBtn[$i], 708 + $g_iBottomOffsetYNew] ; RC Done
			ClickP($PointSwitch, 1, 0)
			If Not _WaitForCheckXML(@ScriptDir & "\imgxml\BuildersBase\Attack\VersusBattle\ChangeTroops\", "0,400,855,25", True, 10000, 250) Then ; RC Done
				Setlog("_WaitForCheckXML Error at Camps!", $COLOR_ERROR)
				$i = $i - 1
				$avoidInfLoop += 1
				If $avoidInfLoop = 20 Then ExitLoop
				If _sleep(10) Then ExitLoop
				If Not $g_bRunState Then ExitLoop
				ContinueLoop
			EndIf
			; Result [X][0] = NAME , [x][1] = Xaxis , [x][2] = Yaxis , [x][3] = Level
			Local $aAttackBar = _ImageSearchBundlesMultibot($g_sBundleAttackBarBB, $g_aBundleAttackBarSwitchBBParms[0], $g_aBundleAttackBarSwitchBBParms[1], $g_aBundleAttackBarSwitchBBParms[2], False)
			If Not IsArray($aAttackBar) And UBound($aAttackBar) < 1 Then
				_DebugFailedImageDetection("Attackbar")
			EndIf
			For $j = 0 To UBound($aAttackBar) - 1
				If Not $g_bRunState Then ExitLoop
				If $aAttackBar[$j][0] = $aCamps[$i] Then
					Local $Point = [$aAttackBar[$j][1], $aAttackBar[$j][2]]
					ClickP($Point, 1, 0)
					If _sleep(1000) Then Return
					Setlog("Selected " & FullNametroops($aCamps[$i]), $COLOR_SUCCESS)
					$NewAvailableTroops[$i][0] = $aCamps[$i]
					$NewAvailableTroops[$i][1] = _ArraySearch($g_asBBTroopShortNames, $aCamps[$i])
					; After populate with the new prio position let's sort ascending column 1
					_ArraySort($NewAvailableTroops, 0, 0, 0, 1)
					If $g_bDebugSetlog Then Setlog("New tab is " & _ArrayToString($NewAvailableTroops, "-", -1, -1, "|", -1, -1), $COLOR_INFO)
					; Now let's restart the for loop , is a nesty way to do but is only to tests
					$i = -1
					ExitLoop
				EndIf
			Next
		EndIf
	Next

	If Not $Waschanged Then Return

	If _sleep(1000) Then Return

	; populate the correct array with correct Troops
	For $i = 0 To UBound($NewAvailableTroops) - 1
		$AvailableTroops[$i][0] = $NewAvailableTroops[$i][0]
	Next

	For $i = 0 To UBound($AvailableTroops) - 1
		If Not $g_bRunState Then Return
		If $AvailableTroops[$i][0] <> "" Then ;We Just Need To redo the ocr for mentioned troop only
			$AvailableTroops[$i][2] = Number(_getTroopCountBig(Number($AvailableTroops[$i][1]), 633 + $g_iBottomOffsetYNew)) ; RC Done
			If $AvailableTroops[$i][2] < 1 Then $AvailableTroops[$i][2] = Number(_getTroopCountSmall(Number($AvailableTroops[$i][1]), 640 + $g_iBottomOffsetYNew)) ; RC Done ; For Small numbers when the troop is selected
			If $AvailableTroops[$i][0] = "Machine" Then $AvailableTroops[$i][2] = 1
		EndIf
	Next

	For $i = 0 To UBound($AvailableTroops) - 1
		If Not $g_bRunState Then Return
		If $AvailableTroops[$i][0] <> "" Then SetLog("[" & $i + 1 & "] - " & $AvailableTroops[$i][2] & "x " & FullNametroops($AvailableTroops[$i][0]), $COLOR_SUCCESS)
	Next
EndFunc   ;==>BuilderBaseSelectCorrectScript
