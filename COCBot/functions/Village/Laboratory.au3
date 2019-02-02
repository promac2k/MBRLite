; #FUNCTION# ====================================================================================================================
; Name ..........: Laboratory
; Description ...:
; Syntax ........: Laboratory()
; Parameters ....:
; Return values .: None
; Author ........: summoner
; Modified ......: KnowJack (2015-06), Sardo (2015-08), Monkeyhunter(2016-02,2016-04), MMHK(2018-06)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func Laboratory($test = False)

	Local $iAvailElixir, $iAvailDark, $sElixirCount, $sDarkCount, $TimeDiff, $aArray, $Result

	$g_iUpgradeMinElixir = Number($g_iUpgradeMinElixir)
	$g_iUpgradeMinDark = Number($g_iUpgradeMinDark)

	$g_iLaboratoryElixirCost = 0
	If Not $g_bAutoLabUpgradeEnable Then Return ; Lab upgrade not enabled.

	If $g_iCmbLaboratory = 0 Then
		SetLog("Laboratory enabled, but no troop upgrade selected", $COLOR_WARNING)
		Return False ; Nothing selected to upgrade
	EndIf

	If $g_aiLaboratoryPos[0] = 0 Or $g_aiLaboratoryPos[1] = 0 Then
		SetLog("Laboratory Location not found!", $COLOR_WARNING)
		LocateLab() ; Lab location unknown, so find it.
		If $g_aiLaboratoryPos[0] = 0 Or $g_aiLaboratoryPos[1] = 0 Then
			SetLog("Problem locating Laboratory, train laboratory position before proceeding", $COLOR_ERROR)
			Return False
		EndIf
	EndIf

	If $g_sLabUpgradeTime <> "" Then $TimeDiff = _DateDiff("n", _NowCalc(), $g_sLabUpgradeTime) ; what is difference between end time and now in minutes?
	If @error Then _logErrorDateDiff(@error)
	If $g_bDebugSetlog Or $test Then SetDebugLog($g_avLabTroops[$g_iCmbLaboratory][3] & " Lab end time: " & $g_sLabUpgradeTime & ", DIFF= " & $TimeDiff, $COLOR_DEBUG)

	If Not $g_bRunState Then Return
	If $TimeDiff <= 0 Then
		SetLog("Checking Troop Upgrade in Laboratory ...", $COLOR_INFO)
	Else
		SetLog("Laboratory Upgrade in progress, waiting for completion", $COLOR_INFO)
		Return False
	EndIf

	; Get updated village elixir and dark elixir values
	If _CheckPixel($aVillageHasDarkElixir, $g_bCapturePixel) Then ; check if the village have a Dark Elixir Storage
		$sElixirCount = getResourcesMainScreen(696, 74)
		$sDarkCount = getResourcesMainScreen(728, 123)
		SetLog("Updating village values [E]: " & $sElixirCount & " [D]: " & $sDarkCount, $COLOR_SUCCESS)
	Else
		$sElixirCount = getResourcesMainScreen(701, 74)
		SetLog("Updating village values [E]: " & $sElixirCount, $COLOR_SUCCESS)
	EndIf

	$iAvailElixir = Number($sElixirCount)
	$iAvailDark = Number($sDarkCount)

	; Array to hold Laboratory Troop information [LocX , LocY , PageLocation, Troop "name", Icon # in DLL file , Upgrade Value]
	; $g_avLabTroops[36][6]

	If $g_avLabTroops[$g_iCmbLaboratory][5] > 0 Then
		If IsElixir2USe() Then
			If $g_avLabTroops[$g_iCmbLaboratory][5] + $g_iUpgradeMinElixir > $iAvailElixir Then
				SetLog("Insufficent Elixir for " & $g_avLabTroops[$g_iCmbLaboratory][3] & ", Lab requires: " & $g_avLabTroops[$g_iCmbLaboratory][5] & " + " & $g_iUpgradeMinElixir & " user reserve, available: " & $iAvailElixir, $COLOR_INFO)
				ClickP($aAway, 2, $DELAYLABORATORY4, "#0355")
				Return False
			EndIf
		Else
			If $g_avLabTroops[$g_iCmbLaboratory][5] + $g_iUpgradeMinDark > $iAvailDark Then
				SetLog("Insufficent Dark Elixir for " & $g_avLabTroops[$g_iCmbLaboratory][3] & ", Lab requires: " & $g_avLabTroops[$g_iCmbLaboratory][5] & " + " & $g_iUpgradeMinDark & " user reserve, available: " & $iAvailDark, $COLOR_INFO)
				Return False
			EndIf
		EndIf
	EndIf

	If $g_avLabTroops[$g_iCmbLaboratory][5] = -1 Then
		SetLog($g_avLabTroops[$g_iCmbLaboratory][3] & " already max level, select another troop", $COLOR_ERROR)
		Return False
	EndIf

	;Click Laboratory
	BuildingClickP($g_aiLaboratoryPos, "#0197")
	If _Sleep($DELAYLABORATORY3) Then Return ; Wait for window to open

	; Find Research Button
	; NEW CODE - IMAGE DETECTION
	Local $sResearch = GetButtonDiamond("Research")
	Local $aResearchOptions = findMultiple($g_sImgResearch, $sResearch, $sResearch, 0, 1000, 3, "objectname,objectpoints", True)
	If $aResearchOptions <> "" And IsArray($aResearchOptions) Then
		For $i = 0 To UBound($aResearchOptions, $UBOUND_ROWS) - 1
			Local $aTempArray = $aResearchOptions[$i]
			If UBound($aTempArray) >= 2 Then
				If $g_bDebugImageSave Then DebugImageSave("LabUpgrade")
				Local $aTempBtnCoords = StringSplit($aTempArray[1], ",", $STR_NOCOUNT)
				If IsMainPage() Then ClickP($aTempBtnCoords, 1, 0, "#0198") ; Click Research Button
				If _Sleep($DELAYLABORATORY3) Then Return ; Wait for window to open
			EndIf
		Next
	Else
		SetLog("Trouble finding research button, try again...", $COLOR_WARNING)
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0199")
		Return False
	EndIf

	; check for upgrade in process - look for green in finish upgrade with gems button
	If $g_bDebugSetlog Then SetLog("_GetPixelColor(683, 169): " & _GetPixelColor(683, 169, True) & ":e6fc90", $COLOR_DEBUG)
	If _ColorCheck(_GetPixelColor(683, 169, True), Hex(0xe6fc90, 6), 20) Then
		SetLog("Laboratory Upgrade in progress, waiting for completion", $COLOR_INFO)
		If _Sleep($DELAYLABORATORY2) Then Return
		; upgrade in process and time not recorded so update completion time!
		Local $sLabTimeOCR = getRemainTLaboratory(270, 212)
		Local $iLabFinishTime = ConvertOCRTime("Lab Time", $sLabTimeOCR, False)
		SetDebugLog("$sLabTimeOCR: " & $sLabTimeOCR & ", $iLabFinishTime = " & $iLabFinishTime & " m")
		If $iLabFinishTime > 0 Then
			$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), _NowCalc())
			If @error Then _logErrorDateAdd(@error)
			SetLog("Research will finish in " & $sLabTimeOCR & " (" & $g_sLabUpgradeTime & ")")
			LabStatusGUIUpdate() ; Update GUI flag
		ElseIf $g_bDebugSetlog Then
			SetLog("Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
		EndIf
		ClickP($aAway, 2, $DELAYLABORATORY4, "#0328")
		Return False
	EndIf

	; Possible window for the XX troop/Spell/Siege
	Local $Window = WhatWindow()
	If $test Then setlog("Window: " & $Window)

	If _Sleep($DELAYLABORATORY3) Then Return

#Tidy_Off
	Local  $aShortNames[36] = [ "", "Barb", "Arch", "Giant", "Gobl", "Wall", "Ball", "Wiza", "Heal", "Drag", "Pekk", "BabyD", "Mine", "EDrag", _
									"LSpell", "HSpell", "RSpell", "JSpell", "FSpell", "CSpell", "PSpell", "ESpell", "HaSpell", "SkSpell", "BaSpell", _
									"Mini", "Hogs", "Valk", "Gole", "Witc", "Lava", "Bowl", "IceG", _
									"WallW", "BattleB", "StoneS"]
#Tidy_On


	Local $Slide2 = 300
	If $g_sAndroidEmulator = "BlueStacks2" Then $Slide2 = 100

	; Just in csae of slow dragclick
	For $i = 0 To 2
		If $Window > 1 Then
			ClickDrag(735, 423, $Slide2, 423, 50, True)
			If _Sleep($DELAYLABORATORY3) Then Return
		EndIf
		If $Window > 2 Then
			ClickDrag(735, 423, $Slide2, 423, 50, True)
			If _Sleep($DELAYLABORATORY3) Then Return
		EndIf

		; Capture the screen for comparison
		Local $x = 110
		Local $y = 366 + $g_iMidOffsetYNew
		_CaptureRegion2($x, $y, 740, 568 + $g_iMidOffsetYNew) ; RC Done

		; Let's Search for the Selected troop/Spell/Siege
		Local $sFilter = String($aShortNames[$g_iCmbLaboratory]) & "*"
		Local $asImageToUse = _FileListToArray($g_sImgResearchLab, $sFilter, $FLTA_FILES, True)
		Local $asResult = DllCallMyBot("FindTile", "handle", $g_hHBitmap2, "str", $asImageToUse[1], "str", "FV", "int", 1)

		If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error)

		Local $detection[2] = [0, 0]

		If IsArray($asResult) Then
			If $asResult[0] = "0" Then
				SetLog("No " & $aShortNames[$g_iCmbLaboratory] & " Icon found, attempted " & $i + 1, $COLOR_ERROR)
				ContinueLoop
			ElseIf $asResult[0] = "-1" Then
				SetLog("Laboratory.au3 GetIcon(): ImgLoc DLL Error Occured!", $COLOR_ERROR)
			ElseIf $asResult[0] = "-2" Then
				SetLog("Laboratory.au3 GetIcon(): Wrong Resolution used for ImgLoc Search!", $COLOR_ERROR)
			Else
				If $g_bDebugSetlog Or $test Then SetLog("String: " & $asResult[0])
				Local $aResult = StringSplit($asResult[0], "|", $STR_NOCOUNT)
				Local $aCoordinates = StringSplit($aResult[1], ",", $STR_NOCOUNT)
				$detection[0] = $x + Int($aCoordinates[0])
				$detection[1] = $y + Int($aCoordinates[1]) ; RC Done
				SetLog("Found " & $g_avLabTroops[$g_iCmbLaboratory][3] & " [" & $detection[0] & "," & $detection[1] & "]", $COLOR_SUCCESS)
				ExitLoop
			EndIf
		Else
			SetLog("Don't know how to Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][3])
		EndIf
	Next

	; Let's get the OCR for Red or White
	If $detection[0] <> 0 And $detection[1] <> 0 Then
		; [0] is Yaxis , [1] Xaxis OCR Start , [2] Xaxis OCR Ends
		Local $FinalResult = GetTheStartAndEndSlotOCR($detection)
		If $FinalResult = -1 Then
			ClickP($aAway, 2, $DELAYLABORATORY4, "#0355")
			Return False
		EndIf
		If $g_bDebugSetlog Or $test Then SetLog("String OCR Position : " & _ArrayToString($FinalResult))
		; Red
		Local $Values = Number(getLabUpgrdResourceRed($FinalResult[1], $FinalResult[0]))
		If $g_bDebugSetlog Or $test Then SetLog("String OCR Red : " & $Values)
		If $Values = "" Or Not IsNumber($Values) Then
			; White
			$Values = Number(getLabUpgrdResourceWht($FinalResult[1], $FinalResult[0]))
			; Didn't get any value can be already max level
			If $Values = "" Or Not IsNumber($Values) Or $Values = 111 Then
				SetLog($g_avLabTroops[$g_iCmbLaboratory][3] & " already max level, select another troop", $COLOR_ERROR)
				$g_avLabTroops[$g_iCmbLaboratory][5] = -1
			Else
				$g_avLabTroops[$g_iCmbLaboratory][5] = $Values
				If IsElixir2USe() Then
					If $g_avLabTroops[$g_iCmbLaboratory][5] + $g_iUpgradeMinElixir > $iAvailElixir Then
						SetLog("Insufficent Elixir for " & $g_avLabTroops[$g_iCmbLaboratory][3] & ", Lab requires: " & $g_avLabTroops[$g_iCmbLaboratory][5] & " + " & $g_iUpgradeMinElixir & " user reserve, available: " & $iAvailElixir, $COLOR_INFO)
						ClickP($aAway, 2, $DELAYLABORATORY4, "#0355")
						Return False
					EndIf
				Else
					If $g_avLabTroops[$g_iCmbLaboratory][5] + $g_iUpgradeMinDark > $iAvailDark Then
						SetLog("Insufficent Dark Elixir for " & $g_avLabTroops[$g_iCmbLaboratory][3] & ", Lab requires: " & $g_avLabTroops[$g_iCmbLaboratory][5] & " + " & $g_iUpgradeMinDark & " user reserve, available: " & $iAvailDark, $COLOR_INFO)
						Return False
					EndIf
				EndIf
				LabUpgrade($detection, $test)
			EndIf
		Else
			; Values are Red , you don't have enough resources to Upgrade , let's reserve the values
			$g_avLabTroops[$g_iCmbLaboratory][5] = $Values
			Local $text = IsElixir2USe() ? "Elixir" : "Dark Elixir"
			SetLog("Insufficent " & $text & " for " & $g_avLabTroops[$g_iCmbLaboratory][3] & " is necessary " & $g_avLabTroops[$g_iCmbLaboratory][5])
		EndIf
	EndIf

	ClickP($aAway, 2, $DELAYLABORATORY4, "#0359")
	Return False

EndFunc   ;==>Laboratory
;

Func LabUpgrade($detection, $test = False)
	Local $StartTime, $EndTime, $EndPeriod, $Result, $TimeAdd = 0

	; If none of other error conditions apply, begin upgrade process
	Click($detection[0], $detection[1], 1, 0, "#0200") ; Click Upgrade troop button
	If _Sleep($DELAYLABUPGRADE1) Then Return ; Wait for window to open
	If $g_bDebugImageSave Or $test Then DebugImageSave("LabUpgrade")

	; get upgrade time from window
	$Result = getLabUpgradeTime(580, 494 + $g_iMidOffsetYNew) ; RC Done ; Try to read white text showing time for upgrade
	Local $iLabFinishTime = ConvertOCRTime("Lab Time", $Result, False)
	If $g_bDebugSetlog Then SetLog($g_avLabTroops[$g_iCmbLaboratory][3] & " Upgrade OCR Time = " & $Result & ", $iLabFinishTime = " & $iLabFinishTime & " m", $COLOR_INFO)
	$StartTime = _NowCalc() ; what is date:time now
	If $g_bDebugSetlog Or $test Then SetDebugLog($g_avLabTroops[$g_iCmbLaboratory][3] & " Upgrade Started @ " & $StartTime, $COLOR_SUCCESS)
	If $iLabFinishTime > 0 Then
		$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), $StartTime)
		SetLog($g_avLabTroops[$g_iCmbLaboratory][3] & " Upgrade Finishes @ " & $Result & " (" & $g_sLabUpgradeTime & ")", $COLOR_SUCCESS)

		Local $txtTip = GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_06", "Troop Upgrade started") & ": " & $StartTime & ", " & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_07", "Will begin to check completion at:") & " " & $g_sLabUpgradeTime & @CRLF & " "
		_GUICtrlSetTip($g_hBtnResetLabUpgradeTime, $txtTip)

		If Not $test Then Click(660, 520 + $g_iMidOffsetY, 1, 0, "#0202") ; Everything is good - Click the upgrade button
		If _Sleep($DELAYLABUPGRADE1) Then Return
	Else
		SetLog("Error processing upgrade time required, try again!", $COLOR_WARNING)
		Return False
	EndIf

	If isGemOpen(True) = False Then ; check for gem window
		; check for green button to use gems to finish upgrade, checking if upgrade actually started
		If Not (_ColorCheck(_GetPixelColor(625, 218 + $g_iMidOffsetY, True), Hex(0x6fbd1f, 6), 15) Or _ColorCheck(_GetPixelColor(660, 218 + $g_iMidOffsetY, True), Hex(0x6fbd1f, 6), 15)) Then
			SetLog("Something went wrong with " & $g_avLabTroops[$g_iCmbLaboratory][3] & " Upgrade, try again.", $COLOR_ERROR)
			ClickP($aAway, 2, $DELAYLABUPGRADE3, "#0360")
			Return False
		EndIf
		SetLog("Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][3] & " in your laboratory started with success...", $COLOR_SUCCESS)
		PushMsg("LabSuccess")
		If _Sleep($DELAYLABUPGRADE2) Then Return
		$g_bAutoLabUpgradeEnable = False ;reset enable lab upgrade flag
		GUICtrlSetState($g_hChkAutoLabUpgrades, $GUI_UNCHECKED) ; reset enable lab upgrade check box

		ClickP($aAway, 2, 0, "#0204")

		Return True
	Else
		SetLog("Oops, Gems required for " & $g_avLabTroops[$g_iCmbLaboratory][3] & " Upgrade, try again.", $COLOR_ERROR)
	EndIf

	ClickP($aAway, 2, $DELAYLABUPGRADE3, "#0205")
	Return False

EndFunc   ;==>LabUpgrade

Func IsElixir2USe()
	Switch $g_iCmbLaboratory
		Case 1 To 19 ; regular elixir
			Return True
		Case 33 To 36
			Return True
		Case 20 To 32 ; Dark Elixir
			Return False
		Case Else
			SetLog("Something went wrong with loot value on Lab upgrade on #" & $g_avLabTroops[$g_iCmbLaboratory][3], $COLOR_ERROR)
			Return False
	EndSwitch
EndFunc   ;==>IsElixir2USe

Func WhatWindow()
	Switch $g_iCmbLaboratory
		Case 1 To 12 ; regular elixir
			Return 1
		Case 13 To 24
			Return 2
		Case 25 To 35 ; Dark Elixir
			Return 3
		Case Else
			SetLog("Something went wrong with loot value on Lab upgrade on #" & $g_avLabTroops[$g_iCmbLaboratory][3], $COLOR_ERROR)
			Return False
	EndSwitch
EndFunc   ;==>WhatWindow

; ProMac January 2019 Future Lab Code
Func GetTheStartAndEndSlotOCR($detection, $ScreenCapture = True)

	If UBound($detection) <> 2 Then Return -1

	; [0] is Yaxis , [1] Xaxis OCR Start , [2] Xaxis OCR Ends
	Local $FinalResult[3] = [0, 0, 0]

	; YAxis
	Switch $detection[1]
		Case 300 To 420
			$FinalResult[0] = 399
		Case 430 To 550
			$FinalResult[0] = 504
		Case Else
			Return -1
	EndSwitch

	If $ScreenCapture Then _CaptureRegion()

	; Let get the start slot position
	For $i = $detection[0] To $detection[0] - 100 Step -1
		If _ColorCheck(_GetPixelColor($i, $FinalResult[0], False), Hex(0xd3d3cb, 6), 5) Or _ ; Grey from Background Slots
				_ColorCheck(_GetPixelColor($i, $FinalResult[0], False), Hex(0xe8e8e0, 6), 5) Then ; Grey from Window Border
			$FinalResult[1] = $i
			If $g_bDebugSetlog Then Setlog("Start at: " & $i & " Xaxis")
			ExitLoop
		EndIf
	Next

	; Let get the end slot position
	For $i = $detection[0] To $detection[0] + 100
		If _ColorCheck(_GetPixelColor($i, $FinalResult[0], False), Hex(0xd3d3cb, 6), 5) Or _ ; Grey from Background Slots
				_ColorCheck(_GetPixelColor($i, $FinalResult[0], False), Hex(0xe8e8e0, 6), 5) Then ; Grey from Window Border
			$FinalResult[2] = $i
			If $g_bDebugSetlog Then Setlog("Ends at: " & $i & " Xaxis")
			ExitLoop
		EndIf
	Next

	Return $FinalResult
EndFunc   ;==>GetTheStartAndEndSlotOCR
