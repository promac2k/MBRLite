; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file This file creates the "Debug" tab under the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

;$hGUI_BotDebug = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_BOT)
;GUISwitch($hGUI_BotDebug)

Global $g_hChkDebugSetlog = 0, $g_hChkDebugAndroid = 0, $g_hChkDebugClick = 0, $g_hChkDebugOCR = 0, $g_hChkDebugImageSave = 0, $g_hChkdebugBuildingPos = 0, $g_hChkdebugTrain = 0, $g_hChkDebugOCRDonate = 0
Global $g_hChkdebugAttackCSV = 0, $g_hChkMakeIMGCSV = 0, $g_hChkDebugDisableZoomout = 0, $g_hChkDebugDisableVillageCentering = 0, $g_hChkDebugDeadbaseImage = 0, $g_hChkDebugFunc = 0, $g_hChkDebugGetVillageSize = 0

Global $g_hBtnTestTrain = 0, $g_hBtnTestDonateCC = 0, $g_hBtnTestRequestCC = 0, $g_hBtnTestSendText = 0, $g_hBtnTestAttackBar = 0, $g_hBtnTestClickDrag = 0, $g_hBtnTestImage = 0
Global $g_hBtnTestVillageSize = 0, $g_hBtnTestDeadBase = 0, $g_hBtnTestTHimgloc = 0, $g_hBtnTestTrainsimgloc = 0, $g_hBtnTestQuickTrainsimgloc = 0, $g_hTxtTestFindButton = 0
Global $g_hBtnTestFindButton = 0, $g_hBtnTestDeadBaseFolder = 0, $g_hBtnTestCleanYard = 0, $g_hBtnTestAttackCSV = 0, $g_hBtnTestBuildingLocation = 0, $g_hBtnTestArmyWindow = 0
Global $g_hBtnTestConfigSave = 0, $g_hBtnTestConfigApply = 0, $g_hBtnTestConfigRead = 0, $g_hBtnTestOcrMemory = 0, $g_hBtnTestWeakBase = 0, $g_hBtnTestClickAway = 0, $g_hBtnTestAutoUpgrade = 0
Global $g_hBtnTestUpgradeWindow = 0, $g_hBtnTestSmartWait = 0, $g_hBtnConsoleWindow = 0,$g_hBtnTestZoomout = 0, $g_hBtnTestVillagePolygon = 0 , $g_hBtnTestVillageRedlines = 0
Global $g_hBtnTestWardenMode = 0, $g_hBtnTestSwitchSiegeMachines = 0, $g_hBtnTestRearm = 0

