; #FUNCTION# ====================================================================================================================
; Name ..........: SuggestedUpgrades()
; Description ...: Goes to Builders Island and Upgrades buildings with 'suggested upgrades window'.
; Syntax ........: SuggestedUpgrades()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (05-2017)
; Modified ......:
; Remarks .......: This file is part of MultiBot, previously known as Mybot and ClashGameBot. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================

; coc-armycamp ---> OCR the values on Builder suggested updates
; coc-build ----> building names and levels [ needs some work on 'u' and 'e' ]  getNameBuilding(

; Zoomout
; If Suggested Upgrade window is open [IMAGE] -> C:\Users\user\Documents\MDOCOCPROJECT\imgxml\Resources\PicoBuildersBase\SuggestedUpdates\IsSuggestedWindowOpened_0_92.png
; Image folder [GOLD] -> C:\Users\user\Documents\MDOCOCPROJECT\imgxml\Resources\PicoBuildersBase\SuggestedUpdates\Gold_0_89.png
; Image folder [GOLD] -> C:\Users\user\Documents\MDOCOCPROJECT\imgxml\Resources\PicoBuildersBase\SuggestedUpdates\Elixir_0_89.png

; Builder Icon position Blue[i] [Check color] [360, 11, 0x7cbdde, 10]
; Suggested Upgrade window position [Imgloc] [380, 59, 100, 20]
; Zone to search for Gold / Elixir icons and values [445, 100, 90, 85 ]
; Gold offset for OCR [Point] [x,y, length]  ,x = x , y = - 10  , length = 535 - x , Height = y + 7   [17]
; Elixir offset for OCR [Point] [x,y, length]  ,x = x , y = - 10  , length = 535 - x , Height = y + 7 [17]
; Builder Name OCR ::::: BuildingInfo(242, 464)
; Button Upgrade position [275, 670, 300, 30]  -> UpgradeButton_0_89.png
; Button OK position Check Pixel [430, 540, 0x6dbd1d, 10] and CLICK

; Draft
; 01 - Verify if we are on Builder island [Boolean]
; 01.1 - Verify available builder [ OCR - coc-Builders ] [410 , 23 , 40 ]
; 02 - Click on Builder [i] icon [Check color]
; 03 - Verify if the window opened [Boolean]
; 04 - Detect Gold and Exlir icons [Point] by a dynamic Y [ignore list]
; 05 - With the previous positiosn and a offset , proceeds with OCR : [WHITE] OK , [salmon] Not enough resources will return "" [strings] convert to [integer]
; 06 - Make maths , IF the Gold is selected on GUI , if Elixir is Selected on GUI , and the resources values and min to safe [Boolean]
; 07 - Click on he correct ICon on Suggested Upgrades window [Point]
; 08 - Verify buttons to upgrade [Point] - Detect the Builder name [OCR]
; 09 - Verify the button to upgrade window [point]  -> [Boolean] ->[check pixel][imgloc]
; 10 - Builder Base report
; 11 - DONE

; GUI
; Check Box to enable the function
; Ignore Gold , Ignore Elixir
; Ignore building names
; Setlog

Func chkActivateBBSuggestedUpgrades()
	; CheckBox Enable Suggested Upgrades [Update values][Update GUI State]
	If GUICtrlRead($g_hChkBBSuggestedUpgrades) = $GUI_CHECKED Then
		$g_iChkBBSuggestedUpgrades = 1
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreGold, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreElixir, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreHall, $GUI_ENABLE)
		GUICtrlSetState($g_hChkPlacingNewBuildings, $GUI_ENABLE)
	Else
		$g_iChkBBSuggestedUpgrades = 0
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreGold, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreElixir, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreHall, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_hChkPlacingNewBuildings, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	EndIf
EndFunc   ;==>chkActivateBBSuggestedUpgrades

