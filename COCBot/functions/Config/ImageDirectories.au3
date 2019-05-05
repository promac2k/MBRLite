; #Variables# ====================================================================================================================
; Name ..........: Image Search Directories
; Description ...: Gobal Strings holding Path to Images used for Image Search
; Syntax ........: $g_sImgxxx = @ScriptDir & "\imgxml\xxx\"
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================

Global $g_sImgImgLocButtons = @ScriptDir & "\imgxml\imglocbuttons"
Global $g_sImgImgLocOkay = @ScriptDir & "\imgxml\imglocbuttons\Okay\"

#Region Obstacles
Global Const $g_sImgAnyoneThere = @ScriptDir & "\imgxml\other\AnyoneThere[[Android]]*"
Global Const $g_sImgPersonalBreak = @ScriptDir & "\imgxml\other\break*"
Global Const $g_sImgAnotherDevice = @ScriptDir & "\imgxml\other\Device[[Android]]*"
Global Const $g_sImgCocStopped = @ScriptDir & "\imgxml\other\CocStopped*"
Global Const $g_sImgCocReconnecting = @ScriptDir & "\imgxml\other\CocReconnecting*"
Global Const $g_sImgAppRateNever = @ScriptDir & "\imgxml\other\RateNever[[Android]]*"
Global Const $g_sImgGfxError = @ScriptDir & "\imgxml\other\GfxError*"
Global Const $g_sImgError = @ScriptDir & "\imgxml\other\Error[[Android]]*"
Global Const $g_sImgOutOfSync = @ScriptDir & "\imgxml\other\Oos[[Android]]*"
Global Const $g_sImgNotice = @ScriptDir & "\imgxml\other\Notice*"
#EndRegion Obstacles

#Region Main Village
Global $g_sImgCollectRessources = @ScriptDir & "\imgxml\Resources\Collect"
Global Const $g_sImgCollectLootCart = @ScriptDir & "\imgxml\Resources\LootCart\imgloc\LootCart_0_85.xml"
Global Const $g_sImgCollectNewLootCart = @ScriptDir & "\imgxml\Resources\LootCart\new"
Global $g_sImgBoat = @ScriptDir & "\imgxml\Boat\BoatNormalVillage_0_89.xml"
Global $g_sImgZoomOutDir = @ScriptDir & "\imgxml\village\NormalVillage\" ;Backslash '\' at the end of path is important
Global $g_sImgCheckWallDir = @ScriptDir & "\imgxml\Walls"
Global $g_sImgClearTombs = @ScriptDir & "\imgxml\Resources\Tombs"
Global $g_sImgCleanYard = @ScriptDir & "\imgxml\Resources\Obstacles"
Global $g_sImgCleanYardSnow = @ScriptDir & "\imgxml\Obstacles_Snow"
Global $g_sImgGemBox = @ScriptDir & "\imgxml\Resources\GemBox"
Global $g_sImgCollectReward = @ScriptDir & "\imgxml\Resources\ClaimReward"
Global $g_sImgTrader = @ScriptDir & "\imgxml\FreeMagicItems\TraderIcon"
Global $g_sImgDailyDiscountWindow = @ScriptDir & "\imgxml\FreeMagicItems\DailyDiscount"
Global $g_sImgBuyDealWindow = @ScriptDir & "\imgxml\FreeMagicItems\BuyDeal"
Global $g_sImgResearch = @ScriptDir & "\imgxml\Lab\Research"
Global $g_sImgResearchLab = @ScriptDir & "\imgxml\Lab\Window"
#EndRegion Main Village

#Region DonateCC
Global $g_sImgDonateTroops = @ScriptDir & "\imgxml\DonateCC\Troops\"
Global $g_sImgDonateSpells = @ScriptDir & "\imgxml\DonateCC\Spells\"
Global $g_sImgDonateSiege = @ScriptDir & "\imgxml\DonateCC\SiegeMachines\"
Global $g_sImgChatDivider = @ScriptDir & "\imgxml\DonateCC\donateccwbl\chatdivider_0_98.xml"
Global $g_sImgChatDividerHidden = @ScriptDir & "\imgxml\DonateCC\donateccwbl\chatdividerhidden_0_98.xml"
Global $g_sImgChatIUnterstand = @ScriptDir & "\imgxml\DonateCC\donateccwbl\chatiunderstand_0_95.xml"
Global $g_sImgDonateCloseWindow = @ScriptDir & "\imgxml\DonateCC\DonateWindowClose\"
#EndRegion DonateCC

#Region Auto Upgrade Normal Village
Global $g_sImgAUpgradeObst = @ScriptDir & "\imgxml\Resources\Auto Upgrade\Obstacles"
Global $g_sImgAUpgradeZero = @ScriptDir & "\imgxml\Resources\Auto Upgrade\Zero"
Global $g_sImgAUpgradeUpgradeBtn = @ScriptDir & "\imgxml\Resources\Auto Upgrade\UpgradeButton"
Global $g_sImgAUpgradeRes = @ScriptDir & "\imgxml\Resources\Auto Upgrade\Resources"
#EndRegion Auto Upgrade Normal Village

