; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Attack Plan" tab under the "Builder Base" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Fahid.Mahmood (2018)
; Remarks .......: This file is part of MultiBot, previously known as Mybot and ClashGameBot. Copyright 2015-2018
;                  MultiBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hChkBBStopAt3 = 0, $g_hChkBBTrophiesRange = 0, $g_hTxtBBDropTrophiesMin = 0, $g_hLblBBDropTrophiesDash = 0, $g_hTxtBBDropTrophiesMax = 0, $g_hCmbBBAttackStyle[3] = [0,0,0]
Global $g_hCmbBBArmy1 = 0, $g_hCmbBBArmy2 = 0, $g_hCmbBBArmy3 = 0, $g_hCmbBBArmy4 = 0, $g_hCmbBBArmy5 = 0, $g_hCmbBBArmy6 = 0
Global $g_hIcnBBarmy1 = 0, $g_hIcnBBarmy2 = 0, $g_hIcnBBarmy3 = 0, $g_hIcnBBarmy4 = 0, $g_hIcnBBarmy5 = 0, $g_hIcnBBarmy6 = 0
Global $g_hLblNotesScriptBB[3] = [0,0,0], $g_hGrpOptionsBB = 0, $g_hGrpAttackStyleBB = 0 ,$g_hGrpGuideScriptBB[3] = [0,0,0], $g_hIcnBBCSV[4] = [0,0,0,0]
Global $g_hGUI_ATTACK_PLAN_BUILDER_BASE = 0, $g_hGUI_ATTACK_PLAN_BUILDER_BASE_CSV = 0
Global $g_hChkBBRandomAttack = 0