Func CreateBotDebug()

	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "Group_01", "Debug"), $x - 20, $y - 20, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2)
		$g_hChkDebugSetlog = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugSetlog", "Messages"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugSetlog_Info _01", "Debug: Enables debug SetLog messages in code for Troubleshooting."))

	$y += 20
		$g_hChkDebugAndroid = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugAndroid", "Android"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugAndroid_Info _01", "Debug: Enables additional log debug messages for Android operations."))

	$y += 20
		$g_hChkDebugClick = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugClick", "Click"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugClick_Info _01", "Debug: Write the clicked (x,y) coordinates to the log."))

	$y += 20
		$g_hChkDebugFunc = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugFunc", "Functions"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugFunc_Info _01", "Debug: Enables debug function times and call hierarchy."))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
		$g_hChkDebugOCR = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugOCR", "OCR"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugOCR_Info _01", "Debug: Enables Saving OCR images for troubleshooting."))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
		$g_hChkDebugImageSave = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugImageSave", "Images"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugImageSave_Info _01", "Debug: Enables Saving images for troubleshooting."))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
		$g_hChkdebugBuildingPos = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkdebugBuildingPos", "Buildings"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkdebugBuildingPos_Info _01", "Debug: Enables showing positions of buildings in log."))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
		$g_hChkdebugTrain = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkdebugTrain", "Training"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkdebugTrain_Info _01", "Debug: Enables showing debug during training."))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
		$g_hChkDebugOCRDonate = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugOCRDonate", "Online debug donations"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugOCRDonate_Info _01", "Debug: make ocr of donations and simulate only donate but no donate any troop"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
		$g_hChkdebugAttackCSV = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkdebugAttackCSV", "Attack CSV"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkdebugAttackCSV_Info _01", "Debug: Generates special CSV parse log files"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
		$g_hChkMakeIMGCSV = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkMakeIMGCSV", "Attack CSV Image"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkMakeIMGCSV_Info _01", "Debug: Enables saving clean and location marked up images of bases attacked by CSV scripts"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
		$g_hChkDebugDisableZoomout = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugDisableZoomout", "Disable Zoomout"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugDisableZoomout_Info _01", "Debug: Disables zoomout of village."))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
		$g_hChkDebugDisableVillageCentering = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugDisableVillageCentering", "Disable Village Centering"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugDisableVillageCentering_Info _01", "Debug: Disables centering of village."))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
		$g_hChkDebugDeadbaseImage = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugDeadbaseImage", "Deadbase Image save"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugDeadbaseImage_Info _01", "Debug: Saves images of skipped deadbase villages."))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
		$g_hChkDebugSmartZap = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugSmartZap", "Debug SmartZap"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugSmartZap_Info _01", "Use it to debug SmartZap"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)
	$y += 20
		$g_hChkDebugGetVillageSize = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugGetVillageSize", "Debug External Lines"), $x, $y - 5, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugGetVillageSize_Info _01", "Use it to Get the External Lines at Attack"))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetState(-1, $GUI_HIDE)

	Local $x = 350
	$y = 33
	Local $BtnSizeW = 90
	Local $BtnSizeH = 20
	Local $yNext = 25
		$g_hBtnTestTrain = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestTrain", "SmartFarm"), $x, $y, $BtnSizeW, $BtnSizeH)
	$y += $yNext

		$g_hBtnTestDonateCC = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestDonateCC", "Test Donate"), $x, $y, $BtnSizeW, $BtnSizeH)
	$y += $yNext

		$g_hBtnTestRequestCC = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestRequestCC", "Test Request"), $x, $y, $BtnSizeW, $BtnSizeH)
	$y += $yNext

		$g_hBtnTestAttackBar = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestAttackBar", "Test Attack Bar"), $x, $y, $BtnSizeW, $BtnSizeH)
	$y += $yNext

		$g_hBtnTestClickDrag = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestClickDrag", "Test ClickDrag"), $x, $y, $BtnSizeW, $BtnSizeH)
	$y += $yNext

		$g_hBtnTestImage = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestImage", "Test Image"), $x, $y, $BtnSizeW, $BtnSizeH)

	$y += $yNext

		$g_hBtnTestDeadBase = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestDeadBase", "Test DeadBase"), $x, $y, $BtnSizeW, $BtnSizeH)
	$y += $yNext

		$g_hBtnTestTHimgloc = GUICtrlCreateButton("imgloc TH", $x, $y, $BtnSizeW, $BtnSizeH)
	$y += $yNext

		$g_hBtnTestTrainsimgloc = GUICtrlCreateButton("Queued Spells", $x, $y, $BtnSizeW, $BtnSizeH)
	$y += $yNext

		$g_hBtnTestQuickTrainsimgloc = GUICtrlCreateButton("Queued Troops", $x, $y, $BtnSizeW, $BtnSizeH)

	$y += $yNext
		$g_hBtnTestOcrMemory = GUICtrlCreateButton("OCR Memory Test", $x, $y, $BtnSizeW, $BtnSizeH)

	$y += $yNext
		$g_hBtnTestSmartWait = GUICtrlCreateButton("Test SmartWait", $x, $y, $BtnSizeW, $BtnSizeH)

	$y += $yNext
		$g_hBtnTestBuildingLocation = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestBuildingLocation", "Find Building"), $x , $y, $BtnSizeW, $BtnSizeH)

	$y += $yNext
		$g_hBtnTestCleanYard = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestCleanYard", "Test CleanYard"), $x , $y, $BtnSizeW, $BtnSizeH)

	$y += $yNext
		$g_hBtnTestZoomout = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "TestZoomout", "Test Zoomout"), $x , $y, $BtnSizeW, $BtnSizeH)
		GUICtrlSetColor($g_hBtnTestZoomout, 0xFF0000) ; Multibot RC Debug Buttons
	$y += $yNext
		$g_hBtnTestVillageSize = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestVillageSize", "Test VillageSize"), $x, $y, $BtnSizeW, $BtnSizeH)
		GUICtrlSetColor($g_hBtnTestZoomout, 0xFF0000) ; Multibot RC Debug Buttons

	; now go up again
	$x -= $BtnSizeW + 5

		$g_hTxtTestFindButton = GUICtrlCreateInput("BoostOne", $x - ($BtnSizeW + 5), $y + 1, 85, 20)
		$g_hBtnTestFindButton = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "TestFindButton", "Test Find Button"), $x , $y, $BtnSizeW, $BtnSizeH)
	$y -= $yNext
		$g_hBtnTestRearm = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestRearm", "Test Rearm/Tomb"), $x - ($BtnSizeW + 5), $y + 1, 85, 20)
		$g_hBtnTestDeadBaseFolder = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestDeadBaseFolder", "Test DB Folder"), $x , $y, $BtnSizeW, $BtnSizeH)

	$y -= $yNext
		$g_hBtnTestArmyWindow = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestArmyWindow", "Army Overview"), $x - ($BtnSizeW + 5), $y, $BtnSizeW, $BtnSizeH)
		$g_hBtnTestAttackCSV = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestAttackCSV", "CSV Test"), $x , $y, $BtnSizeW, $BtnSizeH)
		GUICtrlSetColor($g_hBtnTestAttackCSV, 0xFF0000) ; Multibot RC Debug Buttons
	$y -= $yNext
		$g_hBtnTestConfigSave = GUICtrlCreateButton("Config Save", $x , $y, $BtnSizeW, $BtnSizeH)

	$y -= $yNext
		$g_hBtnTestConfigApply = GUICtrlCreateButton("Config Apply", $x , $y, $BtnSizeW, $BtnSizeH)

	$y -= $yNext
		$g_hBtnTestConfigRead = GUICtrlCreateButton("Config Read", $x , $y, $BtnSizeW, $BtnSizeH)

	$y -= $yNext
		$g_hBtnTestSendText = GUICtrlCreateButton("ClanGames", $x , $y, $BtnSizeW, $BtnSizeH)

	$y -= $yNext
		$g_hBtnTestWeakBase = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "TestWeakBase", "Test WeakBase"), $x , $y, $BtnSizeW, $BtnSizeH)

	$y -= $yNext
		$g_hBtnTestClickAway = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "TestClickAway", "Test ClickAway"), $x , $y, $BtnSizeW, $BtnSizeH)

	$y -= $yNext
		$g_hBtnTestAutoUpgrade = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "TestAutoUpgrade", "Test LabUpgrade"), $x , $y, $BtnSizeW, $BtnSizeH)

	$y -= $yNext
		$g_hBtnTestUpgradeWindow = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "TestUpgradeWindow", "Test UpgWindow"), $x , $y, $BtnSizeW, $BtnSizeH)

	$y -= $yNext
		$g_hBtnConsoleWindow = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ConsoleWindow", "S/H Console"), $x , $y, $BtnSizeW, $BtnSizeH)

	$y -= $yNext
		$g_hBtnTestVillagePolygon = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "TestVillagePolygon", "Test Polygon"), $x , $y, $BtnSizeW, $BtnSizeH)
		GUICtrlSetColor($g_hBtnTestVillagePolygon, 0xFF0000) ; Multibot RC Debug Buttons

	$y -= $yNext
		$g_hBtnTestVillageRedlines = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "TestVillageRedlines", "Test REDs"), $x , $y, $BtnSizeW, $BtnSizeH)
		GUICtrlSetColor($g_hBtnTestVillageRedlines, 0xFF0000) ; Multibot RC Debug Buttons

	$y -= $yNext
		$g_hBtnTestWardenMode = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "TestWardenMode", "Test Warden Mode"), $x , $y, $BtnSizeW, $BtnSizeH)

	$y -= $yNext
		$g_hBtnTestSwitchSiegeMachines = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "TestSwitchSiegeMachines", "Test Switch Siege"), $x , $y, $BtnSizeW, $BtnSizeH)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateBotDebug
