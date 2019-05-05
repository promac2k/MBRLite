; #FUNCTION# ====================================================================================================================
; Name ..........: searchTroopBar
; Description ...: Searches for the Troops and Spels in Troop Attack Bar
; Syntax ........: searchTroopBar($directory, $maxReturnPoints = 1, $TroopBarSlots)
; Parameters ....: $directory - tile location to perform search , $maxReturnPoints ( max number of coords returned ,   $TroopBarSlots array to hold return values
; Return values .: $TroopBarSlots
; Author ........: Trlopes (06-2016)
; Modified ......: ProMac (12-2016), Fahid.Mahmood(12-2018)
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func AttackBarCheck($bRemaining = False, $pMatchMode = $DB, $bDebug = False)

	Local $iX1 = 0, $iY1 = 659 + $g_iBottomOffsetYNew, $iX2 = 853, $iY2 = 698 + $g_iBottomOffsetYNew ; RC Done
	Static Local $bCheckSlot12 = False
	Static Local $iSlot0XAxis = 0 ;Store Slot 1 Starting X-axis
	Static Local $aAttackBarSlotDetails[22][3] ;22 Slots of troops -  [0] Detected Troop Name, [1] Troop Detected X, [2] Slot Starting X axis

	If Not $bRemaining Then
		$bCheckSlot12 = False
		$iSlot0XAxis = 0
		_ArrayDelete($aAttackBarSlotDetails, UBound($aAttackBarSlotDetails))
	ElseIf $aAttackBarSlotDetails[0][0] = "" Then ;When Remain Called we know it attackbar should have at least 1 troop detected
		SetLog("Error while detecting Attackbar Remaining Called Before initializing the Attackbar", $COLOR_ERROR)
		Return
	EndIf

	If $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, True)

	; Reset to level one the Spells level
	$g_iLSpellLevel = 1
	$g_iESpellLevel = 1

	; Setup arrays, including default return values for $return
	Local $aResult[1][6], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue

	If Not $g_bRunState Then Return

	; Capture the screen for comparison
	_CaptureRegion2($iX1, $iY1, $iX2, $iY2)

	Local $sFinalResult = "", $iAttackbarStart = __TimerInit()

	; Perform the search
	Local $sAttBarRes = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $g_sImgAttackBarDir, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)

	If IsArray($sAttBarRes) Then
		If $sAttBarRes[0] = "0" Or $sAttBarRes[0] = "" Then
			SetLog("AttackBarCheck Error: Nothing found", $COLOR_ERROR)
		ElseIf StringLeft($sAttBarRes[0], 2) = "-1" Then
			SetLog("DLL Error: " & $sAttBarRes[0] & ", AttackBarCheck", $COLOR_ERROR)
		Else
			; Get the keys for the dictionary item.
			Local $aKeys = StringSplit($sAttBarRes[0], "|", $STR_NOCOUNT)

			; Redimension the result array to allow for the new entries
			ReDim $aResult[UBound($aKeys)][6]
			Local $iResultAddDup = 0

			; Loop through the array
			For $i = 0 To UBound($aKeys) - 1
				If Not $g_bRunState Then Return
				; Get the property values
				$aResult[$i + $iResultAddDup][0] = RetrieveImglocProperty($aKeys[$i], "objectname")
				; Get the coords property
				$aValue = RetrieveImglocProperty($aKeys[$i], "objectpoints")
				$aCoords = decodeMultipleCoords($aValue, 50) ; dedup coords by x on 50 pixel
				$aCoordsSplit = $aCoords[0]
				If UBound($aCoordsSplit) = 2 Then
					; Store the coords into a two dimensional array
					$aCoordArray[0][0] = $aCoordsSplit[0] ; X coord.
					$aCoordArray[0][1] = $aCoordsSplit[1] ; Y coord.
				Else
					$aCoordArray[0][0] = -1
					$aCoordArray[0][1] = -1
				EndIf
				If $g_bDebugSetlog Then SetDebugLog($aResult[$i + $iResultAddDup][0] & " | $aCoordArray: " & $aCoordArray[0][0] & "-" & $aCoordArray[0][1])
				; Store the coords array as a sub-array
				$aResult[$i + $iResultAddDup][1] = Number($aCoordArray[0][0])
				$aResult[$i + $iResultAddDup][2] = Number($aCoordArray[0][1])
				;If a Clan Castle Spell exists
				Local $iMultipleCoords = UBound($aCoords)
				; Check if two Clan Castle Spells exist with different levels
				If $iMultipleCoords > 1 And StringInStr($aResult[$i + $iResultAddDup][0], "Spell") <> 0 Then
					If $g_bDebugSetlog Then SetDebugLog($aResult[$i + $iResultAddDup][0] & " detected " & $iMultipleCoords & " times!")
					For $j = 1 To $iMultipleCoords - 1
						Local $aCoordsSplit2 = $aCoords[$j]
						If UBound($aCoordsSplit2) = 2 Then
							; add slot
							$iResultAddDup += 1
							ReDim $aResult[UBound($aKeys) + $iResultAddDup][6]
							$aResult[$i + $iResultAddDup][0] = $aResult[$i + $iResultAddDup - 1][0] ; same objectname
							$aResult[$i + $iResultAddDup][1] = $aCoordsSplit2[0]
							$aResult[$i + $iResultAddDup][2] = $aCoordsSplit2[1]
							If $g_bDebugSetlog Then SetDebugLog($aResult[$i + $iResultAddDup][0] & " | $aCoordArray: " & $aResult[$i + $iResultAddDup][1] & "-" & $aResult[$i + $iResultAddDup][2])
						Else
							; don't invalidate anything
							;$aCoordArray[0][0] = -1
							;$aCoordArray[0][1] = -1
						EndIf
					Next
				EndIf
			Next

			_ArraySort($aResult, 0, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i

			If $g_bDebugSetlog Then SetDebugLog("Attackbar detection completed in " & StringFormat("%.2f", _Timer_Diff($iAttackbarStart)) & " ms")
			$iAttackbarStart = __TimerInit()

			If Not $bRemaining Then
				$bCheckSlot12 = _ColorCheck(_GetPixelColor(17, 643 + $g_iBottomOffsetYNew, True), Hex(0x478AC6, 6), 15) Or _  	 ; RC Done ; Slot Filled / Background Blue / More than 11 Slots
						_ColorCheck(_GetPixelColor(17, 643 + $g_iBottomOffsetYNew, True), Hex(0x434343, 6), 10) ; RC Done ; Slot deployed / Gray / More than 11 Slots
				If $g_bDebugSetlog Then
					SetDebugLog(" Slot > 12 _ColorCheck 0x478AC6 at (17," & 643 + $g_iBottomOffsetYNew & "): " & $bCheckSlot12, $COLOR_DEBUG) ; RC Done ;Debug
					Local $CheckSlot12Color = _GetPixelColor(17, 643 + $g_iBottomOffsetYNew, $g_bCapturePixel) ; RC Done
					SetDebugLog(" Slot > 12 _GetPixelColor(17," & 643 + $g_iBottomOffsetYNew & "): " & $CheckSlot12Color, $COLOR_DEBUG) ; RC Done ;Debug
				EndIf

			EndIf
			Local $bScreenCapture = False
			Local $iLastSlotX = 0 ;Store Last Processed Slot X-Axis Need for getting space between two slots
			Local $iTotalSpaceBetweenSlot = 0 ;Contains Total Space Between Processed Slot
			For $i = 0 To UBound($aResult) - 1
				Local $iSlotX = 0
				Local $iSlotNo = 0
				Local $aTempSlot[2] = [$iSlotX, $iSlotNo] ;Just Initialize with empty
				If $aResult[$i][1] > 0 Then
					If $g_bDebugSetlog Then SetDebugLog("Index:" & $i & " |Detection : " & $aResult[$i][0] & "|x" & $aResult[$i][1] & "|y" & $aResult[$i][2], $COLOR_DEBUG) ;Debug
					;$aTempSlot -> [0] Slot Starting X axis, [1] Slot No
					If Not $bRemaining Then
						$aTempSlot = SlotAttack(Number($aResult[$i][1]), $bScreenCapture, $iSlot0XAxis, $iLastSlotX, $iTotalSpaceBetweenSlot)
					Else
						$aTempSlot = SlotAttackGetFromCopy(Number($aResult[$i][1]), $aResult[$i][0], $aAttackBarSlotDetails)
						;Just In Case Slot Was Not Found In Cache It Can Happen Only When Troop Slot Was Not Recognized In First Place
						If Number($aTempSlot[0]) = 0 Then
							$aTempSlot = SlotAttack(Number($aResult[$i][1]), $bScreenCapture, $iSlot0XAxis, $iLastSlotX, $iTotalSpaceBetweenSlot)
							$iSlotX = Number($aTempSlot[0]) ;Slot Starting X axis
							$iSlotNo = $aTempSlot[1] ;Attackbar Slot No
							If ($iSlotNo >= 0 And $iSlotNo < UBound($aAttackBarSlotDetails)) Then ;Just Incase Verify Slot Index Lies In Array
								If $aAttackBarSlotDetails[$iSlotNo][0] = "" Then ;At this point Correct Slot is not gurrentied that's why checking if new slot is empty only then it means slot was detected correctly
									$aAttackBarSlotDetails[$iSlotNo][0] = $aResult[$i][0] ;Detected Troop Name
									$aAttackBarSlotDetails[$iSlotNo][1] = $aResult[$i][1] ; Troop Detected X
									$aAttackBarSlotDetails[$iSlotNo][2] = $iSlotX ;Slot Starting X axis
								EndIf
							EndIf
						EndIf
					EndIf
					If $g_bRunState = False Then Return ; Stop function
					If _Sleep(20) Then Return ; Pause function
					If UBound($aTempSlot) = 2 And Number($aTempSlot[0]) <> 0 Then
						$iSlotX = Number($aTempSlot[0]) ;Slot Starting X axis
						$iSlotNo = $aTempSlot[1] ;Attackbar Slot No
						If Not $bRemaining Then
							If ($iSlotNo >= 0 And $iSlotNo < UBound($aAttackBarSlotDetails)) Then ;Just Incase Verify Slot Index Lies In Array
								$aAttackBarSlotDetails[$iSlotNo][0] = $aResult[$i][0] ;Detected Troop Name
								$aAttackBarSlotDetails[$iSlotNo][1] = $aResult[$i][1] ; Troop Detected X
								$aAttackBarSlotDetails[$iSlotNo][2] = $iSlotX ;Slot Starting X axis
							EndIf
						EndIf
						;If $g_bDebugSetlog Then SetDebugLog("SLOT: " & $aTempSlot[1] & " | OCR : " & $aTempSlot[0] + $g_iSlotOCRCompensation, $COLOR_DEBUG) ;Debug
						If $aResult[$i][0] = "Castle" Or $aResult[$i][0] = "King" Or $aResult[$i][0] = "Queen" Or $aResult[$i][0] = "Warden" Or $aResult[$i][0] = "WallW" Or $aResult[$i][0] = "BattleB" Or $aResult[$i][0] = "StoneS" Then
							$aResult[$i][3] = 1
							$aResult[$i][4] = $iSlotNo
						Else
							$aResult[$i][3] = Number(getTroopCountBig($iSlotX + $g_iSlotOCRCompensation, 633 + $g_iBottomOffsetYNew)) ; For big numbers when the troop is selected
							$aResult[$i][4] = $iSlotNo
							If $aResult[$i][3] = "" Or $aResult[$i][3] = 0 Then
								$aResult[$i][3] = Number(getTroopCountSmall($iSlotX + $g_iSlotOCRCompensation, 640 + $g_iBottomOffsetYNew)) ; RC Done ; For small numbers when the troop isn't selected
								$aResult[$i][4] = $iSlotNo
							EndIf

							If StringInStr($aResult[$i][0], "ESpell") <> 0 And $g_bSmartZapEnable Then
								$aResult[$i][5] = getTroopsSpellsLevel($iSlotX + $g_iSlotLvlOCRCompensation, 704 + $g_iBottomOffsetYNew) ; RC Done
								If $aResult[$i][5] <> "" Then $g_iESpellLevel = $aResult[$i][5] ; If they aren't empty will store the correct level, or will be level 1 , just in case
								If $g_bDebugSmartZap Then SetLog("Earthquake Spell detected with level: " & $aResult[$i][5], $COLOR_DEBUG)
							EndIf
							If StringInStr($aResult[$i][0], "LSpell") <> 0 And $g_bSmartZapEnable Then
								$aResult[$i][5] = getTroopsSpellsLevel($iSlotX + $g_iSlotLvlOCRCompensation, 704 + $g_iBottomOffsetYNew) ; RC Done
								If $aResult[$i][5] <> "" Then $g_iLSpellLevel = $aResult[$i][5] ; If they aren't empty will store the correct level, or will be level 1 , just in case
								If $g_bDebugSmartZap Then SetLog("Lightning Spell detected with level: " & $aResult[$i][5], $COLOR_DEBUG)
							EndIf
						EndIf
					Else
						SetLog("Error while detecting Attackbar", $COLOR_ERROR)
						SetLog("Index:" & $i & " |Detection : " & $aResult[$i][0] & "|x" & $aResult[$i][1] & "|y" & $aResult[$i][2], $COLOR_DEBUG) ;Debug
						$aResult[$i][3] = -1
						$aResult[$i][4] = -1
					EndIf
					; [0] = Troop Enum Cross Reference [1] = Slot position [2] = Quantities [3] = Slot Starting X-Axis
					$sFinalResult &= "|" & TroopIndexLookup($aResult[$i][0]) & "#" & $aResult[$i][4] & "#" & $aResult[$i][3] & "#" & $iSlotX
				EndIf
			Next
		EndIf
	EndIf


	If $g_bDebugSetlog Then SetDebugLog("Attackbar OCR completed in " & StringFormat("%.2f", __TimerDiff($iAttackbarStart)) & " ms")

	If $bDebug Then
		Local $iX1 = 0, $iY1 = 659 + $g_iBottomOffsetYNew, $iX2 = 853, $iY2 = 698 + $g_iBottomOffsetYNew ; RC Done
		_CaptureRegion2($iX1, $iY1, $iX2, $iY2)

		Local $sSubDir = $g_sProfileTempDebugPath & "AttackBarDetection"

		DirCreate($sSubDir)

		Local $sDate = @YEAR & "-" & @MON & "-" & @MDAY, $sTime = @HOUR & "." & @MIN & "." & @SEC
		Local $sDebugImageName = String($sDate & "_" & $sTime & "_.png")
		Local $hEditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hEditedImage)
		Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3)

		For $i = 0 To UBound($aResult) - 1
			addInfoToDebugImage($hGraphic, $hPenRED, $aResult[$i][0], $aResult[$i][1], $aResult[$i][2])
		Next

		_GDIPlus_ImageSaveToFile($hEditedImage, $sSubDir & "\" & $sDebugImageName)
		_GDIPlus_PenDispose($hPenRED)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_BitmapDispose($hEditedImage)
	EndIf

	; Drag left & checking extended troops from Slot11+ ONLY if not a smart attack
	If ($pMatchMode <= $LB And $bCheckSlot12 And UBound($aResult) > 1 And $g_aiAttackAlgorithm[$pMatchMode] <> 3) Then
		SetDebuglog("$sFinalResult 1st page = " & $sFinalResult)
		Local $aLastTroop1stPage[2]
		$aLastTroop1stPage[0] = $aResult[UBound($aResult) - 1][0] ; Name of troop at last slot 1st page
		$aLastTroop1stPage[1] = UBound(_ArrayFindAll($aResult, $aLastTroop1stPage[0])) ; Number of slots this troop appears in 1st page
		SetDebuglog("$sLastTroop1stPage = " & $aLastTroop1stPage[0] & ", appears: " & $aLastTroop1stPage[1])
		DragAttackBar()
		$sFinalResult &= ExtendedAttackBarCheck($aLastTroop1stPage, $bRemaining, $iSlot0XAxis, $aAttackBarSlotDetails)
		DragAttackBar($g_iTotalAttackSlot, True) ; return drag
	EndIf

	$sFinalResult = StringTrimLeft($sFinalResult, 1)

	; Old style is: "|" & Troopa Number & "#" & Slot Number & "#" & Quantities
	Return $sFinalResult

EndFunc   ;==>AttackBarCheck

Func ExtendedAttackBarCheck($aLastTroop1stPage, $bRemaining, ByRef $iSlot0XAxis, ByRef $aAttackBarSlotDetails)

	Local $iX1 = 0, $iY1 = 659 + $g_iBottomOffsetYNew, $iX2 = 853, $iY2 = 698 + $g_iBottomOffsetYNew ; RC Done

	; Setup arrays, including default return values for $return
	Local $aResult[1][6], $aCoordArray[1][2], $aCoords, $aCoordsSplit, $aValue
	If Not $g_bRunState Then Return

	; Capture the screen for comparison
	_CaptureRegion2($iX1, $iY1, $iX2, $iY2)

	Local $sFinalResult = ""
	; Perform the search
	Local $sAttBarRes = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $g_sImgAttackBarDir, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)

	If IsArray($sAttBarRes) Then
		If $sAttBarRes[0] = "0" Or $sAttBarRes[0] = "" Then
			SetLog("Imgloc|AttackBarCheck not found!", $COLOR_RED)
		ElseIf StringLeft($sAttBarRes[0], 2) = "-1" Then
			SetLog("DLL Error: " & $sAttBarRes[0] & ", AttackBarCheck", $COLOR_RED)
		Else
			; Get the keys for the dictionary item.
			Local $aKeys = StringSplit($sAttBarRes[0], "|", $STR_NOCOUNT)

			; Redimension the result array to allow for the new entries
			ReDim $aResult[UBound($aKeys)][6]
			Local $iResultAddDup = 0

			; Loop through the array
			For $i = 0 To UBound($aKeys) - 1
				If Not $g_bRunState Then Return
				; Get the property values
				$aResult[$i + $iResultAddDup][0] = RetrieveImglocProperty($aKeys[$i], "objectname")
				; Get the coords property
				$aValue = RetrieveImglocProperty($aKeys[$i], "objectpoints")
				$aCoords = decodeMultipleCoords($aValue, 50) ; dedup coords by x on 50 pixel
				$aCoordsSplit = $aCoords[0]
				If UBound($aCoordsSplit) = 2 Then
					; Store the coords into a two dimensional array
					$aCoordArray[0][0] = $aCoordsSplit[0] ; X coord.
					$aCoordArray[0][1] = $aCoordsSplit[1] ; Y coord.
				Else
					$aCoordArray[0][0] = -1
					$aCoordArray[0][1] = -1
				EndIf
				If $g_bDebugSetlog Then SetDebugLog($aResult[$i + $iResultAddDup][0] & " | $aCoordArray: " & $aCoordArray[0][0] & "-" & $aCoordArray[0][1])
				; Store the coords array as a sub-array
				$aResult[$i + $iResultAddDup][1] = Number($aCoordArray[0][0])
				$aResult[$i + $iResultAddDup][2] = Number($aCoordArray[0][1])
				;If a Clan Castle Spell exists
				Local $iMultipleCoords = UBound($aCoords)
				If $iMultipleCoords > 1 And StringInStr($aResult[$i + $iResultAddDup][0], "Spell") <> 0 Then
					If $g_bDebugSetlog Then SetDebugLog($aResult[$i + $iResultAddDup][0] & " detected " & $iMultipleCoords & " times")

					For $j = 1 To $iMultipleCoords - 1
						Local $aCoordsSplit2 = $aCoords[$j]
						If UBound($aCoordsSplit2) = 2 Then
							; add slot
							$iResultAddDup += 1
							ReDim $aResult[UBound($aKeys) + $iResultAddDup][6]
							$aResult[$i + $iResultAddDup][0] = $aResult[$i + $iResultAddDup - 1][0] ; same objectname
							$aResult[$i + $iResultAddDup][1] = $aCoordsSplit2[0]
							$aResult[$i + $iResultAddDup][2] = $aCoordsSplit2[1]
							If $g_bDebugSetlog Then SetDebugLog($aResult[$i + $iResultAddDup][0] & " | $aCoordArray: " & $aResult[$i + $iResultAddDup][1] & "-" & $aResult[$i + $iResultAddDup][2])
						Else
							; don't invalidate anything
							;$aCoordArray[0][0] = -1
							;$aCoordArray[0][1] = -1
						EndIf
					Next
				EndIf
			Next

			_ArraySort($aResult, 0, 0, 0, 1) ; Sort By X position , will be the Slot 0 to $i

			Local $iSlotExtended = 0
			Static $iFirstExtendedSlot = -1 ; Location of 1st extended troop after drag
			If Not $bRemaining Then $iFirstExtendedSlot = -1 ; Reset value for 1st time detecting troop bar

			Local $iFoundLastTroop1stPage
			Local $bStart2ndPage = False
			Local $bScreenCapture = False
			Local $iLastSlotX = 0 ;Store Last Processed Slot X-Axis Need for getting space between two slots
			Local $iTotalSpaceBetweenSlot = 0 ;Contains Total Space Between Processed Slot
			For $i = 0 To UBound($aResult) - 1
				Local $iSlotX = 0
				Local $iSlotNo = 0
				Local $aTempSlot[2] = [$iSlotX, $iSlotNo] ;Just Initialize with empty
				If $aResult[$i][1] > 0 Then
					; Finding where to start the 2nd page
					If $aResult[$i][0] = $aLastTroop1stPage[0] And Not $bStart2ndPage Then
						$iFoundLastTroop1stPage += 1
						;SetDebugLog("Found $aLastTroop1stPage[0]: " & $aResult[$i][0] & " x" & $iFoundLastTroop1stPage)
						If $iFoundLastTroop1stPage >= $aLastTroop1stPage[1] Then $bStart2ndPage = True
						ContinueLoop
					EndIf
					If Not $bStart2ndPage Then ContinueLoop
					If $g_bDebugSetlog Then SetDebugLog("Index:" & $i & " |Detection : " & $aResult[$i][0] & "|x" & $aResult[$i][1] & "|y" & $aResult[$i][2], $COLOR_DEBUG) ;Debug
					If Not $bRemaining Then
						$aTempSlot = SlotAttack(Number($aResult[$i][1]), $bScreenCapture, $iSlot0XAxis, $iLastSlotX, $iTotalSpaceBetweenSlot)
					Else
						$aTempSlot = SlotAttackGetFromCopy(Number($aResult[$i][1]), $aResult[$i][0], $aAttackBarSlotDetails)
						;Just In Case Slot Was Not Found In Cache It Can Happen Only When Troop Slot Was Not Recognized In First Place
						If Number($aTempSlot[0]) = 0 Then
							$aTempSlot = SlotAttack(Number($aResult[$i][1]), $bScreenCapture, $iSlot0XAxis, $iLastSlotX, $iTotalSpaceBetweenSlot)
							$iSlotX = Number($aTempSlot[0]) ;Slot Starting X axis
							$iSlotNo = ($aTempSlot[1] + 11) - $iFirstExtendedSlot ;Attackbar Slot No
							If ($iSlotNo >= 0 And $iSlotNo < UBound($aAttackBarSlotDetails)) Then ;Just Incase Verify Slot Index Lies In Array
								If $aAttackBarSlotDetails[$iSlotNo][0] = "" Then ;At this point Correct Slot is not gurrentied that's why checking if new slot is empty only then it means slot was detected correctly
									$aAttackBarSlotDetails[$iSlotNo][0] = $aResult[$i][0] ;Detected Troop Name
									$aAttackBarSlotDetails[$iSlotNo][1] = $aResult[$i][1] ; Troop Detected X
									$aAttackBarSlotDetails[$iSlotNo][2] = $iSlotX ;Slot Starting X axis
								EndIf
							EndIf
						EndIf
					EndIf
					If $iFirstExtendedSlot = -1 Then $iFirstExtendedSlot = $aTempSlot[1] ; flag only once
					$iSlotExtended = $aTempSlot[1] - $iFirstExtendedSlot + 1
					If Not $g_bRunState Then Return ; Stop function
					If _Sleep(20) Then Return ; Pause function
					If UBound($aTempSlot) = 2 And Number($aTempSlot[0]) <> 0 Then
						$iSlotX = Number($aTempSlot[0])
						If Not $bRemaining Then
							$iSlotNo = ($aTempSlot[1] + 11) - $iFirstExtendedSlot
							If ($iSlotNo >= 0 And $iSlotNo < UBound($aAttackBarSlotDetails)) Then ;Just Incase Verify Slot Index Lies In Array
								$aAttackBarSlotDetails[$iSlotNo][0] = $aResult[$i][0] ;Detected Troop Name
								$aAttackBarSlotDetails[$iSlotNo][1] = $aResult[$i][1] ; Troop Detected X
								$aAttackBarSlotDetails[$iSlotNo][2] = $iSlotX ;Slot Starting X axis
							EndIf
						Else ;As We Got This From Cache It's Already Correct Slot
							$iSlotNo = $aTempSlot[1]
						EndIf
						;If $g_bDebugSetlog Then SetDebugLog("SLOT: " & $aTempSlot[1] & " | OCR : " & $aTempSlot[0] + $g_iSlotOCRCompensation, $COLOR_DEBUG) ;Debug
						If $aResult[$i][0] = "Castle" Or $aResult[$i][0] = "King" Or $aResult[$i][0] = "Queen" Or $aResult[$i][0] = "Warden" Or $aResult[$i][0] = "WallW" Or $aResult[$i][0] = "BattleB" Or $aResult[$i][0] = "StoneS" Then
							$aResult[$i][3] = 1
						Else
							$aResult[$i][3] = Number(getTroopCountSmall($iSlotX + $g_iSlotOCRCompensation, 640 + $g_iBottomOffsetYNew)) ; RC Done ; For small Numbers
							If $aResult[$i][3] = "" Or $aResult[$i][3] = 0 Then
								$aResult[$i][3] = Number(getTroopCountBig($iSlotX + $g_iSlotOCRCompensation, 633 + $g_iBottomOffsetYNew)) ; RC Done ; For Big Numbers , when the troops is selected
							EndIf
						EndIf
						$aResult[$i][4] = $iSlotNo
					Else
						Setlog("Problem with Attack bar detection!", $COLOR_ERROR)
						SetLog("Index:" & $i & " |Detection : " & $aResult[$i][0] & "|x" & $aResult[$i][1] & "|y" & $aResult[$i][2], $COLOR_DEBUG) ;Debug
						$aResult[$i][3] = -1
						$aResult[$i][4] = -1
					EndIf
					; [0] = Troop Enum Cross Reference [1] = Slot position [2] = Quantities [3] = Slot Starting X-Axis
					$sFinalResult &= "|" & TroopIndexLookup($aResult[$i][0]) & "#" & $aResult[$i][4] & "#" & $aResult[$i][3] & "#" & $iSlotX
				EndIf
			Next
			If Not $bRemaining Then
				$g_iTotalAttackSlot = $iSlotExtended + 10
			EndIf

			SetDebugLog("$iSlotExtended / $g_iTotalAttackSlot: " & $iSlotExtended & "/" & $g_iTotalAttackSlot)

		EndIf
	EndIf

	SetDebugLog("Extended $sFinalResult: " & $sFinalResult)
	Return $sFinalResult

