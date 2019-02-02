; #FUNCTION# ====================================================================================================================
; Name ..........: GetLocationMine
; Description ...:
; Syntax ........: GetLocationMine()
; Parameters ....:
; Return values .: String with locations
; Author ........:
; Modified ......: ProMac (04-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================


Func GetLocationTownHall()
	imglocTHSearch(True, True) ; search th on myvillage
	Local $return[1]
	IF $g_iTHx > 0 Then
		$g_aiTownHallPos[0] = $g_iTHx
		$g_aiTownHallPos[1] = $g_iTHy
		If $g_bDebugSetlog Then SetDebugLog(" Townhall: (" & $g_aiTownHallPos[0] & "," & $g_aiTownHallPos[1] & ")", $COLOR_ERROR)
		$return[0] = $g_aiTownHallPos
	EndIf
	Return $return
EndFunc

Func GetLocationMine()

	Local $sDirectory = @ScriptDir & "\imgxml\Storages\GoldMines"
	Local $sTxtName = "Mines"
	Local $iMaxReturns = 7

	; Snow Theme detected
	If $g_iDetectedImageType = 1 Then
		$sDirectory = @ScriptDir & "\imgxml\Storages\Mines_Snow"
		$sTxtName = "SnowMines"
	EndIf

	Local $aTempResult = returnMultipleMatches($sDirectory, $iMaxReturns)
	Local $aEndResult = ConvertImgloc2MBR($aTempResult, $iMaxReturns)
	If $g_bDebugBuildingPos Then SetLog("#*# GetLocation" & $sTxtName & ": " & $aEndResult, $COLOR_DEBUG)
	If $g_bDebugGetLocation Then DebugImageGetLocation($aEndResult, $sTxtName)

	Return GetListPixel($aEndResult)
EndFunc   ;==>GetLocationMine

Func GetLocationElixir()
	Local $sDirectory = @ScriptDir & "\imgxml\Storages\Collectors"
	Local $sTxtName = "Collectors"
	Local $iMaxReturns = 7

	; Snow Theme detected
	If $g_iDetectedImageType = 1 Then
		$sDirectory = @ScriptDir & "\imgxml\Storages\Collectors_Snow"
		$sTxtName = "SnowCollectors"
	EndIf

	Local $aTempResult = returnMultipleMatches($sDirectory, $iMaxReturns)
	Local $aEndResult = ConvertImgloc2MBR($aTempResult, $iMaxReturns)
	If $g_bDebugBuildingPos Then SetLog("#*# GetLocation" & $sTxtName & ": " & $aEndResult, $COLOR_DEBUG)
	If $g_bDebugGetLocation Then DebugImageGetLocation($aEndResult, $sTxtName)

	Return GetListPixel($aEndResult)
EndFunc   ;==>GetLocationElixir

Func GetLocationDarkElixir()
	Local $sDirectory = @ScriptDir & "\imgxml\Storages\Drills"
	Local $iMaxReturns = 3
	Local $aTempResult = returnMultipleMatches($sDirectory, $iMaxReturns)
	Local $aEndResult = ConvertImgloc2MBR($aTempResult, $iMaxReturns)

	If $g_bDebugBuildingPos Then SetLog("#*# GetLocationDarkElixir: " & $aEndResult, $COLOR_DEBUG)
	If $g_bDebugGetLocation Then DebugImageGetLocation($aEndResult, "DarkElixir")

	Return GetListPixel($aEndResult)
EndFunc   ;==>GetLocationDarkElixir

Func GetLocationDarkElixirStorage()
	; TODO , Verify Files
	Local $sDirectory = @ScriptDir & "\imgxml\Storages\DarkElixir"
	Local $iMaxReturns = 1
	Local $aTempResult = returnMultipleMatches($sDirectory, $iMaxReturns)
	Local $aEndResult = ConvertImgloc2MBR($aTempResult, $iMaxReturns)

	If $g_bDebugBuildingPos Then SetLog("#*# GetLocationDarkElixir: " & $aEndResult, $COLOR_DEBUG)
	If $g_bDebugGetLocation Then DebugImageGetLocation($aEndResult, "DarkElixir")

	Return GetListPixel($aEndResult)
EndFunc   ;==>GetLocationDarkElixir

Func GetLocationDarkElixirWithLevel()
	Local $sDirectory = @ScriptDir & "\imgxml\Storages\Drills"
	Local $iMaxReturns = 3
	Local $aTempResult = returnMultipleMatches($sDirectory, $iMaxReturns)
	Local $aEndResult = ConvertImgloc2MBR($aTempResult, $iMaxReturns, True)
	If $g_bDebugBuildingPos Then SetLog("#*# getLocationDarkElixirExtractorWithLevel: " & $aEndResult, $COLOR_DEBUG)
	If $g_bDebugGetLocation Then DebugImageGetLocation($aEndResult, "DarkElixirExtractorWithLevel")

	Return $aEndResult
EndFunc   ;==>GetLocationDarkElixirWithLevel


; #FUNCTION# ====================================================================================================================
; Name ..........: GetLocationBuilding
; Description ...: Finds any buildings in global enum & $g_sBldgNames list, saves property data into $g_oBldgAttackInfo dictionary.
; Syntax ........: GetLocationBuilding($iBuildingType[, $iAttackingTH = 11[, $forceCaptureRegion = True]])
; Parameters ....: $iBuildingType       - an integer value with enum of building to find and retrieve information about from  $g_sBldgNames list
;                  $iAttackingTH        - [optional] an integer value of TH being attacked. Default is 11. Lower TH level reduces # of images by setting MaxLevel
;                  $bforceCaptureRegion  - [optional] a boolean value. Default is True. "False" avoids repetitive capture of same base for multiple finds in row.
; Return values .: None
; Author ........: MonkeyHunter (04-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetLocationBuilding($iBuildingType, $iAttackingTH = 12, $bForceCaptureRegion = True)

	If $g_bDebugSetlog Then SetDebugLog("Begin GetLocationBuilding: " & $g_sBldgNames[$iBuildingType], $COLOR_DEBUG1)
	Local $hTimer = __TimerInit() ; timer to track image detection time

	; Variables
	Local $TotalBuildings = 0
	Local $minLevel = 0
	Local $statFile = ""
	Local $fullCocAreas = "DCD"
	Local $BuildingXY, $redLines, $bRedLineExists, $aBldgCoord, $sTempCoord, $tmpNumFound
	Local $tempNewLevel, $tempExistingLevel, $sLocCoord, $sNearCoord, $sFarCoord, $directory, $iCountUpdate

	; error proof TH level
	If $iAttackingTH = "-" Or Not IsInt($iAttackingTH) Then $iAttackingTH = 12

	; Get path to image file
	If _ObjSearch($g_oBldgImages, $iBuildingType & "_" & $g_iDetectedImageType) = True Then ; check if image exists to prevent error when snow images are not avialable for building type
		$directory = _ObjGetValue($g_oBldgImages, $iBuildingType & "_" & $g_iDetectedImageType)
		If @error Then
			_ObjErrMsg("_ObjGetValue $g_oBldgImages " & $g_sBldgNames[$iBuildingType] & ($g_iDetectedImageType = 1 ? "Snow " : " "), @error) ; Log COM error prevented
			SetError(1, 0, -1) ; unknown image, must exit find
			Return
		EndIf
	Else
		$directory = _ObjGetValue($g_oBldgImages, $iBuildingType & "_0") ; fall back to regular non-snow image if needed
		If @error Then
			_ObjErrMsg("_ObjGetValue $g_oBldgImages" & $g_sBldgNames[$iBuildingType], @error) ; Log COM error prevented
			SetError(1, 0, -1) ; unknown image, must exit find
			Return
		EndIf
	EndIf

	; Get max number of buildings available for TH level
	Local $maxReturnPoints = IsInt($iAttackingTH) ? _ObjGetValue($g_oBldgMaxQty, $iBuildingType)[$iAttackingTH - 1] : _ObjGetValue($g_oBldgMaxQty, $iBuildingType)[11]
	If @error Then
		_ObjErrMsg("_ObjGetValue $g_oBldgMaxQty", @error) ; Log COM error prevented
		$maxReturnPoints = 20 ; unknown number of buildings, then set equal to 20 and keep going
	EndIf

	; Get redline data
	If _ObjSearch($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS") = True Then
		If _ObjGetValue($g_oBldgAttackInfo, $eBldgRedLine & "_COUNT") > 50 Then ; if count is less 50, try again to more red line locations
			$redLines = _ObjGetValue($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS")
			If @error Then _ObjErrMsg("_ObjGetValue $g_oBldgAttackInfo redline", @error) ; Log COM error prevented
			If IsString($redLines) And $redLines <> "" And $redLines <> "ECD" Then ; error check for null red line data in dictionary
				$bRedLineExists = True
			Else
				$redLines = ""
				$bRedLineExists = False
			EndIf
		Else ; if less than 25 redline stored, then try again.
			$redLines = ""
			$bRedLineExists = False
		EndIf
	Else
		$redLines = ""
		$bRedLineExists = False
	EndIf

	; get max building level available for TH
	Local $maxLevel = IsInt($iAttackingTH) ? _ObjGetValue($g_oBldgLevels, $iBuildingType)[$iAttackingTH - 1] : _ObjGetValue($g_oBldgLevels, $iBuildingType)[11]
	If @error Then
		_ObjErrMsg("_ObjGetValue $g_oBldgLevels", @error) ; Log COM error prevented
		$maxLevel = 20 ; unknown number of building levels, then set equal to 20
	EndIf

	If $bForceCaptureRegion = True Then _CaptureRegion2()

	; Perform the search
	Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", $fullCocAreas, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
	If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error)
	If checkImglocError($res, "SearchMultipleTilesBetweenLevels", $directory) = True Then ; check for bad values returned from DLL
		SetError(2, 1, 1) ; set return = 1 when no building found
		Return
	EndIf

	;	Get the redline data
	If $bRedLineExists = False Then ; if already exists, then skip saving again.
		Local $aValue = RetrieveImglocProperty("redline", "")
		If $aValue <> "" Then ; redline exists
			Local $aCoordsSplit = StringSplit($aValue, "|") ; split redlines in x,y, to get count of redline locations
			If $aCoordsSplit[0] > 50 Then ; check that we have enough red line points or keep trying for better data
				$redLines = $aValue
				_ObjPutValue($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS", $redLines) ; add/update value
				If @error Then _ObjErrMsg("_ObjPutValue $g_oBldgAttackInfo", @error)
				Local $redlinesCount = $aCoordsSplit[0] ; assign to variable to avoid constant check for array exists
				_ObjPutValue($g_oBldgAttackInfo, $eBldgRedLine & "_COUNT", $redlinesCount)
				If @error Then _ObjErrMsg("_ObjSetValue $g_oBldgAttackInfo", @error)
			Else
				Setdebuglog("> Not enough red line points to save in building dictionary?", $COLOR_WARNING)
			EndIf
		Else
			SetLog("> DLL Error getting Red Lines in GetLocationBuilding", $COLOR_ERROR)
		EndIf
	EndIf

	; Get rest of data return by DLL
	If $res[0] <> "" Then
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT) ; Spilt each returned key into array
		For $i = 0 To UBound($aKeys) - 1 ; Loop through the array to get all property values
			;SetDebugLog("$aKeys[" & $i & "]: " & $aKeys[$i], $COLOR_DEBUG)  ; key value debug

			; Object level retrieval
			$tempNewLevel = Int(RetrieveImglocProperty($aKeys[$i], "objectlevel"))

			; Munber of objects found retrieval
			$tmpNumFound = Int(RetrieveImglocProperty($aKeys[$i], "totalobjects"))

			; Location string retrieval
			$sTempCoord = RetrieveImglocProperty($aKeys[$i], "objectpoints") ; get location points

			; Check for duplicate locations from DLL when more than 1 location returned?
			If $i = 0 And StringLen($sTempCoord) > 7 Then
				$iCountUpdate = RemoveDupNearby($sTempCoord) ; remove duplicates BYREF, return location count
				If $tmpNumFound <> $iCountUpdate And $iCountUpdate <> "" Then $tmpNumFound = $iCountUpdate
			EndIf

			; check if this building is max level found
			If _ObjSearch($g_oBldgAttackInfo, $iBuildingType & "_MAXLVLFOUND") Then
				$tempExistingLevel = _ObjGetValue($g_oBldgAttackInfo, $iBuildingType & "_MAXLVLFOUND")
			Else
				$tempExistingLevel = 0
			EndIf
			If Int($tempNewLevel) > Int($tempExistingLevel) Then ; save if max level
				_ObjPutValue($g_oBldgAttackInfo, $iBuildingType & "_MAXLVLFOUND", $tempNewLevel)
				If @error Then _ObjErrMsg("_ObjPutValue " & $g_sBldgNames[$iBuildingType] & " _MAXLVLFOUND", @error) ; log errors
				_ObjPutValue($g_oBldgAttackInfo, $iBuildingType & "_NAMEFOUND", $aKeys[$i])
				If @error Then _ObjErrMsg("_ObjPutValue " & $g_sBldgNames[$iBuildingType] & " _NAMEFOUND", @error) ; log errors
			EndIf

			; save all relevant data on every image found using key number to differentiate data, ONLY WHEN more than one image is found!
			If UBound($aKeys) > 1 Then
				_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_LVLFOUND_K" & $i, $tempNewLevel)
				If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iBuildingType] & " _LVLFOUND_K" & $i, @error) ; log errors
				_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_FILENAME_K" & $i, $aKeys[$i])
				If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iBuildingType] & " _FILENAME_K" & $i, @error) ; log errors
				_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_COUNT_K" & $i, $tmpNumFound)
				If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iBuildingType] & " _COUNT_K" & $i, @error) ; log errors
				_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_OBJECTPOINTS_K" & $i, $sTempCoord) ; save string of locations
				If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iBuildingType] & " _OBJECTPOINTS_K" & $i, @error) ; Log errors
			EndIf

			; check if valid objectpoints returned
			If $sTempCoord <> "" Then
				If $sLocCoord = "" Then ; check if 1st set of points
					$sLocCoord = $sTempCoord
					$TotalBuildings = $tmpNumFound
				Else ; if not 1st set, then merge and check for duplicate locations in object points
					$iCountUpdate = AddPoints_RemoveDuplicate($sLocCoord, $sTempCoord, $maxReturnPoints) ; filter results to remove duplicate locations matching same building location, return no more than max allowed
					If $iCountUpdate <> "" Then $TotalBuildings = $iCountUpdate
				EndIf
			Else
				SetDebugLog("> no data in 'objectpoints' request?", $COLOR_WARNING)
			EndIf
		Next
	EndIf

	$aBldgCoord = decodeMultipleCoords($sLocCoord) ; change string into array with location x,y sub-arrays inside each row
	;$aBldgCoord = GetListPixel($sLocCoord, ",", "GetLocationBuilding" & $g_sBldgNames[$iBuildingType]) ; change string into array with debugattackcsv message instead of general log msg?

	If $g_bDebugBuildingPos Or  $g_bDebugSetlog Then ; temp debug message to display building location string returned, and convert "_LOCATION" array to string message for comparison
		SetLog("Bldg Loc Coord String: " & $sLocCoord, $COLOR_DEBUG)
		Local $sText
		Select
			Case UBound($aBldgCoord, 1) > 1 And IsArray($aBldgCoord[1]) ; if we have array of arrays, separate and list
				$sText = PixelArrayToString($aBldgCoord, ",")
			Case IsArray($aBldgCoord[0]) ; single row with array
				Local $aPixelb = $aBldgCoord[0]
				$sText = PixelToString($aPixelb, ";")
			Case IsArray($aBldgCoord[0]) = 0
				$sText = PixelToString($aBldgCoord, ":")
			Case Else
				$sText = "Monkey ate bad banana!"
		EndSelect
		SetLog($g_sBldgNames[$iBuildingType] & " $aBldgCoord Array Contents: " & $sText, $COLOR_DEBUG)
	EndIf

	If IsArray($aBldgCoord) Then ; string and array location(s) save to dictionary
		_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_OBJECTPOINTS", $sLocCoord) ; save string of locations
		If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iBuildingType] & " _OBJECTPOINTS", @error) ; Log errors
		_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_LOCATION", $aBldgCoord) ; save array of locations
		If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iBuildingType] & " _LOCATION", @error) ; Log errors
	EndIf

	If $TotalBuildings <> 0 Then ; building count save to dictionary
		_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_COUNT", $TotalBuildings)
		If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iBuildingType] & " _COUNT", @error) ; Log errors
	EndIf
	SetLog("Total " & $g_sBldgNames[$iBuildingType] & " Buildings: " & $TotalBuildings)

	Local $iTime = __TimerDiff($hTimer) * 0.001 ; Image search time saved to dictionary in seconds
	_ObjAdd($g_oBldgAttackInfo, $iBuildingType & "_FINDTIME", $iTime)
	If @error Then _ObjErrMsg("_ObjAdd" & $g_sBldgNames[$iBuildingType] & " _FINDTIME", @error) ; Log errors

	If $g_bDebugBuildingPos Then SetLog("  - Location(s) found in: " & Round($iTime, 2) & " seconds ", $COLOR_DEBUG)

