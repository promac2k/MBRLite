; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseMain.au3
; Description ...: Builder Base Main Loop
; Syntax ........: runBuilderBase()
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

Func TestrunBuilderBase()
	SetDebugLog("** TestrunBuilderBase START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	$g_bRunState = True
	runBuilderBase(False)
	$g_bRunState = $Status
	SetDebugLog("** TestrunBuilderBase END**", $COLOR_DEBUG)
EndFunc   ;==>TestrunBuilderBase

Func runBuilderBase($Test = False)

	If Not $g_bRunState Then Return

	ClickP($aAway, 3, 400, "#0000") ;Click Away

	; Check IF is Necessary run the Builder Base IDLE loop

	If Not $g_bChkBuilderAttack And Not $g_bChkCollectBuilderBase And Not $g_bChkStartClockTowerBoost And Not $g_iChkBBSuggestedUpgrades And Not $g_bChkCleanYardBB Then
		If $g_bChkPlayBBOnly Then
			SetLog("Play Only Builder Base Check Is On But BB Option's(Collect,Attack etc) Unchecked", $COLOR_ERROR)
			SetLog("Please Check BB Options From Builder Base Tab", $COLOR_INFO)
			$g_bRunState = False ;Stop The Bot
			btnStop()
		EndIf
		Return
	EndIf

	If Not isOnBuilderIsland2() Then SwitchBetweenBases()

	SetLog("Builder Base Idle Starts", $COLOR_INFO)

	If _Sleep(2000) Then Return

	If Not BuilderBaseZoomOut(False, True) Then Return

	If $g_bRestart = True Then Return
	; If checkObstacles() Then SetLog("Window clean required, but no problem for MultiBot!", $COLOR_INFO)

	; Collect resources
	If ($g_iCmbBoostBarracks = 0 Or $g_bFirstStart Or $g_bChkPlayBBOnly) And $g_bChkFarmVersion = False Then CollectBuilderBase()
	If $g_bRestart = True Then Return

	; Builder base Report - Get The number of available attacks
	BuilderBaseReport()
	If $g_bRestart = True Then Return

	; Just in Case , the bot can proceed but will give issues because
	; the new image detetion needs a verified token.
	Local $Var = _ChkVerificationToken()
	If Not IsArray($Var) Or Not $Var[0] Then
		If Not $Var[0] Then Setlog("Your token was not verified!", $COLOR_ERROR)
		; switch back to normal village
		If isOnBuilderIsland2() Then SwitchBetweenBases()
		Return
	EndIf

	; Upgrade Troops
	If $g_bRestart = True Then Return
	If ($g_iCmbBoostBarracks = 0 Or $g_bFirstStart Or $g_bChkPlayBBOnly) And $g_bChkFarmVersion = False Then BuilderBaseUpgradeTroops()
	Local $boosted = False
	; Fill/check Army Camps only If is necessary attack
	If $g_bRestart = True Then Return
	If $g_iAvailableAttacksBB > 0 Or Not $g_bChkBBStopAt3 Then CheckArmyBuilderBase()
	; Just a loop to benefit from Clock Tower Boost
	For $i = 0 To 10
		; See The Pending Actions Like ScreenShot cmd , Arg False => is not at Main Village
		NotifyPendingActions(False)
		; Zoomout
		If $g_bRestart = True Then Return
		If Not $g_bRunState Then Return

		If Not BuilderBaseZoomOut() Then Return

		If checkObstacles(True) Then
			SetLog("Window clean required, but no problem for Multibot!", $COLOR_INFO)
			ExitLoop
		EndIf

		; Just in Case , the bot can proceed but will give issues because
		; the new image detetion needs a verified token.
		If IsArray($Var) And $Var[1] Then
			; Attack
			If $g_bRestart = True Then Return
			If Not $g_bRunState Then Return

			BuilderBaseAttack($Test)
			If Not $g_bRunState Then Return

			; Zoomout
			If $g_bRestart = True Then Return
			If Not BuilderBaseZoomOut() Then Return
			If Not $g_bRunState Then Return
		Else
			If Not $Var[1] Then Setlog("Your token was not Pro!", $COLOR_INFO)
		EndIf


		; Clock Tower Boost
		If $g_bRestart = True Then Return
		If Not $g_bRunState Then Return

		If Not $boosted Then $boosted = StartClockTowerBoost()
		; Get Benfit of Boost and clean all yard
		If $g_bRestart = True Then Return

		CleanYardBB()
		; BH Walls Upgrade
		If $g_bRestart = True Then Return
		If Not $g_bRunState Then Return
		WallsUpgradeBB()

		; Auto Upgrade just when you don't need more defenses to win battles
		If $g_bRestart = True Then Return
		If ($g_iCmbBoostBarracks = 0 Or $g_bFirstStart Or $g_bChkPlayBBOnly) And $g_bChkFarmVersion = False And $g_iAvailableAttacksBB = 0 Then SuggestedUpgradeBuildings()

		If Not $boosted Then ExitLoop
		If $boosted Then
			If $g_bRestart = True Then Return
			If $g_iAvailableAttacksBB = 0 And $g_bChkBBStopAt3 Then ExitLoop
		EndIf
		If $g_bRestart = True Then Return
		If Not $g_bRunState Then Return

		BuilderBaseReport()
	Next

	If Not $g_bChkPlayBBOnly Then
		; switch back to normal village
		If isOnBuilderIsland2() Then SwitchBetweenBases()
	EndIf

	_Sleep($DELAYRUNBOT3)

	SetLog("Builder Base Idle Ends", $COLOR_INFO)

	If ProfileSwitchAccountEnabled() Then Return

	If $g_bChkPlayBBOnly Then _Sleep($DELAYRUNBOT1 * 15) ;Add 15 Sec Delay Before Starting Again In BB Only
EndFunc   ;==>runBuilderBase


Func NewImageDetection()

	Local $Status = $g_bRunState
	$g_bRunState = True

	SetLog("FirstTestNewImageDetection STARTS", $COLOR_DEBUG)


	Local $AllResults[0][3]
	Local $hStarttime = _Timer_Init()

	Local $a_Array = _ImageSearchBundlesMultibot($g_sBundleCollectResourcesBB, $g_aXMLToForceAreaParms[0], $g_aXMLToForceAreaParms[1], $g_aXMLToForceAreaParms[2], $g_bDebugBBattack)

	; Example to PNG
	;
	; Local $PNGPath = @ScriptDir & "\imgxml\BuildersBase\Bundles\CollectElixir_1_75_15.png"
	;
	; DllCallMyBot("MultiBotSearchPNG", "handle", $g_hHBitmap2, "str", $PNGPath, "Int", $Quantity2Match, "str", $Area2Search, "bool", False, "bool", $g_bDebugBBattack)


	$g_bRunState = $Status

	SetLog("FirstTestNewImageDetection ENDS", $COLOR_DEBUG)
EndFunc   ;==>NewImageDetection
