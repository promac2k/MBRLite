; #FUNCTION# ====================================================================================================================
; Name ..........: ParseAttackCSV
; Description ...:
; Syntax ........: ParseAttackCSV([$debug = False])
; Parameters ....: $debug               - [optional]
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: MMHK (07-2017)(01-2018)
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func ParseAttackCSV($debug = False)

	Local $bForceSideExist = False
	Local $sErrorText, $sTargetVectors = ""
	Local $iTroopIndex
	;Need This Var In case of Event Commands Where we don't want bot to waste time on ability check and moves on
	Local $bCheckHeroAbility = True
	; TL , TR , BL , BR
	Local $sides2drop[4] = [False, False, False, False]

	For $v = 0 To 25 ; Zero all 26 vectors from last atttack in case here is error MAKE'ing new vectors
		Assign("ATTACKVECTOR_" & Chr(65 + $v), "", $ASSIGN_EXISTFAIL) ; start with character "A" = ASCII 65
		If @error Then SetLog("Failed to erase old vector: " & Chr(65 + $v) & ", ask code monkey to fix!", $COLOR_ERROR)
	Next

	;Local $filename = "attack1"
	If $g_iMatchMode = $DB Then
		Local $filename = $g_sAttackScrScriptName[$DB]
	Else
		Local $filename = $g_sAttackScrScriptName[$LB]
	EndIf
	SetLog("Attack With Script: " & $filename, $COLOR_INFO)

	Local $f, $line, $acommand, $command
	Local $value1 = "", $value2 = "", $value3 = "", $value4 = "", $value5 = "", $value6 = "", $value7 = "", $value8 = "", $value9 = ""
	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		Local $aLines = FileReadToArray($g_sCSVAttacksPath & "\" & $filename & ".csv")

		; Read in lines of text until the EOF is reached
		For $iLine = 0 To UBound($aLines) - 1
			$bCheckHeroAbility = True
			$line = $aLines[$iLine]
			$sErrorText = "" ; empty error text each row
			debugAttackCSV("line: " & $iLine + 1)
			If @error = -1 Then ExitLoop
			If $debug = True Then SetLog("parse line:<<" & $line & ">>")
			debugAttackCSV("line content: " & $line)
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), $STR_STRIPTRAILING)
				If $command = "TRAIN" Or $command = "REDLN" Or $command = "DRPLN" Or $command = "CCREQ" Then ContinueLoop ; discard setting commands
				If $command = "SIDE" Or $command = "SIDEB" Then ContinueLoop ; discard attack side commands
				; Set values
				For $i = 2 To (UBound($acommand) - 1)
					Assign("value" & Number($i - 1), StringStripWS(StringUpper($acommand[$i]), $STR_STRIPTRAILING))
				Next

				Switch $command
					Case ""
						debugAttackCSV("comment line")
					Case "MAKE"
						ReleaseClicks()
						If CheckCsvValues("MAKE", 2, $value2) Then
							Local $sidex = StringReplace($value2, "-", "_")
							If $sidex = "RANDOM" Then
								Switch Random(1, 4, 1)
									Case 1
										$sidex = "FRONT_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "LEFT"
										Else
											$sidex &= "RIGHT"
										EndIf
										$sides2drop[0] = True
									Case 2
										$sidex = "BACK_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "LEFT"
										Else
											$sidex &= "RIGHT"
										EndIf
										$sides2drop[1] = True
									Case 3
										$sidex = "LEFT_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "FRONT"
										Else
											$sidex &= "BACK"
										EndIf
										$sides2drop[2] = True
									Case 4
										$sidex = "RIGHT_"
										If Random(0, 1, 1) = 0 Then
											$sidex &= "FRONT"
										Else
											$sidex &= "BACK"
										EndIf
										$sides2drop[3] = True
								EndSwitch
							EndIf
							Switch Eval($sidex)
								Case StringInStr(Eval($sidex), "TOP-LEFT") > 0
									$sides2drop[0] = True
								Case StringInStr(Eval($sidex), "TOP-RIGHT") > 0
									$sides2drop[1] = True
								Case StringInStr(Eval($sidex), "BOTTOM-LEFT") > 0
									$sides2drop[2] = True
								Case StringInStr(Eval($sidex), "BOTTOM-RIGHT") > 0
									$sides2drop[3] = True
							EndSwitch
							If CheckCsvValues("MAKE", 1, $value1) And CheckCsvValues("MAKE", 5, $value5) Then
								$sTargetVectors = StringReplace($sTargetVectors, $value3, "", Default, $STR_NOCASESENSEBASIC) ; if re-making a vector, must remove from target vector string
								If CheckCsvValues("MAKE", 8, $value8) Then ; Vector is targeted towards building v2.0.3
									; new field definitions:
									; $side = target side string
									; value3 = Drop points can be 1,3,5,7... ODD number Only e.g if 5=[2, 1, 0, -1, -2] will Add tiles to left and right to make drop point 3 would be exact positon of building
									; value4 = addtiles
									; value5 = versus ignore direction
									; value6 = RandomX ignored as image find location will be "random" without need to add more variability
									; value7 = randomY ignored as image find location will be "random" without need to add more variability
									; value8 = Building target for drop points
									If $value3 > 0 Then ; check for valid number of drop points
										Local $tmpArray = MakeTargetDropPoints(Eval($sidex), $value3, $value4, $value8)
										If @error Then
											$sErrorText = "MakeTargetDropPoints: " & @error ; set flag
										Else
											Assign("ATTACKVECTOR_" & $value1, $tmpArray) ; assing vector
											$sTargetVectors &= $value1 ; add letter of every vector using building target to string to error check DROP command
										EndIf
									Else
										$sErrorText = "value 3"
									EndIf
								Else ; normal redline based drop vectors
									Assign("ATTACKVECTOR_" & $value1, MakeDropPoints(Eval($sidex), $value3, $value4, $value5, $value6, $value7))
								EndIf
							Else
								$sErrorText = "value1 or value 5"
							EndIf
						Else
							$sErrorText = "value2"
						EndIf
						If $sErrorText <> "" Then ; log error message
							SetLog("Discard row, bad " & $sErrorText & " parameter: row " & $iLine + 1)
							debugAttackCSV("Discard row, bad " & $sErrorText & " parameter: row " & $iLine + 1)
						Else ; debuglog vectors
							For $i = 0 To UBound(Execute("$ATTACKVECTOR_" & $value1)) - 1
								Local $pixel = Execute("$ATTACKVECTOR_" & $value1 & "[" & $i & "]")
								debugAttackCSV($i & " - " & $pixel[0] & "," & $pixel[1])
							Next
						EndIf
					Case "SWIPEAB"
						ReleaseClicks()
						If $g_iTotalAttackSlot > 10 Then
							If $g_bDraggedAttackBar Then
								SetLog("SWIPEAB: Swipe to 1st Page of attackbar.")
								debugAttackCSV("SWIPEAB: Swipe to 1st Page of attackbar.")
								DragAttackBar($g_iTotalAttackSlot, True) ; drag to 1st page
							Else
								SetLog("SWIPEAB: Swipe to 2nd Page of attackbar.")
								debugAttackCSV("SWIPEAB: Swipe to 2nd Page of attackbar.")
								DragAttackBar($g_iTotalAttackSlot, False)  ; drag to 2nd page
							EndIf
						Else
							SetLog("Discard row: " & $iLine + 1 & ", SWIPEAB: You should have 11+ slot to use this command")
							debugAttackCSV("Discard row: " & $iLine + 1 & ", SWIPEAB: You should have 11+ slot to use this command")
						EndIf
						If _Sleep($DELAYRESPOND) Then Return ; check for pause/stop
					Case "DROP"
						KeepClicks()
						;index...
						Local $index1, $index2, $indexArray, $indexvect
						$indexvect = StringSplit($value2, "-", 2)
						If UBound($indexvect) > 1 Then
							$indexArray = 0
							If Int($indexvect[0]) > 0 And Int($indexvect[1]) > 0 Then
								$index1 = Int($indexvect[0])
								$index2 = Int($indexvect[1])
							Else
								$index1 = 1
								$index2 = 1
							EndIf
						Else
							$indexArray = StringSplit($value2, ",", 2)
							If UBound($indexArray) > 1 Then
								$index1 = 0
								$index2 = UBound($indexArray) - 1
							Else
								$indexArray = 0
								If Int($value2) > 0 Then
									$index1 = Int($value2)
									$index2 = Int($value2)
								Else
									$index1 = 1
									$index2 = 1
								EndIf
							EndIf
						EndIf
						;qty...
						Local $qty1, $qty2, $qtyvect
						$qtyvect = StringSplit($value3, "-", 2)
						If UBound($qtyvect) > 1 Then
							If Int($qtyvect[0]) > 0 And Int($qtyvect[1]) > 0 Then
								$qty1 = Int($qtyvect[0])
								$qty2 = Int($qtyvect[1])
							Else
								$index1 = 1
								$qty2 = 1
							EndIf
						Else
							If Int($value3) > 0 Then
								$qty1 = Int($value3)
								$qty2 = Int($value3)
							Else
								$qty1 = 1
								$qty2 = 1
							EndIf
						EndIf
						;delay between points
						Local $delaypoints1, $delaypoints2, $delaypointsvect
						$delaypointsvect = StringSplit($value5, "-", 2)
						If UBound($delaypointsvect) > 1 Then
							If Int($delaypointsvect[0]) >= 0 And Int($delaypointsvect[1]) >= 0 Then
								$delaypoints1 = Int($delaypointsvect[0])
								$delaypoints2 = Int($delaypointsvect[1])
							Else
								$delaypoints1 = 1
								$delaypoints2 = 1
							EndIf
						Else
							If Int($value5) >= 0 Then
								$delaypoints1 = Int($value5)
								$delaypoints2 = Int($value5)
							Else
								$delaypoints1 = 1
								$delaypoints2 = 1
							EndIf
						EndIf
						;delay between  drops in same point
						Local $delaydrop1, $delaydrop2, $delaydropvect
						$delaydropvect = StringSplit($value6, "-", 2)
						If UBound($delaydropvect) > 1 Then
							If Int($delaydropvect[0]) >= 0 And Int($delaydropvect[1]) >= 0 Then
								$delaydrop1 = Int($delaydropvect[0])
								$delaydrop2 = Int($delaydropvect[1])
							Else
								$delaydrop1 = 1
								$delaydrop2 = 1
							EndIf
						Else
							If Int($value6) >= 0 Then
								$delaydrop1 = Int($value6)
								$delaydrop2 = Int($value6)
							Else
								$delaydrop1 = 1
								$delaydrop2 = 1
							EndIf
						EndIf
						;sleep time after drop
						Local $sleepdrop1, $sleepdrop2, $sleepdroppvect
						$sleepdroppvect = StringSplit($value7, "-", 2)
						If UBound($sleepdroppvect) > 1 Then
							If Int($sleepdroppvect[0]) >= 0 And Int($sleepdroppvect[1]) >= 0 Then
								$sleepdrop1 = Int($sleepdroppvect[0])
								$sleepdrop2 = Int($sleepdroppvect[1])
							Else
								$index1 = 1
								$sleepdrop2 = 1
							EndIf
						Else
							If Int($value7) >= 0 Then
								$sleepdrop1 = Int($value7)
								$sleepdrop2 = Int($value7)
							Else
								$sleepdrop1 = 1
								$sleepdrop2 = 1
							EndIf
						EndIf
						; check for targeted vectors and validate index numbers, need too many values for check logic to use CheckCSVValues()
						Local $tmpVectorList = StringSplit($value1, "-", $STR_NOCOUNT) ; get array with all vector(s) used
						For $v = 0 To UBound($tmpVectorList) - 1 ; loop thru each vector in target list
							If StringInStr($sTargetVectors, $tmpVectorList[$v], $STR_NOCASESENSEBASIC) = True Then
								If IsArray($indexArray) Then ; is index comma separated list?
									For $i = $index1 To $index2 ; check that all values are less 5?
										If $indexArray[$i] < 1 Or $indexArray[$i] > 5 Then
											$sErrorText &= "Invalid INDEX for near building DROP"
											SetDebugLog("$index1: " & $index1 & ", $index2: " & $index2 & ", $indexArray[" & $i & "]: " & $indexArray[$i], $COLOR_ERROR)
											ExitLoop
										EndIf
									Next
								ElseIf $indexArray = 0 Then ; index is either 2 values comma separated, range "-" separated between 1 & 5, or single index
									Select
										Case $index1 = 1 And $index1 = $index2
											; do nothing, is valid
										Case $index1 >= 1 And $index1 <= 5 And $index2 > 1 And $index2 <= 5
											; do nothing valid index values for near location targets
										Case Else
											$sErrorText &= "Invalid INDEX for building target"
											SetDebugLog("$index1: " & $index1 & ", $index2: " & $index2, $COLOR_ERROR)
									EndSelect
								Else
									SetDebugLog("Monkey found a bad banana checking Bdlg target INDEX!", $COLOR_ERROR)
								EndIf
							EndIf
						Next
						If $sErrorText <> "" Then
							SetLog("Discard row, " & $sErrorText & ": row " & $iLine + 1)
							debugAttackCSV("Discard row, " & $sErrorText & ": row " & $iLine + 1)
						Else
							; REMAIN CMD from @chalicucu | ProMac Updated
							If $value4 = "REMAIN" Then
								ReleaseClicks()
								SetLog("Drop|Remain:  Dropping left over troops", $COLOR_BLUE)
								; Let's get the troops again and quantities
								If PrepareAttack($g_iMatchMode, True) > 0 Then
									; a Loop from all troops
									For $ii = $eBarb To $eIceG ; lauch all remaining troops
										; Loop on all detected troops
										For $x = 0 To UBound($g_avAttackTroops) - 1
											; If the Name exist and haves more than zero is deploy it
											If $g_avAttackTroops[$x][0] = $ii And $g_avAttackTroops[$x][1] > 0 Then
												Local $plural = 0
												If $g_avAttackTroops[$x][1] > 1 Then $plural = 1
												Local $name = NameOfTroop($g_avAttackTroops[$x][0], $plural)
												Setlog("Name: " & $name, $COLOR_DEBUG)
												Setlog("Qty: " & $g_avAttackTroops[$x][1], $COLOR_DEBUG)
												DropTroopFromINI($value1, $index1, $index2, $indexArray, $g_avAttackTroops[$x][1], $g_avAttackTroops[$x][1], $g_asTroopShortNames[$ii], $delaypoints1, $delaypoints2, $delaydrop1, $delaydrop2, $sleepdrop1, $sleepdrop2, $debug)
												CheckHeroesHealth()
												If _Sleep($DELAYALGORITHM_ALLTROOPS5) Then Return
											EndIf
										Next
									Next
									; Loop on all detected troops And Check If Heroes Or Siege Was Not Dropped
									For $i = 0 To UBound($g_avAttackTroops) - 1
										Local $bFoundSpecialTroop = False
										Local $iTroopKind = $g_avAttackTroops[$i][0]
										If $iTroopKind = $eCastle Or $iTroopKind = $eWallW Or $iTroopKind = $eBattleB Or $iTroopKind = $eStoneS Then
											$bFoundSpecialTroop = True
										ElseIf ($iTroopKind = $eKing And Not $g_bDropKing) Or ($iTroopKind = $eQueen And Not $g_bDropQueen) Or ($iTroopKind = $eWarden And Not $g_bDropWarden) Then
											$bFoundSpecialTroop = True
										EndIf
										If $bFoundSpecialTroop Then
											Setlog("Name: " & NameOfTroop($iTroopKind, 0), $COLOR_DEBUG)
											DropTroopFromINI($value1, $index1, $index2, $indexArray, $g_avAttackTroops[$i][1], $g_avAttackTroops[$i][1], GetTroopShortName($iTroopKind), $delaypoints1, $delaypoints2, $delaydrop1, $delaydrop2, $sleepdrop1, $sleepdrop2, $debug)
											CheckHeroesHealth()
											If _Sleep($DELAYALGORITHM_ALLTROOPS5) Then Return
										EndIf
									Next
								EndIf
							Else
								DropTroopFromINI($value1, $index1, $index2, $indexArray, $qty1, $qty2, $value4, $delaypoints1, $delaypoints2, $delaydrop1, $delaydrop2, $sleepdrop1, $sleepdrop2, $debug)
							EndIf
						EndIf
						ReleaseClicks($g_iAndroidAdbClicksTroopDeploySize)
						If _Sleep($DELAYRESPOND) Then Return ; check for pause/stop
					Case "WAIT", "WFSTD", "WFTHD", "WFSTD-WFTHD", "WFTHD-WFSTD", "WFSTD&WFTHD", "WFTHD&WFSTD"
						Local $hSleepTimer = __TimerInit() ; Initialize the timer at first
						ReleaseClicks()
						;sleep time
						Local $sleep1, $sleep2, $sleepvect
						$sleepvect = StringSplit($value1, "-", 2)
						If UBound($sleepvect) > 1 Then
							If Int($sleepvect[0]) > 0 And Int($sleepvect[1]) > 0 Then
								$sleep1 = Int($sleepvect[0])
								$sleep2 = Int($sleepvect[1])
							Else
								$sleep1 = 1
								$sleep2 = 1
							EndIf
						Else
							If Int($value1) > 0 Then
								$sleep1 = Int($value1)
								$sleep2 = Int($value1)
							Else
								$sleep1 = 1
								$sleep2 = 1
							EndIf
						EndIf
						If $sleep1 <> $sleep2 Then
							Local $sleep = Random(Int($sleep1), Int($sleep2), 1)
						Else
							Local $sleep = Int($sleep1)
						EndIf
						debugAttackCSV($command & " " & $sleep)

						Local $bIsSiegeBreakCommand = False
						Local $bIsThBreakCommand = False
						Local $bIsThAndSiegeBreakCommand = False
						Local $bIsEventWaitCommand = False
						Local $iSiegeMachineSlotX = -1

						;Check If Siege&Townhall Destory Condition Is Given
						If StringInStr($command, "&") > 0 Then
							If StringInStr($command, "WFSTD") > 0 And StringInStr($command, "WFTHD") > 0 Then
								$bIsThAndSiegeBreakCommand = True
							EndIf
							;Check If Siege Or Townhall Destory Condition Is Given
						ElseIf StringInStr($command, "-") > 0 Then
							If StringInStr($command, "WFSTD") > 0 Then $bIsSiegeBreakCommand = True
							If StringInStr($command, "WFTHD") > 0 Then $bIsThBreakCommand = True
							;Check If Only Siege Destory Condition Is Given
						ElseIf StringInStr($command, "WFSTD") > 0 Then
							$bIsSiegeBreakCommand = True
							;Check If Only Townhall Destory Condition Is Given
						ElseIf StringInStr($command, "WFTHD") > 0 Then
							$bIsThBreakCommand = True
						EndIf
						If $bIsSiegeBreakCommand Or $bIsThBreakCommand Or $bIsThAndSiegeBreakCommand Then $bIsEventWaitCommand = True

						debugAttackCSV("$bIsSiegeBreakCommand = " & $bIsSiegeBreakCommand & ", $bIsThBreakCommand = " & $bIsThBreakCommand & ", $bIsThAndSiegeBreakCommand = " & $bIsThAndSiegeBreakCommand)
						SetDebugLog("$bIsSiegeBreakCommand = " & $bIsSiegeBreakCommand & ", $bIsThBreakCommand = " & $bIsThBreakCommand & ", $bIsThAndSiegeBreakCommand = " & $bIsThAndSiegeBreakCommand, $COLOR_INFO)

						If $bIsSiegeBreakCommand Or $bIsThAndSiegeBreakCommand Then
							debugAttackCSV("WFSTD->Wait For Siege Troop Drop " & $sleep)
							;Check if Siege is Available In Attackbar or not if not then no need to run this command
							For $i = 0 To UBound($g_avAttackTroops) - 1
								If $g_avAttackTroops[$i][0] = $eCastle Then
									SetLog("WFSTD Command is for Siege Machine Only But Clan Castle Troop Found. Skip It!!", $COLOR_INFO)
									ExitLoop
								ElseIf $g_avAttackTroops[$i][0] = $eWallW Or $g_avAttackTroops[$i][0] = $eBattleB Or $g_avAttackTroops[$i][0] = $eStoneS Then
									Local $sSiegeName = NameOfTroop($g_avAttackTroops[$i][0])
									SetDebugLog("WFSTD Command Found " & $sSiegeName & " Let's Check If is Dropped Or Not?", $COLOR_SUCCESS)
									;Check Siege Slot Quantity If It's 0 Means Siege Is Dropped
									If ReadTroopQuantity($i) = 0 Then
										SetDebugLog($sSiegeName & " is Dropped Let's check when troops will get dropped.", $COLOR_SUCCESS)
										;Get Siege Machine Slot Starting X Will Use This X For Checking Slot Grayed Out or Not
										$iSiegeMachineSlotX = GetXPosOfArmySlot($i) + 5
									Else
										SetDebugLog($sSiegeName & " is not dropped yet Skip this command.", $COLOR_SUCCESS)
									EndIf
									ExitLoop
								EndIf
							Next
							;If Siege Was No Dropped
							If $iSiegeMachineSlotX = -1 Then
								;If Townhall+Siege destroy condtion was set, Set it to Townhall destroy only
								If $bIsThAndSiegeBreakCommand Then
									$bIsThAndSiegeBreakCommand = False
									$bIsThBreakCommand = True
								EndIf
								$bIsSiegeBreakCommand = False
							EndIf
						EndIf
						If $command = "WAIT" Or $bIsSiegeBreakCommand Or $bIsThBreakCommand Or $bIsThAndSiegeBreakCommand Then
							Local $Gold = 0
							Local $Elixir = 0
							Local $DarkElixir = 0
							Local $Trophies = 0
							Local $exitOneStar = 0
							Local $exitTwoStars = 0
							Local $exitNoResources = 0
							Local $exitAttackEnded = 0
							Local $hResourceCheckDelayTimer = __TimerInit()
							While __TimerDiff($hSleepTimer) < $sleep
								;For Benchmark Purpose
								;Local $hLoopWorkTimer = __TimerInit()
								CheckHeroesHealth()
								;For WFSTD Command Checking after delay function so in case troops dropped return ASAP
								If $bIsSiegeBreakCommand And CheckIfSiegeDroppedTheTroops($hSleepTimer, $iSiegeMachineSlotX) Then
									;Incase Of Event Commands Don't check Hero Ability In the End Of Code To Avoid Delay
									$bCheckHeroAbility = False
									ExitLoop
								EndIf
								;For WFTHD Command Checking after delay function so in case townhall destroyed return ASAP
								If $bIsThBreakCommand And CheckIfTownHallGotDestroyed($hSleepTimer) Then
									;Incase Of Event Commands Don't check Hero Ability In the End Of Code To Avoid Delay
									$bCheckHeroAbility = False
									ExitLoop
								EndIf
								;For WFSTD&WFTHD Command Checking after delay function so in case townhall&Siege destroyed return ASAP
								If $bIsThAndSiegeBreakCommand And CheckIfSiegeDroppedTheTroops($hSleepTimer, $iSiegeMachineSlotX) And CheckIfTownHallGotDestroyed($hSleepTimer) Then
									;Incase Of Event Commands Don't check Hero Ability In the End Of Code To Avoid Delay
									$bCheckHeroAbility = False
									ExitLoop
								EndIf
								;Incase of Event Command Event Command is more important then Exiting battle. So Check resouce after every 2 Sec When Command is WFSTD,WFTHD
								If Not $bIsEventWaitCommand Or __TimerDiff($hResourceCheckDelayTimer) > 2000 Then
									$hResourceCheckDelayTimer = __TimerInit()
									;READ RESOURCES
									$Gold = getGoldVillageSearch(48, 69)
									$Elixir = getElixirVillageSearch(48, 69 + 29)
									$Trophies = getTrophyVillageSearch(48, 69 + 99)
									; If trophy value found, then base has Dark Elixir
									If $Trophies <> "" Then
										$DarkElixir = getDarkElixirVillageSearch(48, 69 + 57)
									Else
										$DarkElixir = ""
										$Trophies = getTrophyVillageSearch(48, 69 + 69)
									EndIf

									If $g_bDebugSetlog Then SetDebugLog("detected [G]: " & $Gold & " [E]: " & $Elixir & " [DE]: " & $DarkElixir, $COLOR_INFO)
									If _Sleep($DELAYRESPOND) Then Return ; check for pause/stop
									;EXIT IF RESOURCES = 0
									If $g_abStopAtkNoResources[$g_iMatchMode] And Number($Gold) = 0 And Number($Elixir) = 0 And Number($DarkElixir) = 0 Then
										If Not $g_bDebugSetlog Then SetDebugLog("detected [G]: " & $Gold & " [E]: " & $Elixir & " [DE]: " & $DarkElixir, $COLOR_INFO) ; log if not down above
										SetDebugLog("From Attackcsv: Gold & Elixir & DE = 0, end battle ", $COLOR_DEBUG)
										$exitNoResources = 1
										ExitLoop
									EndIf
									;CALCULATE TWO STARS REACH
									If $g_abStopAtkTwoStars[$g_iMatchMode] And _CheckPixel($aWonTwoStar, True) Then
										SetDebugLog("From Attackcsv: Two Star Reach, exit", $COLOR_SUCCESS)
										$exitTwoStars = 1
										ExitLoop
									EndIf
									;CALCULATE ONE STARS REACH
									If $g_abStopAtkOneStar[$g_iMatchMode] And _CheckPixel($aWonOneStar, True) Then
										SetDebugLog("From Attackcsv: One Star Reach, exit", $COLOR_SUCCESS)
										$exitOneStar = 1
										ExitLoop
									EndIf
									If $g_abStopAtkPctHigherEnable[$g_iMatchMode] And Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)) > Int($g_aiStopAtkPctHigherAmt[$g_iMatchMode]) Then
										ExitLoop
									EndIf
									If _CheckPixel($aEndFightSceneBtn, True) And _CheckPixel($aEndFightSceneAvl, True) And _CheckPixel($aEndFightSceneReportGold, True) Then
										SetDebugLog("From Attackcsv: Found End Fight Scene to close, exit", $COLOR_SUCCESS)
										$exitAttackEnded = 1
										ExitLoop
									EndIf
								EndIf
								;If $g_bDebugSetlog Then SetDebugLog("One Cycle of WAIT Loop Total Took : " & Round(__TimerDiff($hLoopWorkTimer), 2) & "ms", $COLOR_SUCCESS)
								If _Sleep($DELAYRESPOND) Then Return     ; check for pause/stop
							WEnd

							If $exitOneStar = 1 Or $exitTwoStars = 1 Or $exitNoResources = 1 Or $exitAttackEnded = 1 Then ExitLoop     ;stop parse CSV file, start exit battle procedure
						EndIf
					Case "RECALC"
						ReleaseClicks()
						PrepareAttack($g_iMatchMode, True)

					Case Else
						Switch StringLeft($command, 1)
							Case ";", "#", "'"
								; also comment
								debugAttackCSV("comment line")
							Case Else
								SetLog("attack row bad, discard: row " & $iLine + 1, $COLOR_ERROR)
						EndSwitch
				EndSwitch
			Else
				If StringLeft($line, 7) <> "NOTE  |" And StringLeft($line, 7) <> "      |" And StringStripWS(StringUpper($line), 2) <> "" Then SetLog("attack row error, discard: row " & $iLine + 1, $COLOR_ERROR)
			EndIf
			;Incase Of Event Commands Don't check Hero Ability In the End Of Code To Avoid Delay
			If $bCheckHeroAbility Then CheckHeroesHealth()

			If _Sleep($DELAYRESPOND) Then Return     ; check for pause/stop after each line of CSV
		Next
		For $i = 0 To 3
			If $sides2drop[$i] Then $g_iSidesAttack += 1
		Next
		ReleaseClicks()
	Else
		SetLog("Cannot find attack file " & $g_sCSVAttacksPath & "\" & $filename & ".csv", $COLOR_ERROR)
	EndIf
EndFunc   ;==>ParseAttackCSV

;This Function is getting used FOR WFSTD Command to check if Siege Drooped The Troops
Func CheckIfSiegeDroppedTheTroops($hSleepTimer, $iSiegeMachineSlotX)
	;Check Gray Pixel When Siege IS Dead.
	If _ColorCheck(_GetPixelColor($iSiegeMachineSlotX, 577, True, "IsSiegeDestroyed"), Hex(0x474747, 6), 10) Then
		SetDebugLog("Siege Got Destroyed After " & Round(__TimerDiff($hSleepTimer)) & "ms", $COLOR_SUCCESS)
		Return True
	EndIf
	Return False
EndFunc   ;==>CheckIfSiegeDroppedTheTroops

;This Function is getting used FOR WFTHD Command to check if Townhall is destroyed
Func CheckIfTownHallGotDestroyed($hSleepTimer)
	Local $bIsTHDestroyed = False
	;Get Current Damge %
	Local $iDamage = Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY))
	;Check if got any star
	Local $bWonOneStar = _CheckPixel($aWonOneStar, True)
	Local $bWonTwoStar = _CheckPixel($aWonTwoStar, True)

	;If Got 1 Star and Damage % < 50% then TH was taken before 50%
	If $bWonOneStar And $iDamage < 50 Then
		$bIsTHDestroyed = True
		;If Got 2 Star and Damage % >= 50% then TH was taken after 50%
	ElseIf $bWonTwoStar And $iDamage >= 50 Then
		$bIsTHDestroyed = True
	EndIf
	SetDebugLog("WFTHD--> $iDamage: " & $iDamage & " | $bWonOneStar: " & $bWonOneStar & " | $bWonTwoStar: " & $bWonTwoStar & " | $bIsTHDestroyed: " & $bIsTHDestroyed, $COLOR_INFO)
	If $bIsTHDestroyed Then SetDebugLog("Town Hall Got Destroyed After " & Round(__TimerDiff($hSleepTimer)) & "ms", $COLOR_SUCCESS)
	Return $bIsTHDestroyed
