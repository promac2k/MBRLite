; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
#include-once

; Func chkTrap()
	; If GUICtrlRead($g_hChkTrap) = $GUI_CHECKED Then
		; $g_bChkTrap = True
		; ;GUICtrlSetState($btnLocateTownHall, $GUI_SHOW)
	; Else
		; $g_bChkTrap = False
		; ;GUICtrlSetState($btnLocateTownHall, $GUI_HIDE)
	; EndIf
; EndFunc   ;==>chkTrap

; Func ChkCollect()
	; $g_bChkCollect = (GUICtrlRead($g_hChkCollect) = $GUI_CHECKED)
; EndFunc   ;==>ChkCollect

Func chkRequestCCHours()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "chkRequestCCHours")

	If GUICtrlRead($g_hChkRequestTroopsEnable) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtRequestCC, $GUI_SHOW + $GUI_ENABLE)
		For $i = $g_hLblRequestType To $g_hLblRequestCCHoursPM
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		chkRequestCountCC()
	Else
		GUICtrlSetState($g_hTxtRequestCC, $GUI_SHOW + $GUI_DISABLE)
		For $i = $g_hLblRequestType To $g_hLblRequestCCHoursPM
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf

	SetRedrawBotWindowControls($bWasRedraw, $g_hGrpRequestCC, "chkRequestCCHours")
EndFunc   ;==>chkRequestCCHours

Func chkRequestCountCC()
	If GUICtrlRead($g_hChkRequestType_Troops) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtRequestCountCCTroop, $GUI_ENABLE)
		For $i = $g_ahCmbClanCastleTroop[0] To $g_ahCmbClanCastleTroop[2]
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		CmbClanCastleTroop()
	Else
		GUICtrlSetState($g_hTxtRequestCountCCTroop, $GUI_DISABLE)
		For $i = $g_ahCmbClanCastleTroop[0] To $g_ahTxtClanCastleTroop[2]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
	If GUICtrlRead($g_hChkRequestType_Spells) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtRequestCountCCSpell, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbClanCastleSpell, $GUI_ENABLE)
		cmbClanCastleSpell()
	Else
		GUICtrlSetState($g_hTxtRequestCountCCSpell, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbClanCastleSpell, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtClanCastleSpell, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbClanCastleSpell2, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkRequestCountCC

Func CmbClanCastleTroop()
	For $i = 0 To UBound($g_ahCmbClanCastleTroop) - 1
		If _GUICtrlComboBox_GetCurSel($g_ahCmbClanCastleTroop[$i]) <= $eTroopIceGolem Then
			GUICtrlSetState($g_ahTxtClanCastleTroop[$i], $GUI_ENABLE)
		Else
			GUICtrlSetState($g_ahTxtClanCastleTroop[$i], $GUI_DISABLE)
		EndIf
	Next
EndFunc   ;==>CmbClanCastleTroop

Func cmbClanCastleSpell()
	Local $iSpellSelection = _GUICtrlComboBox_GetCurSel($g_hCmbClanCastleSpell)
	If $iSpellSelection < 5 Then
		GUICtrlSetState($g_hCmbClanCastleSpell2, BitOR($GUI_HIDE, $GUI_DISABLE))
		GUICtrlSetState($g_hTxtClanCastleSpell, BitOR($GUI_HIDE, $GUI_DISABLE))
	Else
		GUICtrlSetState($g_hCmbClanCastleSpell2, BitOR($GUI_SHOW, $GUI_ENABLE))
		GUICtrlSetState($g_hTxtClanCastleSpell, BitOR($GUI_SHOW, $GUI_ENABLE))
	EndIf
EndFunc   ;==>cmbDBWaitForCCSpell

Func chkRequestCCHoursE1()
	If GUICtrlRead($g_hChkRequestCCHoursE1) = $GUI_CHECKED And GUICtrlRead($g_ahChkRequestCCHours[0]) = $GUI_CHECKED Then
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkRequestCCHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkRequestCCHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkRequestCCHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkRequestCCHoursE1

Func chkRequestCCHoursE2()
	If GUICtrlRead($g_hChkRequestCCHoursE2) = $GUI_CHECKED And GUICtrlRead($g_ahChkRequestCCHours[12]) = $GUI_CHECKED Then
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkRequestCCHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkRequestCCHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkRequestCCHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkRequestCCHoursE2

Func chkDonateHours()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "chkDonateHours")

    If GUICtrlRead($g_hChkDonateHoursEnable) = $GUI_CHECKED Then
		For $i = $g_hLblDonateCChour To $g_hLblDonateHoursPM
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $g_hLblDonateCChour To $g_hLblDonateHoursPM
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf

	SetRedrawBotWindowControls($bWasRedraw, $g_hGrpDonateCC, "chkDonateHours")
EndFunc   ;==>chkDonateHours

Func chkDonateHoursE1()
	If GUICtrlRead($g_ahChkDonateHoursE1) = $GUI_CHECKED And GUICtrlRead($g_ahChkDonateHours[0]) = $GUI_CHECKED Then
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkDonateHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkDonateHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_ahChkDonateHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkDonateHoursE1

Func chkDonateHoursE2()
	If GUICtrlRead($g_ahChkDonateHoursE2) = $GUI_CHECKED And GUICtrlRead($g_ahChkDonateHours[12]) = $GUI_CHECKED Then
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkDonateHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkDonateHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_ahChkDonateHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkDonateHoursE2
