; #FUNCTION# ====================================================================================================================
; Name ..........: SwitchSiegeMachines
; Description ...: Check in which siege needs to select from attackbar and switch if needed
; Author ........: Promac (07-2018)
; Modified ......: Fahid.Mahmood (01-2019)
; Remarks .......: This file is part of MultiBot, previously known as Mybot and ClashGameBot. Copyright 2015-2018
;                  MultiBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func btnTestSwitchSiegeMachines()
	SetLog("Test Switch Siege Machines Started", $COLOR_DEBUG)

	Local $wasRunState = $g_bRunState
	Local $wasCurrentSiegeMachines = $g_aiCurrentSiegeMachines[$eSiegeWallWrecker]
	;For Debug Purpose set these values temporarily
	$g_bRunState = True
	$g_aiCurrentSiegeMachines[$eSiegeWallWrecker] = 1
	_GUICtrlTab_ClickTab($g_hTabMain, 0)
	SwitchSiegeMachines($DB, False, True)
	;Reset to orignal state
	$g_bRunState = $wasRunState
	$g_aiCurrentSiegeMachines[$eSiegeWallWrecker] = $wasCurrentSiegeMachines

	SetLog("Test Switch Siege Machines Ended", $COLOR_DEBUG)
EndFunc   ;==>btnTestSwitchSiegeMachines