EndFunc   ;==>CheckIfTownHallGotDestroyed



; #FUNCTION# ====================================================================================================================
; Name ..........: ParseAttackCSV_MainSide
; Description ...:
; Syntax ........: ParseAttackCSV_MainSide([$debug = False])
; Parameters ....: $debug               - [optional]
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: MMHK (07-2017)(01-2018), Demen (2019)
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func ParseAttackCSV_MainSide($debug = False)

	Local $bForceSideExist = False
	;Local $filename = "attack1"
	If $g_iMatchMode = $DB Then
		Local $filename = $g_sAttackScrScriptName[$DB]
	Else
		Local $filename = $g_sAttackScrScriptName[$LB]
	EndIf

	Local $line, $acommand, $command
	Local $value1 = "", $value2 = "", $value3 = "", $value4 = "", $value5 = "", $value6 = "", $value7 = "", $value8 = "", $value9 = ""
	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		Local $aLines = FileReadToArray($g_sCSVAttacksPath & "\" & $filename & ".csv")

		; Read in lines of text until the EOF is reached
		For $iLine = 0 To UBound($aLines) - 1
			$line = $aLines[$iLine]
			debugAttackCSV("line: " & $iLine + 1)
			If @error = -1 Then ExitLoop
			If $debug = True Then SetLog("parse line:<<" & $line & ">>")
			debugAttackCSV("line content: " & $line)
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), $STR_STRIPTRAILING)
				If $command <> "SIDE" And $command <> "SIDEB" Then ContinueLoop     ; Only deal with SIDE and SIDEB commands
				; Set values
				For $i = 2 To (UBound($acommand) - 1)
					Assign("value" & Number($i - 1), StringStripWS(StringUpper($acommand[$i]), $STR_STRIPTRAILING))
				Next

				Switch $command
					Case "SIDE"
						ReleaseClicks()
						SetLog("Calculate main side... ")
						Local $heightTopLeft = 0, $heightTopRight = 0, $heightBottomLeft = 0, $heightBottomRight = 0
						If StringUpper($value8) = "TOP-LEFT" Or StringUpper($value8) = "TOP-RIGHT" Or StringUpper($value8) = "BOTTOM-LEFT" Or StringUpper($value8) = "BOTTOM-RIGHT" Then
							$MAINSIDE = StringUpper($value8)
							SetLog("Forced side: " & StringUpper($value8), $COLOR_INFO)
							$bForceSideExist = True
						Else


							For $i = 0 To UBound($g_aiPixelMine) - 1
								Local $pixel = $g_aiPixelMine[$i]
								If UBound($pixel) = 2 Then
									Switch StringLeft(Slice8($pixel), 1)
										Case 1, 2
											$heightBottomRight += Int($value1)
										Case 3, 4
											$heightTopRight += Int($value1)
										Case 5, 6
											$heightTopLeft += Int($value1)
										Case 7, 8
											$heightBottomLeft += Int($value1)
									EndSwitch
								EndIf
							Next

							For $i = 0 To UBound($g_aiPixelElixir) - 1
								Local $pixel = $g_aiPixelElixir[$i]
								If UBound($pixel) = 2 Then
									Switch StringLeft(Slice8($pixel), 1)
										Case 1, 2
											$heightBottomRight += Int($value2)
										Case 3, 4
											$heightTopRight += Int($value2)
										Case 5, 6
											$heightTopLeft += Int($value2)
										Case 7, 8
											$heightBottomLeft += Int($value2)
									EndSwitch
								EndIf
							Next

							For $i = 0 To UBound($g_aiPixelDarkElixir) - 1
								Local $pixel = $g_aiPixelDarkElixir[$i]
								If UBound($pixel) = 2 Then
									Switch StringLeft(Slice8($pixel), 1)
										Case 1, 2
											$heightBottomRight += Int($value3)
										Case 3, 4
											$heightTopRight += Int($value3)
										Case 5, 6
											$heightTopLeft += Int($value3)
										Case 7, 8
											$heightBottomLeft += Int($value3)
									EndSwitch
								EndIf
							Next

							If IsArray($g_aiCSVGoldStoragePos) Then
								For $i = 0 To UBound($g_aiCSVGoldStoragePos) - 1
									Local $pixel = $g_aiCSVGoldStoragePos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value4)
											Case 3, 4
												$heightTopRight += Int($value4)
											Case 5, 6
												$heightTopLeft += Int($value4)
											Case 7, 8
												$heightBottomLeft += Int($value4)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVElixirStoragePos) Then
								For $i = 0 To UBound($g_aiCSVElixirStoragePos) - 1
									Local $pixel = $g_aiCSVElixirStoragePos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value5)
											Case 3, 4
												$heightTopRight += Int($value5)
											Case 5, 6
												$heightTopLeft += Int($value5)
											Case 7, 8
												$heightBottomLeft += Int($value5)
										EndSwitch
									EndIf
								Next
							EndIf

							Switch StringLeft(Slice8($g_aiCSVDarkElixirStoragePos), 1)
								Case 1, 2
									$heightBottomRight += Int($value6)
								Case 3, 4
									$heightTopRight += Int($value6)
								Case 5, 6
									$heightTopLeft += Int($value6)
								Case 7, 8
									$heightBottomLeft += Int($value6)
							EndSwitch

							Local $pixel = StringSplit($g_iTHx & "-" & $g_iTHy, "-", 2)
							Switch StringLeft(Slice8($pixel), 1)
								Case 1, 2
									$heightBottomRight += Int($value7)
								Case 3, 4
									$heightTopRight += Int($value7)
								Case 5, 6
									$heightTopLeft += Int($value7)
								Case 7, 8
									$heightBottomLeft += Int($value7)
							EndSwitch
						EndIf

						If $bForceSideExist = False Then
							Local $maxValue = $heightBottomRight
							Local $sidename = "BOTTOM-RIGHT"

							If $heightTopLeft > $maxValue Then
								$maxValue = $heightTopLeft
								$sidename = "TOP-LEFT"
							EndIf

							If $heightTopRight > $maxValue Then
								$maxValue = $heightTopRight
								$sidename = "TOP-RIGHT"
							EndIf

							If $heightBottomLeft > $maxValue Then
								$maxValue = $heightBottomLeft
								$sidename = "BOTTOM-LEFT"
							EndIf

							SetLog("Mainside: " & $sidename & " (top-left:" & $heightTopLeft & " top-right:" & $heightTopRight & " bottom-left:" & $heightBottomLeft & " bottom-right:" & $heightBottomRight)
							$MAINSIDE = $sidename
						EndIf

						Switch $MAINSIDE
							Case "BOTTOM-RIGHT"
								$FRONT_LEFT = "BOTTOM-RIGHT-DOWN"
								$FRONT_RIGHT = "BOTTOM-RIGHT-UP"
								$RIGHT_FRONT = "TOP-RIGHT-DOWN"
								$RIGHT_BACK = "TOP-RIGHT-UP"
								$LEFT_FRONT = "BOTTOM-LEFT-DOWN"
								$LEFT_BACK = "BOTTOM-LEFT-UP"
								$BACK_LEFT = "TOP-LEFT-DOWN"
								$BACK_RIGHT = "TOP-LEFT-UP"
							Case "BOTTOM-LEFT"
								$FRONT_LEFT = "BOTTOM-LEFT-UP"
								$FRONT_RIGHT = "BOTTOM-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-RIGHT-DOWN"
								$RIGHT_BACK = "BOTTOM-RIGHT-UP"
								$LEFT_FRONT = "TOP-LEFT-DOWN"
								$LEFT_BACK = "TOP-LEFT-UP"
								$BACK_LEFT = "TOP-RIGHT-UP"
								$BACK_RIGHT = "TOP-RIGHT-DOWN"
							Case "TOP-LEFT"
								$FRONT_LEFT = "TOP-LEFT-UP"
								$FRONT_RIGHT = "TOP-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-LEFT-UP"
								$RIGHT_BACK = "BOTTOM-LEFT-DOWN"
								$LEFT_FRONT = "TOP-RIGHT-UP"
								$LEFT_BACK = "TOP-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-RIGHT-UP"
								$BACK_RIGHT = "BOTTOM-RIGHT-DOWN"
							Case "TOP-RIGHT"
								$FRONT_LEFT = "TOP-RIGHT-DOWN"
								$FRONT_RIGHT = "TOP-RIGHT-UP"
								$RIGHT_FRONT = "TOP-LEFT-UP"
								$RIGHT_BACK = "TOP-LEFT-DOWN"
								$LEFT_FRONT = "BOTTOM-RIGHT-UP"
								$LEFT_BACK = "BOTTOM-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-LEFT-DOWN"
								$BACK_RIGHT = "BOTTOM-LEFT-UP"
						EndSwitch

					Case "SIDEB"
						ReleaseClicks()
						If $bForceSideExist = False Then
							SetLog("Recalculate main side for additional defense buildings... ", $COLOR_INFO)

							Switch StringLeft(Slice8($g_aiCSVEagleArtilleryPos), 1)
								Case 1, 2
									$heightBottomRight += Int($value1)
								Case 3, 4
									$heightTopRight += Int($value1)
								Case 5, 6
									$heightTopLeft += Int($value1)
								Case 7, 8
									$heightBottomLeft += Int($value1)
							EndSwitch

							If IsArray($g_aiCSVInfernoPos) Then
								For $i = 0 To UBound($g_aiCSVInfernoPos) - 1
									Local $pixel = $g_aiCSVInfernoPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value4)
											Case 3, 4
												$heightTopRight += Int($value4)
											Case 5, 6
												$heightTopLeft += Int($value4)
											Case 7, 8
												$heightBottomLeft += Int($value4)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVXBowPos) Then
								For $i = 0 To UBound($g_aiCSVXBowPos) - 1
									Local $pixel = $g_aiCSVXBowPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value4)
											Case 3, 4
												$heightTopRight += Int($value4)
											Case 5, 6
												$heightTopLeft += Int($value4)
											Case 7, 8
												$heightBottomLeft += Int($value4)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVWizTowerPos) Then
								For $i = 0 To UBound($g_aiCSVWizTowerPos) - 1
									Local $pixel = $g_aiCSVWizTowerPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value4)
											Case 3, 4
												$heightTopRight += Int($value4)
											Case 5, 6
												$heightTopLeft += Int($value4)
											Case 7, 8
												$heightBottomLeft += Int($value4)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVMortarPos) Then
								For $i = 0 To UBound($g_aiCSVMortarPos) - 1
									Local $pixel = $g_aiCSVMortarPos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value4)
											Case 3, 4
												$heightTopRight += Int($value4)
											Case 5, 6
												$heightTopLeft += Int($value4)
											Case 7, 8
												$heightBottomLeft += Int($value4)
										EndSwitch
									EndIf
								Next
							EndIf

							If IsArray($g_aiCSVAirDefensePos) Then
								For $i = 0 To UBound($g_aiCSVAirDefensePos) - 1
									Local $pixel = $g_aiCSVAirDefensePos[$i]
									If UBound($pixel) = 2 Then
										Switch StringLeft(Slice8($pixel), 1)
											Case 1, 2
												$heightBottomRight += Int($value4)
											Case 3, 4
												$heightTopRight += Int($value4)
											Case 5, 6
												$heightTopLeft += Int($value4)
											Case 7, 8
												$heightBottomLeft += Int($value4)
										EndSwitch
									EndIf
								Next
							EndIf

							Local $maxValue = $heightBottomRight
							Local $sidename = "BOTTOM-RIGHT"

							If $heightTopLeft > $maxValue Then
								$maxValue = $heightTopLeft
								$sidename = "TOP-LEFT"
							EndIf

							If $heightTopRight > $maxValue Then
								$maxValue = $heightTopRight
								$sidename = "TOP-RIGHT"
							EndIf

							If $heightBottomLeft > $maxValue Then
								$maxValue = $heightBottomLeft
								$sidename = "BOTTOM-LEFT"
							EndIf

							SetLog("New Mainside: " & $sidename & " (top-left:" & $heightTopLeft & " top-right:" & $heightTopRight & " bottom-left:" & $heightBottomLeft & " bottom-right:" & $heightBottomRight, $COLOR_INFO)
							$MAINSIDE = $sidename
						EndIf
						Switch $MAINSIDE
							Case "BOTTOM-RIGHT"
								$FRONT_LEFT = "BOTTOM-RIGHT-DOWN"
								$FRONT_RIGHT = "BOTTOM-RIGHT-UP"
								$RIGHT_FRONT = "TOP-RIGHT-DOWN"
								$RIGHT_BACK = "TOP-RIGHT-UP"
								$LEFT_FRONT = "BOTTOM-LEFT-DOWN"
								$LEFT_BACK = "BOTTOM-LEFT-UP"
								$BACK_LEFT = "TOP-LEFT-DOWN"
								$BACK_RIGHT = "TOP-LEFT-UP"
							Case "BOTTOM-LEFT"
								$FRONT_LEFT = "BOTTOM-LEFT-UP"
								$FRONT_RIGHT = "BOTTOM-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-RIGHT-DOWN"
								$RIGHT_BACK = "BOTTOM-RIGHT-UP"
								$LEFT_FRONT = "TOP-LEFT-DOWN"
								$LEFT_BACK = "TOP-LEFT-UP"
								$BACK_LEFT = "TOP-RIGHT-UP"
								$BACK_RIGHT = "TOP-RIGHT-DOWN"
							Case "TOP-LEFT"
								$FRONT_LEFT = "TOP-LEFT-UP"
								$FRONT_RIGHT = "TOP-LEFT-DOWN"
								$RIGHT_FRONT = "BOTTOM-LEFT-UP"
								$RIGHT_BACK = "BOTTOM-LEFT-DOWN"
								$LEFT_FRONT = "TOP-RIGHT-UP"
								$LEFT_BACK = "TOP-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-RIGHT-UP"
								$BACK_RIGHT = "BOTTOM-RIGHT-DOWN"
							Case "TOP-RIGHT"
								$FRONT_LEFT = "TOP-RIGHT-DOWN"
								$FRONT_RIGHT = "TOP-RIGHT-UP"
								$RIGHT_FRONT = "TOP-LEFT-UP"
								$RIGHT_BACK = "TOP-LEFT-DOWN"
								$LEFT_FRONT = "BOTTOM-RIGHT-UP"
								$LEFT_BACK = "BOTTOM-RIGHT-DOWN"
								$BACK_LEFT = "BOTTOM-LEFT-DOWN"
								$BACK_RIGHT = "BOTTOM-LEFT-UP"
						EndSwitch

					Case Else
						SetLog("No 'SIDE' or 'SIDEB' csv line found, using default attack side: " & $MAINSIDE)
				EndSwitch
			EndIf
			If _Sleep($DELAYRESPOND) Then Return     ; check for pause/stop after each line of CSV
		Next
		ReleaseClicks()
	Else
		SetLog("Cannot find attack file " & $g_sCSVAttacksPath & "\" & $filename & ".csv", $COLOR_ERROR)
	EndIf
EndFunc   ;==>ParseAttackCSV_MainSide