Func chkActivateBBSuggestedUpgradesGold()
	; if disabled, why continue?
	If $g_iChkBBSuggestedUpgrades = 0 Then Return
	; Ignore Upgrade Building with Gold [Update values]
	$g_iChkBBSuggestedUpgradesIgnoreGold = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreGold) = $GUI_CHECKED) ? 1 : 0
	; If Gold is Selected Than we can disable the Builder Hall [is gold]
	If $g_iChkBBSuggestedUpgradesIgnoreGold = 0 Then
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreElixir, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreHall, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreElixir, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreHall, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	EndIf
	; Ignore Upgrade Builder Hall [Update values]
	$g_iChkBBSuggestedUpgradesIgnoreHall = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreHall) = $GUI_CHECKED) ? 1 : 0
	; Update Elixir value
	$g_iChkBBSuggestedUpgradesIgnoreElixir = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreElixir) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>chkActivateBBSuggestedUpgradesGold

Func chkActivateBBSuggestedUpgradesElixir()
	; if disabled, why continue?
	If $g_iChkBBSuggestedUpgrades = 0 Then Return
	; Ignore Upgrade Building with Elixir [Update values]
	$g_iChkBBSuggestedUpgradesIgnoreElixir = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreElixir) = $GUI_CHECKED) ? 1 : 0
	If $g_iChkBBSuggestedUpgradesIgnoreElixir = 0 Then
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreGold, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreGold, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	EndIf
	; Update Gold value
	$g_iChkBBSuggestedUpgradesIgnoreGold = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreGold) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>chkActivateBBSuggestedUpgradesElixir

