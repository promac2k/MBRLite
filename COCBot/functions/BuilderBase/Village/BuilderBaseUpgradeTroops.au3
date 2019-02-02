; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseUpgradeTroops
; Description ...: Builder Base Upgrade Troops
; Syntax ........: BBUpgradeTroops()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018)
; Modified ......:
; Remarks .......: This file is part of MultiBot, previously known as Mybot and ClashGameBot. Copyright 2015-2018
;                  MultiBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func TestBBUpgradeTroops()
	Setlog("** TestBBUpgradeTroops START**", $COLOR_DEBUG)
	Local $gbDebugOcr = $g_bDebugOcr
	Local $Status = $g_bRunState
	$g_bDebugOcr = True
	$g_bRunState = True
	BuilderBaseReport()
	; 1 Test Troops, 2 Test machine , 3 Test the first Check
	BuilderBaseUpgradeTroops(2)
	$g_bRunState = $Status
	$g_bDebugOcr = $gbDebugOcr
	Setlog("** TestBBUpgradeTroops END**", $COLOR_DEBUG)
EndFunc   ;==>TestBBUpgradeTroops

Func BuilderBaseUpgradeTroops($Test = 0)

	; If is to run
	If Not $g_bChkUpgradeTroops And $Test = 0 Then Return

	;Just to debug
	FuncEnter(BuilderBaseUpgradeTroops)

	ClickP($aAway, 1, 0, "#0900") ;Click Away

	; Static Variables
	Local Static $bIsFirstRun[8] = [True, True, True, True, True, True, True, True]
	; [0] = Remain Upgrade time for next level  [1] = Machine next Level , [2] = Machine Next level cost
	Local Static $aMachineStatus[8][3]

	Local Static $aRemainLabtime[8]
	Local Static $aElixirStorageCap[8]
	Local Static $TimerToCheck[8]

	; [8] total accounts , [2] = Name and Upgrade value
	Local Static $aTroopsToUpgrade[8][2]

	;Local Varibales
	Local $MachineUpgTimes[25] = [12, 12, 12, 24, 24, 24, 24, 24, 24, 24, 48, 48, 48, 48, 48, 72, 72, 72, 72, 72, 72, 72, 72, 72, 72] ; Hours
	Local $MachineUpgCost[25] = [900000, 1000000, 1100000, 1200000, 1300000, 1500000, 1600000, 1700000, 1800000, 1900000, 2100000, 2200000, 2300000, 2400000, 2500000, 2600000, 2700000, 2800000, 2900000, 3000000, 3100000, 3200000, 3300000, 3400000, 3500000]
	Local $bDoNotProceedWithMachine = False

	; Just to force each day to update all values , example if the Elixir Stroage was updated the Cap is differente
	If @YDAY <> $TimerToCheck[$g_iCurAccount] Then $bIsFirstRun[$g_iCurAccount] = True

	; Just for tests
	If $Test = 3 Then $bIsFirstRun[$g_iCurAccount] = True

	; ZoomOut Check
	AndroidOnlyZoomOut()

	; First Round
	; First run Check the Machine if exist or not => $aMachineStatus[8][3] , [0] = Remain Upgrade time for next level  [1] = Machine next Level , [2] = Machine Next level cost
	; Check Machine level , reserve the update values => $aMachineStatus[8][3]
	; we need to peek the Cap Elixir Storages value on Main at Elixir values , why? if we don't have enough capacity for Machine Upgrade value?! => $aElixirStorageCap[8]

	; First run Check the Lab
	; If is running reserve the Remain time =>  $aRemainLabtime[8] each account
	; Peek the correct Troops to upgrade => $aTroopsToUpgrade[8][2] = [8] total accounts , [2] = Name and Upgrade value
	; Select the correct from UI or ANY with lower value

	If $bIsFirstRun[$g_iCurAccount] Then
		Setlog("Upgrades troops first Check started!", $COLOR_ACTION)
		;Reset and populate variables
		For $i = 0 To 2
			$aMachineStatus[$g_iCurAccount][$i] = -1
		Next
		$aRemainLabtime[$g_iCurAccount] = -1
		$aElixirStorageCap[$g_iCurAccount] = -1
		$bIsFirstRun[$g_iCurAccount] = False
		$TimerToCheck[$g_iCurAccount] = @YDAY
		$aTroopsToUpgrade[$g_iCurAccount][0] = -1
		$aTroopsToUpgrade[$g_iCurAccount][1] = -1

		; Verify Machine
		If $g_bChkUpgradeMachine Then BuilderBaseCheckMachine($aMachineStatus, $Test)

		;Verify Elixir Storage Cap
		If $g_bChkUpgradeMachine Then BuilderBaseCheckElixirStorageCap($aElixirStorageCap, $Test)

		;Verify Lab
		BuilderBaseCheckLab($aRemainLabtime, $Test)

		;Verify what troop is selected on UI
		$aTroopsToUpgrade[$g_iCurAccount][0] = $g_iCmbBBLaboratory < 10 ? $g_asBBTroopNames[$g_iCmbBBLaboratory] : "Any"

		Setlog("Upgrades troops first Check ended!", $COLOR_ACTION)
		If _Sleep(500) Then Return
		ClickP($aAway, 2, 100, "#0900") ;Click Away
		FuncReturn()
		Return
	EndIf

	; Remain Times and if we are waiting or Not
	Local $TimeDiff = 0
	; what is difference between end time and now in minutes? and reserve it at $TimeDiff
	If $aRemainLabtime[$g_iCurAccount] <> 0 Then $TimeDiff = _DateDiff("n", _NowCalc(), $aRemainLabtime[$g_iCurAccount])

	; Verify Level and Cost from machine, if is not exist or is maxed
	If $aMachineStatus[$g_iCurAccount][1] > 0 And $aMachineStatus[$g_iCurAccount][1] < 25 And $g_bChkUpgradeMachine Then
		Local $MachineLevel = $aMachineStatus[$g_iCurAccount][1]
		$aMachineStatus[$g_iCurAccount][0] = $MachineUpgTimes[$MachineLevel]
		$aMachineStatus[$g_iCurAccount][2] = $MachineUpgCost[$MachineLevel]
		Setlog("Current Machine level is " & $aMachineStatus[$g_iCurAccount][1], $COLOR_INFO)
		Setlog("Next Upgrade will cost " & $MachineUpgCost[$MachineLevel], $COLOR_INFO)
		Setlog("With remain time of " & $MachineUpgTimes[$MachineLevel] & " hours", $COLOR_INFO)
		; Verifing Elixir Storage Cap and Machine Value
		If Number($MachineUpgCost[$MachineLevel]) > Number($aElixirStorageCap[$g_iCurAccount]) Then
			$bDoNotProceedWithMachine = True
			Setlog("Elixir Storage Capacity lower than Upg value!", $COLOR_WARNING)
		EndIf
		; Verify if is a specific troop selected
		If $aTroopsToUpgrade[$g_iCurAccount][0] <> "Any" Then
			$bDoNotProceedWithMachine = True
			Setlog($aTroopsToUpgrade[$g_iCurAccount][0] & " selected to upgrade", $COLOR_INFO)
		EndIf
	Else
		; Machine is not to Upgrade
		$bDoNotProceedWithMachine = True
	EndIf

	; Is Not to proceed with Machine
	If $bDoNotProceedWithMachine Or $Test = 1 Then
		;Check the remain Lab Times
		If $TimeDiff <= 0 Or $Test > 0 Then
			; If the Troop Upgrade Value is > Elixir or was not cheked
			If Number($aTroopsToUpgrade[$g_iCurAccount][1]) < Number($g_aiCurrentLootBB[$eLootElixirBB]) Or Number($aTroopsToUpgrade[$g_iCurAccount][1]) = -1 Then
				SetLog("Checking Troop Upgrade in Lab ...", $COLOR_INFO)
				If BuilderBaseUpgradeTroop($aRemainLabtime, $aTroopsToUpgrade, $Test) Then
					;Verify what troop is selected on UI , reset
					$aTroopsToUpgrade[$g_iCurAccount][0] = "Any"
					$aTroopsToUpgrade[$g_iCurAccount][1] = -1
				EndIf
			Else
				SetLog("Not Enough Elixir to Upgrade " & $aTroopsToUpgrade[$g_iCurAccount][0], $COLOR_INFO)
			EndIf
		Else
			SetLog("Lab Upgrade in progress until " & $aRemainLabtime[$g_iCurAccount] & "...", $COLOR_INFO)
		EndIf
	ElseIf $Test = 2 Or Not $bDoNotProceedWithMachine Then
		If Number($aMachineStatus[$g_iCurAccount][2]) < Number($g_aiCurrentLootBB[$eLootElixirBB]) Then
			BuilderBaseUpgradeMachine($Test)
		Else
			SetLog("Not Enough Elixir to Upgrade Machine!", $COLOR_INFO)
		EndIf
	EndIf

	If _Sleep(2000) Then Return
	ClickP($aAway, 2, 1000, "#0900") ;Click Away
	FuncReturn()