EndFunc   ;==>ExtendedAttackBarCheck

Func DragAttackBar($iTotalSlot = 20, $bBack = False)
	If $g_iTotalAttackSlot > 10 Then $iTotalSlot = $g_iTotalAttackSlot
	Local $bAlreadyDrag = False

	If Not $bBack Then
		SetDebugLog("Dragging attack troop bar to 2nd page. Distance = " & $iTotalSlot - 9 & " slots")
		ClickDrag(25 + 73 * ($iTotalSlot - 9), 660 + $g_iBottomOffsetYNew, 25, 660 + $g_iBottomOffsetYNew, 1000) ; RC Done
		If _Sleep(1000 + $iTotalSlot * 25) Then Return
		$bAlreadyDrag = True
	Else
		SetDebugLog("Dragging attack troop bar back to 1st page. Distance = " & $iTotalSlot - 9 & " slots")
		ClickDrag(25, 660 + $g_iBottomOffsetYNew, 25 + 73 * ($iTotalSlot - 9), 660 + $g_iBottomOffsetYNew, 1000) ; RC Done
		If _Sleep(800 + $iTotalSlot * 25) Then Return
		$bAlreadyDrag = False
	EndIf

	$g_bDraggedAttackBar = $bAlreadyDrag
	$g_iCSVLastTroopPositionDropTroopFromINI = -1 ; after drag attack bar, need to clear last troop selected
	Return $bAlreadyDrag
