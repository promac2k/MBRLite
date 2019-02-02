; #FUNCTION# ====================================================================================================================
; Name ..........: GetVillageSize
; Description ...: Measures the size of village. After CoC October 2016 update, max'ed zoomed out village is 440 (reference!)
;                  But usually sizes around 470 - 490 pixels are measured due to lock on max zoom out.
; Syntax ........: GetVillageSize()
; Parameters ....:
; Return values .: 0 if not identified or Array with index
;                      0 = Size of village (float)
;                      1 = Zoom factor based on 443 village size (float)
;                      2 = X offset of village center (int)
;                      3 = Y offset of village center (int)
;                      4 = X coordinate of stone
;                      5 = Y coordinate of stone
;                      6 = stone image file name
;                      7 = X coordinate of tree
;                      8 = Y coordinate of tree
;                      9 = tree image file name
; Author ........: Cosote (Oct 17th 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func TestGetVillageSize()
	SetDebugLog("** GetVillageSize START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	$g_bRunState = True

	GetVillageSize(True, Default, Default, True, True)

	$g_bRunState = $Status
	SetDebugLog("** GetVillageSize END**", $COLOR_DEBUG)
EndFunc

Func GetVillageSize($DebugLog = False, $sStonePrefix = Default, $sTreePrefix = Default, $debugwithImage = False, $bForecCapture = False)

	; [xx][0] = X , [1] = Y , [2] = Name
	Local $DebugImage[0][3]

	If $debugwithImage Then

		If $bForecCapture Then _CaptureRegion2()
		Local $subDirectory = $g_sProfileTempDebugPath & "ZoomOut"
		DirCreate($subDirectory)
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3) ; Create a pencil Color FF0000/RED
		Local $hPenWhite = _GDIPlus_PenCreate(0xFFFFFFFF, 3) ; Create a pencil Color FFFFFF/WHITE
		Local $hPenYellow = _GDIPlus_PenCreate(0xFFEEF017, 3) ; Create a pencil Color EEF017/YELLOW
		Local $hPenBlue = _GDIPlus_PenCreate(0xFF6052F9, 3) ; Create a pencil Color 6052F9/BLUE

		Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
		Local $hFormat = _GDIPlus_StringFormatCreate()
		Local $hFamily = _GDIPlus_FontFamilyCreate("Arial")
		Local $hFont = _GDIPlus_FontCreate($hFamily, 8)
		Local $filename = String($Date & "_" & $Time & "_ZoomOut_.png")

	EndIf

	If $sStonePrefix = Default Then $sStonePrefix = "stone"
	If $sTreePrefix = Default Then $sTreePrefix = "tree"

	Local $aResult = 0
	Local $sDirectory
	Local $stone[6] = [0, 0, 0, 0, 0, ""], $tree[6] = [0, 0, 0, 0, 0, ""]
	Local $x0, $y0, $d0, $x, $y, $x1, $y1, $right, $bottom, $a

	Local $iAdditional = 75

	If isOnBuilderBase(True) Then
		$sDirectory = $g_sImgZoomOutDirBB
	Else
		$sDirectory = $g_sImgZoomOutDir
	EndIf

	Local $aStoneFiles = _FileListToArray($sDirectory, $sStonePrefix & "*.*", $FLTA_FILES)
	If @error Then
		SetLog("Error: Missing stone files (" & @error & ")", $COLOR_ERROR)
		Return $aResult
	EndIf
	; use stoneBlueStacks2A stones first
	Local $iNewIdx = 1
	For $i = 1 To $aStoneFiles[0]
		If StringInStr($aStoneFiles[$i], "stoneBlueStacks2A") = 1 Then
			Local $s = $aStoneFiles[$iNewIdx]
			$aStoneFiles[$iNewIdx] = $aStoneFiles[$i]
			$aStoneFiles[$i] = $s
			$iNewIdx += 1
		EndIf
	Next
	Local $aTreeFiles = _FileListToArray($sDirectory, $sTreePrefix & "*.*", $FLTA_FILES)
	If @error Then
		SetLog("Error: Missing tree (" & @error & ")", $COLOR_ERROR)
		Return $aResult
	EndIf
	Local $i, $findImage, $sArea, $a

	For $i = 1 To $aStoneFiles[0]
		$findImage = $aStoneFiles[$i]
		$a = StringRegExp($findImage, ".*-(\d+)-(\d+)-(\d*,*\d+)_.*[.](xml|png|bmp)$", $STR_REGEXPARRAYMATCH)
		If UBound($a) = 4 Then

			$x0 = $a[0]
			$y0 = $a[1]
			$d0 = StringReplace($a[2], ",", ".")

			$x1 = $x0 - $iAdditional
			$y1 = $y0 - $iAdditional
			$right = $x0 + $iAdditional
			$bottom = $y0 + $iAdditional
			$sArea = Int($x1) & "," & Int($y1) & "|" & Int($right) & "," & Int($y1) & "|" & Int($right) & "," & Int($bottom) & "|" & Int($x1) & "," & Int($bottom)
			;SetDebugLog("GetVillageSize check for image " & $findImage)
			If $DebugLog Then setlog("GetVillageSize: " & $findImage)
			$a = decodeSingleCoord(findImage($findImage, $sDirectory & $findImage, $sArea, 1, True))
			If UBound($a) = 2 Then
				$x = Int($a[0])
				$y = Int($a[1])
				;SetDebugLog("Found stone image at " & $x & ", " & $y & ": " & $findImage)
				$stone[0] = $x ; x center of stone found
				$stone[1] = $y ; y center of stone found
				$stone[2] = $x0 ; x ref. center of stone
				$stone[3] = $y0 ; y ref. center of stone
				$stone[4] = $d0 ; distance to village map in pixel
				$stone[5] = $findImage

				; [xx][0] = X , [1] = Y , [2] = Name
				Redim $DebugImage[UBound($DebugImage) + 1][3]
				$DebugImage[UBound($DebugImage) - 1][0] = $x
				$DebugImage[UBound($DebugImage) - 1][1] = $y
				$DebugImage[UBound($DebugImage) - 1][2] = $findImage

				If $debugwithImage Then
					_GDIPlus_GraphicsDrawRect($hGraphic, $x - 5, $y - 5, 10, 10, $hPenBlue)
					_GDIPlus_GraphicsDrawRect($hGraphic, $x0 - 5, $y0 - 5, 10, 10, $hPenWhite)
					Local $tLayout = _GDIPlus_RectFCreate(Abs($x - $x0) + $x, Abs($y - $y0) + $y, 0, 0)
					Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $findImage & "_" & $d0, $hFont, $tLayout, $hFormat)
					_GDIPlus_GraphicsDrawStringEx($hGraphic, $findImage & "_" & $d0, $hFont, $aInfo[0], $hFormat, $hBrush)
				EndIf
				ExitLoop
			EndIf

		Else
			;SetDebugLog("GetVillageSize ignore image " & $findImage & ", reason: " & UBound($a), $COLOR_WARNING)
		EndIf
	Next

	If $stone[0] = 0 Then
		SetDebugLog("GetVillageSize cannot find stone", $COLOR_WARNING)
		If $debugwithImage Then
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
		EndIf
		Return $aResult
	EndIf

	For $i = 1 To $aTreeFiles[0]
		$findImage = $aTreeFiles[$i]
		$a = StringRegExp($findImage, ".*-(\d+)-(\d+)-(\d*,*\d+)_.*[.](xml|png|bmp)$", $STR_REGEXPARRAYMATCH)
		If UBound($a) = 4 Then

			$x0 = $a[0]
			$y0 = $a[1]
			$d0 = StringReplace($a[2], ",", ".")

			$x1 = $x0 - $iAdditional
			$y1 = $y0 - $iAdditional
			$right = $x0 + $iAdditional
			$bottom = $y0 + $iAdditional
			$sArea = Int($x1) & "," & Int($y1) & "|" & Int($right) & "," & Int($y1) & "|" & Int($right) & "," & Int($bottom) & "|" & Int($x1) & "," & Int($bottom)
			;SetDebugLog("GetVillageSize check for image " & $findImage)
			$a = decodeSingleCoord(findImage($findImage, $sDirectory & $findImage, $sArea, 1, False))
			If UBound($a) = 2 Then
				$x = Int($a[0])
				$y = Int($a[1])
				;SetDebugLog("Found tree image at " & $x & ", " & $y & ": " & $findImage)
				$tree[0] = $x ; x center of tree found
				$tree[1] = $y ; y center of tree found
				$tree[2] = $x0 ; x ref. center of tree
				$tree[3] = $y0 ; y ref. center of tree
				$tree[4] = $d0 ; distance to village map in pixel
				$tree[5] = $findImage

				; [xx][0] = X , [1] = Y , [2] = Name
				Redim $DebugImage[UBound($DebugImage) + 1][3]
				$DebugImage[UBound($DebugImage) - 1][0] = $x
				$DebugImage[UBound($DebugImage) - 1][1] = $y
				$DebugImage[UBound($DebugImage) - 1][2] = $findImage

				If $debugwithImage Then
					_GDIPlus_GraphicsDrawRect($hGraphic, $x - 5, $y - 5, 10, 10, $hPenBlue)
					_GDIPlus_GraphicsDrawRect($hGraphic, $x0 - 5, $y0 - 5, 10, 10, $hPenWhite)
					Local $tLayout = _GDIPlus_RectFCreate(Abs($x - $x0) + $x - 150, Abs($y - $y0) + $y + 10, 0, 0)
					Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $findImage & "_" & $d0, $hFont, $tLayout, $hFormat)
					_GDIPlus_GraphicsDrawStringEx($hGraphic, $findImage & "_" & $d0, $hFont, $aInfo[0], $hFormat, $hBrush)
				EndIf
				ExitLoop
			EndIf

		Else
			;SetDebugLog("GetVillageSize ignore image " & $findImage & ", reason: " & UBound($a), $COLOR_WARNING)
		EndIf
	Next

	If $tree[0] = 0 Then
		SetDebugLog("GetVillageSize cannot find tree", $COLOR_WARNING)
		If $debugwithImage Then
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
		EndIf
		Return $aResult
	EndIf

	; calculate village size, see https://en.wikipedia.org/wiki/Pythagorean_theorem
	Local $a = $tree[0] - $stone[0]
	Local $b = $stone[1] - $tree[1]
	Local $c = Sqrt($a * $a + $b * $b) - $stone[4] - $tree[4]

	Local $txtDebug = "White square : Expected position" & @CRLF & _
			"Blue square : Detected position" & @CRLF & _
			"$tree[0]: " & $tree[0] & " - $stone[0]: " & $stone[0] & " = " & $a & @CRLF & _
			"$stone[1]: " & $stone[1] & " - $tree[1]: " & $tree[1] & " = " & $b & @CRLF & _
			"Distance is : " & Sqrt($a * $a + $b * $b) & @CRLF & _
			"Dist Stone to village map: " & $stone[4] & @CRLF & _
			"Dist Tree to village map: " & $tree[4] & @CRLF & _
			"Final: " & $c

	; initial reference village had a width of 443.22742128372 (and not 440) and stone located at 172, 435, so center on that reference and used zoom factor on that size
	Local $z = $c / 443.22742128372 ; new RC

	If $debugwithImage Then

		setlog("Distance from tree to stone is : " & Sqrt($a * $a + $b * $b) - $stone[4] - $tree[4])
		Setlog("Village Distance is: " &  $c)
		Setlog("Dist Tree to village map: " & $tree[4])
		Setlog("Dist Stone to village map: " & $stone[4])
		Setlog("Village Factor is: " &  $z)

		Local $tLayout = _GDIPlus_RectFCreate(430, 630 + $g_iBottomOffsetYNew, 0, 0) ; RC Done
		Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $txtDebug, $hFont, $tLayout, $hFormat)
		_GDIPlus_GraphicsDrawStringEx($hGraphic, $txtDebug, $hFont, $aInfo[0], $hFormat, $hBrush)

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
	EndIf

	Local $stone_x_exp = $stone[2]
	Local $stone_y_exp = $stone[3]
	ConvertVillagePos($stone_x_exp, $stone_y_exp, $z) ; expected x, y position of stone
	$x = $stone[0] - $stone_x_exp
	$y = $stone[1] - $stone_y_exp

	If $DebugLog Then SetDebugLog("GetVillageSize measured: " & $c & ", Zoom factor: " & $z & ", Offset: " & $x & ", " & $y, $COLOR_INFO)

	; ONSCREEN
	_UIA_Debug($DebugImage)

	Dim $aResult[10]
	$aResult[0] = $c
	$aResult[1] = $z
	$aResult[2] = $x
	$aResult[4] = $stone[0]
	$aResult[3] = $y
	$aResult[5] = $stone[1]
	$aResult[6] = $stone[5]
	$aResult[7] = $tree[0]
	$aResult[8] = $tree[1]
	$aResult[9] = $tree[5]
	Return $aResult