EndFunc   ;==>BuilderBaseUpgradeTroops


; Extra Methods
; First Check
Func BuilderBaseCheckMachine(ByRef $aMachineStatus, $Test = 0)
	ClickP($aAway, 2, 300, "#900") ;Click Away
	; $aMachineStatus[X][0] = Remain Upgrade time for next level  [1] = Machine next Level , [2] = Machine Next level cost

	If IsMainPageBuilderBase() Then
		; Machine Detection
		Local $MachinePosition = _ImageSearchXMLMultibot($g_sXMLTroopsUpgradeMachine, $g_aXMLToForceBuilderBaseParms[0], $g_aXMLToForceBuilderBaseParms[1], $g_aXMLToForceBuilderBaseParms[2], $Test)
		If IsArray($MachinePosition) And UBound($MachinePosition) > 0 Then
			If $Test > 0 Then Setlog("Machine Found: " & _ArrayToString($MachinePosition))
			Click($MachinePosition[0][1], $MachinePosition[0][2], 1, 0, "#901")

			For $i = 0 To 10
				If _Sleep(200) Then Return
				; $aResult[1] = Name , $aResult[2] = Level
				Local $aResult = BuildingInfo(242, 520 + $g_iBottomOffsetY)
				If UBound($aResult) >= 2 Then ExitLoop
				If $i = 10 Then
					Setlog("Error geting the Machine Info!!", $COLOR_ERROR)
					ClickP($aAway, 2, 300, "#900") ;Click Away
					Return
				EndIf
			Next
			$aMachineStatus[$g_iCurAccount][1] = $aResult[2] <> "Broken" ? Number($aResult[2]) : 0
			If $Test > 0 Then Setlog("Machine Level: " & $aMachineStatus[$g_iCurAccount][1])
		Else
			_DebugFailedImageDetection("Machine")
			$aMachineStatus[$g_iCurAccount][1] = 0
		EndIf
	EndIf
	ClickP($aAway, 2, 300, "#900") ;Click Away
