; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseImageDetection
; Description ...: Use on Builder Base attack , Get Points to Deploy , Get buildings etc
; Syntax ........: Several
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

Func TestBuilderBaseBuildingsDetection()
	Setlog("** TestBuilderBaseBuildingsDetection START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	$g_bRunState = True
	; Reset the Boat Position , only in tests
	$g_aBoatPos[0] = Null
	$g_aBoatPos[1] = Null
	Local $SelectedItem = _GUICtrlComboBox_GetCurSel($g_cmbBuildings)
	Local $temp = BuilderBaseBuildingsDetection($SelectedItem)
	For $i = 0 To UBound($temp) - 1
		Setlog(" - " & $temp[$i][0] & " - " & $temp[$i][3] & " - " & $temp[$i][1] & "x" & $temp[$i][2])
	Next
	DebugBuilderBaseBuildingsDetection2($temp)
	$g_bRunState = $Status
	Setlog("** TestBuilderBaseBuildingsDetection END**", $COLOR_DEBUG)
EndFunc   ;==>TestBuilderBaseBuildingsDetection

Func TestBuilderBaseGetDeployPoints()
	Setlog("** TestBuilderBaseGetDeployPoints START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	$g_bRunState = True
	; Reset the Boat Position , only in tests
	$g_aBoatPos[0] = Null
	$g_aBoatPos[1] = Null
	Local $FurtherFrom = 0 ; 5 pixels before the deploy point
	BuilderBaseGetDeployPoints($FurtherFrom, True)
	$g_bRunState = $Status
	Setlog("** TestBuilderBaseGetDeployPoints END**", $COLOR_DEBUG)
EndFunc   ;==>TestBuilderBaseGetDeployPoints

Func TestBuilderBaseGetHall()
	Setlog("** TestBuilderBaseGetHall START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	$g_bRunState = True

	Local $BuilderHallPos = _ImageSearchBundlesMultibot($g_sBundleBuilderHall, $g_aBundleBuilderHallParms[0], $g_aBundleBuilderHallParms[1], $g_aBundleBuilderHallParms[2], True)
	If Not IsArray($BuilderHallPos) And UBound($BuilderHallPos) < 1 Then
		_DebugFailedImageDetection("BuilderHall")
	EndIf
	Setlog(_ArrayToString($BuilderHallPos))
	$g_bRunState = $Status
	Setlog("** TestBuilderBaseGetHall END**", $COLOR_DEBUG)
EndFunc   ;==>TestBuilderBaseGetHall

Func BuilderBaseGetDeployPoints($FurtherFrom = 0, $DebugImage = False)

	If Not $g_bRunState Then Return

	Local $DebugLog
	If $g_bDebugBBattack Or $DebugImage Then $DebugLog = True

	; [0] - TopLeft ,[1] - TopRight , [2] - BottomRight , [3] - BottomLeft
	; Each with an Array [$i][2] =[x,y]  for Xaxis and Yaxis
	Local $DeployPoints[4]
	Local $Name[4] = ["TopLeft", "TopRight", "BottomRight", "BottomLeft"]
	Local $hStarttime = __TimerInit()

	For $i = 0 To 2
		Local $BuilderHallPos = _ImageSearchBundlesMultibot($g_sBundleBuilderHall, $g_aBundleBuilderHallParms[0], $g_aBundleBuilderHallParms[1], $g_aBundleBuilderHallParms[2], $DebugLog)
		If $BuilderHallPos <> -1 And UBound($BuilderHallPos) > 0 Then
			$g_aBuilderHallPos[0][0] = $BuilderHallPos[0][1]
			$g_aBuilderHallPos[0][1] = $BuilderHallPos[0][2]
			ExitLoop
		Else
			_DebugFailedImageDetection("BuilderHall")
			Setlog("Builder Hall detection Error!", $Color_Error)
			If $i = 2 Then
				$g_aBuilderHallPos[0][0] = 450
				$g_aBuilderHallPos[0][1] = 330 ; RC DONE
			EndIf
		EndIf
		If _sleep(1000) Then Return
		;If $i = 2 Then Return -1
	Next
	If Not $g_bRunState Then Return

	Setlog("Builder Base Hall detection: " & Round(__timerdiff($hStarttime) / 1000, 2) & " seconds", $COLOR_DEBUG)
	$hStarttime = __TimerInit()

	Local $DeployPointsResult = _ImageSearchBundlesMultibot($g_sBundleDeployPointsBB, $g_aBundleDeployPointsBBParms[0], $g_aBundleDeployPointsBBParms[1], $g_aBundleDeployPointsBBParms[2], $DebugLog)

	If $DeployPointsResult <> -1 And UBound($DeployPointsResult) > 0 Then
		Local $TopLeft[0][2], $TopRight[0][2], $BottomRight[0][2], $BottomLeft[0][2]
		Local $Point[2], $Local = ""
		For $i = 0 To UBound($DeployPointsResult) - 1
			$Point[0] = Int($DeployPointsResult[$i][1])
			$Point[1] = Int($DeployPointsResult[$i][2])
			SetDebugLog("[" & $i & "]Deploy Point: (" & $Point[0] & "," & $Point[1] & ")")
			$Local = DeployPointsPosition($Point)
			SetDebugLog("[" & $i & "]Deploy Local: (" & $Local & ")")
			Select
				Case $Local = "TopLeft"
					ReDim $TopLeft[UBound($TopLeft) + 1][2]
					$TopLeft[UBound($TopLeft) - 1][0] = $Point[0] - $FurtherFrom
					$TopLeft[UBound($TopLeft) - 1][1] = $Point[1] - $FurtherFrom

				Case $Local = "TopRight"
					ReDim $TopRight[UBound($TopRight) + 1][2]
					$TopRight[UBound($TopRight) - 1][0] = $Point[0] + $FurtherFrom
					$TopRight[UBound($TopRight) - 1][1] = $Point[1] - $FurtherFrom

				Case $Local = "BottomRight"
					ReDim $BottomRight[UBound($BottomRight) + 1][2]
					$BottomRight[UBound($BottomRight) - 1][0] = $Point[0] + $FurtherFrom
					$BottomRight[UBound($BottomRight) - 1][1] = $Point[1] + $FurtherFrom

				Case $Local = "BottomLeft"
					ReDim $BottomLeft[UBound($BottomLeft) + 1][2]
					$BottomLeft[UBound($BottomLeft) - 1][0] = $Point[0] - $FurtherFrom
					$BottomLeft[UBound($BottomLeft) - 1][1] = $Point[1] + $FurtherFrom

			EndSelect
		Next

		Local $Sides[4] = [$TopLeft, $TopRight, $BottomRight, $BottomLeft]

		For $i = 0 To 3
			If Not $g_bRunState Then Return
			Setlog($Name[$i] & " points: " & UBound($Sides[$i]))
			$DeployPoints[$i] = $Sides[$i]
		Next
	Else
		_DebugFailedImageDetection("DeployPoints")
		Setlog("Deploy Points detection Error!", $Color_Error)
		Return -1
	EndIf

	Setlog("Builder Base Internal Deploy Points: " & Round(__timerdiff($hStarttime) / 1000, 2) & " seconds", $COLOR_DEBUG)
	$hStarttime = __TimerInit()

	$g_aBuilderBaseDiamond = BuilderBaseAttackDiamond()

	If $g_aBuilderBaseDiamond = -1 Then
		_DebugFailedImageDetection("DeployPoints")
		Setlog("Deploy $g_aBuilderBaseDiamond - Points detection Error!", $Color_Error)
		$g_aExternalEdges = BuilderBaseGetFakeEdges()
	Else
		$g_aExternalEdges = BuilderBaseGetEdges($g_aBuilderBaseDiamond, "External Edges")
	EndIf

	Setlog("Builder Base Edges Deploy Points: " & Round(__timerdiff($hStarttime) / 1000, 2) & " seconds", $COLOR_DEBUG)

	$hStarttime = __TimerInit()

	$g_aBuilderBaseOuterDiamond = BuilderBaseAttackOuterDiamond()

	If $g_aBuilderBaseOuterDiamond = -1 Then
		_DebugFailedImageDetection("DeployPoints")
		Setlog("Deploy $g_aBuilderBaseOuterDiamond - Points detection Error!", $Color_Error)
		$g_aOuterEdges = BuilderBaseGetFakeEdges()
	Else
		$g_aOuterEdges = BuilderBaseGetEdges($g_aBuilderBaseOuterDiamond, "Outer Edges")
	EndIf

	; Let's get the correct side by BH position  for Outer Points
	Local $TopLeft[0][2], $TopRight[0][2], $BottomRight[0][2], $BottomLeft[0][2]

	For $i = 0 To 3
		If Not $g_bRunState Then Return
		Local $CorrectSide = $g_aOuterEdges[$i]
		For $j = 0 To UBound($CorrectSide) - 1
			Local $Point[2] = [$CorrectSide[$j][0], $CorrectSide[$j][1]]
			Local $Local = DeployPointsPosition($Point)
			Select
				Case $Local = "TopLeft"
					ReDim $TopLeft[UBound($TopLeft) + 1][2]
					$TopLeft[UBound($TopLeft) - 1][0] = $Point[0]
					$TopLeft[UBound($TopLeft) - 1][1] = $Point[1]

				Case $Local = "TopRight"
					ReDim $TopRight[UBound($TopRight) + 1][2]
					$TopRight[UBound($TopRight) - 1][0] = $Point[0]
					$TopRight[UBound($TopRight) - 1][1] = $Point[1]

				Case $Local = "BottomRight"
					ReDim $BottomRight[UBound($BottomRight) + 1][2]
					$BottomRight[UBound($BottomRight) - 1][0] = $Point[0]
					$BottomRight[UBound($BottomRight) - 1][1] = $Point[1]

				Case $Local = "BottomLeft"
					ReDim $BottomLeft[UBound($BottomLeft) + 1][2]
					$BottomLeft[UBound($BottomLeft) - 1][0] = $Point[0]
					$BottomLeft[UBound($BottomLeft) - 1][1] = $Point[1]
			EndSelect
		Next
	Next
	; Final array
	$g_aFinalOuter[0] = $TopLeft
	$g_aFinalOuter[1] = $TopRight
	$g_aFinalOuter[2] = $BottomRight
	$g_aFinalOuter[3] = $BottomLeft

	; Verify how many point and if needs OuterEdges points [10 points]
	For $i = 0 To 3
		If Not $g_bRunState Then Return
		If UBound($DeployPoints[$i]) < 10 Then
			Setlog($Name[$i] & " doesn't have enough deploy points(" & UBound($DeployPoints[$i]) & ") let's use Outer points", $COLOR_DEBUG)
			;When arrayconcatenate does not work so just simply use outer points(Because it can happen due to non array etc)
			If UBound($DeployPoints[$i], $UBOUND_COLUMNS) <> UBound($g_aFinalOuter[$i], $UBOUND_COLUMNS) Then
				SetDebugLog("$DeployPoints Array dimension array diff from $g_aFinalOuter array", $COLOR_DEBUG)
				$DeployPoints[$i] = $g_aFinalOuter[$i]
			Else
				; Array Combine
				Local $tempDeployPoints = $DeployPoints[$i]
				SetDebugLog($Name[$i] & " Outer points are " & UBound($g_aFinalOuter[$i]))
				Local $tempFinalOuter = $g_aFinalOuter[$i]
				For $j = 0 To UBound($tempFinalOuter, $UBOUND_ROWS) - 1
					ReDim $tempDeployPoints[UBound($tempDeployPoints, $UBOUND_ROWS) + 1][2]
					$tempDeployPoints[UBound($tempDeployPoints, $UBOUND_ROWS) - 1][0] = $tempFinalOuter[$j][0]
					$tempDeployPoints[UBound($tempDeployPoints, $UBOUND_ROWS) - 1][1] = $tempFinalOuter[$j][1]
				Next
				$DeployPoints[$i] = $tempDeployPoints
			EndIf
			Setlog($Name[$i] & " points(" & UBound($DeployPoints[$i]) & ") after using outer one", $COLOR_DEBUG)
		EndIf
	Next
	;Find Best 10 points 1-10 , the 5 is the Middle , 1 = closest to BuilderHall
	Local $BestDeployPoints[4]
	For $i = 0 To 3
		;Before Finding Best Drop Points First we need to sort x-axis so we have best points
		_ArraySort($DeployPoints[$i], 0, 0, 0, 0) ; Sort By X-Axis
		SetDebugLog("Get the best Points for " & $Name[$i])
		$BestDeployPoints[$i] = FindBestDropPoints($DeployPoints[$i])
	Next

	Setlog("Builder Base Outer Edges Deploy Points: " & Round(__timerdiff($hStarttime) / 1000, 2) & " seconds", $COLOR_DEBUG)

	If $DebugImage Or $g_bDebugBBattack Then DebugBuilderBaseBuildingsDetection($DeployPoints, $BestDeployPoints, "Deploy_Points")
	$g_aDeployPoints = $DeployPoints
	$g_aDeployBestPoints = $BestDeployPoints

EndFunc   ;==>BuilderBaseGetDeployPoints

Func FindBestDropPoints($DropPoints, $MaxDropPoint = 10)
	;Find Best 10 points 1-10 , the 5 is the Middle , 1 = closest to BuilderHall
	Local $aDeployP[0][2]
	If Not $g_bRunState Then Return
	;Just in case $DropPoints is empty
	If Not UBound($DropPoints) > 0 Then Return

	; If the points are less than MaxDrop Points then is necessary to assign max drop points
	; New code correction
	If UBound($DropPoints) < $MaxDropPoint Then $MaxDropPoint = UBound($DropPoints)

	Local $ArrayDimStep = Ceiling(UBound($DropPoints) / $MaxDropPoint)
	SetDebugLog("The array dimension step is " & $ArrayDimStep)

	ReDim $aDeployP[UBound($aDeployP) + 1][2]
	$aDeployP[UBound($aDeployP) - 1][0] = $DropPoints[0][0] ; X axis First Point
	$aDeployP[UBound($aDeployP) - 1][1] = $DropPoints[0][1] ; Y axis First Point
	SetDebugLog("First point assigned at " & $DropPoints[0][0] & "," & $DropPoints[0][1])
	; New code correction
	If $MaxDropPoint > 2 Then
		For $i = 1 To $MaxDropPoint - 2 ; e.g if $MaxDeployPoint is 10 get 2 to 9 points
			Local $DimensionTemp = $ArrayDimStep * ($i) >= UBound($DropPoints) ? UBound($DropPoints) - 1 : $ArrayDimStep * ($i)
			SetDebugLog("Assigned Array Dimension: " & $DimensionTemp)
			If $DimensionTemp = (UBound($DropPoints) - 1) Then $DimensionTemp -= 1 ; Incase of $DropPoints is Odd Number Last Point Can Be Duplicate to avoid that did the -1
			SetDebugLog("Dimension Correction: " & $DimensionTemp)
			ReDim $aDeployP[UBound($aDeployP) + 1][2]
			$aDeployP[UBound($aDeployP) - 1][0] = $DropPoints[$DimensionTemp][0] ; X axis
			$aDeployP[UBound($aDeployP) - 1][1] = $DropPoints[$DimensionTemp][1] ; Y axis
		Next
	EndIf

	ReDim $aDeployP[UBound($aDeployP) + 1][2]
	$aDeployP[UBound($aDeployP) - 1][0] = $DropPoints[UBound($DropPoints) - 1][0] ; X axis of Last Point
	$aDeployP[UBound($aDeployP) - 1][1] = $DropPoints[UBound($DropPoints) - 1][1] ; Y axis of Last Point
	SetDebugLog("last point assigned at " & $DropPoints[UBound($DropPoints) - 1][0] & "," & $DropPoints[UBound($DropPoints) - 1][1])

	Return $aDeployP
EndFunc   ;==>FindBestDropPoints

Func DeployPointsPosition($Point)
	If Not IsArray($g_aBuilderHallPos) Then Return "TopLeft"
	If $g_aBuilderHallPos[0][0] = Null Then Return "TopLeft"

	; Setlog("BB is:" & $g_aBuilderHallPos[0][0] & "," & $g_aBuilderHallPos[0][1])

	For $i = 0 To 3
		If Not $g_bRunState Then Return
		; LEFT
		If Int($Point[0]) < Int($g_aBuilderHallPos[0][0]) Then
			; TOP
			If Int($Point[1]) < Int($g_aBuilderHallPos[0][1]) Then
				; Setlog("Building is:" & $Point[0] & "," & $Point[1]& " TopLeft")
				Return "TopLeft"
			Else
				; BOTTOM
				; Setlog("Building is:" & $Point[0] & "," & $Point[1]& " BottomLeft")
				Return "BottomLeft"
			EndIf
			; Right
		Else
			; TOP
			If Int($Point[1]) < Int($g_aBuilderHallPos[0][1]) Then
				; Setlog("Building is:" & $Point[0] & "," & $Point[1]& " TopRight")
				Return "TopRight"
			Else
				; BOTTOM
				; Setlog("Building is:" & $Point[0] & "," & $Point[1] & " BottomRight")
				Return "BottomRight"
			EndIf
		EndIf
	Next

	Return "TopLeft"
EndFunc   ;==>DeployPointsPosition

Func BuilderBaseBuildingsDetection($iBuilding = 4)

	; Enum $g_iAirDefense = 0 , $g_iCrusher , $g_GuardPost, $g_iCannon, $g_iBuilderHall, $g_iDeployPoints
	Local $sBuildings = ["AirDefenses", "Crusher", "GuardPost", "Cannon", "BuilderHall", "DeployPoints"]


	Local $Screen[4] = [110, 80, 745, 540] ; RC Done
	If Not $g_bRunState Then Return

	If UBound($sBuildings) < $iBuilding Then Return -1

	Local $sTilePath = $g_sImgOpponentBuildingsBB & $sBuildings[$iBuilding]

	Setlog("initial detection for " & $sBuildings[$iBuilding])

	Local $aResults = QuickMIS("NxCx", $sTilePath, $Screen[0], $Screen[1], $Screen[2], $Screen[3], True, False)
	Local $aAllResults[0][4], $aCoordinates, $aCoord

	If $aResults = 0 Then Return -1

	For $i = 0 To UBound($aResults) - 1
		If Not $g_bRunState Then Return
		$aCoordinates = Null
		$aCoordinates = $aResults[$i][1]
		For $j = 0 To UBound($aCoordinates) - 1
			$aCoord = Null
			$aCoord = $aCoordinates[$j]
			SetDebugLog(" - " & $aResults[$i][0] & " at (" & $aCoord[0] + $Screen[0] & "," & $aCoord[1] + $Screen[1] & ")")
			ReDim $aAllResults[UBound($aAllResults) + 1][4]
			$aAllResults[UBound($aAllResults) - 1][0] = $aResults[$i][0] ; NAME
			$aAllResults[UBound($aAllResults) - 1][1] = $aCoord[0] + $Screen[0] ; X axis
			$aAllResults[UBound($aAllResults) - 1][2] = $aResults[$i][0] = "AirBombs" ? $aCoord[1] + $Screen[1] + 15 : $aCoord[1] + $Screen[1] ; Y axis
			$aAllResults[UBound($aAllResults) - 1][3] = $aResults[$i][2] ; Level
		Next
	Next

	; Sort by X axis
	_ArraySort($aAllResults, 0, 0, 0, 1)

	; Distance in pixels to check if is a duplicated detection , for deploy point will be 5
	Local $D2Check = $iBuilding <> 5 ? 10 : 5

	; check if is a double Detection, near in 10px
	Local $Dime = 0
	For $i = 0 To UBound($aAllResults) - 1
		If Not $g_bRunState Then Return
		If $i > UBound($aAllResults) - 1 Then ExitLoop
		Local $LastCoordinate[4] = [$aAllResults[$i][0], $aAllResults[$i][1], $aAllResults[$i][2], $aAllResults[$i][3]]
		SetDebugLog("Coordinate to Check: " & _ArrayToString($LastCoordinate))
		If UBound($aAllResults) > 1 Then
			For $j = 0 To UBound($aAllResults) - 1
				If $j > UBound($aAllResults) - 1 Then ExitLoop
				; SetDebugLog("$j: " & $j)
				; SetDebugLog("UBound($aAllResults) -1: " & UBound($aAllResults) - 1)
				Local $SingleCoordinate[4] = [$aAllResults[$j][0], $aAllResults[$j][1], $aAllResults[$j][2], $aAllResults[$j][3]]
				; SetDebugLog(" - Comparing with: " & _ArrayToString($SingleCoordinate))
				If $LastCoordinate[1] <> $SingleCoordinate[1] Or $LastCoordinate[2] <> $SingleCoordinate[2] Then
					If Int($SingleCoordinate[1]) < Int($LastCoordinate[1]) + $D2Check And Int($SingleCoordinate[1]) > Int($LastCoordinate[1]) - $D2Check And _
							Int($SingleCoordinate[2]) < Int($LastCoordinate[2]) + $D2Check And Int($SingleCoordinate[2]) > Int($LastCoordinate[2]) - $D2Check Then
						; SetDebugLog(" - removed : " & _ArrayToString($SingleCoordinate))
						_ArrayDelete($aAllResults, $j)
					EndIf
				Else
					If $LastCoordinate[1] = $SingleCoordinate[1] And $LastCoordinate[2] = $SingleCoordinate[2] And $LastCoordinate[3] <> $SingleCoordinate[3] Then
						; SetDebugLog(" - removed equal level : " & _ArrayToString($SingleCoordinate))
						_ArrayDelete($aAllResults, $j)
					EndIf
				EndIf
			Next
		EndIf
	Next

	Return $aAllResults


EndFunc   ;==>BuilderBaseBuildingsDetection

Func DebugBuilderBaseBuildingsDetection2($DetectedBuilding)
	_CaptureRegion2()
	Local $subDirectory = $g_sProfileTempDebugPath & "BuilderBase"
	DirCreate($subDirectory)
	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
	Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3) ; Create a pencil Color FF0000/RED
	Local $filename = ""

	For $i = 0 To UBound($DetectedBuilding) - 1
		Local $SingleCoordinate = [$DetectedBuilding[$i][0], $DetectedBuilding[$i][1], $DetectedBuilding[$i][2]]
		_GDIPlus_GraphicsDrawString($hGraphic, $DetectedBuilding[$i][0], $DetectedBuilding[$i][1] + 10, $DetectedBuilding[$i][2] - 10)
		_GDIPlus_GraphicsDrawRect($hGraphic, $DetectedBuilding[$i][1] - 5, $DetectedBuilding[$i][2] - 5, 10, 10, $hPenRED)
		$filename = String($Date & "_" & $Time & "_" & $DetectedBuilding[$i][0] & "_.png")
	Next

	_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $filename)
	_GDIPlus_PenDispose($hPenRED)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_BitmapDispose($editedImage)
EndFunc   ;==>DebugBuilderBaseBuildingsDetection2

Func DebugBuilderBaseBuildingsDetection($DeployPoints, $BestDeployPoints, $DebugText, $CSVDeployPoints = 0, $isCSVDeployPoints = False)

	_CaptureRegion2()
	Local $subDirectory = $g_sProfileTempDebugPath & "BuilderBase"
	DirCreate($subDirectory)
	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
	Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3) ; Create a pencil Color FF0000/RED
	Local $hPenWhite = _GDIPlus_PenCreate(0xFFFFFFFF, 3) ; Create a pencil Color FFFFFF/WHITE
	Local $hPenYellow = _GDIPlus_PenCreate(0xFFEEF017, 3) ; Create a pencil Color EEF017/YELLOW
	Local $hPenBlue = _GDIPlus_PenCreate(0xFF6052F9, 3) ; Create a pencil Color 6052F9/BLUE

	If $g_aBuilderHallPos[0][1] <> Null Then
		_GDIPlus_GraphicsDrawRect($hGraphic, $g_aBuilderHallPos[0][0] - 5, $g_aBuilderHallPos[0][1] - 5, 10, 10, $hPenRED)
		_GDIPlus_GraphicsDrawLine($hGraphic, 0, $g_aBuilderHallPos[0][1], 860, $g_aBuilderHallPos[0][1], $hPenWhite)
		_GDIPlus_GraphicsDrawLine($hGraphic, $g_aBuilderHallPos[0][0], 0, $g_aBuilderHallPos[0][0], 628, $hPenWhite)
	EndIf

	Local $Text = ["TL", "TR", "BR", "BL"]
	Local $Position[4][2] = [[215, 160], [645, 160], [645, 480], [215, 480]] ; RC Done

	Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
	Local $hFormat = _GDIPlus_StringFormatCreate()
	Local $hFamily = _GDIPlus_FontFamilyCreate("Arial")
	Local $hFont = _GDIPlus_FontCreate($hFamily, 20)

	Local $Size = $g_aBuilderBaseDiamond[0]

	For $i = 1 To UBound($g_aBuilderBaseDiamond) - 1
		Local $Coord = $g_aBuilderBaseDiamond[$i]
		Local $NextCoord = ($i = UBound($g_aBuilderBaseDiamond) - 1) ? $g_aBuilderBaseDiamond[1] : $g_aBuilderBaseDiamond[$i + 1]
		_GDIPlus_GraphicsDrawLine($hGraphic, $Coord[0], $Coord[1], $NextCoord[0], $NextCoord[1], $hPenBlue)
	Next

	Local $Size = $g_aBuilderBaseOuterDiamond[0]

	For $i = 1 To UBound($g_aBuilderBaseOuterDiamond) - 1
		Local $Coord = $g_aBuilderBaseOuterDiamond[$i]
		Local $NextCoord = ($i = UBound($g_aBuilderBaseOuterDiamond) - 1) ? $g_aBuilderBaseOuterDiamond[1] : $g_aBuilderBaseOuterDiamond[$i + 1]
		_GDIPlus_GraphicsDrawLine($hGraphic, $Coord[0], $Coord[1], $NextCoord[0], $NextCoord[1], $hPenBlue)
	Next


	For $i = 0 To UBound($g_aExternalEdges) - 1
		Local $Local = $g_aExternalEdges[$i]
		For $j = 0 To UBound($Local) - 1
			_GDIPlus_GraphicsDrawRect($hGraphic, $Local[$j][0] - 2, $Local[$j][1] - 2, 4, 4, $hPenYellow)
		Next
	Next

	For $i = 0 To UBound($g_aOuterEdges) - 1
		Local $Local = $g_aOuterEdges[$i]
		For $j = 0 To UBound($Local) - 1
			_GDIPlus_GraphicsDrawRect($hGraphic, $Local[$j][0] - 2, $Local[$j][1] - 2, 4, 4, $hPenWhite)
		Next
	Next

	For $i = 0 To 3
		Local $Local = $DeployPoints[$i]
		Local $tLayout = _GDIPlus_RectFCreate($Position[$i][0], $Position[$i][1], 0, 0)
		Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $Text[$i], $hFont, $tLayout, $hFormat)
		_GDIPlus_GraphicsDrawStringEx($hGraphic, $Text[$i], $hFont, $aInfo[0], $hFormat, $hBrush)
		For $j = 0 To UBound($Local) - 1
			_GDIPlus_GraphicsDrawRect($hGraphic, $Local[$j][0] - 2, $Local[$j][1] - 2, 4, 4, $hPenYellow)
		Next
	Next

	For $i = 0 To 3
		Local $Local = $BestDeployPoints[$i]
		Local $tLayout = _GDIPlus_RectFCreate($Position[$i][0], $Position[$i][1], 0, 0)
		Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $Text[$i], $hFont, $tLayout, $hFormat)
		_GDIPlus_GraphicsDrawStringEx($hGraphic, $Text[$i], $hFont, $aInfo[0], $hFormat, $hBrush)
		For $j = 0 To UBound($Local) - 1
			_GDIPlus_GraphicsDrawRect($hGraphic, $Local[$j][0] - 2, $Local[$j][1] - 2, 4, 4, $hPenRED)
		Next
	Next

	If $isCSVDeployPoints And IsArray($CSVDeployPoints) = 1 Then
		For $j = 0 To UBound($CSVDeployPoints) - 1
			_GDIPlus_GraphicsDrawRect($hGraphic, $CSVDeployPoints[$j][0], $CSVDeployPoints[$j][1] - 2, 4, 4, $hPenWhite)
		Next
	EndIf

	Local $filename = String($Date & "_" & $Time & "_" & $DebugText & "_" & $Size & "_.png")

	_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $filename)
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_PenDispose($hPenRED)
	_GDIPlus_PenDispose($hPenWhite)
	_GDIPlus_PenDispose($hPenYellow)
	_GDIPlus_PenDispose($hPenBlue)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_BitmapDispose($editedImage)