Func SwitchSiegeMachines($pMatchMode, $Remaining = False, $DebugSiege = False)
	Local $hStarttime = _Timer_Init()
	; Lets Select The CC Or Siege Machine ; $eCastle , $eWallW , $eBattleB, $eStoneS
	Local $aPaths = [$g_sImgSwitchSiegeCastle, $g_sImgSwitchSiegeWallWrecker, $g_sImgSwitchSiegeBattleBlimp, $g_sImgSwitchSiegeStoneSlammer]
	Local $aShotNames = ['CC', 'WW', 'BB', 'SS']

	Local $ToUse = $eCastle, $iDa = 0

	If ($pMatchMode = $DB Or $pMatchMode = $LB Or $pMatchMode = $TS) And Not $Remaining Then

		; Default is CC ,let's check Siege Machines , if is to be used and exist.
		If $g_abAttackDropCC[$pMatchMode] And $g_aiAttackUseSiege[$pMatchMode] = 3 And ($g_aiCurrentSiegeMachines[$eSiegeStoneSlammer] > 0 Or $g_aiCurrentCCSiegeMachines[$eSiegeStoneSlammer] > 0) Then
			$ToUse = $eStoneS
			$iDa = 3
		ElseIf $g_abAttackDropCC[$pMatchMode] And $g_aiAttackUseSiege[$pMatchMode] = 2 And ($g_aiCurrentSiegeMachines[$eSiegeBattleBlimp] > 0 Or $g_aiCurrentCCSiegeMachines[$eSiegeBattleBlimp] > 0) Then
			$ToUse = $eBattleB
			$iDa = 2
		ElseIf $g_abAttackDropCC[$pMatchMode] And $g_aiAttackUseSiege[$pMatchMode] = 1 And ($g_aiCurrentSiegeMachines[$eSiegeWallWrecker] > 0 Or $g_aiCurrentCCSiegeMachines[$eSiegeWallWrecker] > 0) Then
			$ToUse = $eWallW
			$iDa = 1
		Else
			$ToUse = $eCastle
			$iDa = 0
		EndIf

		; Only procceds if necessary Drop the CC troops
		If Not $Remaining And $g_abAttackDropCC[$pMatchMode] Then
			Setlog("Let's use " & NameOfTroop($ToUse))
			If QuickMIS("BC1", $g_sImgSwitchSiegeMachine, 50, 605, 820, 630, True, False) Then ; RC Done
				Local $iSwitchMachineBtnX = $g_iQuickMISWOffSetX, $iSwitchMachineBtnY = $g_iQuickMISWOffSetY
				If $g_bDebugSetlog Then SetDebugLog("Benchmark Switch Siege Bar: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms")
				$hStarttime = _Timer_Init()
				Setlog("Switching button in a Siege Machine/CC detected.")
				; Was detectable lets click
				Click($iSwitchMachineBtnX, $iSwitchMachineBtnY, 1)
				; wait to appears the new small window
				If _Sleep(1000) Then Return
				;Detect "Cha" latters for getting window start
				If QuickMIS("BC1", $g_sImgSwitchSiegeMachine, 50, 405, 820, 425, True, False) Then
					; "Cha" Template size width is 27.So 27/2=14 Will Be Template Start
					$g_iQuickMISWOffSetX = $g_iQuickMISWOffSetX - 14
					;SlotSize*Total Slots Currently 5 Seige Slots Can Be Shown In Change Window December Upate(2018)
					Local $iSiegeWindowSize = 72 * 5
					;Just In Case $iSiegeWindowSize is outside Main Width
					If ($g_iQuickMISWOffSetX + $iSiegeWindowSize) >= $g_iGAME_WIDTH Then $iSiegeWindowSize = $g_iGAME_WIDTH - $g_iQuickMISWOffSetX - 5
					Local $iChangeSiegeWindowStartX = $g_iQuickMISWOffSetX, $iChangeSiegeWindowLastX = $g_iQuickMISWOffSetX + $iSiegeWindowSize
					; Lets detect the CC & Sieges and click
					Local $HowMany = QuickMIS("CX", $aPaths[$iDa], $iChangeSiegeWindowStartX, 450, $iChangeSiegeWindowLastX, 490, True, False)  ; RC Done
					If $g_bDebugSetlog Then SetDebugLog("Benchmark Switch Siege HowMany: " & UBound($HowMany) & " | " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms")
					If $g_bDebugSetlog Then SetDebugLog("Sleeps : " & 1000 & "'ms")
					$hStarttime = _Timer_Init()

					If UBound($HowMany) > 0 Then
						If $DebugSiege Then
							Setlog("SiegeSwitch , Detected array: " & _ArrayToString($HowMany, "|"))
							; Create the necessery GDI stuff
							_CaptureRegion2()
							Local $subDirectory = $g_sProfileTempDebugPath & "SiegeSwitch"
							DirCreate($subDirectory)
							Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
							Local $Time = @HOUR & "." & @MIN & "." & @SEC
							Local $filename = String($Date & "_" & $Time & "_" & $iDa & "_.png")
							Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
							Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
							Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3) ; Create a pencil Color FF0000/RED
						EndIf

						Local $aSiegeAvailable[0][3] ; [0] : Xaxis , [1] Yaxis , [2] Level

						For $i = 0 To UBound($HowMany) - 1
							Local $Coordinates = StringSplit($HowMany[$i], ",", $STR_NOCOUNT)
							Local $iSiegeSlotPosX = $Coordinates[0] + $iChangeSiegeWindowStartX, $iSiegeSlotPosY = $Coordinates[1] + 450 ; RC Done
							;Getting Detected Siege Slot Starting X
							Local $iSiegeSlotStartPosX = GetSiegeSlotStartingX($iSiegeSlotPosX)
							Local $iSiegeLevelPosX = $iSiegeSlotStartPosX + 6
							Local $bIsCCSiegeMachine = IsCCSiegeMachine($iSiegeSlotStartPosX)

							ReDim $aSiegeAvailable[UBound($aSiegeAvailable) + 1][3]
							$aSiegeAvailable[UBound($aSiegeAvailable) - 1][0] = $iSiegeSlotPosX
							$aSiegeAvailable[UBound($aSiegeAvailable) - 1][1] = $iSiegeSlotPosY
							Local $SiegeLevel = getTroopsSpellsLevel($iSiegeLevelPosX, 497) ; RC Done
							; Just in case of Level 1
							$aSiegeAvailable[UBound($aSiegeAvailable) - 1][2] = $SiegeLevel <> "" ? Number($SiegeLevel) : 1

							If $DebugSiege Then
								Local $TextLog = $bIsCCSiegeMachine ? "_CC" : ""
								Local $Info = $i + 1 & $TextLog & "_" & $aShotNames[$iDa] & "_L" & $aSiegeAvailable[UBound($aSiegeAvailable) - 1][2]
								addInfoToDebugImage($hGraphic, $hPenRED, $Info, $iSiegeSlotPosX, $iSiegeSlotPosY, 7, 1)
								_GDIPlus_GraphicsDrawLine($hGraphic, 0, 497, 860, 497, $hPenRED)
								_GDIPlus_GraphicsDrawLine($hGraphic, $iSiegeLevelPosX, 0, $iSiegeLevelPosX, 644, $hPenRED)
							EndIf
						Next
						If $g_bDebugSetlog Then SetDebugLog("Benchmark Switch Siege Levels: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms")
						If $g_bDebugSetlog Then SetDebugLog("Sleeps : " & 0 & "'ms")
						$hStarttime = _Timer_Init()

						Local $iFinalX = 0, $iFinalY = 0, $iFinalLevel = 0

						If UBound($aSiegeAvailable) > 0 Then
							For $i = 0 To UBound($aSiegeAvailable) - 1
								If $aSiegeAvailable[$i][2] > $iFinalLevel Then
									$iFinalX = $aSiegeAvailable[$i][0]
									$iFinalY = $aSiegeAvailable[$i][1]
									$iFinalLevel = $aSiegeAvailable[$i][2]
								EndIf
							Next
							Click($iFinalX, $iFinalY, 1)
							Local $TextLog = $ToUse = $eCastle ? "" : " Level " & $iFinalLevel
							Setlog(NameOfTroop($ToUse) & $TextLog & " selected!", $COLOR_SUCCESS)
						Else
							If $g_bDebugImageSave Then DebugImageSave("PrepareAttack_SwitchSiege")
							Click($iSwitchMachineBtnX, $iSwitchMachineBtnY, 1)
						EndIf

						If _Sleep(250) Then Return

						If $DebugSiege Then
							; Destroy the used GDI stuff
							_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $filename)
							_GDIPlus_PenDispose($hPenRED)
							_GDIPlus_GraphicsDispose($hGraphic)
							_GDIPlus_BitmapDispose($editedImage)
						EndIf
					Else
						If $g_bDebugImageSave Then DebugImageSave("PrepareAttack_SwitchSiege")
						; If was not detectable lets click again on green icon to hide the window!
						Click($iSwitchMachineBtnX, $iSwitchMachineBtnY, 1)
						If _sleep(250) Then Return
					EndIf
					If _Sleep(750) Then Return
				EndIf
			EndIf
		EndIf
		If $g_bDebugSetlog Then SetDebugLog("Benchmark Switch Siege Detection: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms")
		If $g_bDebugSetlog Then SetDebugLog("Sleeps : " & 250 + 750 & "'ms")
	Else
		If $g_bDebugSetlog Then SetDebugLog("Skip Switch Siege Machine Check Conditions Not Matched!")
	EndIf

