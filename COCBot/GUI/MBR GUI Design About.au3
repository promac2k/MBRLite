; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "About Us" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: CodeSlinger69 (2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_ABOUT = 0
Global $g_hLblCreditsBckGrnd = 0, $g_hLblMyBotURL = 0, $g_hLblForumURL = 0
Global $g_hGUI_CommandLineHelp = 0

Global $g_hBtnVerifyToken = 0 , $g_hTxtRegistrationToken = 0, $g_hLblMember = 0

Func CreateAboutTab()
	$g_hGUI_ABOUT = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)
	; GUISetBkColor($COLOR_WHITE, $g_hGUI_ABOUT)

	Local $sText = ""
	Local $x = 18, $y = 10 + $_GUI_MAIN_TOP
	;$g_hLblCreditsBckGrnd = GUICtrlCreateLabel("", $x - 20, $y - 20, 454, 380)  ; adds fixed white background for entire tab, if using "Labels"
	;GUICtrlSetBkColor(-1, $COLOR_WHITE)
	$sText = "MultiBot Lite is a Fork from MyBot.Run - open source" & @CRLF & _
				"Taking different technical direction..."
	GUICtrlCreateLabel($sText, $x + 8, $y - 10, 400, 35, $SS_CENTER)
	GUICtrlSetFont(-1, 10, $FW_BOLD, Default, "Arial")
	GUICtrlSetColor(-1, $COLOR_NAVY)

	$y += 30
	$sText = "Please visit MultiBot web forum:"
	GUICtrlCreateLabel($sText, $x + 30, $y, 200, 30, $SS_CENTER)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
	$g_hLblMyBotURL = GUICtrlCreateLabel("https://forum.multibot.run", $x + 223, $y, 150, 20)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
	GUICtrlSetColor(-1, $COLOR_INFO)

	$y += 22
	GUICtrlCreateLabel("Credits belong to following programmers for donating their time:", $x - 5, $y, 420, 20)
	GUICtrlSetFont(-1, 10, $FW_BOLD, Default, "Arial")

	$y += 30
	$sText = "MultiBot Lite Version: "
	GUICtrlCreateLabel($sText, $x - 5, $y, 410, 20, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
	GUICtrlSetColor(-1, $COLOR_NAVY)
	$sText = "ProMac, Fahid.Mahmood, RoroTiti, IceCube and Spartan"
	GUICtrlCreateLabel($sText, $x + 5, $y + 15, 410, 50, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
	GUICtrlSetFont(-1, 9, $FW_MEDIUM, Default, "Arial")

	$y += 33
	$sText = "Special thanks to all contributing forum members helping to make this" & @CRLF & "software better!"
	GUICtrlCreateLabel($sText, $x + 14, $y, 390, 30, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $ES_CENTER), 0)
	GUICtrlSetFont(-1, 9, $FW_MEDIUM, Default, "Arial")

	$y += 40
	$sText = "The latest release of 'MultiBot' can be found at:"
	GUICtrlCreateLabel($sText, $x - 5, $y, 400, 15, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
	GUICtrlSetFont(-1, 10, $FW_BOLD, Default, "Arial")

	$y += 18
	$g_hLblForumURL = GUICtrlCreateLabel("https://multibot.run", $x + 25, $y, 450, 20)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
	GUICtrlSetColor(-1, $COLOR_INFO)

	$y += 25
	$sText = "By running this program, the user accepts all responsibility that arises from the use of this software." & @CRLF & _
			"This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even " & @CRLF & _
			"the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General " & @CRLF & _
			"Public License for more details. The license can be found in the main code folder location." & @CRLF & _
			"Copyright (C) 2015-2018 MultiBot.run"
	GUICtrlCreateLabel($sText, $x + 1, $y, 415, 56, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT, $ES_CENTER), 0)
	GUICtrlSetColor(-1, 0x000053)
	GUICtrlSetFont(-1, 6.5, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	$y += 75
	GUICtrlCreateGroup("MULTIBOT " & GetTranslatedFileIni("MBR GUI Design About", "Group_01", " - MEMBER"), $x - 5, $y + 56 + 20, 435, 50)
		$g_hTxtRegistrationToken = GUICtrlCreateInput(GetTranslatedFileIni("MBR GUI Design Bottom", "LblRegistrationToken", "Enter Reg. Token"), $x, $y + 56 + 40, 155, 20)
			GUICtrlSetFont(-1, 6.5, $FW_THIN, Default, "Arial", $CLEARTYPE_QUALITY)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "LblRegistrationToken_Info_01", "https://multibot.run/free-register | You need to be a 'Silver Member' to use Builder Base attack."))

		$g_hBtnVerifyToken = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "LblVerifyToken", "Check"), $x + 160, $y + 56 + 39 , 50, 21)
			GUICtrlSetColor(-1, $COLOR_RED)
			GUICtrlSetOnEvent(-1, "ChkVerificationToken")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnVerifyToken_Info_01", "Token Signing/Verification"))

		$g_hLblMember = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Bottom", "LblMember", "Not Verified Token") , $x + 215 , $y + 56 + 43, 210 , 20)
		GUICtrlSetColor($g_hLblMember, $COLOR_RED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAboutTab

Func ShowCommandLineHelp()

	SetDebugLog ("Help File called from CrtlID: " & @GUI_CtrlId)

	Local $PathHelp = "CommandLineParameter"

	; This can be use for several Help Files
	Switch @GUI_CtrlId
		Case $g_lblHelpBot; Bot/Android/Help Handle
			$PathHelp = "CommandLineParameter"
		Case $g_lblHepNotify
			$PathHelp = "NotifyHelp"
	EndSwitch

	UpdateBotTitle()
	$g_hGUI_CommandLineHelp = GUICreate($g_sBotTitle & " - Command Line Help", 650, 700, -1, -1, BitOR($WS_CAPTION, $WS_POPUPWINDOW, $DS_MODALFRAME))
	GUISetIcon($g_sLibIconPath, $eIcnGUI, $g_hGUI_CommandLineHelp)

	; add controls
	Local $hRichEdit = _GUICtrlRichEdit_Create($g_hGUI_CommandLineHelp, "", 2, 0, 646, 667, $WS_VSCROLL + $ES_MULTILINE)
	Local $sHelpFile = @ScriptDir & "\Help\" & $PathHelp
	If $g_sLanguage <> $g_sDefaultLanguage Then
		If FileExists($sHelpFile & "_" & $g_sLanguage & ".rtf") Then
			$sHelpFile &= "_" & $g_sLanguage
		Else
			SetDebugLog("Help file not available: " & $sHelpFile & "_" & $g_sLanguage & ".rtf")
		EndIf
	EndIf
	_GUICtrlRichEdit_StreamFromFile($hRichEdit, $sHelpFile & ".rtf")
	_GUICtrlRichEdit_SetReadOnly($hRichEdit)
	_GUICtrlRichEdit_SetScrollPos($hRichEdit, 0, 0) ; scroll to top
	Local $hClose = GUICtrlCreateButton("Close", 300, 670, 50)

	GUISetState(@SW_SHOW)

	Local $iOpt = Opt("GUIOnEventMode", 0)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $hClose
				ExitLoop
		EndSwitch
	WEnd

	GUIDelete($g_hGUI_CommandLineHelp)
	Opt("GUIOnEventMode", $iOpt)

EndFunc   ;==>ShowCommandLineHelp