EndFunc   ;==>DebugBuilderBaseBuildingsDetection

; TODO RC
Func BuilderBaseAttackDiamond()

	Local $Size = GetBuilderBaseSize(False) ; Wihtout Clicks
	If Not $g_bRunState Then Return
	Setlog("Builder Base Diamond: " & $Size)
	If ($Size < 520 And $Size > 590) Or $Size = 0 Then
		Setlog("Builder Base Attack Zoomout.")
		BuilderBaseZoomOut()
		If _Sleep(1000) Then Return
		$Size = GetBuilderBaseSize(False) ; Wihtout Clicks
	EndIf

	If $Size = 0 Then Return -1

	; ZoomFactor
	Local $CorrectSizeLR = Floor(($Size - 590) / 2)
	Local $CorrectSizeT = Floor(($Size - 590) / 4)
	Local $CorrectSizeB = ($Size - 590)

	; Polygon Points
	Local $Top[2], $Right[2], $BottomR[2], $BottomL[2], $Left[2]

	$Top[0] = $g_aBoatPos[0] - (180 + $CorrectSizeT)
	$Top[1] = $g_aBoatPos[1] + 6

	$Right[0] = $g_aBoatPos[0] + (160 + $CorrectSizeLR)
	$Right[1] = $g_aBoatPos[1] + (260 + $CorrectSizeLR)

	$Left[0] = $g_aBoatPos[0] - (515 + $CorrectSizeB)
	$Left[1] = $g_aBoatPos[1] + (260 + $CorrectSizeLR)

	$BottomR[0] = $g_aBoatPos[0] - (110 - $CorrectSizeB)
	$BottomR[1] = 540

	$BottomL[0] = $g_aBoatPos[0] - (225 + $CorrectSizeB)
	$BottomL[1] = 540

	Local $BuilderBaseDiamond[6] = [$Size, $Top, $Right, $BottomR, $BottomL, $Left]
	Return $BuilderBaseDiamond
