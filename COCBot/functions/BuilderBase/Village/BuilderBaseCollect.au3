; #FUNCTION# ====================================================================================================================
; Name ..........: Collect
; Description ...:
; Syntax ........: CollectBuilderBase()
; Parameters ....:
; Return values .: None
; Author ........: Fliegerfaust (05-2017)
; Modified ......:
; Remarks .......: This file is part of MultiBot, previously known as Mybot and ClashGameBot. Copyright 2015-2018
;                  MultiBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func CollectBuilderBase()

	If Not $g_bChkCollectBuilderBase Then Return
	If Not $g_bRunState Then Return

	FuncEnter(CollectBuilderBase)

	If Not BuilderBaseZoomOut() Then Return
	SetLog("Collecting Resources on Builders Base", $COLOR_INFO)
	If _Sleep($DELAYCOLLECT2) Then Return

	; Collect function to Parallel Search , will run all pictures inside the directory
	; Setup arrays, including default return values for $return
	Local $sFilename = ""
	Local $aCollectXY, $t

	Local $aResult = multiMatches($g_sImgCollectRessourcesBB, 0, "FV", "FV")

	If UBound($aResult) > 1 Then ; we have an array with data of images found
		For $i = 1 To UBound($aResult) - 1 ; loop through array rows
			$sFilename = $aResult[$i][1] ; Filename
			$aCollectXY = $aResult[$i][5] ; Coords
			If IsArray($aCollectXY) Then ; found array of locations
				$t = Random(0, UBound($aCollectXY) - 1, 1) ; SC May 2017 update only need to pick one of each to collect all
				If $g_bDebugSetlog Then SetDebugLog($sFilename & " found, random pick(" & $aCollectXY[$t][0] & "," & $aCollectXY[$t][1] & ")", $COLOR_SUCCESS)
				If IsMainPageBuilderBase() Then Click($aCollectXY[$t][0], $aCollectXY[$t][1], 1, 0, "#0430")
				If _Sleep($DELAYCOLLECT2) Then Return
			EndIf
		Next
	EndIf
	FuncReturn()
	If _Sleep($DELAYCOLLECT3) Then Return
EndFunc   ;==>CollectBuilderBase
