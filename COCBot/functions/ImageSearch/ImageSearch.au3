; #FUNCTION# ====================================================================================================================
; Name ..........: _ImageSearch
; Description ...:
; Syntax ........: _ImageSearch($findImage, $resultPosition, Byref $x, Byref $y, $Tolerance)
; Parameters ....: $findImage           - the image to find.
;                  $resultPosition      - .
;                  $x                   - [in/out] X Location of image found.
;                  $y                   - [in/out] Y Location of image found.
;                  $Tolerance           - allowable variation in finding image.
; Return values .:
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func _ImageSearch($findImage, $resultPosition, ByRef $x, ByRef $y, $Tolerance)
	Return _ImageSearchArea($findImage, $resultPosition, 0, 0, 840, 630, $x, $y, $Tolerance) ; RC Done
EndFunc   ;==>_ImageSearch
;
;
; #FUNCTION# ====================================================================================================================
; Name ..........: _ImageSearchArea
; Description ...:
; Syntax ........: _ImageSearchArea($findImage, $resultPosition, $x1, $y1, $right, $bottom, Byref $x, Byref $y, $Tolerance)
; Parameters ....: $findImage           - the image to find.
;                  $resultPosition      - 1 returns centered coordinates of image found.
;                  $x1                  - Top left corner X location of area to search
;                  $y1                  - Top left corner Y location of area to search
;                  $right               - Bottom right corner x location of area to search
;                  $bottom              - Bottom right corner y location of area to search
;                  $x                   - X Location of image match if found.
;                  $y                   - Y Location of image match if found.
;                  $Tolerance           - allowable variation in finding image.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func _ImageSearchArea($findImage, $resultPosition, $x1, $y1, $right, $bottom, ByRef $x, ByRef $y, $Tolerance)
	Local $HBMP = $g_hHBitmap
	If $g_bChkBackgroundMode = False Then
		$HBMP = 0
		$x1 += $g_aiBSpos[0]
		$y1 += $g_aiBSpos[1]
		$right += $g_aiBSpos[0]
		$bottom += $g_aiBSpos[1]
	EndIf
	;MsgBox(0,"asd","" & $x1 & " " & $y1 & " " & $right & " " & $bottom)

	Local $result
	If IsString($findImage) Then
		If $Tolerance > 0 Then $findImage = "*" & $Tolerance & " " & $findImage
		If $HBMP = 0 Then
			;$result = DllCallMyBot("ImageSearch", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage) ;
			$result = DllCall($g_sLibImageSearchPath, "str", "ImageSearch", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage) ;
		Else
			;$result = DllCallMyBot("ImageSearchEx", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage, "ptr", $HBMP)
			$result = DllCall($g_sLibImageSearchPath, "str", "ImageSearchEx", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "str", $findImage, "ptr", $HBMP)
		EndIf
	Else
		;$result = DllCallMyBot("ImageSearchExt", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "int", $Tolerance, "ptr", $findImage, "ptr", $HBMP)
		$result = DllCall($g_sLibImageSearchPath, "str", "ImageSearchExt", "int", $x1, "int", $y1, "int", $right, "int", $bottom, "int", $Tolerance, "ptr", $findImage, "ptr", $HBMP)
	EndIf
	If @error Then _logErrorDLLCall($g_sLibImageSearchPath, @error)

	; If error exit
	If IsArray($result) Then
		If $result[0] = "0" Then Return 0
	Else
		SetLog("Error: Image Search not working...", $COLOR_ERROR)
		Return 1
	EndIf


	; Otherwise get the x,y location of the match and the size of the image to
	; compute the centre of search
	Local $array = StringSplit($result[0], "|")
	If (UBound($array) >= 4) Then
		$x = Int(Number($array[2]))
		$y = Int(Number($array[3]))
		If $resultPosition = 1 Then
			$x = $x + Int(Number($array[4]) / 2)
			$y = $y + Int(Number($array[5]) / 2)
		EndIf
		;If $g_bIsHidden = False Then
		$x -= $x1
		$y -= $y1
		;EndIf
		Return 1
	EndIf