EndFunc   ;==>BuilderBaseAttackDiamond

Func BuilderBaseAttackOuterDiamond()
	Local $Size = GetBuilderBaseSize(False) ; WihtoutClicks
	If Not $g_bRunState Then Return
	Setlog("Builder Base Diamond: " & $Size)
	If ($Size < 520 And $Size > 590) Or $Size = 0 Then
		Setlog("Builder Base Attack Zoomout.")
		BuilderBaseZoomOut()
		If _Sleep(1000) Then Return
		$Size = GetBuilderBaseSize(False) ; WihtoutClicks
	EndIf

	If $Size = 0 Then Return -1

	; ZoomFactor
	Local $CorrectSizeLR = Floor(($Size - 590) / 2)
	Local $CorrectSizeT = Floor(($Size - 590) / 4)
	Local $CorrectSizeB = ($Size - 590)

	; Polygon Points
	Local $Top[2], $Right[2], $BottomR[2], $BottomL[2], $Left[2]

	$Top[0] = $g_aBoatPos[0] - (180 + $CorrectSizeT)
	$Top[1] = $g_aBoatPos[1] - 25

	$Right[0] = $g_aBoatPos[0] + (205 + $CorrectSizeLR)
	$Right[1] = $g_aBoatPos[1] + (260 + $CorrectSizeLR)

	$Left[0] = $g_aBoatPos[0] - (560 + $CorrectSizeB)
	$Left[1] = $g_aBoatPos[1] + (260 + $CorrectSizeLR)

	$BottomR[0] = $g_aBoatPos[0] - (70 - $CorrectSizeB)
	$BottomR[1] = 540

	$BottomL[0] = $g_aBoatPos[0] - (275 + $CorrectSizeB)
	$BottomL[1] = 540

	Local $BuilderBaseDiamond[6] = [$Size, $Top, $Right, $BottomR, $BottomL, $Left]
	;This Format is for _IsPointInPoly function
	Dim $g_aBuilderBaseOuterPolygon[7][2] = [[5, -1], [$Top[0], $Top[1]], [$Right[0], $Right[1]], [$BottomR[0], $BottomR[1]], [$BottomL[0], $BottomL[1]], [$Left[0], $Left[1]], [$Top[0], $Top[1]]] ; Make Polygon From Points
	SetDebugLog("Builder Base Outer Polygon : " & _ArrayToString($g_aBuilderBaseOuterPolygon))
	Return $BuilderBaseDiamond
