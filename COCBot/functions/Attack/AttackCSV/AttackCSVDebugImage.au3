; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSVDEBUGIMAGE
; Description ...:
; Syntax ........: AttackCSVDEBUGIMAGE()
; Parameters ....:
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func AttackCSVDEBUGIMAGE()

	Local $iTimer = __TimerInit()

	_CaptureRegion2()

	Local $EditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
	Local $testx
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($EditedImage)
	Local $hFormat = _GDIPlus_StringFormatCreate()
	Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
	Local $hFamily = _GDIPlus_FontFamilyCreate("Arial")
	Local $hFont = _GDIPlus_FontCreate($hFamily, 14)
	Local $hArrowEndCap = _GDIPlus_ArrowCapCreate(10, 10)

	Local $pixel

	; Open box of crayons :-)
	Local $hPenLtGreen = _GDIPlus_PenCreate(0xFF00DC00, 2)
	Local $hPenDkGreen = _GDIPlus_PenCreate(0xFF006E00, 2)
	Local $hPenMdGreen = _GDIPlus_PenCreate(0xFF4CFF00, 2)
	Local $hPenRed = _GDIPlus_PenCreate(0xFFFF0000, 2)
	Local $hPenDkRed = _GDIPlus_PenCreate(0xFF6A0000, 2)
	Local $hPenNavyBlue = _GDIPlus_PenCreate(0xFF000066, 2)
	Local $hPenBlue = _GDIPlus_PenCreate(0xFF0000CC, 2)
	Local $hPenSteelBlue = _GDIPlus_PenCreate(0xFF0066CC, 2)
	Local $hPenLtBlue = _GDIPlus_PenCreate(0xFF0080FF, 2)
	Local $hPenPaleBlue = _GDIPlus_PenCreate(0xFF66B2FF, 2)
	Local $hPenCyan = _GDIPlus_PenCreate(0xFF00FFFF, 2)
	Local $hPenYellow = _GDIPlus_PenCreate(0xFFFFD800, 2)
	Local $hPenLtGrey = _GDIPlus_PenCreate(0xFFCCCCCC, 2)
	Local $hPenWhite = _GDIPlus_PenCreate(0xFFFFFFFF, 2)
	Local $hPenWhiteBold = _GDIPlus_PenCreate(0xFFFFFFFF, 5)
	Local $hPenMagenta = _GDIPlus_PenCreate(0xFFFF00F6, 2)


	;-- DRAW EXTERNAL PERIMETER LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[0][0], $ExternalArea[0][1], $ExternalArea[2][0], $ExternalArea[2][1], $hPenLtGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[0][0], $ExternalArea[0][1], $ExternalArea[3][0], $ExternalArea[3][1], $hPenLtGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[1][0], $ExternalArea[1][1], $ExternalArea[2][0], $ExternalArea[2][1], $hPenLtGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[1][0], $ExternalArea[1][1], $ExternalArea[3][0], $ExternalArea[3][1], $hPenLtGreen)

	;-- DRAW EXTERNAL PERIMETER LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[0][0], $InternalArea[0][1], $InternalArea[2][0], $InternalArea[2][1], $hPenDkGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[0][0], $InternalArea[0][1], $InternalArea[3][0], $InternalArea[3][1], $hPenDkGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[1][0], $InternalArea[1][1], $InternalArea[2][0], $InternalArea[2][1], $hPenDkGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[1][0], $InternalArea[1][1], $InternalArea[3][0], $InternalArea[3][1], $hPenDkGreen)

	;-- DRAW VERTICAL AND ORIZONTAL LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[2][0], 0, $InternalArea[2][0], $g_iGAME_HEIGHT, $hPenDkGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, 0, $InternalArea[0][1], $g_iGAME_WIDTH, $InternalArea[0][1], $hPenDkGreen)

	;-- DRAW DIAGONALS LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[4][0], $ExternalArea[4][1], $ExternalArea[7][0], $ExternalArea[7][1], $hPenLtGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[5][0], $ExternalArea[5][1], $ExternalArea[6][0], $ExternalArea[6][1], $hPenLtGreen)

	;-- DRAW REDAREA PATH
	For $i = 0 To UBound($g_aiPixelTopLeft) - 1
		$pixel = $g_aiPixelTopLeft[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next
	For $i = 0 To UBound($g_aiPixelTopRight) - 1
		$pixel = $g_aiPixelTopRight[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next
	For $i = 0 To UBound($g_aiPixelBottomLeft) - 1
		$pixel = $g_aiPixelBottomLeft[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next
	For $i = 0 To UBound($g_aiPixelBottomRight) - 1
		$pixel = $g_aiPixelBottomRight[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next

	;DRAW FULL DROP LINES PATH

	For $i = 0 To UBound($g_aiPixelTopLeftDropLine) - 1
		$pixel = $g_aiPixelTopLeftDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenBlue)
	Next
	For $i = 0 To UBound($g_aiPixelTopRightDropLine) - 1
		$pixel = $g_aiPixelTopRightDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenCyan)
	Next
	For $i = 0 To UBound($g_aiPixelBottomLeftDropLine) - 1
		$pixel = $g_aiPixelBottomLeftDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenYellow)
	Next
	For $i = 0 To UBound($g_aiPixelBottomRightDropLine) - 1
		$pixel = $g_aiPixelBottomRightDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenLtGrey)
	Next

	;DRAW SLICES DROP PATH LINES
	For $i = 0 To UBound($g_aiPixelTopLeftDOWNDropLine) - 1
		$pixel = $g_aiPixelTopLeftDOWNDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenBlue)
	Next
	For $i = 0 To UBound($g_aiPixelTopLeftUPDropLine) - 1
		$pixel = $g_aiPixelTopLeftUPDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenCyan)
	Next
	For $i = 0 To UBound($g_aiPixelBottomLeftDOWNDropLine) - 1
		$pixel = $g_aiPixelBottomLeftDOWNDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenYellow)
	Next
	For $i = 0 To UBound($g_aiPixelBottomLeftUPDropLine) - 1
		$pixel = $g_aiPixelBottomLeftUPDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenLtGrey)
	Next
	For $i = 0 To UBound($g_aiPixelTopRightDOWNDropLine) - 1
		$pixel = $g_aiPixelTopRightDOWNDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenBlue)
	Next
	For $i = 0 To UBound($g_aiPixelTopRightUPDropLine) - 1
		$pixel = $g_aiPixelTopRightUPDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenCyan)
	Next
	For $i = 0 To UBound($g_aiPixelBottomRightDOWNDropLine) - 1
		$pixel = $g_aiPixelBottomRightDOWNDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenYellow)
	Next
	For $i = 0 To UBound($g_aiPixelBottomRightUPDropLine) - 1
		$pixel = $g_aiPixelBottomRightUPDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenLtGrey)
	Next

	;DRAW DROP POINTS EXAMPLES

	$testx = MakeDropPoints("BOTTOM-RIGHT-DOWN", 10, 0, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
	Next

	$testx = MakeDropPoints("BOTTOM-RIGHT-DOWN", 10, 0, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 12, $pixel[1] - 12, "Arial", 12)
	Next

	$testx = MakeDropPoints("BOTTOM-RIGHT-UP", 10, 0, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
	Next

	$testx = MakeDropPoints("BOTTOM-RIGHT-UP", 10, 0, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 12, $pixel[1] - 12, "Arial", 12)
	Next

	$testx = MakeDropPoints("TOP-RIGHT-DOWN", 10, 0, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 5, $pixel[1] + 5, "Arial", 12)
	Next

	$testx = MakeDropPoints("TOP-RIGHT-DOWN", 10, 0, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] + 10, $pixel[1] - 10, "Arial", 12)
	Next

	$testx = MakeDropPoints("TOP-RIGHT-UP", 10, 0, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 5, $pixel[1] + 5, "Arial", 12)
	Next

	$testx = MakeDropPoints("TOP-RIGHT-UP", 10, 0, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] + 10, $pixel[1] - 10, "Arial", 12)
	Next

	$testx = MakeDropPoints("TOP-LEFT-UP", 10, 0, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
	Next

	$testx = MakeDropPoints("TOP-LEFT-UP", 10, 0, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 12, $pixel[1] - 12, "Arial", 12)
	Next

	$testx = MakeDropPoints("TOP-LEFT-DOWN", 10, 0, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
	Next

	$testx = MakeDropPoints("TOP-LEFT-DOWN", 10, 0, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 12, $pixel[1] - 12, "Arial", 12)
	Next

	$testx = MakeDropPoints("BOTTOM-LEFT-UP", 10, 0, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 5, $pixel[1] + 5, "Arial", 12)
	Next

	$testx = MakeDropPoints("BOTTOM-LEFT-UP", 10, 0, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] + 10, $pixel[1] - 10, "Arial", 12)
	Next

	$testx = MakeDropPoints("BOTTOM-LEFT-DOWN", 10, 0, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 5, $pixel[1] + 5, "Arial", 12)
	Next

	$testx = MakeDropPoints("BOTTOM-LEFT-DOWN", 10, 0, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] + 10, $pixel[1] - 10, "Arial", 12)
	Next
	; 06 - DRAW MINES, ELIXIR, DRILLS ------------------------------------------------------------------------
	For $i = 0 To UBound($g_aiPixelMine) - 1
		$pixel = $g_aiPixelMine[$i]
		_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 10, 20, 20, $hPenLtGreen)
	Next
	For $i = 0 To UBound($g_aiPixelElixir) - 1
		$pixel = $g_aiPixelElixir[$i]
		_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 5, 20, 20, $hPenDkGreen)
	Next
	For $i = 0 To UBound($g_aiPixelDarkElixir) - 1
		$pixel = $g_aiPixelDarkElixir[$i]
		_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 5, 20, 20, $hPenDkRed)
	Next

	; - DRAW GOLD STORAGE -------------------------------------------------------
	If $g_bCSVLocateStorageGold = True And IsArray($g_aiCSVGoldStoragePos) Then
		For $i = 0 To UBound($g_aiCSVGoldStoragePos) - 1
			$pixel = $g_aiCSVGoldStoragePos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 15, 20, 20, $hPenWhite)
		Next
	EndIf

	; - DRAW ELIXIR STORAGE ---------------------------------------------------------
	If $g_bCSVLocateStorageElixir = True And IsArray($g_aiCSVElixirStoragePos) Then
		For $i = 0 To UBound($g_aiCSVElixirStoragePos) - 1
			$pixel = $g_aiCSVElixirStoragePos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 15, 20, 20, $hPenMagenta)
		Next
	EndIf


	; - DRAW TOWNHALL -------------------------------------------------------------------
	_GDIPlus_GraphicsDrawRect($hGraphic, $g_iTHx - 5, $g_iTHy - 10, 30, 30, $hPenRed)

	;- DRAW BUILDINGS LEFT-RIGHT DROP POINTS IF MENTIONED
	If $g_iMatchMode = $DB Then
		Local $filename = $g_sAttackScrScriptName[$DB]
	Else
		Local $filename = $g_sAttackScrScriptName[$LB]
	EndIf
	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		Local $aLines = FileReadToArray($g_sCSVAttacksPath & "\" & $filename & ".csv")
		Local $value1 = "", $value2 = "", $value3 = "", $value4 = "", $value5 = "", $value6 = "", $value7 = "", $value8 = "", $value9 = ""
		Local $f, $line, $acommand, $command
		; Read in lines of text until the EOF is reached
		For $iLine = 0 To UBound($aLines) - 1
			$line = $aLines[$iLine]
			If @error = -1 Then ExitLoop
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				; Set values
				For $i = 2 To (UBound($acommand) - 1)
					Assign("value" & Number($i - 1), StringStripWS(StringUpper($acommand[$i]), $STR_STRIPTRAILING))
				Next
				$command = StringStripWS(StringUpper($acommand[1]), $STR_STRIPTRAILING)
				If $command = "MAKE" Then
					If CheckCsvValues("MAKE", 2, $value2) Then
						Local $sidex = StringReplace($value2, "-", "_")
						If CheckCsvValues("MAKE", 1, $value1) And CheckCsvValues("MAKE", 5, $value5) And CheckCsvValues("MAKE", 8, $value8) Then     ; Vector is targeted towards building v2.0.3
							; new field definitions:
							; $side = target side string
							; value3 = Drop points can be 1,3,5,7... ODD number Only e.g if 5=[2, 1, 0, -1, -2] will Add tiles to left and right to make drop point 3 would be exact positon of building
							; value4 = addtiles
							; value5 = versus ignore direction
							; value6 = RandomX ignored as image find location will be "random" without need to add more variability
							; value7 = randomY ignored as image find location will be "random" without need to add more variability
							; value8 = Building target for drop points
							If $value3 > 1 Then         ; check for valid number of drop points
								Local $tmpArray = MakeTargetDropPoints(Eval($sidex), $value3, $value4, $value8)
								If (UBound($tmpArray) > 0) Then
									Local $aLineStartPoint = $tmpArray[0]
									Local $aLineEndPoint = $tmpArray[UBound($tmpArray) - 1]
									_GDIPlus_GraphicsDrawLine($hGraphic, $aLineStartPoint[0], $aLineStartPoint[1], $aLineEndPoint[0], $aLineEndPoint[1], $hPenRed)
									For $i = 0 To UBound($tmpArray) - 1
										Local $aPixel = $tmpArray[$i]
										_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $aPixel[0] - 10, $aPixel[1] - 10, "Arial", 12)
									Next
								EndIf
							EndIf
						EndIf
					EndIf
				ElseIf $command = "DROP" Then
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf

	; - DRAW Eagle -------------------------------------------------------------------
	If $g_bCSVLocateEagle = True And IsArray($g_aiCSVEagleArtilleryPos) Then
		_GDIPlus_GraphicsDrawRect($hGraphic, $g_aiCSVEagleArtilleryPos[0] - 15, $g_aiCSVEagleArtilleryPos[1] - 15, 30, 30, $hPenBlue)
	EndIf

	; - DRAW Inferno -------------------------------------------------------------------
	If $g_bCSVLocateInferno = True And IsArray($g_aiCSVInfernoPos) Then
		For $i = 0 To UBound($g_aiCSVInfernoPos) - 1
			$pixel = $g_aiCSVInfernoPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 10, 20, 20, $hPenNavyBlue)
		Next
	EndIf

	; - DRAW X-Bow -------------------------------------------------------------------
	If $g_bCSVLocateXBow = True And IsArray($g_aiCSVXBowPos) Then
		For $i = 0 To UBound($g_aiCSVXBowPos) - 1
			$pixel = $g_aiCSVXBowPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 25, 25, 25, $hPenBlue)
		Next
	EndIf

	; - DRAW Wizard Towers -------------------------------------------------------------------
	If $g_bCSVLocateWizTower = True And IsArray($g_aiCSVWizTowerPos) Then
		For $i = 0 To UBound($g_aiCSVWizTowerPos) - 1
			$pixel = $g_aiCSVWizTowerPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 5, $pixel[1] - 15, 25, 25, $hPenSteelBlue)
		Next
	EndIf

	; - DRAW Mortars -------------------------------------------------------------------
	If $g_bCSVLocateMortar = True And IsArray($g_aiCSVMortarPos) Then
		For $i = 0 To UBound($g_aiCSVMortarPos) - 1
			$pixel = $g_aiCSVMortarPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 15, 25, 25, $hPenLtBlue)
		Next
	EndIf

	; - DRAW Air Defense -------------------------------------------------------------------
	If $g_bCSVLocateAirDefense = True And IsArray($g_aiCSVAirDefensePos) Then
		For $i = 0 To UBound($g_aiCSVAirDefensePos) - 1
			$pixel = $g_aiCSVAirDefensePos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 12, $pixel[1] - 10, 25, 25, $hPenPaleBlue)
		Next
	EndIf

	; - DRAW MAIN SIDE Text -------------------------------------------------------------------
	Local $aMainSidesText[8] = ["TOP-LEFT", "TOP-RIGHT", "BOTTOM-RIGHT", "BOTTOM-LEFT"]
	Local $aMainSidesPosition[4][4] = [ _
			[$DiamondMiddleX - 280, $DiamondMiddleY - 215, $DiamondMiddleX - 280 + 80, $DiamondMiddleY - 215 + 60], _ ;TOP-LEFT
			[$DiamondMiddleX + 280, $DiamondMiddleY - 215, $DiamondMiddleX + 280 - 80, $DiamondMiddleY - 215 + 60], _ ;TOP-RIGHT
			[$DiamondMiddleX + 280, $DiamondMiddleY + 215, $DiamondMiddleX + 280 - 80, $DiamondMiddleY + 215 - 60], _ ;BOTTOM-RIGHT
			[$DiamondMiddleX - 280, $DiamondMiddleY + 215, $DiamondMiddleX - 280 + 80, $DiamondMiddleY + 215 - 60]] ;BOTTOM-LEFT
	Local $iMainSidePostionIndex = _ArraySearch($aMainSidesText, $MAINSIDE)
	If $iMainSidePostionIndex <> -1 Then
		_GDIPlus_ArrowCapSetMiddleInset($hArrowEndCap, 0.5)
		_GDIPlus_PenSetCustomEndCap($hPenWhiteBold, $hArrowEndCap)
		_GDIPlus_GraphicsDrawLine($hGraphic, $aMainSidesPosition[$iMainSidePostionIndex][0], $aMainSidesPosition[$iMainSidePostionIndex][1], $aMainSidesPosition[$iMainSidePostionIndex][2], $aMainSidesPosition[$iMainSidePostionIndex][3], $hPenWhiteBold)
	EndIf
	; - DRAW ALL SIDE Text -------------------------------------------------------------------
	Local $aBaseSidesPosition[8][2] = [ _
			[$DiamondMiddleX + 120, $DiamondMiddleY + 215], _ ;BOTTOM-RIGHT-DOWN
			[$DiamondMiddleX + 295, $DiamondMiddleY + 085], _ ;BOTTOM-RIGHT-UP
			[$DiamondMiddleX + 295, $DiamondMiddleY - 120], _ ;TOP-RIGHT-DOWN
			[$DiamondMiddleX + 115, $DiamondMiddleY - 260], _ ;TOP-RIGHT-UP
			[$DiamondMiddleX - 180, $DiamondMiddleY - 260], _ ;TOP-LEFT-UP
			[$DiamondMiddleX - 350, $DiamondMiddleY - 125], _ ;TOP-LEFT-DOWN
			[$DiamondMiddleX - 350, $DiamondMiddleY + 085], _ ;BOTTOM-LEFT-UP
			[$DiamondMiddleX - 250, $DiamondMiddleY + 215]] ;BOTTOM-LEFT-DOWN

	Local $aBaseSidesText[8] = ["BOTTOM-RIGHT-DOWN", "BOTTOM-RIGHT-UP", "TOP-RIGHT-DOWN", "TOP-RIGHT-UP", "TOP-LEFT-UP", "TOP-LEFT-DOWN", "BOTTOM-LEFT-UP", "BOTTOM-LEFT-DOWN"]
	Local $aBaseCalculatedSides[8] = [$FRONT_LEFT, $FRONT_RIGHT, $RIGHT_FRONT, $RIGHT_BACK, $LEFT_FRONT, $LEFT_BACK, $BACK_LEFT, $BACK_RIGHT]
	Local $aBaseSidesTextPrint[8] = ["FRONT_LEFT", "FRONT_RIGHT", "RIGHT_FRONT", "RIGHT_BACK", "LEFT_FRONT", "LEFT_BACK", "BACK_LEFT", "BACK_RIGHT"]

	For $i = 0 To 7
		Local $iSidePostionIndex = _ArraySearch($aBaseSidesText, $aBaseCalculatedSides[$i])
		If $iSidePostionIndex <> -1 Then
			Local $tLayout = _GDIPlus_RectFCreate($aBaseSidesPosition[$iSidePostionIndex][0], $aBaseSidesPosition[$iSidePostionIndex][1], 0, 0)
			Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, (($iSidePostionIndex <> 0 And $iSidePostionIndex <> 7) ? StringReplace($aBaseSidesTextPrint[$i], "_", @CRLF) : $aBaseSidesTextPrint[$i]), $hFont, $tLayout, $hFormat)
			_GDIPlus_GraphicsDrawStringEx($hGraphic, (($iSidePostionIndex <> 0 And $iSidePostionIndex <> 7) ? StringReplace($aBaseSidesTextPrint[$i], "_", @CRLF) : $aBaseSidesTextPrint[$i]), $hFont, $aInfo[0], $hFormat, $hBrush)
		EndIf
	Next


	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $filename = $g_sProfileTempDebugPath & String("AttackDebug_" & $Date & "_" & $Time) & ".jpg"
	_GDIPlus_ImageSaveToFile($EditedImage, $filename)
	If @error Then SetLog("Debug Image save error: " & @extended, $COLOR_ERROR)
	SetDebugLog("Attack CSV image saved: " & $filename)

	; Clean up resources
	_GDIPlus_PenDispose($hPenLtGreen)
	_GDIPlus_PenDispose($hPenDkGreen)
	_GDIPlus_PenDispose($hPenMdGreen)
	_GDIPlus_PenDispose($hPenRed)
	_GDIPlus_PenDispose($hPenDkRed)
	_GDIPlus_PenDispose($hPenBlue)
	_GDIPlus_PenDispose($hPenNavyBlue)
	_GDIPlus_PenDispose($hPenSteelBlue)
	_GDIPlus_PenDispose($hPenLtBlue)
	_GDIPlus_PenDispose($hPenPaleBlue)
	_GDIPlus_PenDispose($hPenCyan)
	_GDIPlus_PenDispose($hPenYellow)
	_GDIPlus_PenDispose($hPenLtGrey)
	_GDIPlus_PenDispose($hPenWhite)
	_GDIPlus_PenDispose($hPenWhiteBold)
	_GDIPlus_PenDispose($hPenMagenta)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_ArrowCapDispose($hArrowEndCap)
	_GDIPlus_BitmapDispose($EditedImage)
	_GDIPlus_GraphicsDispose($hGraphic)
	; open image
	If TestCapture() = True Then
		ShellExecute($filename)
	EndIf

	SetDebugLog("AttackCSV DEBUG IMAGE Create Required: " & Round((__TimerDiff($iTimer) * 0.001), 1) & "Seconds", $COLOR_DEBUG)

EndFunc   ;==>AttackCSVDEBUGIMAGE