#Region Train
Global $g_sImgTrainTroops = @ScriptDir & "\imgxml\Train\Train_Train\"
Global $g_sImgTrainSpells = @ScriptDir & "\imgxml\Train\Spell_Train\"
Global $g_sImgArmyOverviewSpells = @ScriptDir & "\imgxml\ArmyOverview\Spells" ; @ScriptDir & "\imgxml\ArmySpells"
Global $g_sImgArmyRequestCC = @ScriptDir & "\imgxml\ArmyOverview\Request"
#EndRegion Train

#Region Attack
Global Const $g_sImgAttackBarDir = @ScriptDir & "\imgxml\AttackBar\Imgloc"
Global Const $g_sImgNewAttackBarDir = @ScriptDir & "\imgxml\AttackBar\New\Attackbar.DocBundle"
Global $g_sImgSwitchSiegeMachine = @ScriptDir & "\imgxml\SwitchSiegeMachines\Siege"
Global $g_sImgSwitchSiegeCastle = @ScriptDir & "\imgxml\SwitchSiegeMachines\Castle"
Global $g_sImgSwitchSiegeWallWrecker = @ScriptDir & "\imgxml\SwitchSiegeMachines\WallWrecker"
Global $g_sImgSwitchSiegeBattleBlimp = @ScriptDir & "\imgxml\SwitchSiegeMachines\BattleBlimp"
Global $g_sImgSwitchSiegeStoneSlammer = @ScriptDir & "\imgxml\SwitchSiegeMachines\StoneSlammer"
#EndRegion Attack

#Region Search
Global $g_sImgElixirStorage = @ScriptDir & "\imgxml\deadbase\elix\storage\"
Global $g_sImgElixirCollectorFill = @ScriptDir & "\imgxml\deadbase\elix\fill\"
Global $g_sImgElixirCollectorLvl = @ScriptDir & "\imgxml\deadbase\elix\lvl\"
Global $g_sImgWeakBaseBuildingsDir = @ScriptDir & "\imgxml\Buildings"
Global $g_sImgWeakBaseBuildingsEagleDir = @ScriptDir & "\imgxml\Buildings\Eagle"
Global $g_sImgWeakBaseBuildingsInfernoDir = @ScriptDir & "\imgxml\Buildings\Infernos"
Global $g_sImgWeakBaseBuildingsXbowDir = @ScriptDir & "\imgxml\Buildings\Xbow"
Global $g_sImgWeakBaseBuildingsWizTowerSnowDir = @ScriptDir & "\imgxml\Buildings\WTower_Snow"
Global $g_sImgWeakBaseBuildingsWizTowerDir = @ScriptDir & "\imgxml\Buildings\WTower"
Global $g_sImgWeakBaseBuildingsMortarsDir = @ScriptDir & "\imgxml\Buildings\Mortars"
Global $g_sImgWeakBaseBuildingsAirDefenseDir = @ScriptDir & "\imgxml\Buildings\ADefense"
Global $g_sImgSearchDrill = @ScriptDir & "\imgxml\Storages\Drills"
Global $g_sImgSearchDrillLevel = @ScriptDir & "\imgxml\Storages\Drills\Level"
Global $g_sImgEasyBuildings = @ScriptDir & "\imgxml\easybuildings"
#EndRegion Search

#Region SwitchAcc
Global Const $g_sImgGoogleSelectAccount = @ScriptDir & "\imgxml\other\GoogleSelectAccount*"
Global Const $g_sImgGoogleSelectEmail = @ScriptDir & "\imgxml\other\GoogleSelectEmail*"
Global Const $g_sImgLoginWithSupercellID = @ScriptDir & "\imgxml\SuperCellID\LogIn"
Global Const $g_sImgSCIDWindow = @ScriptDir & "\imgxml\SuperCellID\Window"
Global Const $g_sImgSCID = @ScriptDir & "\imgxml\SuperCellID\Accounts"
#EndRegion SwitchAcc

#Region Grand Warden Mode
Global $g_sImgGrandWardenCurrentMode = @ScriptDir & "\imgxml\SwitchGrandWarden\WardenCurrentMode"
Global $g_sImgGrandWardenSwitchToAir = @ScriptDir & "\imgxml\SwitchGrandWarden\SwitchToAir"
Global $g_sImgGrandWardenSwitchToGround = @ScriptDir & "\imgxml\SwitchGrandWarden\SwitchToGround"
#EndRegion Grand Warden Mode

#Region ClanGames
Global Const $g_sImgCaravan = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Caravan"
Global Const $g_sImgStart = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Start"
Global Const $g_sImgPurge = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Purge"
Global Const $g_sImgCoolPurge = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Gem"
Global Const $g_sImgTrashPurge = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Trash"
Global Const $g_sImgOkayPurge = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Okay"
Global Const $g_sImgReward = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\Reward"
Global Const $g_sImageBuilerGames = @ScriptDir & "\imgxml\Resources\ClanGamesImages\MainLoop\BuilderGames"
#EndRegion ClanGames