EndFunc   ;==>BuilderBaseAttackOuterDiamond

Func BuilderBaseGetEdges($BuilderBaseDiamond, $Text)

	Local $TopLeft[0][2], $TopRight[0][2], $BottomRight[0][2], $BottomLeft[0][2]
	If Not $g_bRunState Then Return

	; $BuilderBaseDiamond[6] = [$Size, $Top, $Right, $BottomR, $BottomL, $Left]
	Local $Top = $BuilderBaseDiamond[1], $Right = $BuilderBaseDiamond[2], $BottomR = $BuilderBaseDiamond[3], $BottomL = $BuilderBaseDiamond[4], $Left = $BuilderBaseDiamond[5]

	Local $X = [$Top[0], $Right[0]]
	Local $Y = [$Top[1], $Right[1]]

	; TOP RIGHT
	For $i = $X[0] To $X[1] Step 20
		ReDim $TopRight[UBound($TopRight) + 1][2]
		$TopRight[UBound($TopRight) - 1][0] = $i
		$TopRight[UBound($TopRight) - 1][1] = Floor($Y[0])
		$Y[0] += 15
		If $Y[0] > $Y[1] Then ExitLoop
	Next

	Local $X = [$Right[0], $BottomR[0]]
	Local $Y = [$Right[1], $BottomR[1]]

	; BOTTOM RIGHT
	For $i = $X[0] To $X[1] Step -20
		ReDim $BottomRight[UBound($BottomRight) + 1][2]
		$BottomRight[UBound($BottomRight) - 1][0] = $i
		$BottomRight[UBound($BottomRight) - 1][1] = Floor($Y[0])
		$Y[0] += 15
		If $Y[0] > $Y[1] Then ExitLoop
	Next

	Local $X = [$BottomL[0], $Left[0]]
	Local $Y = [$BottomL[1], $Left[1]]

	; BOTTOM LEFT
	For $i = $X[0] To $X[1] Step -20
		ReDim $BottomLeft[UBound($BottomLeft) + 1][2]
		$BottomLeft[UBound($BottomLeft) - 1][0] = $i
		$BottomLeft[UBound($BottomLeft) - 1][1] = Ceiling($Y[0])
		$Y[0] -= 15
		If $Y[0] < $Y[1] Then ExitLoop
	Next

	Local $X = [$Left[0], $Top[0]]
	Local $Y = [$Left[1], $Top[1]]

	; TOP LEFT
	For $i = $X[0] To $X[1] Step 20
		ReDim $TopLeft[UBound($TopLeft) + 1][2]
		$TopLeft[UBound($TopLeft) - 1][0] = $i
		$TopLeft[UBound($TopLeft) - 1][1] = Floor($Y[0])
		$Y[0] -= 15
		If $Y[0] < $Y[1] Then ExitLoop
	Next

	Local $ExternalEdges[4] = [$TopLeft, $TopRight, $BottomRight, $BottomLeft]
	Local $Names = ["Top Left", "Top Right", "Bottom Right", "Bottom Left"]

	For $i = 0 To 3
		SetDebugLog($Text & " Points to " & $Names[$i] & " (" & UBound($ExternalEdges[$i]) & ")")
	Next

	Return $ExternalEdges

