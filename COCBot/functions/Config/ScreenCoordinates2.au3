; #Variables# ====================================================================================================================
; Name ..........: Screen Position Variables
; Description ...: Global variables for commonly used X|Y positions, screen check color, and tolerance
; Syntax ........: $aXXXXX[Y]  : XXXX is name of point or item being checked, Y = 2 for position only, or 4 when color/tolerance value included
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;;;;;;;;;;;;;;;;;;;;;;;; OLD 860x732 resolution ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ERRORS PAGES
Global $aIsReloadError[4] = [457, 301 + $g_iMidOffsetY, 0x33B5E5, 10] ; Pixel Search Check point For All Reload Button errors, except break ending
Global $aBottomRightClient[4] = [850, 675 + $g_iBottomOffsetY, 0x000000, 0] ; BottomRightClient: Tolerance not needed
Global $aIsConnectLost[4] = [255, 271 + $g_iMidOffsetY, 0x33B5E5, 20] ; COC message : 'Connection Lost' network error or annother device
Global $aIsCheckOOS[4] = [223, 272 + $g_iMidOffsetY, 0x33B5E5, 20] ; COC message : 'Connection Lost' network error or annother device
Global $aIsMaintenance[4] = [350, 273 + $g_iMidOffsetY, 0x33B5E5, 20] ; COC message : 'Anyone there?'
Global $aReloadButton[4] = [443, 408 + $g_iMidOffsetY, 0x282828, 10] ; Reload Coc Button after Out of Sync, 860x780
Global $aReloadButton51[4] = [205, 390 + $g_iMidOffsetY, 0x434545, 10] ; Reload Coc Button after PBT Android 5.1 [$g_iAndroidVersionAPI = $g_iAndroidLollipop]
Global $aReloadButton71[4] = [205, 390 + $g_iMidOffsetY, 0x434545, 10] ; Reload Coc Button after PBT Android 7.1 [$g_iAndroidVersionAPI = $g_iAndroidNougat]
Global $aIsAttackShield[4] = [250, 415 + $g_iMidOffsetY, 0xE8E8E0, 10] ; Attack window, white shield verification window

; WINDOWS
Global $aMessageButton[2] = [38, 143] ; Main Screen, Message Button
Global $aIsGemWindow1[4] = [573, 256 + $g_iMidOffsetY, 0xEB1316, 20] ; Main Screen, pixel left of Red X to close gem window
Global $aIsGemWindow2[4] = [577, 266 + $g_iMidOffsetY, 0xCC2025, 20] ; Main Screen, pixel below Red X to close gem window
Global $aIsGemWindow3[4] = [586, 266 + $g_iMidOffsetY, 0xCC2025, 20] ; Main Screen, pixel below Red X to close gem window
Global $aIsGemWindow4[4] = [595, 266 + $g_iMidOffsetY, 0xCC2025, 20] ; Main Screen, pixel below Red X to close gem window

Global $g_aShopWindowOpen[4] = [804, 54, 0xC00508, 15] ; Red pixel in lower right corner of RED X to close shop window
Global $aTreasuryWindow[4] = [689, 138 + $g_iMidOffsetY, 0xFF8D95, 20] ; Redish pixel above X to close treasury window
Global $aAttackForTreasury[4] = [88, 619 + $g_iMidOffsetY, 0xF0EBE8, 5] ; Red pixel below X to close treasury window

Global $aLootCartBtn[2] = [430, 640 + $g_iBottomOffsetY] ; Main Screen Loot Cart button
Global $aCleanYard[4] = [418, 587 + $g_iBottomOffsetY, 0xE1DEBE, 20] ; Main Screen Clean Resources - Trees , Mushrooms etc
Global $aIsTrainPgChk1[4] = [813, 80 + $g_iMidOffsetY, 0xFF8D95, 10] ; Main Screen, Train page open - left upper corner of x button
Global $aIsTrainPgChk2[4] = [762, 328 + $g_iMidOffsetY, 0xF18439, 10] ; Main Screen, Train page open - Dark Orange in left arrow
Global $aRtnHomeCloud1[4] = [56, 592 + $g_iBottomOffsetY, 0x0A223F, 15] ; Cloud Screen, during search, blue pixel in left eye
Global $aRtnHomeCloud2[4] = [72, 592 + $g_iBottomOffsetY, 0x103F7E, 15] ; Cloud Screen, during search, blue pixel in right eye
Global $aDetectLang[2] = [16, 634 + $g_iBottomOffsetY] ; Detect Language, bottom left Attack button must read "Attack"


; PROFILE
Global Const $aProfileReport[4] = [619, 344, 0x4E4D79, 20] ; Dark Purple of Profile Page when no Attacks were made
Global $aCheckTopProfile[4] = [200, 166, 0x868CAC, 5]
Global $aCheckTopProfile2[4] = [220, 355, 0x4E4D79, 5]

;returnhome
Global Const $aRtnHomeCheck1[4] = [363, 548 + $g_iMidOffsetY, 0x78C11C, 20]
Global Const $aRtnHomeCheck2[4] = [497, 548 + $g_iMidOffsetY, 0x79C326, 20]

;ReplayShare
Global Const $aAttackLogPage[4] = [775, 125 + $g_iMidOffsetYNew, 0xEB1115, 40] ; RC Done ;red on X Button of Attack Log Page
Global Const $aAttackLogAttackTab[4] = [437, 114 + $g_iMidOffsetYNew, 0xF0F4F0, 30] ; White on Attack Log Tab  (Tab Name) [RC]
Global Const $aBlueShareReplayButton[4] = [500, 156 + $g_iMidOffsetY, 0x70D4E8, 30] ; Blue Share Replay Button
Global Const $aGrayShareReplayButton[4] = [500, 156 + $g_iMidOffsetY, 0xBBBBBB, 30] ; Gray Share Replay Button

;Google Play
Global $aButtonConnected[4] = [534, 380 + $g_iMidOffsetY, 0xC5EB6D, 20] ; Setting screen, Connected button
Global $aButtonDisconnected[4] = [534, 380 + $g_iMidOffsetY, 0xFE6D72, 20] ; Setting screen, Disconnected button
Global $aListAccount[4] = [635, 210 + $g_iMidOffsetY, 0xFFFFFF, 10] ; Accounts list google, White
Global $aButtonVillageLoad[4] = [515, 411 + $g_iMidOffsetY, 0x6EBD1F, 20] ; Load button, Green
Global $aTextBox[4] = [320, 190, 0xFFFFFF, 10] ; RC Done ; Text box, White
Global $aButtonVillageOkay[4] = [500, 200, 0x81CA2D, 20] ; RC Done ; Okay button, Green


;Change Language To English
Global $aButtonLanguage[4] = [210, 375 + $g_iMidOffsetY, 0xD0E978, 20]
Global $aListLanguage[4] = [110, 90 + $g_iMidOffsetY, 0xFFFFFF, 10]
Global $aEnglishLanguage[4] = [420, 140 + $g_iMidOffsetY, 0xD7D5C7, 20]
Global $aLanguageOkay[4] = [510, 420 + $g_iMidOffsetY, 0x6FBD1F, 20]