EndFunc   ;==>GetVillageSize

Func UpdateGlobalVillageOffset($x, $y)

	Local $updated = False

	If $g_sImglocRedline <> "" Then

		Local $newReadLine = ""
		Local $aPoints = StringSplit($g_sImglocRedline, "|", $STR_NOCOUNT)

		For $sPoint In $aPoints

			Local $aPoint = GetPixel($sPoint, ",")
			$aPoint[0] += $x
			$aPoint[1] += $y

			If StringLen($newReadLine) > 0 Then $newReadLine &= "|"
			$newReadLine &= ($aPoint[0] & "," & $aPoint[1])

		Next

		; set updated red line
		$g_sImglocRedline = $newReadLine

		$updated = True
	EndIf

	If $g_aiTownHallDetails[0] <> 0 And $g_aiTownHallDetails[1] <> 0 Then
		$g_aiTownHallDetails[0] += $x
		$g_aiTownHallDetails[1] += $y
		$updated = True
	EndIf
	If $g_iTHx <> 0 And $g_iTHy <> 0 Then
		$g_iTHx += $x
		$g_iTHy += $y
		$updated = True
	EndIf

	ConvertInternalExternArea("UpdateGlobalVillageOffset")

	Return $updated

EndFunc   ;==>UpdateGlobalVillageOffset