EndFunc   ;==>BuilderBaseGetEdges

Func BuilderBaseGetFakeEdges()
	Local $TopLeft[18][2], $TopRight[18][2], $BottomRight[18][2], $BottomLeft[18][2]
	; several points when the Village was not zoomed
	; Presets
	For $i = 0 To 17
		$TopLeft[$i][0] = 145 + ($i * 15)
		$TopLeft[$i][1] = 275 - ($i * 11)
	Next
	For $i = 0 To 17
		$TopRight[$i][0] = 430 + ($i * 20)
		$TopRight[$i][1] = 75 + ($i * 15)
	Next
	For $i = 0 To 17
		$BottomRight[$i][0] = 700 + ($i * 8)
		$BottomRight[$i][1] = 610 - ($i * 6)
	Next
	For $i = 0 To 17
		$BottomLeft[$i][0] = 10 + ($i * 4.5)
		$BottomLeft[$i][1] = 500 + ($i * 3.5)
	Next

	Local $ExternalEdges[4] = [$TopLeft, $TopRight, $BottomRight, $BottomLeft]
	Return $ExternalEdges
EndFunc   ;==>BuilderBaseGetFakeEdges

Func BuilderBaseResetAttackVariables()
	Global $g_aBuilderHallPos[1][2] = [[Null, Null]], $g_aAirdefensesPos[0][2], $g_aCrusherPos[0][2], $g_aCannonPos[0][2], $g_aGuardPostPos[0][2], $g_aDeployPoints, $g_aDeployBestPoints
	Global $g_aOpponentBuildings[6] = [$g_aAirdefensesPos, $g_aCrusherPos, $g_aGuardPostPos, $g_aCannonPos, $g_aBuilderHallPos, $g_aDeployPoints]
	Global $g_aExternalEdges, $g_aBuilderBaseDiamond, $g_aOuterEdges, $g_aBuilderBaseOuterDiamond, $g_aBuilderBaseOuterPolygon, $g_aFinalOuter[4]