EndFunc   ;==>DragAttackBar

Func SlotAttackGetFromCopy($iTroopDetectedX, $sTroopName, $aAttackBarSlotDetails)
	Local $Slottemp[2] = [0, 0]
	;Varaible Taken For Currently Detected Troops X Compare With Cached X With Max 10 Pixel Difference
	Local $iMaxPixelCompensataion = 10
	Local $bSlotDataFound = False
	For $i = 0 To UBound($aAttackBarSlotDetails) - 1
		; First Verify If Troops Name Is not empty and matched
		If ($aAttackBarSlotDetails[$i][0] <> "" And $aAttackBarSlotDetails[$i][0] = $sTroopName) Then
			If ($iTroopDetectedX >= $aAttackBarSlotDetails[$i][1] - $iMaxPixelCompensataion And $iTroopDetectedX <= $aAttackBarSlotDetails[$i][1] + $iMaxPixelCompensataion) Then
				; Slot Starting X-Axis
				$Slottemp[0] = $aAttackBarSlotDetails[$i][2]
				; Slot No
				$Slottemp[1] = $i
				If $g_bDebugSetlog Then SetDebugLog("Cached Slot Found: " & $Slottemp[1] & " For: " & $sTroopName & " |SltStrtPosX: " & $Slottemp[0])
				$bSlotDataFound = True
				ExitLoop
			EndIf
		EndIf
	Next
	If Not $bSlotDataFound And $g_bDebugSetlog Then SetDebugLog("Cached Slot Not Found For: " & $sTroopName & " |x: " & $iTroopDetectedX)
	Return $Slottemp

