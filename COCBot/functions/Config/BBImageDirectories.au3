; #Variables# ====================================================================================================================
; Name ..........: Image Search Directories
; Description ...: Gobal Strings holding Path to Images used for builder base image search
; Syntax ........: $g_sImgxxx = @ScriptDir & "\imgxml\BuildersBase\xxx\"
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MultiBot Lite is a Fork from MyBotRun. Copyright 2018-2019
;                  MultiBot Lite is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://multibot.run/
; Example .......: No
; ===============================================================================================================================


#Region Builder Base
Global Const $g_sBundleCollectResourcesBB = @ScriptDir & "\imgxml\BuildersBase\Bundles\Collect\CollectResources.DocBundle"

Global Const $g_sImgZoomoutBoatBB = @ScriptDir & "\imgxml\BuildersBase\ZoomOut"

Global Const $g_sImgCollectRessourcesBB = @ScriptDir & "\imgxml\BuildersBase\Collect"
Global Const $g_sImgBoatBB = @ScriptDir & "\imgxml\Boat\BoatBuilderBase_0_89.xml"
Global Const $g_sImgZoomOutDirBB = @ScriptDir & "\imgxml\village\BuilderBase\" ;Backslash '\' at the end of path is important
Global Const $g_sImgStartCTBoost = @ScriptDir & "\imgxml\BuildersBase\ClockTower\ClockTowerAvailable*.xml"
Global Const $g_sImgPathIsCTBoosted = @ScriptDir & "\imgxml\BuildersBase\ClockTowerBoosted"
Global Const $g_sImgAvailableAttacks = @ScriptDir & "\imgxml\BuildersBase\AvailableAttacks"
#EndRegion Builder Base


#Region Image Search Standard Parms
Global Const $g_aXMLToForceAreaParms[3] = [1000, "0,0,860,644", True] ; RC Done ; [0] Quantity2Match [1] Area2Search [2] ForceArea
Global Const $g_aXMLNotToForceAreaParms[3] = [1000, "0,0,860,644", False] ; RC Done ; [0] Quantity2Match [1] Area2Search [2] ForceArea
Global Const $g_aXMLToForceBuilderBaseParms[3] = [1, "0,50,860,594", True] ; RC Done ; [0] Quantity2Match [1] Area2Search [2] ForceArea
Global Const $g_aXMLNotToForceBuilderBaseParms[3] = [1, "0,50,860,594", False] ; RC Done ; [0] Quantity2Match [1] Area2Search [2] ForceArea
#EndRegion Image Search Standard Parms

#Region Auto Upgrade Builder Base

Global Const $g_sXMLAutoUpgradeShop = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\NewBuildings\Shop"
Global Const $g_sXMLAutoUpgradeClock = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\NewBuildings\Clock"
Global Const $g_sXMLAutoUpgradeInfoIcon = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\NewBuildings\InfoIcon"
Global Const $g_sXMLAutoUpgradeWhiteZeros = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\NewBuildings\WhiteZeros"
Global Const $g_sXMLAutoUpgradeNewBldgYes = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\NewBuildings\Yes"
Global Const $g_sXMLAutoUpgradeNewBldgNo = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\NewBuildings\No"

Global Const $g_sImgAutoUpgradeElixir = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\Elixir"
Global Const $g_sImgAutoUpgradeGold = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\Gold\"
Global Const $g_sImgAutoUpgradeNew = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\New\"
Global Const $g_sImgAutoUpgradeNoRes = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\NoResources\"
Global Const $g_sImgAutoUpgradeBtnElixir = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\ButtonUpg\Elixir\"
Global Const $g_sImgAutoUpgradeBtnGold = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\ButtonUpg\Gold\"
Global Const $g_sImgAutoUpgradeBtnDir = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\Upgrade\"

;;;;;;;;;;;;;;;;;;;;;NOT USED DIR;;;;;;;;;;;;;;;;;;;;;
Global Const $g_sImgAutoUpgradeWindow = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\Window\"
Global Const $g_sImgAutoUpgradeZero = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\NewBuildings\Shop\"
Global Const $g_sImgAutoUpgradeClock = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\NewBuildings\Clock\"
Global Const $g_sImgAutoUpgradeInfo = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\NewBuildings\Slot\"
Global Const $g_sImgAutoUpgradeNewBldgYes = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\NewBuildings\Yes\"
Global Const $g_sImgAutoUpgradeNewBldgNo = @ScriptDir & "\imgxml\BuildersBase\AutoUpgrade\NewBuildings\No\"
;;;;;;;;;;;;;;;;;;;;;NOT USED DIR;;;;;;;;;;;;;;;;;;;;;
#EndRegion Auto Upgrade Builder Base


#Region Troops Upgrade Builder Base
Global Const $g_sXMLTroopsUpgradeMachine = @ScriptDir & "\imgxml\BuildersBase\TroopsUpgrade\Machine"

Global Const $g_sImgTroopsUpgradeLab = @ScriptDir & "\imgxml\BuildersBase\TroopsUpgrade\Laboratory"
Global Const $g_sImgTroopsUpgradeButton = @ScriptDir & "\imgxml\BuildersBase\TroopsUpgrade\Buttons"
Global Const $g_sImgTroopsUpgradeLabWindow = @ScriptDir & "\imgxml\BuildersBase\TroopsUpgrade\Window"
Global Const $g_sImgTroopsUpgradeElixir = @ScriptDir & "\imgxml\BuildersBase\TroopsUpgrade\AvailableElixir"
Global Const $g_sImgTroopsUpgradeAvaiTroops = @ScriptDir & "\imgxml\BuildersBase\TroopsUpgrade\AvailableTroops"