EndFunc   ;==>BuilderBaseCheckMachine

Func BuilderBaseCheckElixirStorageCap(ByRef $aElixirStorageCap, $Test = 0)
	ClickP($aAway, 1, 1000, "#900") ;Click Away
	If IsMainPageBuilderBase() Then
		Local $ElixirStorageCapPosition[2] = [750, 80]
		ClickP($ElixirStorageCapPosition, 1, 300, "ElixirCap")
		For $i = 0 To 10
			If _sleep(200) Then Return
			$aElixirStorageCap[$g_iCurAccount] = Number(getResourcesMainScreen(738, 113)) ;  coc-bonus
			If $aElixirStorageCap[$g_iCurAccount] = "" Then getResourcesBonus(738, 113) ; when reach the full Cap the numbers are bigger
			If IsNumber($aElixirStorageCap[$g_iCurAccount]) And $aElixirStorageCap[$g_iCurAccount] > 0 Then ExitLoop
			If $i = 10 Then Setlog("Error getting thge Elixir Storage Cap", $COLOR_ERROR)
		Next
	EndIf
	If $Test > 0 Then Setlog("Elixir Storage Cap: " & $aElixirStorageCap[$g_iCurAccount])
	ClickP($aAway, 2, 300, "#900") ;Click Away
EndFunc   ;==>BuilderBaseCheckElixirStorageCap