EndFunc   ;==>BuilderBaseResetAttackVariables

Func BuilderBaseAttackMainSide()
	Local $sMainSide = "TopLeft"
	Local $sSideNames[4] = ["TopLeft", "TopRight", "BottomRight", "BottomLeft"]
	Local $sBuilderNames[4] = ["Airdefenses", "Crusher", "GuardPost", "Cannon"]
	Local $QuantitiesDetected[4] = [0, 0, 0, 0]
	Local $QuantitiesAttackSide[4] = [0, 0, 0, 0]
	Local $Buildings[4] = [$g_aAirdefensesPos, $g_aCrusherPos, $g_aGuardPostPos, $g_aCannonPos]

	; $g_aAirdefensesPos, $g_aCrusherPos, $g_aGuardPostPos, $g_aCannonPos
	For $Index = 0 To 3
		If Not $g_bRunState Then Return
		Local $tempBuilders = $Buildings[$Index]
		SetDebugLog("BuilderBaseAttackMainSide - Builder Name : " & $sBuilderNames[$Index])
		SetDebugLog("BuilderBaseAttackMainSide - All points: " & _ArrayToString($tempBuilders))
		; Can exist more than One Building detected
		For $Howmany = 0 To UBound($tempBuilders) - 1
			If $tempBuilders[$Howmany][0] = Null Then ExitLoop ; goes to next Builder Type
			Local $TempBuilder = [$tempBuilders[$Howmany][1], $tempBuilders[$Howmany][2]]
			Local $side = DeployPointsPosition($TempBuilder)
			SetDebugLog("BuilderBaseAttackMainSide - Point: " & _ArrayToString($TempBuilder))
			SetDebugLog("BuilderBaseAttackMainSide - " & $sBuilderNames[$Index] & " Side : " & $side)
			For $Sides = 0 To UBound($sSideNames) - 1
				If $side = $sSideNames[$Sides] Then
					; Add one more building to correct side
					$QuantitiesDetected[$Sides] += 1
					; ; ;
					; Let's get the Opposite side If doesn't have any detectable Buiding
					; ; ;
					Local $mainSide = $Sides + 2 > 3 ? Abs(($Sides + 2) - 4) : $Sides + 2
					SetDebugLog(" -- " & $sBuilderNames[$Index] & " Side : " & $sSideNames[$Sides])
					SetDebugLog(" -- MainSide to Attack : " & $sSideNames[$mainSide])
					; Let's check the for sides
					For $j = 0 To 3
						Local $LastBuilderSide = $mainSide
						If $QuantitiesDetected[$mainSide] = 0 Then
							$QuantitiesAttackSide[$mainSide] += 1
							SetDebugLog(" -- Confirming the MainSide [$mainSide]: " & $sSideNames[$mainSide])
							ExitLoop (2) ; exit to next Builder position [$Howmany]
						EndIf
						; Lets check other side
						$mainSide = Abs(($mainSide + 1) - 4)
						SetDebugLog(" --- New MainSide [$mainSide]: " & $sSideNames[$mainSide] & " last Side have a building!")
					Next
				EndIf
			Next
		Next
	Next
	For $i = 0 To 3
		If $QuantitiesDetected[$i] > 0 Then SetDebugLog("BuilderBaseAttackMainSide - $QuantitiesDetected : " & $sSideNames[$i] & " - " & $QuantitiesDetected[$i])
	Next
	For $i = 0 To 3
		If $QuantitiesAttackSide[$i] > 0 Then SetDebugLog("BuilderBaseAttackMainSide - $QuantitiesAttackSide : " & $sSideNames[$i] & " - " & $QuantitiesAttackSide[$i])
	Next

	Local $LessNumber = 0

	For $i = 0 To 3
		If $QuantitiesAttackSide[$i] > $LessNumber Then
			$LessNumber = $QuantitiesAttackSide[$i]
			$sMainSide = $sSideNames[$i]
		EndIf
	Next

	Return $sMainSide