EndFunc   ;==>_ImageSearchArea

Func _ImageSearchAreaImgLoc($findImage, $resultPosition, $x1, $y1, $right, $bottom, ByRef $x, ByRef $y, $hHBMP = $g_hHBitmap)

	Local $sArea = Int($x1) & "," & Int($y1) & "|" & Int($right) & "," & Int($y1) & "|" & Int($right) & "," & Int($bottom) & "|" & Int($x1) & "," & Int($bottom)
	Local $MaxReturnPoints = 1

	Local $res = DllCallMyBot("FindTile", "handle", $hHBMP, "str", $findImage, "str", $sArea, "Int", $MaxReturnPoints)
	If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error)
	If IsArray($res) Then
		If $res[0] = "0" Or $res[0] = "" Then
			;SetLog($findImage & " not found", $COLOR_GREEN)
		ElseIf StringLeft($res[0], 2) = "-1" Then
			SetLog("DLL Error: " & $res[0] & ", " & $findImage, $COLOR_ERROR)
		Else
			Local $expRet = StringSplit($res[0], "|", $STR_NOCOUNT)
			;$expret contains 2 positions; 0 is the total objects; 1 is the point in X,Y format
			If UBound($expRet) >= 2 Then
				Local $posPoint = StringSplit($expRet[1], ",", $STR_NOCOUNT)
				If UBound($posPoint) >= 2 Then
					$x = Int($posPoint[0])
					$y = Int($posPoint[1])
					If $resultPosition <> 1 Then ; ImgLoc is always centered, convert to upper-left
						Local $sImgInfo = _ImageGetInfo($findImage)
						Local $iTileWidth = _ImageGetParam($sImgInfo, "Width")
						Local $iTileHeight = _ImageGetParam($sImgInfo, "Height")
						$x -= Int(Number($iTileWidth) / 2)
						$y -= Int(Number($iTileHeight) / 2)
					EndIf
					$x -= $x1
					$y -= $y1
					Return 1
				Else
					;SetLog($findImage & " not found: " & $expRet[1], $COLOR_GREEN)
				EndIf
			EndIf
		EndIf
	EndIf

	Return 0
EndFunc   ;==>_ImageSearchAreaImgLoc