Func BuilderBaseCheckLab(ByRef $aRemainLabtime, $Test = 0)
	ClickP($aAway, 2, 300, "#900") ;Click Away
	If IsMainPageBuilderBase() Then
		If Not DetectedLaboratory() Then Return

		If Not DetectButton() Then Return

		If Not DetectLaboratoryWindow() Then Return

		IsLaboratyAvailable($aRemainLabtime, $Test)
	EndIf
	ClickP($aAway, 2, 300, "#900") ;Click Away
EndFunc   ;==>BuilderBaseCheckLab


; Machine
Func BuilderBaseUpgradeMachine($Test = 0)

	If IsMainPageBuilderBase() Then
		; Machine Detection
		Local $MachinePosition = _ImageSearchXMLMultibot($g_sXMLTroopsUpgradeMachine, $g_aXMLToForceBuilderBaseParms[0], $g_aXMLToForceBuilderBaseParms[1], $g_aXMLToForceBuilderBaseParms[2], $Test)
		If IsArray($MachinePosition) And UBound($MachinePosition) > 0 Then
			SetDebugLog("Machine Found: " & _ArrayToString($MachinePosition))
			Click($MachinePosition[0][1], $MachinePosition[0][2], 1, 0, "#901")
			If _Sleep(2000) Then Return
			If GetUpgradeButton("Elixir", $Test) Then Return True
		Else
			_DebugFailedImageDetection("UpgradeMachine")
		EndIf
	EndIf
	Return False
EndFunc   ;==>BuilderBaseUpgradeMachine


; laboratory
Func BuilderBaseUpgradeTroop(ByRef $aRemaintime, ByRef $aTroopsToUpgrade, $Test = 0)
	If isOnBuilderIsland2() Then

		If Not DetectedLaboratory() Then Return

		If Not DetectButton() Then Return

		If Not DetectLaboratoryWindow() Then Return

		If IsLaboratyAvailable($aRemaintime, $Test) Then

			If IsElixirAvailable($aTroopsToUpgrade) Then
				Local $slot = SlotTroop($g_iQuickMISX, $g_iQuickMISY)
				If $Test <> 0 Then
					Setlog("$slot: " & _ArrayToString($slot))
				Else
					Click($g_iQuickMISX, $g_iQuickMISY, 1)
				EndIf
				If $slot[2] = "" Or $slot[2] = 0 Then $slot[2] = 1
				Setlog("Start Upgrading " & SlotName($slot) & " to Level " & $slot[2] + 1, $COLOR_SUCCESS)
				Setlog("Changing Lab to Any Troop!", $COLOR_INFO)
				$g_iCmbBBLaboratory = 10
				_GUICtrlComboBox_SetCurSel($g_hCmbBBLaboratory, $g_iCmbBBLaboratory)
				_GUICtrlSetImage($g_hPicBBLabUpgrade, $g_sLibBBIconPath, $g_iCmbBBLaboratory + 1)
				If _sleep(2000) Then Return
				; 74c223 650,570 , green button [OK]
				If _ColorCheck(_GetPixelColor(650, 570 + $g_iMidOffsetYNew, True), Hex(0x74c223, 6), 10) Then ; RC Done
					Click(650, 570 + $g_iMidOffsetYNew , 1)
					Return True
				EndIf
			EndIf
		EndIf
	Else
		Setlog("You are not at Builder Base!", $COLOR_WARNING)
	EndIf
	Return False
EndFunc   ;==>BuilderBaseUpgradeTroop

Func DetectedLaboratory()
	If QuickMIS("BC1", $g_sImgTroopsUpgradeLab, 100, 100, 840, 650 + $g_iBottomOffsetYNew, True, False) Then ; RC Done
		SetDebugLog("Laboratory detected: " & $g_iQuickMISWOffSetX & "," & $g_iQuickMISWOffSetY)
		Click($g_iQuickMISWOffSetX + 10, $g_iQuickMISWOffSetY + 10, 1)
		If _Sleep(2000) Then Return
		Return True
	Else
		SetLog("Laboratory not available...", $COLOR_WARNING)
	EndIf
	Return False
EndFunc   ;==>DetectedLaboratory