EndFunc   ;==>GetLocationBuilding

Func DebugImageGetLocation($sVector, $sType, $iBuildingENUM = "")
	SetLog("DebugImageGetLocation() Start:")
	SetLog("$sVector: " & $sVector)
	SetLog("$sType: " & $sType)

	Switch $sType
		Case "DarkElixirStorageWithLevel", "ElixirExtractorWithLevel", "SnowElixirExtractorWithLevel", "MineExtractorWithLevel", "SnowMineExtractorWithLevel", "DarkElixirExtractorWithLevel"
			Local $aVector = StringSplit($sVector, "~", 2) ; 8#387-162~8#460-314
			SetLog("- " & $sType)
			For $i = 0 To UBound($aVector) - 1
				SetLog($sType & " " & $i & " --> " & $aVector[$i])
				Local $temp = StringSplit($aVector[$i], "#", 2) ;TEMP ["2", "404-325"]
				If UBound($temp) = 2 Then
					Local $aPixels = StringSplit($temp[1], "-", 2) ;PIXEL ["404","325"]
					If UBound($aPixels) = 2 Then
						If isInsideDiamondRedArea($aPixels) Then
							If $g_bDebugSetlog Then SetDebugLog("coordinate inside village (" & $aPixels[0] & "," & $aPixels[1] & ")")
							_CaptureRegion($aPixels[0] - 30, $aPixels[1] - 30, $aPixels[0] + 30, $aPixels[1] + 30)
							DebugImageSave("DebugImageGetLocation_" & $sType & "_", False)
						Else
							If $g_bDebugSetlog Then SetDebugLog("coordinate out of village (" & $aPixels[0] & "," & $aPixels[1] & ")")
						EndIf
					EndIf
				EndIf
			Next
		Case "Mine", "SnowMine", "Elixir", "SnowElixir", "DarkElixir", "TownHall", "DarkElixirStorage", "GoldStorage", "ElixirStorage", "Inferno"
			Local $aVector = StringSplit($sVector, "|", 2)
			SetLog("- " & $sType)
			For $i = 0 To UBound($aVector) - 1
				Local $aPixels = StringSplit($aVector[$i], "-", 2) ;PIXEL ["404","325"]
				If UBound($aPixels) = 2 Then
					If isInsideDiamondRedArea($aPixels) Then
						If $g_bDebugSetlog Then SetDebugLog("coordinate inside village (" & $aPixels[0] & "," & $aPixels[1] & ")")
						_CaptureRegion($aPixels[0] - 30, $aPixels[1] - 30, $aPixels[0] + 30, $aPixels[1] + 30)
						DebugImageSave("DebugImageGetLocation_" & $sType & "_", False)
					Else
						If $g_bDebugSetlog Then SetDebugLog("coordinate out of village (" & $aPixels[0] & "," & $aPixels[1] & ")")
					EndIf
				EndIf
			Next
		Case "GetBuildings"
			If $iBuildingENUM = "" Then
				SetLog("DebugImageGetLocation Parameter error!", $COLOR_ERROR)
				Return
			EndIf
			Local $aVector = StringSplit($sVector, "|", 2)
			SetLog("- " & $sType)
			For $i = 0 To UBound($aVector) - 1
				Local $aPixels = StringSplit($aVector[$i], ",", 2) ;PIXEL ["404","325"]
				If UBound($aPixels) = 2 Then
					If isInsideDiamondRedArea($aPixels) Then
						If $g_bDebugSetlog Then SetDebugLog("coordinate inside village (" & $aPixels[0] & "," & $aPixels[1] & ")")
						_CaptureRegion($aPixels[0] - 30, $aPixels[1] - 30, $aPixels[0] + 30, $aPixels[1] + 30)
						DebugImageSave("DebugImageGetLocation_" & StringStripWS($g_sBldgNames[$iBuildingENUM], $STR_STRIPALL) & "_", False)
					Else
						If $g_bDebugSetlog Then SetDebugLog("coordinate out of village (" & $aPixels[0] & "," & $aPixels[1] & ")")
					EndIf
				EndIf
			Next
		Case Else
			SetDebugLog("Bad Input on DebugImageGetLocation(). $sType does not support: " & $sType)
	EndSwitch

