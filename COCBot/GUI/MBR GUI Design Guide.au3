; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Dummy Guide" Layout When Farm Version And BB Only Checked
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Fahid.Mahmood (2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_DUMMY_GUIDE = 0
Global $g_hLblDummyTabGuide = 0

Func CreateDummyGuideTab()
	$g_hGUI_DUMMY_GUIDE = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblDummyTabGuide = GUICtrlCreateLabel("", 10, 10, $g_iSizeWGrpTab1 - 10, 100)
EndFunc   ;==>CreateDummyGuideTab