Func CreateAttackPlanBuilderBaseSubTab()


	$g_hGUI_ATTACK_PLAN_BUILDER_BASE = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_BUILDER_BASE)
	GUISetBkColor($COLOR_WHITE, $g_hGUI_ATTACK_PLAN_BUILDER_BASE)

	Local $sTxtShortRagedBarbarian = GetTranslatedFileIni("MBR Global GUI Design Names BB Troops", "TxtShortRagedBarbarian", "Barb")
	Local $sTxtShortSneakyArcher = GetTranslatedFileIni("MBR Global GUI Design Names BB Troops", "TxtShortSneakyArcher", "Arch")
	Local $sTxtShortBoxerGiant = GetTranslatedFileIni("MBR Global GUI Design Names BB Troops", "TxtShortBoxerGiant", "Giant")
	Local $sTxtShortBetaMinion = GetTranslatedFileIni("MBR Global GUI Design Names BB Troops", "TxtShortBetaMinion", "Beta")
	Local $sTxtShortBomber = GetTranslatedFileIni("MBR Global GUI Design Names BB Troops", "TxtShortBomber", "Bomb")
	Local $sTxtShortBabyDragon = GetTranslatedFileIni("MBR Global GUI Design Names BB Troops", "TxtShortBabyDragon", "BabyDrag")
	Local $sTxtShortCannonCart = GetTranslatedFileIni("MBR Global GUI Design Names BB Troops", "TxtShortCannonCart", "Cannon")
	Local $sTxtShortDropShip = GetTranslatedFileIni("MBR Global GUI Design Names BB Troops", "TxtShortDropShip", "Drop")
	Local $sTxtShortSuperPekka = GetTranslatedFileIni("MBR Global GUI Design Names BB Troops", "TxtShortSuperPekka", "Pekka")
	Local $sTxtShortNightWitch = GetTranslatedFileIni("MBR Global GUI Design Names BB Troops", "TxtShortNightWitch", "Night")
	Local $sTxtShortBBTroopList = [$sTxtShortRagedBarbarian, $sTxtShortSneakyArcher, $sTxtShortBoxerGiant, $sTxtShortBetaMinion, $sTxtShortBomber, $sTxtShortBabyDragon, _
									$sTxtShortCannonCart, $sTxtShortNightWitch, $sTxtShortDropShip, $sTxtShortSuperPekka]

	Local $x = 0, $y = 0
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "Group_01", "Train Army"), $x, $y, $g_iSizeWGrpTab2 - 2, 85)
		$x = +8

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "lblBBArmyCamp1", "Army Camp 1"), $x + 5, $y + 15)
			$g_hCmbBBArmy1 = GUICtrlCreateCombo("", $x + 5, $y + 30, 62)
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "lblBBArmyCampEmpty", "Empty")&"|"& _ArrayToString($sTxtShortBBTroopList), $sTxtShortBetaMinion)
			GUICtrlSetOnEvent(-1, "chkBBArmyCamp")
			$g_hIcnBBarmy1 = _GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnBBBeta, $x + 5 + 19, $y + 54, 24, 24)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "lblBBArmyCamp2", "Army Camp 2"), $x + 75, $y + 15)
			$g_hCmbBBArmy2 = GUICtrlCreateCombo("", $x + 75, $y + 30, 62)
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "lblBBArmyCampEmpty", -1)&"|"& _ArrayToString($sTxtShortBBTroopList), $sTxtShortBetaMinion)
			GUICtrlSetOnEvent(-1, "chkBBArmyCamp")
			$g_hIcnBBarmy2 = _GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnBBBeta, $x + 75 + 19, $y + 54, 24, 24)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "lblBBArmyCamp3", "Army Camp 3"), $x + 145, $y + 15)
			$g_hCmbBBArmy3 = GUICtrlCreateCombo("", $x + 145, $y + 30, 62)
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "lblBBArmyCampEmpty", -1)&"|"& _ArrayToString($sTxtShortBBTroopList), $sTxtShortDropShip)
			GUICtrlSetOnEvent(-1, "chkBBArmyCamp")
			$g_hIcnBBarmy3 = _GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnBBDrop, $x + 145 + 19, $y + 54, 24, 24)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "lblBBArmyCamp4", "Army Camp 4"), $x + 215, $y + 15)
			$g_hCmbBBArmy4 = GUICtrlCreateCombo("", $x + 215, $y + 30, 62)
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "lblBBArmyCampEmpty", -1)&"|"& _ArrayToString($sTxtShortBBTroopList), $sTxtShortNightWitch)
			GUICtrlSetOnEvent(-1, "chkBBArmyCamp")
			$g_hIcnBBarmy4 = _GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnBBNight, $x + 215 + 19, $y + 54, 24, 24)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "lblBBArmyCamp5", "Army Camp 5"), $x + 285, $y + 15)
			$g_hCmbBBArmy5 = GUICtrlCreateCombo("", $x + 285, $y + 30, 62)
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "lblBBArmyCampEmpty", -1)&"|"&  _ArrayToString($sTxtShortBBTroopList), _
			GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "lblBBArmyCampEmpty", -1))
			GUICtrlSetOnEvent(-1, "chkBBArmyCamp")
			$g_hIcnBBarmy5 = _GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnBBEmpty, $x + 285 + 19, $y + 54, 24, 24)

		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "lblBBArmyCamp6", "Army Camp 6"), $x + 355, $y + 15)
			$g_hCmbBBArmy6 = GUICtrlCreateCombo("", $x + 355, $y + 30, 62)
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "lblBBArmyCampEmpty", -1)&"|"&  _ArrayToString($sTxtShortBBTroopList), _
			GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "lblBBArmyCampEmpty", -1))
			GUICtrlSetOnEvent(-1, "chkBBArmyCamp")
			$g_hIcnBBarmy6 = _GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnBBEmpty, $x + 355 + 19, $y + 54, 24, 24)
	GUICtrlCreateGroup("", -99, -99, 1, 1)


	$x = 0
	$y = 90
	$g_hGrpOptionsBB = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "Group_02", "Options"), $x, $y, $g_iSizeWGrpTab2 - 2, 45)
		$g_hChkBBStopAt3 = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "ChkBBStopAt3", "Stop at 3 wins"), $x + 5, $y + 15, -1, -1)

		$g_hChkBBTrophiesRange = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "ChkBBDropTrophies", "Trophies Range") & ": ", $x + 100, $y + 15, -1, -1)
			GUICtrlSetOnEvent(-1, "chkBBtrophiesRange")
			$g_hTxtBBDropTrophiesMin = GUICtrlCreateInput("1250", $x + 203, $y + 15, 40, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$g_hLblBBDropTrophiesDash = GUICtrlCreateLabel("-", $x + 245, $y + 15 + 2)
			$g_hTxtBBDropTrophiesMax = GUICtrlCreateInput("2500", $x + 250, $y + 15, 40, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))

		$g_hChkBBRandomAttack = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "ChkBBRandomAttack ", "Random Attack"), $x + 300, $y + 15, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "ChkBBRandomAttack_Info_01", "Select 3 attacks and the bot will select the best to use according with opponent!") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "ChkBBRandomAttack_Info_02", "Don't worry about the army, the bot will select correct army at attack bar!"))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "ChkBBRandomAttack")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_hGUI_ATTACK_PLAN_BUILDER_BASE_CSV = _GUICreate("", $g_iSizeWGrpTab2 - 2, $g_iSizeHGrpTab4, 0, 140, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_ATTACK_PLAN_BUILDER_BASE)

	$y = 5
	$x = 5
	$g_hGrpAttackStyleBB = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "Group_03", "Attack Style"), $x, $y, $g_iSizeWGrpTab2 - 12, $g_iSizeHGrpTab4 - 90)
		$y += 15
		$g_hGrpGuideScriptBB[0] = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "GrpGuideScriptBB_Info_01", "CSV For Standard Base"), $x + 5, $y , 134, $g_iSizeHGrpTab4 - 108)
			GUICtrlSetFont(-1, 7)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		$g_hGrpGuideScriptBB[1] = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "GrpGuideScriptBB_Info_02", "CSV For Weak Ground Base"), $x + 130 + 10, $y , 134, $g_iSizeHGrpTab4 - 108)
			GUICtrlSetFont(-1, 7)
			GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		$g_hGrpGuideScriptBB[2] = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "GrpGuideScriptBB_Info_03", "CSV For Weak Air Base"), $x + 130 + 130 + 15, $y, 134, $g_iSizeHGrpTab4 - 108)
			GUICtrlSetFont(-1, 7)
			GUICtrlSetState(-1, $GUI_HIDE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		$y += 15
		$x = 7
		$g_hCmbBBAttackStyle[0] = GUICtrlCreateCombo("", $x + 5, $y, 130, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "CmbScriptName", "Choose the script; You can edit/add new scripts located in folder: 'CSV/BuilderBase'"))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkBBStyle")

		$g_hCmbBBAttackStyle[1] = GUICtrlCreateCombo("", $x + 130 + 10 , $y, 130, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
			GUICtrlSetOnEvent(-1, "chkBBStyle")
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hCmbBBAttackStyle[2] = GUICtrlCreateCombo("", $x + 130 + 130 + 15 , $y, 130, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
			GUICtrlSetOnEvent(-1, "chkBBStyle")
			GUICtrlSetState(-1, $GUI_HIDE)

		$g_hIcnBBCSV[0] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnReload, $x + 409, $y + 2, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "IconReload_Info_01", "Reload Script Files"))
			GUICtrlSetOnEvent(-1, 'UpdateComboScriptNameBB') ; Run this function when the secondary GUI [X] is clicked

		$y += 20
		$g_hLblNotesScriptBB[0] = GUICtrlCreateLabel("", $x + 5, $y + 5, 130, 180)
		$g_hLblNotesScriptBB[1] = GUICtrlCreateLabel("", $x + 130 + 10, $y + 5, 130, 180)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hLblNotesScriptBB[2] = GUICtrlCreateLabel("", $x + 130 + 130 + 15, $y + 5, 130, 180)
			GUICtrlSetState(-1, $GUI_HIDE)

		$g_hIcnBBCSV[1] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnEdit, $x + 409, $y + 2, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "IconShow-Edit_Info_01", "Show/Edit current Attack Script"))
			GUICtrlSetOnEvent(-1, "EditScriptBB")

		$y += 20
		$g_hIcnBBCSV[2] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnAddcvs, $x + 409, $y + 2, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "IconCreate_Info_01", "Create a new Attack Script"))
			GUICtrlSetOnEvent(-1, "NewScriptBB")

		$y += 20
		$g_hIcnBBCSV[3] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCopy, $x + 409, $y + 2, 16, 16)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Builder Base - Attack", "IconCopy_Info_01", "Copy current Attack Script to a new name"))
			GUICtrlSetOnEvent(-1, "DuplicateScriptBB")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	;------------------------------------------------------------------------------------------
	;----- populate list of script and assign the default value if no exist profile -----------
	PopulateComboScriptsFilesBB()
	For $i = 0 To 2
		Local $tempindex = _GUICtrlComboBox_FindStringExact($g_hCmbBBAttackStyle[$i], $g_sAttackScrScriptNameBB[$i])
		If $tempindex = -1 Then $tempindex = 0
		_GUICtrlComboBox_SetCurSel($g_hCmbBBAttackStyle[$i], $tempindex)
	Next

EndFunc   ;==>CreateAttackPlanBuilderBaseSubTab