;;;;;;;;;;;;;;;;;;;;;NOT USED DIR;;;;;;;;;;;;;;;;;;;;;
Global Const $g_sImgTroopsUpgradeTroops = @ScriptDir & "\imgxml\BuildersBase\TroopsUpgrade\Troops"
;;;;;;;;;;;;;;;;;;;;;NOT USED DIR;;;;;;;;;;;;;;;;;;;;;
#EndRegion Troops Upgrade Builder Base

#Region Clean Yard
Global Const $g_sBundleCleanYardBB = @ScriptDir & "\imgxml\BuildersBase\Bundles\Obstacles\ObstaclesBB.DocBundle"
Global Const $g_aBundleCleanYardBBParms[3] = [0, "0,50,860,594", False] ; RC Done ; [0] Quantity2Match [1] Area2Search [2] ForceArea
#EndRegion Clean Yard

#Region Check Army Builder Base
Global Const $g_aArmyTrainButtonBB[4] = [46, 572+ $g_iBottomOffsetYNew, 0xE5A439, 10] ; RC Done
Global Const $g_sImgPathFillArmyCampsWindow = @ScriptDir & "\imgxml\BuildersBase\FillArmyCamps\Window"
Global Const $g_aBundlePathCamps[3] = [1000, "0,301,860,40", True] ; RC Done ; [0] Quantity2Match [1] Area2Search [2] ForceArea
Global Const $g_sImgPathCamps = @ScriptDir & "\imgxml\BuildersBase\Bundles\Camps\Camps.DocBundle"
Global Const $g_sImgPathTroopsTrain = @ScriptDir & "\imgxml\BuildersBase\FillArmyCamps\TroopsTrain"
#EndRegion Check Army Builder Base

#Region Builder Base Attack
Global Const $g_sXMLOpponentVillageVisible = @ScriptDir & "\imgxml\BuildersBase\Attack\VersusBattle\OpponentVillage"
Global Const $g_aXMLOpponentVillageVisibleParms[3] = [1, "650,0,200,70", False] ; [0] Quantity2Match [1] Area2Search [2] ForceArea

Global Const $g_sBundleAttackBarBB = @ScriptDir & "\imgxml\BuildersBase\Bundles\AttackBar\BBAttackBar.DocBundle"
Global Const $g_sBundleBuilderHall = @ScriptDir & "\imgxml\BuildersBase\Bundles\BuilderHall\BuilderHall.DocBundle"
Global Const $g_sBundleDeployPointsBB = @ScriptDir & "\imgxml\BuildersBase\Bundles\DeployPoints\DeployPoints.DocBundle"

Global Const $g_aBundleDeployPointsBBParms[3] = [0, "0,0,860,644", True] ; RC Done ; [0] Quantity2Match [1] Area2Search [2] ForceArea
Global Const $g_aBundleBuilderHallParms[3] = [1, "0,0,860,644", True] ; RC Done ; [0] Quantity2Match [1] Area2Search [2] ForceArea
Global Const $g_aBundleAttackBarBBParms[3] = [0, "0,577,860,30", True] ; RC Done ; [0] Quantity2Match [1] Area2Search [2] ForceArea
Global Const $g_aBundleAttackBarSwitchBBParms[3] = [1000, "30,452,830,45", False] ; RC Done ; [0] Quantity2Match [1] Area2Search [2] ForceArea

Global Const $g_sImgOpponentBuildingsBB = @ScriptDir & "\imgxml\BuildersBase\Attack\VersusBattle\Buildings\"

Global Const $g_sImgAttackBtnBB = @ScriptDir & "\imgxml\BuildersBase\Attack\AttackBtn"
Global Const $g_sImgVersusWindow = @ScriptDir & "\imgxml\BuildersBase\Attack\VersusBattle\Window"
Global Const $g_sImgFullArmyBB = @ScriptDir & "\imgxml\BuildersBase\Attack\VersusBattle\ArmyStatus\Full"
Global Const $g_sImgHeroStatusRec = @ScriptDir & "\imgxml\BuildersBase\Attack\VersusBattle\ArmyStatus\Hero\Recovering"
Global Const $g_sImgHeroStatusUpg = @ScriptDir & "\imgxml\BuildersBase\Attack\VersusBattle\ArmyStatus\Hero\Upgrading"
Global Const $g_sImgHeroStatusMachine = @ScriptDir & "\imgxml\BuildersBase\Attack\VersusBattle\ArmyStatus\Hero\Battle Machine"
Global Const $g_sImgFindBtnBB = @ScriptDir & "\imgxml\BuildersBase\Attack\VersusBattle\FindNowbtn"
Global Const $g_sImgCloudSearch = @ScriptDir & "\imgxml\BuildersBase\Attack\VersusBattle\Clouds"

; Report Window : Victory | Draw | Defeat
Global Const $g_sImgReportWaitBB = @ScriptDir & "\imgxml\BuildersBase\Attack\VersusBattle\Report\Waiting"
Global Const $g_sImgReportFinishedBB = @ScriptDir & "\imgxml\BuildersBase\Attack\VersusBattle\Report\Replay"
Global Const $g_sImgReportResultBB = @ScriptDir & "\imgxml\BuildersBase\Attack\VersusBattle\Report\Result"
#EndRegion Builder Base Attack

#Region Builder Base Walls Upgrade
Global Const $g_sBundleWallsBB = @ScriptDir & "\imgxml\BuildersBase\Bundles\Walls\BBWall.DocBundle"
Global Const $g_aBundleWallsBBParms[3] = [0, "0,50,860,594", False] ; [0] Quantity2Match [1] Area2Search [2] ForceArea
#EndRegion Builder Base Walls Upgrade