EndFunc   ;==>DebugImageGetLocation

Func ConvertImgloc2MBR($aArray, $iMaxPositions, $bLevel = False)

	Local $sStringConverted = Null
	Local $iMax = 0

	If IsArray($aArray) Then
		For $i = 1 To UBound($aArray) - 1 ; from 1 cos the 0 is empty
			Local $aCoord = $aArray[$i][5]
			If IsArray($aCoord) Then ; same level with several positions
				For $t = 0 To UBound($aCoord) - 1
					If isInsideDiamondXY($aCoord[$t][0], $aCoord[$t][1]) Then ; just in case
						If $bLevel Then $sStringConverted &= $aArray[$i][2] & "#" & $aCoord[$t][0] & "-" & $aCoord[$t][1] & "~"
						If Not $bLevel Then $sStringConverted &= $aCoord[$t][0] & "-" & $aCoord[$t][1] & "|"
						$iMax += 1
						If $iMax = $iMaxPositions Then ExitLoop (2)
					EndIf
				Next
			EndIf
		Next
	Else
		SetLog("Error on ConvertImgLoc2MBR(): First Value is no Array!", $COLOR_ERROR)
	EndIf

	$sStringConverted = StringTrimRight($sStringConverted, 1) ; remove the last " |" or "~"
	If $g_bDebugSetlog Then SetDebugLog("$sStringConverted: " & $sStringConverted)

	Return $sStringConverted ; xxx-yyy|xxx-yyy|n.... OR Lv#xxx-yyy~Lv#xxx-yyy
EndFunc   ;==>ConvertImgloc2MBR


