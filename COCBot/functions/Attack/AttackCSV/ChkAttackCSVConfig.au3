; #FUNCTION# ====================================================================================================================
; Name ..........: ChkAttackCSVConfig
; Description ...:
; Syntax ........: ChkAttackCSVConfig()
; Parameters ....:
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================
Func ChkAttackCSVConfig()
	;check if exists attackscript Files
	If Not (FileExists($g_sCSVAttacksPath & "\" & $g_sAttackScrScriptName[$DB] & ".csv")) Then
		SetLog("Dead base scripted attack file do not exists (renamed, deleted?)", $COLOR_ERROR)
		SetLog("Please select a new scripted algorithm from 'scripted attack' tab", $COLOR_ERROR)
		PopulateComboScriptsFilesDB()
		btnStop()
	EndIf
	If Not (FileExists($g_sCSVAttacksPath & "\" & $g_sAttackScrScriptName[$LB] & ".csv")) Then
		SetLog("Dead base scripted attack file do not exists (renamed, deleted?)", $COLOR_ERROR)
		SetLog("Please select a new scripted algorithm from 'scripted attack' tab", $COLOR_ERROR)
		PopulateComboScriptsFilesAB()
		btnStop()
	EndIf

EndFunc   ;==>ChkAttackCSVConfig
