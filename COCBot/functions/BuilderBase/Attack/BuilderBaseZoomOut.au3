; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseZoomOutOn
; Description ...: Use on Builder Base attack
; Syntax ........: BuilderBaseZoomOutOnAttack()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018)
; Modified ......:
; Remarks .......: This file is part of MultiBot, previously known as Mybot and ClashGameBot. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================

Global $g_aBoatPos[2] = [Null, Null]

Func TestGetBuilderBaseSize()
	Setlog("** TestGetBuilderBaseSize START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	$g_bRunState = True
	GetBuilderBaseSize(True, True)
	$g_bRunState = $Status
	Setlog("** TestGetBuilderBaseSize END**", $COLOR_DEBUG)
EndFunc   ;==>TestGetBuilderBaseSize

Func TestBuilderBaseZoomOut()
	Setlog("** TestBuilderBaseZoomOutOnAttack START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	$g_bRunState = True
	BuilderBaseZoomOut(True)
	$g_bRunState = $Status
	Setlog("** TestBuilderBaseZoomOutOnAttack END**", $COLOR_DEBUG)
EndFunc   ;==>TestBuilderBaseZoomOut

Func BuilderBaseZoomOut($DebugImage = False, $ForceZoom = False)

	Local $Size = GetBuilderBaseSize(False, $DebugImage) ; WihtoutClicks
	If $Size > 520 And $Size < 590 and Not $ForceZoom Then
		SetDebugLog("BuilderBaseZoomOut check!")
		Return True
	EndIf

	; Small loop just in case
	For $i = 0 To 5
		; Necessary a small drag to Up and right to get the Stone and Boat Images, Just once , coz in attack will display a red text and hide the boat
		If $i = 0 Or $i = 3 Then ClickDrag(100, 130, 230, 30)

		; Update shield status
		AndroidShield("AndroidOnlyZoomOut")
		; Run the ZoomOut Script
		If BuilderBaseSendZoomOut(False, $i) Then
			For $i = 0 To 5
				If _Sleep(500) Then ExitLoop
				If Not $g_bRunState Then Return
				; Get the Distances between images
				Local $Size = GetBuilderBaseSize(True, $DebugImage)
				SetDebugLog("[" & $i & "]BuilderBaseZoomOut $Size: " & $Size)
				If IsNumber($Size) And $Size > 0 Then ExitLoop
			Next
			; Can't be precise each time we enter at Builder base was deteced a new Zoom Factor!! from 563-616
			If $Size > 520 And $Size < 590 Then
				Return True
			EndIf
		Else
			SetDebugLog("[BBzoomout] Send Script Error!", $COLOR_DEBUG)
		EndIf
	Next
	Return False
EndFunc   ;==>BuilderBaseZoomOut

Func BuilderBaseSendZoomOut($Main = False, $i = 0)
	SetDebugLog("[" & $i & "][BuilderBaseSendZoomOut IN]")
	If Not $g_bRunState Then Return
	Local $cmd = CorrectZoomoutScript($Main)
	; $cmd = Default, $timeout = Default, $wasRunState = Default, $EnsureShellInstance = True, $bStripPrompt = True, $bNoShellTerminate = False
	AndroidAdbSendShellCommand($cmd, 7000, Default, False)
	If @error <> 0 Then Return False
	SetDebugLog("[" & $i & "][BuilderBaseSendZoomOut OUT]")
	Return True
EndFunc   ;==>BuilderBaseSendZoomOut

Func GetBuilderBaseSize($WithClick = True, $DebugImage = False)

	Local $BoatCoord[2], $Stonecoord[2]
	Local $BoatSize = [545, 20, 660, 200]
	Local $StoneSize = [125, 400, 225, 580]
	Local $SetBoat[2] = [610, 85]
	Local $SetBoatAttack[2] = [610, 60]
	Local $OffsetForBoat = 50

	If Not $g_bRunState Then Return
	; Get The boat at TOP
	If QuickMIS("BC1", $g_sImgZoomoutBoatBB, $BoatSize[0], $BoatSize[1], $BoatSize[2], $BoatSize[3], True, False) Then ; RC Done
		$BoatCoord[0] = $g_iQuickMISWOffSetX
		$BoatCoord[1] = $g_iQuickMISWOffSetY
		If $DebugImage Then SetDebugLog("[BBzoomout] Coordinate Boat: " & $BoatCoord[0] & "/" & $BoatCoord[01])
		$g_aBoatPos[0] = Int($BoatCoord[0])
		$g_aBoatPos[1] = Int($BoatCoord[1])
		; Get the Stone at Left
		If QuickMIS("BC1", $g_sImgZoomoutBoatBB, $StoneSize[0], $StoneSize[1], $StoneSize[2], $StoneSize[3], True, False) Then ; RC Done
			$Stonecoord[0] = $g_iQuickMISWOffSetX
			$Stonecoord[1] = $g_iQuickMISWOffSetY
			If $DebugImage Then SetDebugLog("[BBzoomout] Coordinate Stone: " & $Stonecoord[0] & "/" & $Stonecoord[01])
			; Get the Distance between Images
			Local $resul = Floor(Village_Distances($BoatCoord[0], $BoatCoord[1], $Stonecoord[0], $Stonecoord[1]))
			If $DebugImage Then SetDebugLog("[BBzoomout] GetDistance Boat to Stone: " & $resul)
			; Debug Image
			Local $boat = isOnBuilderIsland2() ? $SetBoat : $SetBoatAttack
			If $DebugImage Then DebugZoomOutBB($BoatCoord[0], $BoatCoord[1], $Stonecoord[0], $Stonecoord[1], $boat, "GetBuilerBaseSize_" & $resul & "_")
			If $DebugImage Then SetDebugLog("[BBzoomout] ClickDrag: X(" & $BoatCoord[0] & "/" & $SetBoat[0] & ") Y(" & $BoatCoord[1] & "/" & $SetBoat[1] & ")")
			; Centering the Village, use the $OffsetForBoat just to not click on boat and return to village
			If Not isOnBuilderIsland2() And ($g_aBoatPos[0] <> $boat[0] Or $g_aBoatPos[1] <> $boat[1]) Then
				If $WithClick Then ClickDrag($g_aBoatPos[0], $g_aBoatPos[1] + $OffsetForBoat, $boat[0], $boat[1] + $OffsetForBoat)
				; To release click , a possible problem on BS2
				If $WithClick Then ClickP($aAway, 1, 0, "#0332")
			EndIf
			Return $resul
		EndIf
	Else
		$g_aBoatPos[0] = Null
		$g_aBoatPos[1] = Null
	EndIf
	SetDebugLog("[BBzoomout] GetDistance Boat to Stone Error", $COLOR_ERROR)
	Return 0
EndFunc   ;==>GetBuilderBaseSize

Func Village_Distances($x1, $y1, $x2, $y2)
	If Not $g_bRunState Then Return
	;Pythagoras theorem for 2D
	Local $a, $b, $c
	If $x2 = $x1 And $y2 = $y1 Then
		Return 0
	Else
		$a = $y2 - $y1
		$b = $x2 - $x1
		$c = Sqrt($a * $a + $b * $b)
		Return $c
	EndIf
EndFunc   ;==>Village_Distances

Func DebugZoomOutBB($x, $y, $x1, $y1, $aBoat, $DebugText)

	_CaptureRegion2()
	Local $subDirectory = $g_sProfileTempDebugPath & "QuickMIS"
	DirCreate($subDirectory)
	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $filename = String($Date & "_" & $Time & "_" & $DebugText & "_.png")
	Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
	Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3) ; Create a pencil Color FF0000/RED
	Local $hPenWhite = _GDIPlus_PenCreate(0xFFFFFFFF, 3) ; Create a pencil Color FFFFFF/WHITE

	_GDIPlus_GraphicsDrawRect($hGraphic, $x - 5, $y - 5, 10, 10, $hPenRED)
	_GDIPlus_GraphicsDrawRect($hGraphic, $x1 - 5, $y1 - 5, 10, 10, $hPenRED)
	_GDIPlus_GraphicsDrawRect($hGraphic, $aBoat[0] - 5, $aBoat[1] - 5, 10, 10, $hPenWhite)

	_GDIPlus_GraphicsDrawRect($hGraphic, 623, 155, 10, 10, $hPenWhite)
	_GDIPlus_GraphicsDrawRect($hGraphic, 278, 545, 10, 10, $hPenWhite)

	_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $filename)
	_GDIPlus_PenDispose($hPenRED)
	_GDIPlus_PenDispose($hPenWhite)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_BitmapDispose($editedImage)

EndFunc   ;==>DebugZoomOutBB