Func DetectButton()
	If QuickMIS("BC1", $g_sImgTroopsUpgradeButton, 230, 640 + $g_iBottomOffsetYNew) Then ; RC Done
		SetDebugLog("Button Research detected: " & $g_iQuickMISWOffSetX & "," & $g_iQuickMISWOffSetY)
		Click($g_iQuickMISWOffSetX, $g_iQuickMISWOffSetY, 1)
		If _Sleep(2000) Then Return
		Return True
	Else
		SetLog("Button Research not available...", $COLOR_WARNING)
	EndIf
	Return False
EndFunc   ;==>DetectButton

Func DetectLaboratoryWindow()
	If QuickMIS("BC1", $g_sImgTroopsUpgradeLabWindow, 320, 130 + $g_iMidOffsetYNew, 510, 160 + $g_iMidOffsetYNew) Then ; RC Done
		SetDebugLog("Upg Units window detected: " & $g_iQuickMISWOffSetX & "," & $g_iQuickMISWOffSetY)
		Return True
	Else
		SetLog("Upg Units window not available...", $COLOR_WARNING)
	EndIf
	Return False
EndFunc   ;==>DetectLaboratoryWindow

Func IsLaboratyAvailable(ByRef $aRemaintime, $Test = 0) ; passing the all structure
	; x = 660 , y = 250
	; 8088B0 : yes
	; A2CB6C : No
	If _ColorCheck(_GetPixelColor(660, 250 + $g_iMidOffsetYNew, True), Hex(0x8088B0, 6), 5) Then ; RC Done
		SetDebugLog("Unit upgrade Available...")
		$aRemaintime[$g_iCurAccount] = 0
		Return True
	EndIf

	SetLog("Unit Upgrade in progress...", $COLOR_WARNING)
	; Let's get the remain lab time  : coc-RemainLaboratory
	$aRemaintime[$g_iCurAccount] = getRemainTLaboratory(255, 256 + $g_iMidOffsetYNew) ; RC Done
	Setlog("Remain Lab time is " & $aRemaintime[$g_iCurAccount], $COLOR_INFO)
	Local $return = ConvertOCRTime("Builder Base Lab", $aRemaintime[$g_iCurAccount], True)
	$aRemaintime[$g_iCurAccount] = ($return <> False) ? $return : 0

	Return False
EndFunc   ;==>IsLaboratyAvailable

Func IsElixirAvailable(ByRef $aTroopsToUpgrade)

	Local $Temp = QuickMIS("CX", $g_sImgTroopsUpgradeAvaiTroops, 160, 385 + $g_iMidOffsetYNew, 685, 570 + $g_iMidOffsetYNew) ; RC Done
	If IsArray($Temp) Then
		_ArraySort($Temp, 0, 0, 0, 0)
		SetDebugLog("IsElixirAvailable shorted array: " & _ArrayToString($Temp))
		For $i = 0 To UBound($Temp) - 1
			Local $Coordinate = StringSplit($Temp[$i], ",", $STR_NOCOUNT)
			$g_iQuickMISX = 160 + $Coordinate[0] - 60
			$g_iQuickMISY = 385 + $g_iMidOffsetYNew + $Coordinate[1] - 20 ; RC Done
			SetDebugLog("IsElixirAvailable[" & $i & "] Name: " & SlotName(SlotTroop($g_iQuickMISX, $g_iQuickMISY)))
			SetDebugLog("IsElixirAvailable[" & $i & "] Detection at X:" & $g_iQuickMISX & " Y:" & $g_iQuickMISY)

			If $g_iCmbBBLaboratory > 9 Or $g_asBBTroopShortNames[$g_iCmbBBLaboratory] = SlotShortName(SlotTroop($g_iQuickMISX, $g_iQuickMISY)) Then
				Local $x = $g_iQuickMISX
				Local $y = $g_iQuickMISY
				If QuickMIS("BC1", $g_sImgTroopsUpgradeElixir, $x, $y , $x + 60, $y + 50 ) Then ; RC Done
					$g_iQuickMISX += $x
					$g_iQuickMISY += $y
					Return True
				Else
					$aTroopsToUpgrade[$g_iCurAccount][1] = getBBLabUpgrdResourceRed($x - 20, $y + 14)
					SetDebugLog("$ocr: " & $aTroopsToUpgrade[$g_iCurAccount][1])
					SetLog("Insuf. Elixir to Upgrade " & SlotName(SlotTroop($g_iQuickMISX, $g_iQuickMISY)) & " with " & $aTroopsToUpgrade[$g_iCurAccount][1], $COLOR_WARNING)
					If $g_iCmbBBLaboratory < 10 Then Return False
				EndIf
			EndIf
			If $i = UBound($Temp) - 1 Then
				Local $text = $g_iCmbBBLaboratory > 9 ? "Any Troop" : $g_asBBTroopNames[$g_iCmbBBLaboratory]
				SetLog("Doesn't Exist '" & $text & "' to Upgrade!", $COLOR_WARNING)
			EndIf
		Next
	Else
		Local $text = $g_iCmbBBLaboratory > 9 ? "Any Troop" : $g_asBBTroopNames[$g_iCmbBBLaboratory]
		SetLog("Doesn't Exist '" & $text & "' to Upgrade!", $COLOR_WARNING)
	EndIf

	Return False