Func chkPlacingNewBuildings()
	$g_iChkPlacingNewBuildings = (GUICtrlRead($g_hChkPlacingNewBuildings) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>chkPlacingNewBuildings

Func TestBBUpgradeBuilding()
	Setlog("** TestBBUpgradeBuilding START**", $COLOR_DEBUG)
	Local $gbDebugOcr = $g_bDebugOcr
	Local $Status = $g_bRunState
	Local $bDebugSetlog = $g_bDebugSetlog
	$g_bDebugSetlog = True
	$g_bDebugOcr = True
	$g_bRunState = True
	BuilderBaseReport()
	SuggestedUpgradeBuildings(True)
	$g_bRunState = $Status
	$g_bDebugOcr = $gbDebugOcr
	$g_bDebugSetlog = $bDebugSetlog
	Setlog("** TestBBUpgradeBuilding END**", $COLOR_DEBUG)
EndFunc   ;==>TestBBUpgradeBuilding

; MAIN CODE
Func SuggestedUpgradeBuildings($bDebug = False)

	; If is not selected return
	If $g_iChkBBSuggestedUpgrades = 0 Then Return
	;Local $bDebug = False
	Local $bScreencap = True

	FuncEnter(SuggestedUpgradeBuildings)

	; Check if you are on Builder island
	If isOnBuilderIsland2() Then
		; Will Open the Suggested Window and check if is OK
		If ClickOnBuilder() Then
			SetLog(" - Upg Window Opened successfully", $COLOR_INFO)
			Local $y = 102 + $g_iMidOffsetYNew, $y1 = 132 + $g_iMidOffsetYNew, $step = 30, $x = 400, $x1 = 540 ; RC Done
			; Only 3 possible Icons appears on Window
			For $i = 0 To 2
				Local $bSkipGoldCheck = False
				If $g_iChkBBSuggestedUpgradesIgnoreElixir = 0 And $g_aiCurrentLootBB[$eLootElixirBB] > 250 Then
					; Proceeds with Elixir icon detection
					If $bDebug Then setlog("AutoUpgradeElixir: " & _ArrayToString(_FileListToArray($g_sImgAutoUpgradeElixir)))
					Local $aResult = GetIconPosition($x, $y, $x1, $y1, $g_sImgAutoUpgradeElixir, "Elixir", $bScreencap, $bDebug)
					If $bDebug Then Setlog("Elixir GetIcon = " & _ArrayToString($aResult))
					Switch $aResult[2]
						Case "Elixir"
							Click($aResult[0], $aResult[1], 1)
							If _Sleep(2000) Then Return
							If GetUpgradeButton($aResult[2], $bDebug) Then
								ExitLoop
							EndIf
							$bSkipGoldCheck = True
						Case "New"
							If $g_iChkPlacingNewBuildings = 1 Then
								SetLog("[" & $i + 1 & "]" & " New Building detected, Placing it...", $COLOR_INFO)
								If NewBuildings($aResult, $bDebug) Then
									ExitLoop
								EndIf
								$bSkipGoldCheck = True
							EndIf
						Case "NoResources"
							SetLog("[" & $i + 1 & "]" & " Not enough Elixir, continuing...", $COLOR_INFO)
							;ExitLoop ; continue as suggested upgrades are not ordered by amount
							$bSkipGoldCheck = True
						Case Else
							;SetLog("[" & $i + 1 & "]" & " Unsupport Elixir icon '" & $aResult[2] & "', continuing...", $COLOR_INFO)
					EndSwitch
				EndIf

				If $g_iChkBBSuggestedUpgradesIgnoreGold = 0 And $g_aiCurrentLootBB[$eLootGoldBB] > 250 And Not $bSkipGoldCheck Then
					; Proceeds with Gold coin detection
					If $bDebug Then setlog("AutoUpgradeGold: " & _ArrayToString(_FileListToArray($g_sImgAutoUpgradeGold)))
					Local $aResult = GetIconPosition($x, $y, $x1, $y1, $g_sImgAutoUpgradeGold, "Gold", $bScreencap, $bDebug)
					If $bDebug Then Setlog("Gold GetIcon = " & _ArrayToString($aResult))
					Switch $aResult[2]
						Case "Gold"
							Click($aResult[0], $aResult[1], 1)
							If _Sleep(2000) Then Return
							If GetUpgradeButton($aResult[2], $bDebug) Then
								ExitLoop
							EndIf
						Case "New"
							If $g_iChkPlacingNewBuildings = 1 Then
								SetLog("[" & $i + 1 & "]" & " New Building detected, Placing it...", $COLOR_INFO)
								If NewBuildings($aResult, $bDebug) Then
									ExitLoop
								EndIf
							EndIf
						Case "NoResources"
							SetLog("[" & $i + 1 & "]" & " Not enough Gold, continuing...", $COLOR_INFO)
							;ExitLoop ; continue as suggested upgrades are not ordered by amount
						Case Else
							;SetLog("[" & $i + 1 & "]" & " Unsupport Gold icon '" & $aResult[2] & "', continuing...", $COLOR_INFO)
					EndSwitch
				EndIf

				$y += $step
				$y1 += $step
			Next
		EndIf
	EndIf
	ClickP($aAway, 1, 0, "#0121")
	FuncReturn()
EndFunc   ;==>SuggestedUpgradeBuildings

; This fucntion will Open the Suggested Window and check if is OK
Func ClickOnBuilder()

	; Master Builder Check pixel [i] icon
	Local Const $aMasterBuilder[4] = [360, 11, 0x7cbdde, 10]
	; Debug Stuff
	Local $sDebugText = ""
	Local Const $Debug = False
	Local Const $Screencap = True

	; Master Builder is not available return
	If $g_iFreeBuilderCountBB = 0 Then SetLog("No Master Builder available! [" & $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB & "]", $COLOR_INFO)

	; Master Builder available
	If $g_iFreeBuilderCountBB > 0 Then
		; Check the Color and click
		If _CheckPixel($aMasterBuilder, True) Then
			; Click on Builder
			Click($aMasterBuilder[0], $aMasterBuilder[1], 1)
			If _Sleep(2000) Then Return
			; Let's verify if the Suggested Window open
			;If QuickMIS("BC1", $g_sImgAutoUpgradeWindow, 330, 85+ $g_iMidOffsetYNew, 550, 145+ $g_iMidOffsetYNew, $Screencap, $Debug) Then ; RC Done
			Return True
			;Else
			;$sDebugText = "Window didn't opened"
			;EndIf
		Else
			$sDebugText = "BB Pixel problem"
		EndIf
	EndIf
	If $sDebugText <> "" Then SetLog("Problem on Suggested Upg Window: [" & $sDebugText & "]", $COLOR_ERROR)
	Return False
EndFunc   ;==>ClickOnBuilder

Func GetIconPosition($x, $y, $x1, $y1, $directory, $Name = "Elixir", $Screencap = True, $Debug = False)
	; [0] = x position , [1] y postion , [2] Gold or Elixir
	Local $aResult[3] = [-1, -1, ""]

	If QuickMIS("BC1", $directory, $x, $y, $x1, $y1, $Screencap, $Debug) Then
		; Correct positions to Check Green 'New' Building word
		Local $iYoffset = $y + $g_iQuickMISY - 15, $iY1offset = $y + $g_iQuickMISY + 7
		Local $iX = 300, $iX1 = $g_iQuickMISX + $x
		; Store the values
		$aResult[0] = $g_iQuickMISX + $x
		$aResult[1] = $g_iQuickMISY + $y
		$aResult[2] = $Name
		; The pink/salmon color on zeros
		If QuickMIS("BC1", $g_sImgAutoUpgradeNoRes, $aResult[0], $iYoffset, $aResult[0] + 100, $iY1offset, True, $Debug) Then
			; Store new values
			$aResult[2] = "NoResources"
			Return $aResult
		EndIf
		; Proceeds with 'New' detection
		If QuickMIS("BC1", $g_sImgAutoUpgradeNew, $iX, $iYoffset, $iX1, $iY1offset, True, $Debug) Then
			; Store new values
			$aResult[0] = $g_iQuickMISX + $iX + 35
			$aResult[1] = $g_iQuickMISY + $iYoffset
			$aResult[2] = "New"
		EndIf
	EndIf

	Return $aResult
EndFunc   ;==>GetIconPosition

Func GetUpgradeButton($sUpgButtom = "", $Debug = False)

	;Local $aBtnPos = [360, 500, 180, 50] ; x, y, w, h
	Local $aBtnPos = [445, 460, 290, 90] ; x, y, w, h ; support Battke Machine, broken and upgrade

	If $sUpgButtom = "" Then Return

	If $sUpgButtom = "Elixir" Then $sUpgButtom = $g_sImgAutoUpgradeBtnElixir
	If $sUpgButtom = "Gold" Then $sUpgButtom = $g_sImgAutoUpgradeBtnGold

	If QuickMIS("BC1", $g_sImgAutoUpgradeBtnDir, 300, 650 + $g_iBottomOffsetYNew, 600, 720 + $g_iBottomOffsetYNew, True, $Debug) Then
		Local $sBuildingName = getNameBuilding(242, 464)
		If _Sleep(500) Then Return
		SetLog("Building: " & $sBuildingName, $COLOR_INFO)
		; Verify if is Builder Hall and If is to Upgrade
		If StringInStr($sBuildingName, "Hall") > 0 And $g_iChkBBSuggestedUpgradesIgnoreHall Then
			SetLog("Ups! Builder Hall is not to Upgrade!", $COLOR_ERROR)
			Return False
			#cs
				ElseIf StringInStr($sBuildingName, "Battle") > 0 Then
				; adjust Battle Machine button pos
				$aBtnPos[0] = 590
				$aBtnPos[1] = 530
			#ce
		EndIf
		Click($g_iQuickMISWOffSetX, $g_iQuickMISWOffSetY, 1)
		If _Sleep(1500) Then Return
		If QuickMIS("BC1", $sUpgButtom, $aBtnPos[0], $aBtnPos[1], $aBtnPos[0] + $aBtnPos[2], $aBtnPos[1] + $aBtnPos[3], True, $Debug) Then
			Click($g_iQuickMISWOffSetX, $g_iQuickMISWOffSetY, 1)
			SetLog($sBuildingName & " Upgrading!", $COLOR_INFO)
			ClickP($aAway, 1, 0, "#0121")
			Return True
		Else
			ClickP($aAway, 1, 0, "#0121")
			SetLog("Not enough Resources to Upgrade " & $sBuildingName & " !", $COLOR_ERROR)
		EndIf

	EndIf

	Return False
EndFunc   ;==>GetUpgradeButton

; NEEDS TO BE UPDATE : NEW WINDOW
Func NewBuildings($aResult, $DebugLog = False)

	Local $Screencap = True, $Debug = False

	If UBound($aResult) = 3 And $aResult[2] = "New" Then

		; The $g_iQuickMISX and $g_iQuickMISY haves the coordinates compansation from 'New' | GetIconPosition()
		Click($aResult[0], $aResult[1], 1)

		; DELAY with image detection
		For $i = 0 To 30
			; first check if you are in correct window
			Local $DetectionShop = _ImageSearchXMLMultibot($g_sXMLAutoUpgradeShop, $g_aXMLToForceAreaParms[0], $g_aXMLToForceAreaParms[1], $g_aXMLToForceAreaParms[2], $DebugLog)
			SetDebugLog(_ArrayToString($DetectionShop))
			; Search zone XML
			If _Sleep(100) Then Return
			If $DetectionShop <> -1 And UBound($DetectionShop) > 0 Then
				Setlog("Shop - Buildings tab detected.", $COLOR_SUCCESS)
				Setlog("Sliding window detected.", $COLOR_SUCCESS)
				If _sleep(2000) Then Return
				ExitLoop
			EndIf
		Next

		; Result [X][0] = NAME , [x][1] = Xaxis , [x][2] = Yaxis , [x][3] = Level
		; Second check if you have visible clocks
		Local $DetectionClock = _ImageSearchXMLMultibot($g_sXMLAutoUpgradeClock, $g_aXMLToForceAreaParms[0], $g_aXMLToForceAreaParms[1], $g_aXMLToForceAreaParms[2], $DebugLog)
		Setlog(_ArrayToString($DetectionClock))
		; Search zone XML

		Local $Correctclock[1][2]

		; Lets se if exist or NOT the Yellow Arrow, If Doesnt exist the [i] icon than exist the Yellow arrow , DONE

		If Not IsArray($DetectionClock) And UBound($DetectionClock) < 1 Then _DebugFailedImageDetection("DetectionClock")

		For $i = 0 To UBound($DetectionClock) - 1
			; for each Visible clock : search zone is (x , y -100 , x + 160 , y )
			Local $x = $DetectionClock[$i][1]
			Local $y = $DetectionClock[$i][2] - 100
			Local $x1 = 160
			Local $y1 = 100
			Local $Area2Search = $x & "," & $y & "," & $x1 & "," & $y1
			SetDebugLog("$Area2Search: " & $Area2Search)
			Local $DetectionInfo = _ImageSearchXMLMultibot($g_sXMLAutoUpgradeInfoIcon, $g_aXMLNotToForceAreaParms[0], $Area2Search, $g_aXMLNotToForceAreaParms[2], $DebugLog)
			SetDebugLog(_ArrayToString($DetectionInfo))

			If Not IsArray($DetectionInfo) And UBound($DetectionInfo) < 1 Then _DebugFailedImageDetection("DetectionInfo")

			If $DetectionInfo = "" Or UBound($DetectionInfo) < 1 Or Not IsArray($DetectionInfo) Then
				Setlog("Detected the correct building at " & $DetectionClock[$i][1] & "x" & $DetectionClock[$i][2])
				$Correctclock[0][0] = $DetectionClock[$i][1]
				$Correctclock[0][1] = $DetectionClock[$i][2]
				ExitLoop
			EndIf
		Next


		; Check white zeros
		Local $Area2Search = $g_aXMLNotToForceAreaParms[1]
		Local $ForceArea = $g_aXMLNotToForceAreaParms[2]
		; for each Visible clock : search zone is (x , y , x + 160 , y + 55 )
		If $Correctclock[0][0] > 0 Then
			Local $x = $Correctclock[0][0]
			Local $y = $Correctclock[0][1]
			Local $x1 = 160
			Local $y1 = 55
			$Area2Search = $x & "," & $y & "," & $x1 & "," & $y1
		Else
			$ForceArea = True
		EndIf

		SetDebugLog("$Area2Search: " & $Area2Search)
		Local $DetectionWhiteZeros = _ImageSearchXMLMultibot($g_sXMLAutoUpgradeWhiteZeros, $g_aXMLNotToForceAreaParms[0], $Area2Search, $ForceArea, $DebugLog)
		SetDebugLog(_ArrayToString($DetectionWhiteZeros))

		If Not IsArray($DetectionWhiteZeros) And UBound($DetectionWhiteZeros) < 1 Then _DebugFailedImageDetection("DetectionWhiteZeros")

		If IsArray($DetectionWhiteZeros) And UBound($DetectionWhiteZeros) > 1 Then
			; CLICK it
			Setlog("Building detected and you have enough resources!")
			Click($DetectionWhiteZeros[0][1] - 20, $DetectionWhiteZeros[0][2] - 20, 1)
		Else
			Setlog("Building detected and not enough resources!")
			Click(825, 70, 1) ; exit from Shop
			Return False
		EndIf

		; DELAY with image detection using NO Icon
		If _Sleep(1000) Then Return
		; Search zone XML
		Local $DetectionLastNo, $detection = False

		For $j = 0 To 10
			; Check Green YES icon
			Local $DetectionYes = _ImageSearchXMLMultibot($g_sXMLAutoUpgradeNewBldgYes, $g_aXMLToForceAreaParms[0], $g_aXMLToForceAreaParms[1], $g_aXMLToForceAreaParms[2], $DebugLog)
			Setlog("$DetectionYes: " & _ArrayToString($DetectionYes))
			If IsArray($DetectionYes) And UBound($DetectionYes) > 0 Then
				; CLICK it
				SetLog("Placed a new Building on Builder Island! [" & $DetectionYes[0][1] & "," & $DetectionYes[0][2] & "]", $COLOR_INFO)
				Click($DetectionYes[0][1], $DetectionYes[0][2], 1)
				$detection = True
			Else
				; Check Green NO icon
				Local $DetectionNo = _ImageSearchXMLMultibot($g_sXMLAutoUpgradeNewBldgNo, $g_aXMLToForceAreaParms[0], $g_aXMLToForceAreaParms[1], $g_aXMLToForceAreaParms[2], $DebugLog)
				Setlog("$DetectionNo: " & _ArrayToString($DetectionNo))

				If Not IsArray($DetectionNo) And UBound($DetectionNo) < 1 Then _DebugFailedImageDetection("DetectionNo")

				; If NOT present then we can slide the NO icon ( x + 10 , y + 25 ) for TOP until exist the YES icon ) or just click on NO
				If IsArray($DetectionNo) And UBound($DetectionNo) > 0 Then
					; ClickDrag($X1, $Y1, $X2, $Y2, $Delay = 50)
					ClickDrag($DetectionNo[0][1] + 10, $DetectionNo[0][2] + 25, $DetectionNo[0][1] - 20, $DetectionNo[0][2] - 50, 500)
					Setlog("ClickDrag: " & $DetectionNo[0][1] + 10 & "," & $DetectionNo[0][2] + 25 & "," & $DetectionNo[0][1] - 20 & "," & $DetectionNo[0][2] - 30)
					$DetectionLastNo = $DetectionNo
					If _Sleep(250) Then Return
				EndIf
			EndIf
			If $j = 10 Then
				If IsArray($DetectionLastNo) And UBound($DetectionLastNo) > 0 Then
					Click($DetectionLastNo[0][1], $DetectionLastNo[0][2], 1)
				Else
					; Close the game JUST IN CASE of placed the building but didn't get the No or Yes button
					If Not $detection Then
						CloseCoC() ; ensure CoC is gone
						OpenCoC()
					EndIf
				EndIf
				Return $detection
			EndIf
		Next
	EndIf
	Return False

EndFunc   ;==>NewBuildings

