; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Train Army" tab under the "Builder Base" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Fahid.Mahmood (2018)
; Remarks .......: This file is part of MultiBot, previously known as Mybot and ClashGameBot. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
#include-once
Global $g_alblBldBaseStats[4] = ["", "", ""]
Global $g_hChkCollectBuilderBase = 0, $g_hChkStartClockTowerBoost = 0, $g_hChkCTBoostBlderBz = 0, $g_hChkCTBoostAtkAvailable = 0
Global $g_hChkCollectBldGE = 0, $g_hChkCollectBldGems = 0, $g_hChkActivateClockTower = 0, $g_hChkCleanYardBB = 0
Global $g_hBtnBBAtkLogClear = 0,$g_hBtnBBAtkLogCopyClipboard=0
Func CreateMiscBuilderBaseSubTab()
	Local $x = 15, $y = 45

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "Group_01", "Collect && Activate"), $x - 10, $y - 20, $g_iSizeWGrpTab2, 125)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldMineL5, $x + 7, $y - 5, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixirCollectorL5, $x + 32, $y - 5, 24, 24)
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnGemMine, $x + 57, $y - 5, 24, 24)
		$g_hChkCollectBuilderBase = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkCollectBuilderBase", "Collect Resources"), $x + 100, $y - 1, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkCollectBuilderBase_Info_01", "Check this to collect Resources on the Builder Base"))

	$y += 22
		GUICtrlCreateIcon($g_sLibIconPath, $eIcnClockTower, $x + 32, $y, 24, 24)
		$g_hChkStartClockTowerBoost = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkActivateClockTowerBoost", "Activate Clock Tower Boost"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkActivateClockTowerBoost_Info_01", "Check this to activate the Clock Tower Boost when it is available.\r\nThis option doesn't use your Gems"))
			GUICtrlSetOnEvent(-1, "chkStartClockTowerBoost")
	$y += 22
		$g_hChkCTBoostBlderBz = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkCTBoostBlderBz", "Only when builder is busy"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkCTBoostBlderBz_Info_01", "Boost only when the builder is busy"))
			GUICtrlSetOnEvent(-1, "chkCTBoostBlderBz")
			GUICtrlSetState (-1, $GUI_DISABLE)
		$g_hChkCTBoostAtkAvailable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkCTBoostAtkAvailable", "Only when attack available"), $x + 260, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkCTBoostAtkAvailable_Info_01", "Boost only when attack available"))
			GUICtrlSetOnEvent(-1, "chkCTBoostAtkAvailable")
			GUICtrlSetState (-1, $GUI_DISABLE)
	$y += 28
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTree, $x + 20, $y, 24, 24)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBark, $x + 45, $y, 24, 24)
		$g_hChkCleanYardBB = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkCleanYardBB", "Remove Obstacles"), $x + 100, $y + 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "ChkCleanYardBB_Info_01", "Check this to automatically clear Yard from Trees, Trunks etc. from Builder base."))
			GUICtrlSetOnEvent(-1, "chkCleanYardBB")
			GUICtrlSetState(-1, $GUI_UNCHECKED)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 57

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "Group_02", "Builders Base Stats"), $x - 10, $y - 20, $g_iSizeWGrpTab2, 275)
		$y += 5
		_GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnBBGold, $x , $y, 16, 16)
		$g_alblBldBaseStats[$eLootGoldBB] = GUICtrlCreateLabel("---", $x + 35, $y + 2, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$y += 30
		_GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnBBElixir, $x , $y, 16, 16)
		$g_alblBldBaseStats[$eLootElixirBB] = GUICtrlCreateLabel("---", $x + 35 , $y + 2, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		$y += 30
		_GUICtrlCreateIcon($g_sLibBBIconPath, $eIcnBBTrophies, $x , $y, 16, 16)
		$g_alblBldBaseStats[$eLootTrophyBB] = GUICtrlCreateLabel("---", $x + 35 , $y + 2, 100, -1)
			GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		
		$y += 160

		$g_hBtnBBAtkLogClear = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "BtnBBAtkLogClear", "Clear Atk. Log"), $x + 245, $y - 1, 80, 23)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "BtnBBAtkLogClear_Info_01", "Use this to clear the Attack Log."))
			GUICtrlSetOnEvent(-1, "btnBBAtkLogClear")

		$g_hBtnBBAtkLogCopyClipboard = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "BtnBBAtkLogCopyClipboard", "Copy to Clipboard"), $x + 325, $y - 1, 100, 23)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Builder Base - Misc", "BtnBBAtkLogCopyClipboard_Info_01", "Use this to copy the Attack Log to the Clipboard (CTRL+C)"))
			GUICtrlSetOnEvent(-1, "btnBBAtkLogCopyClipboard")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateMiscBuilderBaseSubTab