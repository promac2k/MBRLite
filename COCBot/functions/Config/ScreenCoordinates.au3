; #Variables# ====================================================================================================================
; Name ..........: Screen Position Variables
; Description ...: Global variables for commonly used X|Y positions, screen check color, and tolerance
; Syntax ........: $aXXXXX[Y]  : XXXX is name of point or item being checked, Y = 2 for position only, or 4 when color/tolerance value included
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================


;;;;;;;;;;;;;;;;;;;;;;;; New resolution ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; GENERIC
;
Global Const $aAway[2] = [550, 20] ; Away click [RC]

; BUILDER BASE MAIN
Global Const $aBuildersDigitsBuilderBase[2] = [414, 21] ; Main Screen on Builders Base Free/Total Builders [RC]
Global Const $aIsOnBuilderBase[4] = [839, 18, 0xFFFF4d, 10] ; Check the Gold Coin from resources , is a square not round [RC]

;Builder Base Walls
Global $aWallUpgrade[4] = [521, 580 + $g_iMidOffsetY, 0x7B412B, 20] ; Upgrade Button main screen
Global $aWallUpgradeOK[4] = [483, 496 + $g_iMidOffsetY, 0xFFDC15, 20] ; Ok Button on main screen

; MAIN VILLAGE
;
Global Const $aCenterEnemyVillageClickDrag = [65, 468] ; Scroll village using this location in the water [RC]
Global Const $aCenterHomeVillageClickDrag = [270, 575] ; Scroll village using this location in the water [RC]

Global Const $aIsMain[4] = [278, 9, 0x77BDE0, 20] ; Main Screen, Builder Info Icon [RC]
Global Const $aIsMainGrayed[4] = [278, 9, 0x3C5F70, 15] ; Main Screen, Builder Info Icon grayed [RC]

Global Const $aTrophies[2] = [69, 84] ; Main Screen, Trophies [RC]

Global $aIsDarkElixirFull[4] = [708, 132, 0x270D33, 10] ; Main Screen DE Resource bar is full
Global $aIsGoldFull[4] = [660, 32, 0xE7C00D, 10] ; Main Screen Gold Resource bar is Full
Global $aIsElixirFull[4] = [660, 82, 0xC027C0, 10] ; Main Screen Elixir Resource bar is Full

Global $aVillageHasDarkElixir[4] = [837, 134, 0x3D2D3D, 10] ; Main Page, Base has dark elixir storage

Global $aRecievedTroops[4] = [149, 185, 0xFFFFFF, 5] ; Y of You have recieved blabla from xx!

; SHIELD
Global $aNoShield[4] = [448, 20, 0x43484B, 15] ; Main Screen, charcoal pixel center of shield when no shield is present
Global $aHaveShield[4] = [455, 19, 0xF0F8FB, 15] ; Main Screen, Silver pixel top center of shield
Global $aHavePerGuard[4] = [455, 19, 0x10100D, 15] ; Main Screen, black pixel in sword outline top center of shield
Global $aShieldInfoButton[4] = [431, 10, 0x75BDE4, 15] ; Main Screen, Blue pixel upper part of "i"
Global $aIsShieldInfo[4] = [645, 195 + $g_iMidOffsetYNew, 0xED1115, 20] ; Main Screen, Shield Info window, red pixel right of X [RC]

; PROMAC HERE! CHECKING THE REMAIN VARS TOMORROW

; ATTACK
;inattackscreen
Global Const $aIsAttackPage[4] = [56, 548 + $g_iBottomOffsetY, 0xcf0d0e, 20] ; red button "end battle" 860x780

Global $aAttackButton[2] = [60, 614 + $g_iBottomOffsetY] ; Attack Button, Main Screen
Global $aAttackButtonRND[4] = [20, 540, 100, 610] ; RC DONE ; Attack Button, Main Screen, RND  Screen 860x732
Global $aFindMatchButton[4] = [170, 475, 0xFFBF43, 10] ; RC Done ; Find Multiplayer Match Button, Attack Screen 860x644 without shield
Global $aFindMatchButton2[4] = [170, 475, 0xE75D0D, 10] ; RC Done ; Find Multiplayer Match Button, Attack Screen 860x644 with shield
Global $aFindMatchButtonRND[4] = [150, 450, 300, 500] ; RC Done ; Find Multiplayer Match Button, Both Shield or without shield Screen 860x732

Global $NextBtn[4] = [780, 546 + $g_iBottomOffsetY, 0xD34300, 20] ;  Next Button
Global $NextBtnRND[4] = [710, 460, 830, 520] ; RC Done ; Next Button

Global $aSurrenderButton[4] = [70, 545 + $g_iBottomOffsetY, 0xC00000, 40] ; Surrender Button, Attack Screen
Global $aConfirmSurrender[4] = [500, 415 + $g_iMidOffsetY, 0x60AC10, 20] ; Confirm Surrender Button, Attack Screen, green color on button?
Global $aCancelFight[4] = [822, 48, 0xD80408, 20] ; Cancel Fight Scene
Global $aCancelFight2[4] = [830, 59, 0xD80408, 20] ; Cancel Fight Scene 2nd pixel

Global $aEndFightSceneBtn[4] = [429, 519 + $g_iMidOffsetY, 0xB8E35F, 20] ; Victory or defeat scene buton = green edge
Global $aEndFightSceneAvl[4] = [241, 223 + $g_iMidOffsetYNew, 0xFFF090, 20] ; Victory or defeat scene left side ribbon = light gold
Global $aEndFightSceneReportGold[4] = [830, 25, 0x807a2d, 20] ; Report gold turns into Dark Gold in End Battle Screen
Global $aReturnHomeButton[4] = [376, 567 + $g_iMidOffsetY, 0x60AC10, 20] ; Return Home Button, End Battle Screen

Global $aAtkHasDarkElixir[4] = [31, 144, 0x282020, 10] ; Attack Page, Check for DE icon
Global $aIsAtkDarkElixirFull[4] = [743, 92, 0x270D33, 10] ; Attack Screen DE Resource bar is full
Global $aNoCloudsAttack[4] = [25, 606 + $g_iBottomOffsetYNew, 0xCD0D0D, 15] ; RC Done ; Attack Screen: No More Clouds

; ATTACK REPORT
Global Const $aAtkRprtDECheck[4] = [459, 372 + $g_iMidOffsetY, 0x433350, 20]
Global Const $aAtkRprtTrophyCheck[4] = [327, 189 + $g_iMidOffsetY, 0x3B321C, 30]
Global Const $aAtkRprtDECheck2[4] = [678, 418 + $g_iMidOffsetY, 0x030000, 30]
Global $aWonOneStar[4] = [714, 538 + $g_iBottomOffsetY, 0xC0C8C0, 20] ; Center of 1st Star for winning attack on enemy
Global $aWonTwoStar[4] = [739, 538 + $g_iBottomOffsetY, 0xC0C8C0, 20] ; Center of 2nd Star for winning attack on enemy
Global $aWonThreeStar[4] = [763, 538 + $g_iBottomOffsetY, 0xC0C8C0, 20] ; Center of 3rd Star for winning attack on enemy

; attack report... stars won
Global $aWonOneStarAtkRprt[4] = [325, 180 + $g_iMidOffsetY, 0xC8CaC4, 30] ; Center of 1st Star reached attacked village
Global $aWonTwoStarAtkRprt[4] = [398, 180 + $g_iMidOffsetY, 0xD0D6D0, 30] ; Center of 2nd Star reached attacked village
Global $aWonThreeStarAtkRprt[4] = [534, 180 + $g_iMidOffsetY, 0xC8CAC7, 30] ; Center of 3rd Star reached attacked village
; pixel color: location information								BS 850MB (Reg GFX), BS 500MB (Med GFX) : location


; HEROES
; Check healthy color RGB ( 220,255,19~27) ; the king and queen haves the same Y , but warden is a little lower ...
; King Crown ; background pixel not at green bar
Global $aKingHealth = [-1, 569 + $g_iBottomOffsetY, 0x00D500, 15] ; Attack Screen, Check King's Health, X coordinate is dynamic, not used from array   ;  -> with slot compensation 0xbfb29e
; Queen purple between crown ; background pixel not at green bar
Global $aQueenHealth = [-1, 569 + $g_iBottomOffsetY, 0x00D500, 15] ; Attack Screen, Check Queen's Health, X coordinate is dynamic, not used from array  ;  -> with slot compensation 0xe08227
; Warden hair ; background pixel not at green bar
Global $aWardenHealth = [-1, 569 + $g_iBottomOffsetY, 0x00D500, 15] ; Attack Screen, Check Warden's Health, X coordinate is dynamic, not used from array  ;  -> with slot compensation 0xe08227
;Machine Ability Pixel Is different with Machine Level ;e.g With 7 $MachineSlot[2] = (7*72)-25 = 479 And Pixel It Contains 479x633 -> E7CE93 Or AE9A88
Local $aMachineAbilityPixels[3] = [0xAE9A88, 0xE7CE93, 0xCEB385]
Local $aMachineDeadPixels[3] = [0x4E4E4E, 0x676767, 0x5B5B5B]


; DONATE
Global $aRequestTroopsAO[2] = [807, 574 + $g_iMidOffsetY] ; RC Done ; Button Request Troops in Army Overview
Global Const $aOpenChatTab[4] = [19, 335 + $g_iMidOffsetY, 0xE88D27, 20]
Global Const $aCloseChat[4] = [331, 330 + $g_iMidOffsetY, 0xF0951D, 20] ; duplicate with $aChatTab above, need to rename and fix all code to use one?
Global Const $aChatDonateBtnColors[4][4] = [[0x0d0d0d, 0, -4, 20], [0xdaf582, 10, 0, 20], [0xcdef75, 10, 5, 20], [0xFFFFFF, 23, 9, 10]]
Global $aPerkBtn[4] = [95, 243 + $g_iMidOffsetY, 0x7cd8e8, 10] ; Clan Info Page, Perk Button (blue); 800x780

Global $aChatTab[4] = [331, 325 + $g_iMidOffsetY, 0xF0951D, 20] ; Chat Window Open, Main Screen
Global $aChatTab2[4] = [331, 330 + $g_iMidOffsetY, 0xF0951D, 20] ; Chat Window Open, Main Screen
Global $aChatTab3[4] = [331, 335 + $g_iMidOffsetY, 0xF0951D, 20] ; Chat Window Open, Main Screen
Global $aOpenChat[2] = [19, 349 + $g_iMidOffsetY] ; Open Chat Windows, Main Screen
Global $aClanTab[2] = [189, 24] ; Clan Tab, Chat Window, Main Screen
Global $aClanInfo[2] = [282, 55] ; Clan Info Icon

; REQUEST
Global $aCancRequestCCBtn[4] = [340, 250, 0xdd5525, 20] ; RC Done ;  Red button Cancel in window request CC
Global $aSendRequestCCBtn[2] = [524, 250] ; Green button Send in window request CC
Global $atxtRequestCCBtn[2] = [430, 140] ; textbox in window request CC

;Switch Account
Global $aButtonSetting[4] = [820, 495, 0xFFFFFF, 10] ; RC Done ; Setting button, Main Screen
;SuperCell ID
Global $aButtonConnectedSCID[4] = [570, 514 + $g_iMidOffsetY, 0x6EB730, 20] ; Setting creen, Supercell ID Connected button
Global $aButtonLogOutSCID[4] = [700, 285 + $g_iMidOffsetY, 0x308AFB, 20] ; Supercell ID, Log Out button
Global $aButtonConfirmSCID[4] = [460, 410 + $g_iMidOffsetY, 0x328AFB, 20] ; Supercell ID, Confirm button
Global $aCloseTabSCID[4] = [765, 80] ; RC Done ; Button Close Supercell ID tab

; TRAIN
Global $aArmyTrainButton[2] = [40, 525 + $g_iBottomOffsetY] ; Main Screen, Army Train Button
Global $aArmyTrainButtonRND[4] = [20, 495, 55, 515] ; RC Done ; Main Screen, Army Train Button, RND  Screen 860x732
Global $aArmyCampSize[2] = [110, 136 + $g_iMidOffsetY] ; Training Window, Overview screen, Current Size/Total Size
Global $aSiegeMachineSize[2] = [755, 136 + $g_iMidOffsetY] ; Training Window, Overview screen, Current Number/Total Number
Global $aArmySpellSize[2] = [99, 284 + $g_iMidOffsetY] ; Training Window Overviewscreen, current number/total capacity
Global $g_aArmyCCSpellSize[2] = [473, 469 + $g_iMidOffsetYNew]  ; RC Done ; Training Window, Overview Screen, Current CC Spell number/total cc spell capacity
Global $aArmyCCRemainTime[2] = [782, 552 + $g_iMidOffsetY] ; RC Done ; Training Window Overviewscreen, Minutes & Seconds remaining till can request again
Global $aIsCampNotFull[4] = [149, 150 + $g_iMidOffsetY, 0x761714, 20] ; Training Window, Overview screen Red pixel in Exclamation mark with camp is not full
Global $aIsCampFull[4] = [128, 151 + $g_iMidOffsetY, 0xFFFFFF, 10] ; Training Window, Overview screen White pixel in check mark with camp IS full (can not test for Green, as it has trees under it!)
Global $aBarrackFull[4] = [388, 154 + $g_iMidOffsetY, 0xE84D50, 20] ; Training Window, Barracks Screen, Red pixel in Exclamation mark with Barrack is full
Global $aBuildersDigits[2] = [324, 21] ; Main Screen, Free/Total Builders
Global $aIsTabOpen[4] = [0, 145 + $g_iMidOffsetYNew, 0xEAEAE3, 25] ; RC Done ;Check if specific Tab is opened, X Coordinate is a dummy

Global $aArmyOverviewTest[4] = [150, 554 + $g_iMidOffsetY, 0xBC2BD1, 20] ; Color purple of army overview  bottom left

Global $aGreenArrowTrainTroops[2] = [310, 127 + $g_iMidOffsetYNew] ; RC Done
Global $aGreenArrowBrewSpells[2] = [467, 127 + $g_iMidOffsetYNew] ; RC Done

Global $aTrainBarb[4] = [-1, -1, -1, -1]
Global $aTrainArch[4] = [-1, -1, -1, -1]
Global $aTrainGiant[4] = [-1, -1, -1, -1]
Global $aTrainGobl[4] = [-1, -1, -1, -1]
Global $aTrainWall[4] = [-1, -1, -1, -1]
Global $aTrainBall[4] = [-1, -1, -1, -1]
Global $aTrainWiza[4] = [-1, -1, -1, -1]
Global $aTrainHeal[4] = [-1, -1, -1, -1]
Global $aTrainDrag[4] = [-1, -1, -1, -1]
Global $aTrainPekk[4] = [-1, -1, -1, -1]
Global $aTrainBabyD[4] = [-1, -1, -1, -1]
Global $aTrainMine[4] = [-1, -1, -1, -1]
Global $aTrainEDrag[4] = [-1, -1, -1, -1]
Global $aTrainMini[4] = [-1, -1, -1, -1]
Global $aTrainHogs[4] = [-1, -1, -1, -1]
Global $aTrainValk[4] = [-1, -1, -1, -1]
Global $aTrainGole[4] = [-1, -1, -1, -1]
Global $aTrainWitc[4] = [-1, -1, -1, -1]
Global $aTrainLava[4] = [-1, -1, -1, -1]
Global $aTrainBowl[4] = [-1, -1, -1, -1]
Global $aTrainIceG[4] = [-1, -1, -1, -1]
Global $aTrainLSpell[4] = [-1, -1, -1, -1]
Global $aTrainHSpell[4] = [-1, -1, -1, -1]
Global $aTrainRSpell[4] = [-1, -1, -1, -1]
Global $aTrainJSpell[4] = [-1, -1, -1, -1]
Global $aTrainFSpell[4] = [-1, -1, -1, -1]
Global $aTrainCSpell[4] = [-1, -1, -1, -1]
Global $aTrainPSpell[4] = [-1, -1, -1, -1]
Global $aTrainESpell[4] = [-1, -1, -1, -1]
Global $aTrainHaSpell[4] = [-1, -1, -1, -1]
Global $aTrainSkSpell[4] = [-1, -1, -1, -1]
Global $aTrainBaSpell[4] = [-1, -1, -1, -1]

Global $aTrainArmy[$eArmyCount] = [$aTrainBarb, $aTrainArch, $aTrainGiant, $aTrainGobl, $aTrainWall, $aTrainBall, $aTrainWiza, $aTrainHeal, $aTrainDrag, $aTrainPekk, $aTrainBabyD, $aTrainMine, $aTrainEDrag, _
		$aTrainMini, $aTrainHogs, $aTrainValk, $aTrainGole, $aTrainWitc, $aTrainLava, $aTrainBowl, $aTrainIceG, 0, 0, 0, 0, $aTrainLSpell, $aTrainHSpell, $aTrainRSpell, $aTrainJSpell, $aTrainFSpell, $aTrainCSpell, _
		$aTrainPSpell, $aTrainESpell, $aTrainHaSpell, $aTrainSkSpell, $aTrainBaSpell]

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

Global $aLootCartBtn[2] = [430, 570 + $g_iBottomOffsetY] ; Main Screen Loot Cart button
Global $aCleanYard[4] = [418, 563 + $g_iBottomOffsetY, 0xE1DEBE, 20] ; Main Screen Clean Resources - Trees , Mushrooms etc
Global $aIsTrainPgChk1[4] = [813, 80 + $g_iMidOffsetY, 0xFF8D95, 10] ; Main Screen, Train page open - left upper corner of x button
Global $aIsTrainPgChk2[4] = [762, 328 + $g_iMidOffsetY, 0xF18439, 10] ; Main Screen, Train page open - Dark Orange in left arrow
Global $aRtnHomeCloud1[4] = [56, 592 + $g_iBottomOffsetY, 0x0A223F, 25] ; Cloud Screen, during search, blue pixel in left eye
Global $aRtnHomeCloud2[4] = [72, 592 + $g_iBottomOffsetY, 0x103F7E, 20] ; Cloud Screen, during search, blue pixel in right eye
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