EndFunc   ;==>SlotAttackGetFromCopy

Func SlotAttack($iTroopsSlotPosX, ByRef $bScreenCapture, ByRef $iSlot0XAxis, ByRef $iLastSlotX, ByRef $iTotalSpaceBetweenSlot)
	Local $Slottemp[2] = [0, 0]
	;65 is for unselected slot
	Local $iMaxSelectedSlotSize = 65
	;When slot is selected then it's size got change Selected Slot Starting X + 5 will be unselected slot Starting X
	Local $iSelectedSlotCompensation = 5
	Local $iSpaceBetweenSlot = 0
	; Capture at first time to use in GetPixel Color
	If Not $bScreenCapture Then
		If $g_bDebugSetlog Then SetDebugLog("_CaptureRegion 1 Time Only")
		_CaptureRegion()
		$bScreenCapture = True
	EndIf

	;Check if slot was selected Spells Has Y=636 white pixel and Rest Troops,CC,Heroes has 635
	Local $isSlotSelected = _ColorCheck(_GetPixelColor($iTroopsSlotPosX, 635, False), Hex(0xFFFFFF, 6), 1) Or _ColorCheck(_GetPixelColor($iTroopsSlotPosX, 636, False), Hex(0xFFFFFF, 6), 1)
	; Now we will Get the Troop detection Position and step back until we get a Black Pixel and that is when slot begins!
	For $iTroopsSlotStartPosX = $iTroopsSlotPosX To $iTroopsSlotPosX - $iMaxSelectedSlotSize Step -1
		;Just in case of 12 slot's this value can be in negative
		If ($iTroopsSlotStartPosX > 0) Then
			If _ColorCheck(_GetPixelColor($iTroopsSlotStartPosX, 723 + $g_iBottomOffsetYNew, False), Hex(0x000000, 6), 25) Then ; RC Done
				;Removing two pixel Because 723 is 2 pixel below of starting slot.
				$iTroopsSlotStartPosX = $iTroopsSlotStartPosX - 2
				If $isSlotSelected Then
					If $g_bDebugSetlog Then SetDebugLog("This Slot Was Selected.")
					$iTroopsSlotStartPosX = $iTroopsSlotStartPosX + $iSelectedSlotCompensation
				EndIf
				ExitLoop
			EndIf
		Else
			ExitLoop
		EndIf
		If $g_bRunState = False Then Return
	Next

	; Let's reserve the First Slot Position
	; This is important For Remain Troops Because When 1st slot is dropped we can't know the starting slot point our calculation will be wrong
	If $iSlot0XAxis = 0 Then
		$iSlot0XAxis = $iTroopsSlotStartPosX
		If $g_bDebugSetlog Then SetDebugLog("1st Slot X-Axis Position: " & $iSlot0XAxis)
	EndIf

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
	; Slot Starting X-Axis
	$Slottemp[0] = $iTroopsSlotStartPosX
	; Slot Number = Current slot X coordinate - Total Black Space Between Slots - 1st Slot Start X/ by slot size
	Local $iSlotNo = ($iTroopsSlotStartPosX - $iTotalSpaceBetweenSlot - $iSlot0XAxis) / $iMaxSelectedSlotSize
	$Slottemp[1] = Int($iSlotNo)
	If $g_bDebugSetlog Then SetDebugLog("Slot: " & $Slottemp[1] & "|" & Round($iSlotNo, 2) & " |SltStrtPosX: " & $iTroopsSlotStartPosX & " |SpcBtwenSlot:" & $iSpaceBetweenSlot & " |TtlSpcBtwen:" & $iTotalSpaceBetweenSlot)
	Return $Slottemp

EndFunc   ;==>SlotAttack