EndFunc   ;==>IsElixirAvailable


; Slots And Names
Func SlotTroop($x, $y)

	; SlotTroop[XY]: [X] 456/[Y] 457
	SetDebugLog("SlotTroop at [X: " & $x & "]-[Y:" & $y & "]")
	Local $slot[3] = [0, 0, 0]

	If $y > 325 And $y < 425 Then $slot[1] = 1 ; RC Done
	If $y > 425 Then $slot[1] = 2 ; RC Done
	Switch $x
		Case $x > 160 And $x < 263
			$slot[0] = 1
		Case $x > 263 And $x < 370
			$slot[0] = 2
		Case $x > 370 And $x < 477
			$slot[0] = 3
		Case $x > 477 And $x < 578
			$slot[0] = 4
		Case $x > 578 And $x < 685
			$slot[0] = 5
	EndSwitch

	Local $OcrX[5] = [173, 275, 377, 482, 590]
	Local $OcrY[2] = [420 + $g_iMidOffsetYNew, 520 + $g_iMidOffsetYNew] ; RC Done

	$slot[2] = getTroopLevel($OcrX[$slot[0] - 1], $OcrY[$slot[1] - 1])
	SetDebugLog("SlotTroop OCR at Column: " & $slot[0] & " Row: " & $slot[1] & " troop level: " & $slot[2])

	Return $slot
EndFunc   ;==>SlotTroop

Func SlotName($slot)
	; SlotName[$slot]: [0] 3/[1] 1
	Local $SlotsNames[2][5] = [["Raged Barbarian", "Boxer Giant", "Bomber", "Cannon Cart", "Drop Ship"], ["Sneaky Archer", "Beta Minion", "Baby Dragon", "Night Witch", "Super Pekka"]]
	If $g_bDebugSetlog Then SetDebugLog("SlotName[$slot]: [" & $slot[0] & "][" & $slot[1] & "]")
	Return $SlotsNames[$slot[1] - 1][$slot[0] - 1]
EndFunc   ;==>SlotName

Func SlotShortName($slot)
	; SlotName[$slot]: [0] 3/[1] 1
	Local $SlotsNames[2][5] = [["Barb", "Giant", "Bomb", "Cannon", "Drop"], ["Arch", "Beta", "BabyDragon", "Night", "Pekka"]]
	If $g_bDebugSetlog Then SetDebugLog("SlotShortName[$slot]: [" & $slot[0] & "][" & $slot[1] & "]")
	Return $SlotsNames[$slot[1] - 1][$slot[0] - 1]
EndFunc   ;==>SlotShortName

; OCRS
Func getTroopLevel($x_start, $y_start)
	Return getOcrAndCapture("coc-bbtroopslevel", $x_start, $y_start, 25, 36, True)
EndFunc   ;==>getTroopLevel

Func getBBLabUpgrdResourceRed($x_start, $y_start) ; -> Gets complete value of Elixir/DE on the troop buttons,  xxx,xxx for "laboratory.au3" when red text
	Return getOcrAndCapture("coc-bblab-r", $x_start, $y_start, 70, 14, True)
EndFunc   ;==>getBBLabUpgrdResourceRed