Func _ImageSearchXMLMultibot($XmlPath, $Quantity2Match, $Area2Search, $ForceArea, $DebugLog = False, $checkDuplicatedpoints = False, $Distance2check = 10)

	; DLL call 'MultiBotSearchBundle' , works only with bundles
	; IntPtr Screencapture, string BundlePath, int Quantity2Match, string Area2Search, bool ForceArea, bool DebugLog
	; $Area2Search as String = "X,Y,Width,height"
	; Return : NAME_LEVEL|X,Y-X1,Y1 # NAME_LEVEL|X,Y-X1,Y1 # NAME_LEVEL|X,Y-X1,Y1
	; 		   0 = No Detection , -1 = Empty Bundle , -2 = Security Failed

	; DllCallMyBot("MultiBotSearchBundle", "handle", $g_hHBitmap2, "str", $BundlePath, "Int", $Quantity2Match, "str", $Area2Search, "bool", $ForceArea , "bool", $DebugLog)
	;
	; CollectElixir_1|348,445-484,332#CollectGold_1|395,447#CollectGold_1|443,349

	; JUST IN CASE

	Local $array = _FileListToArray($XmlPath, "*.imgXml")
	If @error Then
		SetLog("Please verify the XML Path!", $COLOR_DEBUG)
		Return -1
	EndIf

	If Not IsInt($Quantity2Match) Then $Quantity2Match = 0
	If Not IsString($Area2Search) Then $Area2Search = "0,0,860,644" ; RC Done
	If Not IsBool($ForceArea) Then $ForceArea = True
	If Not IsBool($DebugLog) Then $DebugLog = False

	; Compatible with BuilderBaseBuildingsDetection()[old function] same return array
	; Result [X][0] = NAME , [x][1] = Xaxis , [x][2] = Yaxis , [x][3] = Level
	Local $AllResults[0][4]
	Local $hStarttime = _Timer_Init()

	; Capture Screen
	_CaptureRegion2()

	Local $res = DllCallMyBot("MultiBotSearchXML", "handle", $g_hHBitmap2, "str", $XmlPath, "Int", $Quantity2Match, "str", $Area2Search, "bool", $ForceArea, "bool", $DebugLog)
	If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error)
	If IsArray($res) Then
		Local $StringResult = $res[0]
		Switch $StringResult
			Case "-3|DEAD"
				SetLog("-- Please visit multibot.run --", $COLOR_DEBUG)
			Case "-2"
				SetLog("-- Security Failed --", $COLOR_DEBUG)
			Case "-1"
				SetLog("-- Empty Bundle --", $COLOR_DEBUG)
			Case "0"
				SetDebugLog("-- No Detection --", $COLOR_DEBUG)
				Return -1
			Case Else
				; lets see if exist '#'
				If $DebugLog Then SetLog("Original string: " & $StringResult, $COLOR_DEBUG)
				If $DebugLog Then Setlog("NewImage, Benchmark: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms !", $COLOR_DEBUG)
				If StringInStr($StringResult, "#") > 0 Then
					Local $Templates = StringSplit($StringResult, "#", $STR_NOCOUNT)
					If $DebugLog Then SetLog("Detected " & UBound($Templates) & " different templates!", $COLOR_INFO)
					For $i = 0 To UBound($Templates) - 1
						Local $Template = StringSplit($Templates[$i], "|", $STR_NOCOUNT)
						; Just In Case
						If Not UBound($Template) = 2 Then ExitLoop
						; let's get Name and level
						Local $NameAndLevel = StringSplit($Template[0], "_", $STR_NOCOUNT)
						; Let's get the coordinates
						; 348,445-484,332
						Local $CoordinateString = $Template[1]
						Local $AllCoordinates = StringSplit($CoordinateString, "-", $STR_NOCOUNT)
						For $j = 0 To UBound($AllCoordinates) - 1
							; Redim and Populate Name and Level
							ReDim $AllResults[UBound($AllResults) + 1][4]
							$AllResults[UBound($AllResults) - 1][0] = $NameAndLevel[0] ; Name
							$AllResults[UBound($AllResults) - 1][3] = Int($NameAndLevel[1]) ; level
							Local $SingleCoordinate = $AllCoordinates[$j]
							; Get X and Y
							Local $arraySingle = StringSplit($SingleCoordinate, ",", $STR_NOCOUNT)
							$AllResults[UBound($AllResults) - 1][1] = Int($arraySingle[0]) ; Xaxis
							$AllResults[UBound($AllResults) - 1][2] = Int($arraySingle[1]) ; Yaxis
						Next
					Next
				Else
					If $DebugLog Then SetLog("Detected 1 different template!", $COLOR_INFO)
					Local $Template = StringSplit($StringResult, "|", $STR_NOCOUNT)
					; Just In Case
					If Not UBound($Template) = 2 Then Return -1
					; let's get Name and level
					Local $NameAndLevel = StringSplit($Template[0], "_", $STR_NOCOUNT)
					; Let's get the coordinates
					; 348,445-484,332
					Local $CoordinateString = $Template[1]
					Local $AllCoordinates = StringSplit($CoordinateString, "-", $STR_NOCOUNT)
					For $j = 0 To UBound($AllCoordinates) - 1
						; Redim and Populate Name and Level
						ReDim $AllResults[UBound($AllResults) + 1][4]
						$AllResults[UBound($AllResults) - 1][0] = $NameAndLevel[0] ; Name
						$AllResults[UBound($AllResults) - 1][3] = Int($NameAndLevel[1]) ; level
						Local $SingleCoordinate = $AllCoordinates[$j]
						; Get X and Y
						Local $arraySingle = StringSplit($SingleCoordinate, ",", $STR_NOCOUNT)
						$AllResults[UBound($AllResults) - 1][1] = Int($arraySingle[0]) ; Xaxis
						$AllResults[UBound($AllResults) - 1][2] = Int($arraySingle[1]) ; Yaxis
					Next
				EndIf

				; USER LOG
				For $i = 0 To UBound($AllResults) - 1
					If $DebugLog Then SetLog("Detected " & $AllResults[$i][0] & " Level " & $AllResults[$i][3] & " at (" & $AllResults[$i][1] & "," & $AllResults[$i][2] & ")", $COLOR_INFO)
				Next

				If ($g_bDebugImageSave Or $DebugLog) And UBound($AllResults) < 50 Then ; Discard Deploy Points Touch much text on image
					_CaptureRegion2()

					Local $sSubDir = $g_sProfileTempDebugPath & "ImageSearchBundlesMultibot"

					DirCreate($sSubDir)

					Local $sDate = @YEAR & "-" & @MON & "-" & @MDAY, $sTime = @HOUR & "." & @MIN & "." & @SEC
					Local $sDebugImageName = String($sDate & "_" & $sTime & "_.png")
					Local $hEditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
					Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hEditedImage)
					Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3)

					For $i = 0 To UBound($AllResults) - 1
						addInfoToDebugImage($hGraphic, $hPenRED, $AllResults[$i][0] & "_" & $AllResults[$i][3], $AllResults[$i][1], $AllResults[$i][2])
					Next

					_GDIPlus_ImageSaveToFile($hEditedImage, $sSubDir & "\" & $sDebugImageName)
					_GDIPlus_PenDispose($hPenRED)
					_GDIPlus_GraphicsDispose($hGraphic)
					_GDIPlus_BitmapDispose($hEditedImage)
				EndIf

		EndSwitch
	EndIf

	If $checkDuplicatedpoints And UBound($AllResults) > 0 Then
		; Sort by X axis
		_ArraySort($AllResults, 0, 0, 0, 1)

		; Distance in pixels to check if is a duplicated detection , for deploy point will be 5
		Local $D2Check = $Distance2check

		; check if is a double Detection, near in 10px
		Local $Dime = 0
		For $i = 0 To UBound($AllResults) - 1
			If $i > UBound($AllResults) - 1 Then ExitLoop
			Local $LastCoordinate[4] = [$AllResults[$i][0], $AllResults[$i][1], $AllResults[$i][2], $AllResults[$i][3]]
			SetDebugLog("Coordinate to Check: " & _ArrayToString($LastCoordinate))
			If UBound($AllResults) > 1 Then
				For $j = 0 To UBound($AllResults) - 1
					If $j > UBound($AllResults) - 1 Then ExitLoop
					; SetDebugLog("$j: " & $j)
					; SetDebugLog("UBound($aAllResults) -1: " & UBound($aAllResults) - 1)
					Local $SingleCoordinate[4] = [$AllResults[$j][0], $AllResults[$j][1], $AllResults[$j][2], $AllResults[$j][3]]
					; SetDebugLog(" - Comparing with: " & _ArrayToString($SingleCoordinate))
					If $LastCoordinate[1] <> $SingleCoordinate[1] Or $LastCoordinate[2] <> $SingleCoordinate[2] Then
						If Int($SingleCoordinate[1]) < Int($LastCoordinate[1]) + $D2Check And Int($SingleCoordinate[1]) > Int($LastCoordinate[1]) - $D2Check And _
								Int($SingleCoordinate[2]) < Int($LastCoordinate[2]) + $D2Check And Int($SingleCoordinate[2]) > Int($LastCoordinate[2]) - $D2Check Then
							; SetDebugLog(" - removed : " & _ArrayToString($SingleCoordinate))
							_ArrayDelete($AllResults, $j)
						EndIf
					Else
						If $LastCoordinate[1] = $SingleCoordinate[1] And $LastCoordinate[2] = $SingleCoordinate[2] And $LastCoordinate[3] <> $SingleCoordinate[3] Then
							; SetDebugLog(" - removed equal level : " & _ArrayToString($SingleCoordinate))
							_ArrayDelete($AllResults, $j)
						EndIf
					EndIf
				Next
			EndIf
		Next
	EndIf

	If (UBound($AllResults) > 0) Then
		Return $AllResults
	Else
		Return -1
	EndIf

EndFunc   ;==>_ImageSearchXMLMultibot

Func _ImageSearchBundlesMultibot($BundlePath, $Quantity2Match, $Area2Search, $ForceArea, $DebugLog = False, $checkDuplicatedpoints = False, $Distance2check = 10, $level = 0)

	; DLL call 'MultiBotSearchBundle' , works only with bundles
	; IntPtr Screencapture, string BundlePath, int Quantity2Match, string Area2Search, bool ForceArea, bool DebugLog
	; $Area2Search as String = "X,Y,Width,height"
	; Return : NAME_LEVEL|X,Y-X1,Y1 # NAME_LEVEL|X,Y-X1,Y1 # NAME_LEVEL|X,Y-X1,Y1
	; 		   0 = No Detection , -1 = Empty Bundle , -2 = Security Failed

	; DllCallMyBot("MultiBotSearchBundle", "handle", $g_hHBitmap2, "str", $BundlePath, "Int", $Quantity2Match, "str", $Area2Search, "bool", $ForceArea , "bool", $DebugLog)
	;
	; CollectElixir_1|348,445-484,332#CollectGold_1|395,447#CollectGold_1|443,349


	; JUST IN CASE
	If StringInStr($BundlePath, ".DocBundle") = 0 Then
		SetLog("Please verify the Bundle Path!", $COLOR_DEBUG)
		Return -1
	EndIf
	If Not FileExists($BundlePath) Then
		SetLog("Please verify the Bundle Path! File doesn't exist!", $COLOR_DEBUG)
		Return -1
	EndIf
	If Not IsInt($Quantity2Match) Then $Quantity2Match = 0
	If Not IsString($Area2Search) Then $Area2Search = "0,0,860,644" ; RC Done
	If Not IsBool($ForceArea) Then $ForceArea = True
	If Not IsBool($DebugLog) Then $DebugLog = False

	; Compatible with BuilderBaseBuildingsDetection()[old function] same return array
	; Result [X][0] = NAME , [x][1] = Xaxis , [x][2] = Yaxis , [x][3] = Level
	Local $AllResults[0][4]
	Local $hStarttime = _Timer_Init()

	; Capture Screen
	_CaptureRegion2()

	Local $res = DllCallMyBot("MultiBotSearchBundle", "handle", $g_hHBitmap2, "str", $BundlePath, "Int", $Quantity2Match, "str", $Area2Search, "bool", $ForceArea, "bool", $DebugLog, "Int", $level)
	If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error)
	If IsArray($res) Then
		Local $StringResult = $res[0]
		Switch $StringResult
			Case "-3|DEAD"
				SetLog("-- Please visit multibot.run --", $COLOR_DEBUG)
			Case "-2"
				SetLog("-- Security Failed --", $COLOR_DEBUG)
			Case "-1"
				SetLog("-- Empty Bundle --", $COLOR_DEBUG)
			Case "0"
				SetDebugLog("-- No Detection --", $COLOR_DEBUG)
				Return -1
			Case Else
				; lets see if exist '#'
				If $DebugLog Then SetLog("Original string: " & $StringResult, $COLOR_DEBUG)
				If $DebugLog Then Setlog("NewImage, Benchmark: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms !", $COLOR_DEBUG)
				If StringInStr($StringResult, "#") > 0 Then
					Local $Templates = StringSplit($StringResult, "#", $STR_NOCOUNT)
					If $DebugLog Then SetLog("Detected " & UBound($Templates) & " different templates!", $COLOR_INFO)
					For $i = 0 To UBound($Templates) - 1
						Local $Template = StringSplit($Templates[$i], "|", $STR_NOCOUNT)
						; Just In Case
						If Not UBound($Template) = 2 Then ExitLoop
						; let's get Name and level
						Local $NameAndLevel = StringSplit($Template[0], "_", $STR_NOCOUNT)
						; Let's get the coordinates
						; 348,445-484,332
						Local $CoordinateString = $Template[1]
						Local $AllCoordinates = StringSplit($CoordinateString, "-", $STR_NOCOUNT)
						For $j = 0 To UBound($AllCoordinates) - 1
							; Redim and Populate Name and Level
							ReDim $AllResults[UBound($AllResults) + 1][4]
							$AllResults[UBound($AllResults) - 1][0] = $NameAndLevel[0] ; Name
							$AllResults[UBound($AllResults) - 1][3] = Int($NameAndLevel[1]) ; level
							Local $SingleCoordinate = $AllCoordinates[$j]
							; Get X and Y
							Local $arraySingle = StringSplit($SingleCoordinate, ",", $STR_NOCOUNT)
							$AllResults[UBound($AllResults) - 1][1] = Int($arraySingle[0]) ; Xaxis
							$AllResults[UBound($AllResults) - 1][2] = Int($arraySingle[1]) ; Yaxis
						Next
					Next
				Else
					If $DebugLog Then SetLog("Detected 1 different template!", $COLOR_INFO)
					Local $Template = StringSplit($StringResult, "|", $STR_NOCOUNT)
					; Just In Case
					If Not UBound($Template) = 2 Then Return -1
					; let's get Name and level
					Local $NameAndLevel = StringSplit($Template[0], "_", $STR_NOCOUNT)
					; Let's get the coordinates
					; 348,445-484,332
					Local $CoordinateString = $Template[1]
					Local $AllCoordinates = StringSplit($CoordinateString, "-", $STR_NOCOUNT)
					For $j = 0 To UBound($AllCoordinates) - 1
						; Redim and Populate Name and Level
						ReDim $AllResults[UBound($AllResults) + 1][4]
						$AllResults[UBound($AllResults) - 1][0] = $NameAndLevel[0] ; Name
						$AllResults[UBound($AllResults) - 1][3] = Int($NameAndLevel[1]) ; level
						Local $SingleCoordinate = $AllCoordinates[$j]
						; Get X and Y
						Local $arraySingle = StringSplit($SingleCoordinate, ",", $STR_NOCOUNT)
						$AllResults[UBound($AllResults) - 1][1] = Int($arraySingle[0]) ; Xaxis
						$AllResults[UBound($AllResults) - 1][2] = Int($arraySingle[1]) ; Yaxis
					Next
				EndIf

				; USER LOG
				For $i = 0 To UBound($AllResults) - 1
					If $DebugLog Then SetLog("Detected " & $AllResults[$i][0] & " Level " & $AllResults[$i][3] & " at (" & $AllResults[$i][1] & "," & $AllResults[$i][2] & ")", $COLOR_INFO)
				Next

				If ($g_bDebugImageSave Or $DebugLog) And UBound($AllResults) < 50 Then ; Discard Deploy Points Touch much text on image
					_CaptureRegion2()

					Local $sSubDir = $g_sProfileTempDebugPath & "ImageSearchBundlesMultibot"

					DirCreate($sSubDir)

					Local $sDate = @YEAR & "-" & @MON & "-" & @MDAY, $sTime = @HOUR & "." & @MIN & "." & @SEC
					Local $sDebugImageName = String($sDate & "_" & $sTime & "_.png")
					Local $hEditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
					Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hEditedImage)
					Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3)

					For $i = 0 To UBound($AllResults) - 1
						addInfoToDebugImage($hGraphic, $hPenRED, $AllResults[$i][0] & "_" & $AllResults[$i][3], $AllResults[$i][1], $AllResults[$i][2])
					Next

					_GDIPlus_ImageSaveToFile($hEditedImage, $sSubDir & "\" & $sDebugImageName)
					_GDIPlus_PenDispose($hPenRED)
					_GDIPlus_GraphicsDispose($hGraphic)
					_GDIPlus_BitmapDispose($hEditedImage)
				EndIf

		EndSwitch
	EndIf

	If $checkDuplicatedpoints And UBound($AllResults) > 0 Then
		; Sort by X axis
		_ArraySort($AllResults, 0, 0, 0, 1)

		; Distance in pixels to check if is a duplicated detection , for deploy point will be 5
		Local $D2Check = $Distance2check

		; check if is a double Detection, near in 10px
		Local $Dime = 0
		For $i = 0 To UBound($AllResults) - 1
			If $i > UBound($AllResults) - 1 Then ExitLoop
			Local $LastCoordinate[4] = [$AllResults[$i][0], $AllResults[$i][1], $AllResults[$i][2], $AllResults[$i][3]]
			SetDebugLog("Coordinate to Check: " & _ArrayToString($LastCoordinate))
			If UBound($AllResults) > 1 Then
				For $j = 0 To UBound($AllResults) - 1
					If $j > UBound($AllResults) - 1 Then ExitLoop
					; SetDebugLog("$j: " & $j)
					; SetDebugLog("UBound($aAllResults) -1: " & UBound($aAllResults) - 1)
					Local $SingleCoordinate[4] = [$AllResults[$j][0], $AllResults[$j][1], $AllResults[$j][2], $AllResults[$j][3]]
					; SetDebugLog(" - Comparing with: " & _ArrayToString($SingleCoordinate))
					If $LastCoordinate[1] <> $SingleCoordinate[1] Or $LastCoordinate[2] <> $SingleCoordinate[2] Then
						If Int($SingleCoordinate[1]) < Int($LastCoordinate[1]) + $D2Check And Int($SingleCoordinate[1]) > Int($LastCoordinate[1]) - $D2Check And _
								Int($SingleCoordinate[2]) < Int($LastCoordinate[2]) + $D2Check And Int($SingleCoordinate[2]) > Int($LastCoordinate[2]) - $D2Check Then
							; SetDebugLog(" - removed : " & _ArrayToString($SingleCoordinate))
							_ArrayDelete($AllResults, $j)
						EndIf
					Else
						If $LastCoordinate[1] = $SingleCoordinate[1] And $LastCoordinate[2] = $SingleCoordinate[2] And $LastCoordinate[3] <> $SingleCoordinate[3] Then
							; SetDebugLog(" - removed equal level : " & _ArrayToString($SingleCoordinate))
							_ArrayDelete($AllResults, $j)
						EndIf
					EndIf
				Next
			EndIf
		Next
	EndIf

	If (UBound($AllResults) > 0) Then
		Return $AllResults
	Else
		Return -1
	EndIf

EndFunc   ;==>_ImageSearchBundlesMultibot

Func _DebugFailedImageDetection($Text)
	If $g_bDebugImageSave Then
		_CaptureRegion2()
		Local $sSubDir = $g_sProfileTempDebugPath & "NewImageDetectionFails"
		DirCreate($sSubDir)
		Local $sDate = @YEAR & "-" & @MON & "-" & @MDAY
		Local $sTime = @HOUR & "." & @MIN & "." & @SEC
		Local $sDebugImageName = String($sDate & "_" & $sTime & "__" & $Text & "_.png")
		Local $hEditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		_GDIPlus_ImageSaveToFile($hEditedImage, $sSubDir & "\" & $sDebugImageName)
		_GDIPlus_BitmapDispose($hEditedImage)
	EndIf
EndFunc   ;==>_DebugFailedImageDetection
