; #FUNCTION# ====================================================================================================================
; Name ..........: CheckWardenMode
; Description ...: Check in which Mode the Warden is from attackbar and switch if needed
; Author ........: Fahid.Mahmod (01-2019)
; Modified ......:
; Remarks .......: This file is part of MultiBot, previously known as Mybot and ClashGameBot. Copyright 2015-2018
;                  MultiBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func btnTestWardenMode()
	SetLog("Test Grand Warden Mode Started", $COLOR_DEBUG)

	Local $wasRunState = $g_bRunState
	Local $wasCheckWardenMode = $g_bCheckWardenMode
	;For Debug Purpose set run state to true temporarily
	$g_bRunState = True
	$g_bCheckWardenMode = True
	_GUICtrlTab_ClickTab($g_hTabMain, 0)
	CheckWardenMode()

	;Reset to orignal state
	$g_bRunState = $wasRunState
	$g_bCheckWardenMode = $wasCheckWardenMode

	SetLog("Test Grand Warden Mode Ended", $COLOR_DEBUG)

EndFunc   ;==>btnTestWardenMode

Func CheckWardenMode()
	If Not $g_bCheckWardenMode Or $g_iCheckWardenMode = -1 Then Return
	If Number($g_iTownHallLevel) <= 10 Then
		SetDebugLog("Townhall Lvl " & $g_iTownHallLevel & " Skipping Warden Mode Check!", $COLOR_INFO)
		Return
	EndIf
	SetLog("Checking if Warden is in the correct Mode", $COLOR_INFO)
	Local $aWardenMode = QuickMIS("N1Cx1", $g_sImgGrandWardenCurrentMode, 50, 695 + $g_iBottomOffsetYNew, 825, 720 + $g_iBottomOffsetYNew, True) ; RC Done ; $aWardenMode[0]=Name, $aWardenMode[1]=[X,Y]
	If ($aWardenMode <> 0 And IsArray($aWardenMode)) Then
		If StringInStr($aWardenMode[0], "Air") Then
			SetLog("Found Grand Warden in Air Mode!", $COLOR_INFO)
			If $g_iCheckWardenMode = 0 Then
				SetLog("Switching Wardens Mode to Ground", $COLOR_INFO)
				ClickP($aWardenMode[1], 1) ; Click Warden Switch Button
				; wait to appears the new small window
				If _Sleep(1000) Then Return
				SwitchWardenMode($g_sImgGrandWardenSwitchToGround, $aWardenMode[1])
			EndIf
		ElseIf StringInStr($aWardenMode[0], "Ground") Then
			SetLog("Found Grand Warden in Ground Mode!", $COLOR_INFO)
			If $g_iCheckWardenMode = 1 Then
				SetLog("Switching Wardens Mode to Air", $COLOR_INFO)
				ClickP($aWardenMode[1], 1) ; Click Warden Switch Button
				; wait to appears the new small window
				If _Sleep(1000) Then Return
				SwitchWardenMode($g_sImgGrandWardenSwitchToAir, $aWardenMode[1])
			EndIf
		EndIf
	EndIf
EndFunc   ;==>CheckWardenMode

Func SwitchWardenMode($sImgSwitchMode, $aSwitchCords)
	If QuickMIS("BC1", $sImgSwitchMode, $aSwitchCords[0] - 115, 575 + $g_iBottomOffsetYNew, $aSwitchCords[0] + 115, 575 + 30 + $g_iBottomOffsetYNew, True) Then ; RC Done
		Click($g_iQuickMISWOffSetX, $g_iQuickMISWOffSetY)
		If _Sleep(250) Then Return
		SetLog("Switched Grand Warden Mode successfully!", $COLOR_SUCCESS)
		Click(5, 595 + $g_iBottomOffsetY, 1, 0, "#0111") ;860x780
		If _Sleep(250) Then Return
	Else
		SetLog("Cannot find the Grand Warden Switch Mode button!", $COLOR_ERROR)
		Click(5, 595 + $g_iBottomOffsetY, 1, 0, "#0111") ;860x780
		If _Sleep(250) Then Return
	EndIf
EndFunc   ;==>SwitchWardenMode