EndFunc   ;==>BuilderBaseAttackMainSide

Func BuilderBaseBuildingsOnEdge($g_aDeployPoints)
	Local $sSideNames[4] = ["TopLeft", "TopRight", "BottomRight", "BottomLeft"]
	; $TempTopLeft[XX][2]
	If UBound($g_aDeployPoints) < 4 Then Return
	If Not $g_bRunState Then Return

	Local $TempTopLeft = $g_aDeployPoints[0]
	Local $TempTopRight = $g_aDeployPoints[1]
	Local $TempBottomRight = $g_aDeployPoints[2]
	Local $TempBottomLeft = $g_aDeployPoints[3]

	; Getting the Out Edges deploy points
	Local $TempOuterTL = $g_aOuterEdges[0]
	Local $TempOuterTR = $g_aOuterEdges[1]
	Local $TempOuterBR = $g_aOuterEdges[2]
	Local $TempOuterBL = $g_aOuterEdges[3]

	;Index 3 Contains Side Name Needed For Adding Tiles Pixel
	Local $ToReturn[0][3], $Left = False, $Top = False, $Right = False, $Bottom = False

	For $Index = 0 To UBound($TempTopLeft) - 1
		If Int($TempTopLeft[$Index][0]) < 200 Then
			If Not $Left Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterTL[0][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterTL[0][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[0]
				$Left = True
				Setlog("Possible Building at edge at LEFT corner " & $TempTopLeft[$Index][0] & "x" & $TempTopLeft[$Index][1], $COLOR_DEBUG)
			EndIf
		ElseIf Int($TempTopLeft[$Index][1]) < 160 Then
			If Not $Top Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterTL[UBound($TempOuterTL) - 1][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterTL[UBound($TempOuterTL) - 1][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[0]
				$Top = True
				Setlog("Possible Building at edge at TOP corner " & $TempTopLeft[$Index][0] & "x" & $TempTopLeft[$Index][1], $COLOR_DEBUG)
			EndIf
		EndIf
	Next

	If Not $g_bRunState Then Return

	For $Index = 0 To UBound($TempTopRight) - 1
		If Int($TempTopRight[$Index][0]) > 690 Then
			If Not $Right Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterTR[UBound($TempOuterTR) - 1][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterTR[UBound($TempOuterTR) - 1][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[1]
				$Right = True
				Setlog("Possible Building at edge at RIGHT corner " & $TempTopRight[$Index][0] & "x" & $TempTopRight[$Index][1], $COLOR_DEBUG)
			EndIf
		ElseIf Int($TempTopRight[$Index][1]) < 160 Then
			If Not $Top Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterTR[0][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterTR[0][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[1]
				$Top = True
				Setlog("Possible Building at edge at TOP corner " & $TempTopRight[$Index][0] & "x" & $TempTopRight[$Index][1], $COLOR_DEBUG)
			EndIf
		EndIf
	Next

	If Not $g_bRunState Then Return

	For $Index = 0 To UBound($TempBottomRight) - 1
		If Int($TempBottomRight[$Index][0]) > 690 Then
			If Not $Right Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterBR[0][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterBR[0][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[2]
				$Right = True
				Setlog("Possible Building at edge at RIGHT corner " & $TempBottomRight[$Index][0] & "x" & $TempBottomRight[$Index][1], $COLOR_DEBUG)
			EndIf
		ElseIf Int($TempBottomRight[$Index][1]) > 490 Then ; RC
			If Not $Bottom Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterBR[UBound($TempOuterBR) - 1][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterBR[UBound($TempOuterBR) - 1][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[2]
				$Bottom = True
				Setlog("Possible Building at edge at BOTTOM corner " & $TempBottomRight[$Index][0] & "x" & $TempBottomRight[$Index][1], $COLOR_DEBUG)
			EndIf
		EndIf
	Next

	If Not $g_bRunState Then Return

	For $Index = 0 To UBound($TempBottomLeft) - 1
		If Int($TempBottomLeft[$Index][0]) < 200 Then
			If Not $Left Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterBL[UBound($TempOuterBL) - 1][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterBL[UBound($TempOuterBL) - 1][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[3]
				$Left = True
				Setlog("Possible Building at edge at LEFT corner " & $TempBottomLeft[$Index][0] & "x" & $TempBottomLeft[$Index][1], $COLOR_DEBUG)
			EndIf
		ElseIf Int($TempBottomLeft[$Index][1]) > 490 Then ; RC
			If Not $Bottom Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterBL[0][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterBL[0][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[3]
				$Bottom = True
				Setlog("Possible Building at edge at BOTTOM corner " & $TempBottomLeft[$Index][0] & "x" & $TempBottomLeft[$Index][1], $COLOR_DEBUG)
			EndIf
		EndIf
	Next

	If Not $g_bRunState Then Return

	Return UBound($ToReturn) > 0 ? $ToReturn : "-1"

EndFunc   ;==>BuilderBaseBuildingsOnEdge