EndFunc   ;==>SwitchSiegeMachines


Func GetSiegeSlotStartingX($iSiegeSlotPosX)
	Local $iMaxSelectedSlotSize = 65
	; Now we will Get the Seiege detection Position and step back until we get a Black Pixel and that is when slot begins!
	For $iSiegeSlotStartPosX = $iSiegeSlotPosX To $iSiegeSlotPosX - $iMaxSelectedSlotSize Step -1
		;Just in case this value can be in negative
		If ($iSiegeSlotStartPosX > 0) Then
			If _ColorCheck(_GetPixelColor($iSiegeSlotStartPosX, 516, True), Hex(0x000000, 6), 25) Then ExitLoop
		Else
			ExitLoop
		EndIf
		If $g_bRunState = False Then Return
	Next

	If $g_bDebugSetlog Then SetDebugLog("iSiegeSlotPosX: " & $iSiegeSlotPosX & " >>> iSiegeSlotStartPosX: " & $iSiegeSlotStartPosX)
	Return $iSiegeSlotStartPosX

EndFunc   ;==>GetSiegeSlotStartingX

Func IsCCSiegeMachine($iSiegeSlotStartPosX)
	; Detect Blue Shadow Above Badge
	For $iSiegeSlotPosX = $iSiegeSlotStartPosX To $iSiegeSlotStartPosX + 15
		If _ColorCheck(_GetPixelColor($iSiegeSlotPosX, 434, True), Hex(0x1F2654, 6), 10) Then Return True
	Next
	Return False
EndFunc   ;==>IsCCSiegeMachine
