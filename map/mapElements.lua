local addonInfo, privateVars = ...

---------- init namespace ---------

if not LibMap then LibMap = {} end

if not privateVars.mapData then privateVars.mapData = {} end

local data        = privateVars.data
local mapData     = privateVars.mapData
local colossusData= privateVars.colossusData

local SIZE_CITY = 20 -- all icons which should be visible mostly on the minimap while in town
local SIZE_NPC = 32

local LAYER_RESSOURCE = 5
local LAYER_CITY = 10
local LAYER_POI = 10
local LAYER_NPC = 15
local LAYER_EVENT = 40
local LAYER_RIFT = 50
local LAYER_PVP = 70
local LAYER_QUEST = 80
---------- set internal data ---------

mapData.mapElements = {
  ["UNKNOWN"]               = { addon = "LibMap", path = "gfx/mapIcons/iconUnknown.png", width = 32, height = 32, layer = 70},  
  ["WAYPOINT"]              = { addon = "LibMap", path = "gfx/mapIcons/iconWaypoint.png", width = 16, height = 16, factor = 1.5, minZoom = 0, layer = 100},

  ["CUSTOMPOI"]             = { path = "icon_menu_achievements.png.dds", width = 32, height = 32, factor = 1, minZoom = 0, layer = 98},
  
  ["UNIT.PLAYER"]           = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconPlayerPosition.png"}, width = 32, height = 32, factor = 1, minZoom = 0, layer = 99, gfxType = "canvas", angleCorr = 280},
  ["UNIT.BODY"]             = {path = "MiniMap_I2A.dds", width = 32, height = 32, minZoom = 1, layer = 97},

  ["UNIT.PLAYERPET"]        = {path = "MainMap_I345.dds", width = 24, height = 24, minZoom = 1, layer = 98},
  ["UNIT.GROUPMEMBER"]      = {path = "indicator_group.png.dds", width = 32, height = 32, minZoom = 1, layer = 98},
  ["UNIT.RARE"]             = {path = "target_portrait_LootPinata.png.dds", width = 32, height = 32, factor = 0.7, minZoom = 1, layer = 98},
  ["UNIT.TARGET.FRIENDLY"]  = {path = "MiniMap_I343.dds", width = 32, height = 32, minZoom = 1, layer = 98},
  ["UNIT.TARGET.HOSTILE"]   = {path = "MiniMap_I316.dds", width = 32, height = 32, minZoom = 1, layer = 98},
  ["UNIT.TARGET.NEUTRAL"]   = {path = "MiniMap_I348.dds", width = 32, height = 32, minZoom = 1, layer = 98},
  
  ["UNIT.ENEMY"]            = {path = "target_portrait_roguepoint.png.dds", width = 32, height = 32, layer = 98},
  ["UNIT.MARK.1"]           = {path = "vfx_ui_mob_tag_01_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.2"]           = {path = "vfx_ui_mob_tag_02_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.3"]           = {path = "vfx_ui_mob_tag_03_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.4"]           = {path = "vfx_ui_mob_tag_04_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.5"]           = {path = "vfx_ui_mob_tag_05_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.6"]           = {path = "vfx_ui_mob_tag_06_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.7"]           = {path = "vfx_ui_mob_tag_07_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.8"]           = {path = "vfx_ui_mob_tag_08_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.9"]           = {path = "vfx_ui_mob_tag_tank_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.10"]          = {path = "vfx_ui_mob_tag_heal_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.11"]          = {path = "vfx_ui_mob_tag_damage_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.12"]          = {path = "vfx_ui_mob_tag_support_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.13"]          = {path = "vfx_ui_mob_tag_arrow_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.14"]          = {path = "vfx_ui_mob_tag_skull_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.15"]          = {path = "vfx_ui_mob_tag_no_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.16"]          = {path = "vfx_ui_mob_tag_smile_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.17"]          = {path = "vfx_ui_mob_tag_squirrel_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.18"]          = {path = "vfx_ui_mob_tag_crown_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.19"]          = {path = "vfx_ui_mob_tag_heal_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.20"]          = {path = "vfx_ui_mob_tag_heal_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.21"]          = {path = "vfx_ui_mob_tag_heal_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.22"]          = {path = "vfx_ui_mob_tag_heart_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.23"]          = {path = "vfx_ui_mob_tag_heart_leftside_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.24"]          = {path = "vfx_ui_mob_tag_heart_rightside_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.25"]          = {path = "vfx_ui_mob_tag_radioactive_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.26"]          = {path = "vfx_ui_mob_tag_sad_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.27"]          = {path = "vfx_ui_mob_tag_tank_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.28"]          = {path = "vfx_ui_mob_tag_tank_mini.png.dds", width = 16, height = 16, layer = 98},
  ["UNIT.MARK.29"]          = {path = "vfx_ui_mob_tag_tank_mini.png.dds", width = 16, height = 16, layer = 98},  
  ["UNIT.MARK.30"]          = {path = "vfx_ui_mob_tag_clover_mini.png.dds", width = 16, height = 16, layer = 98},
  
  ["POI.CAVE"]      = { addon = "LibMap", path = "gfx/mapIcons/iconCave.png", width = 32, height = 32, layer = LAYER_POI, minZoom = 1},
  ["POI.PORTAL"]    = { addon = "LibMap", path = "gfx/mapIcons/iconPortal.png", width = 48, height = 48, layer = LAYER_POI, minZoom = 1},
  ["POI.QUESTHUB"]  = { addon = "LibMap", path = "gfx/mapIcons/iconQuestHub.png", width = 48, height = 48, layer = LAYER_POI, minZoom = 1},
  ["POI.OTHER"]     = { addon = "LibMap", path = "gfx/mapIcons/iconPOIOther.png", width = 32, height = 32, layer = LAYER_POI, minZoom = 1},
  ["POI.DUNGEON"]   = { addon = "LibMap", path = "gfx/mapIcons/iconChronicles.png", width = 32, height = 32, layer = LAYER_POI, minZoom = 1},

  ["POI.PORTALWORLD"] = {path = "map_travel_ep1.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_POI},
  
  ["VENDOR.OTHER"]              = { addon = "LibMap", path = "gfx/mapIcons/iconVendor.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["VENDOR.MOUNTS"]             = { addon = "LibMap", path = "gfx/mapIcons/iconVendor.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["VENDOR.DIMENSIONS"]         = { addon = "LibMap", path = "gfx/mapIcons/iconVendor.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["VENDOR.PLANES"]             = { addon = "LibMap", path = "gfx/mapIcons/iconVendor.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["VENDOR.MINIONS"]            = { addon = "LibMap", path = "gfx/mapIcons/iconVendor.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["VENDOR.HUNT"]               = { addon = "LibMap", path = "gfx/mapIcons/iconVendor.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["VENDOR.PROFESSION"]         = { addon = "LibMap", path = "gfx/mapIcons/iconVendor.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["VENDOR.DYES"]               = { addon = "LibMap", path = "gfx/mapIcons/iconVendor.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},

  ["QUARTERMASTER.PLANES"]      = { addon = "LibMap", path = "gfx/mapIcons/iconQuartermaster.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["QUARTERMASTER.CONSUMABLE"]  = { addon = "LibMap", path = "gfx/mapIcons/iconQuartermaster.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["QUARTERMASTER.PVP"]         = { addon = "LibMap", path = "gfx/mapIcons/iconQuartermaster.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  
  ["VARIA.LETTERBOX"]           = { addon = "LibMap", path = "gfx/mapIcons/iconMailbox.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY + 1},

  ["VARIA.HEALER"] = { path = "NPCDialogIcon_soulmender.png.dds", width = 32, height = 32, layer = LAYER_CITY + 1},
  ["VARIA.GUILDBANK"] = { path = "indicator_banker.png.dds", width = 32, height = 32, layer = LAYER_CITY + 1},
  ["VARIA.GUILDQUESTGIVER"] = { path = "indicator_quest_new.png.dds", width = 32, height = 32, layer = LAYER_CITY + 1},
  
  ["VARIA.BANK"]          = { width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY, addon = "LibMap", path = "gfx/mapIcons/iconBank.png"},
  ["VARIA.AUCTIONHOUSE"]  = { width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY, addon = "LibMap", path = "gfx/mapIcons/iconAuctionHouse.png"},
  ["VARIA.STYLIST"]       = { width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY, addon = "LibMap", path = "gfx/mapIcons/iconBarber.png"},
  ["VARIA.MARRIAGE"]      = { width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY, path = "NPCDialogIcon_wedding"},
  ["VARIA.PLANEVOUCHERS"]   = { path = "indicator_merchant.png.dds", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_NPC },

  ["VARIA.NPC"]             = { path = "MainMap_I337.dds", width = SIZE_NPC, height = SIZE_NPC, layer = LAYER_NPC },
  ["VARIA.NPC.HOSTILE"]     = { path = "MiniMap_I315.dds", width = SIZE_NPC, height = SIZE_NPC, layer = LAYER_NPC },
  ["VARIA.NPC.FRIENDLY"]    = { path = "MiniMap_I342.dds", width = SIZE_NPC, height = SIZE_NPC, layer = LAYER_NPC },
  ["VARIA.NPC.NEUTRAL"]     = { path = "MiniMap_I347.dds", width = SIZE_NPC, height = SIZE_NPC, layer = LAYER_NPC },
  
  ["VARIA.NPC.PVP"]         = { path = "NPCDialogIcon_warfrontmaster.png.dds", width = SIZE_NPC, height = SIZE_NPC, layer = LAYER_NPC },
  ["VARIA.NPC.REP"]         = { path = "NPCDialog_delivery_quest.png.dds", width = SIZE_NPC, height = SIZE_NPC, layer = LAYER_NPC },
  
  ["TEACHER.ROGUE"]       = { addon = "LibMap", path = "gfx/mapIcons/iconTrainer.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["TEACHER.CLERIC"]      = { addon = "LibMap", path = "gfx/mapIcons/iconTrainer.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["TEACHER.WARRIOR"]     = { addon = "LibMap", path = "gfx/mapIcons/iconTrainer.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["TEACHER.MAGE"]        = { addon = "LibMap", path = "gfx/mapIcons/iconTrainer.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["TEACHER.PRIMALIST"]   = { addon = "LibMap", path = "gfx/mapIcons/iconTrainer.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},

  ["QUEST.RETURN"] = { addon = "LibMap", path = "gfx/mapIcons/iconQuestReturn10.png", width = 32, height = 32, minZoom = 1, layer = LAYER_QUEST},

  --[[
  ["QUEST.RETURN"] = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconQuestReturn1.png"}, width = 48, height = 48, layer = LAYER_QUEST + 1, anim = "animation", animZoom = 0.8,
                      textureList = { "gfx/mapIcons/iconQuestReturn1.png",
                                      "gfx/mapIcons/iconQuestReturn2.png",
                                      "gfx/mapIcons/iconQuestReturn3.png",
                                      "gfx/mapIcons/iconQuestReturn4.png",
                                      "gfx/mapIcons/iconQuestReturn5.png",
                                      "gfx/mapIcons/iconQuestReturn6.png",
                                      "gfx/mapIcons/iconQuestReturn7.png",
                                      "gfx/mapIcons/iconQuestReturn8.png",
                                      "gfx/mapIcons/iconQuestReturn9.png",
                                      "gfx/mapIcons/iconQuestReturn10.png"
                      },  minZoom = 2},

]]
  ["QUEST.START"]         = { addon = "LibMap", path = "gfx/mapIcons/iconQuestStart.png", width = 32, height = 32, minZoom = 1, layer = LAYER_QUEST},
  ["QUEST.DAILY"]         = { addon = "LibMap", path = "gfx/mapIcons/iconQuestRepeatable.png", width = 32, height = 32, minZoom = 1, layer = LAYER_QUEST},
  ["QUEST.MISSING"]       = { addon = "LibMap", path = "gfx/mapIcons/iconQuestUnavailable.png", width = 32, height = 32, minZoom = 1, layer = LAYER_QUEST -1},
  
  ["QUEST.CARNAGEPOINT"]  = { addon = "LibMap", path = "gfx/mapIcons/iconCarnage.png", width = 32, height = 32, minZoom = 1, layer = LAYER_QUEST},
  ["QUEST.POINT"]         = { addon = "LibMap", path = "gfx/mapIcons/iconQuestLocation1.png", width = 48, height = 48, minZoom = 1, layer = LAYER_QUEST},
  ["QUEST.PROGRESS"]      = { addon = "LibMap", path = "gfx/mapIcons/iconQuestLocation1.png", width = 48, height = 48, minZoom = 1, layer = LAYER_QUEST},

  ["QUEST.PVPDAILY"]      = { path = "NPCDialogIcon_questrepeat_pvpD.png.dds", width = 32, height = 32, minZoom = 1, layer = 97, layer = LAYER_QUEST},
  ["QUEST.ZONEEVENT"]     = { fill = {source = "Rift", type = "texture", texture = "indicator_track_zonequest.png.dds"}, width = 32, height = 32, minZoom = 1, anim = "rotation", layer = LAYER_QUEST},
  
  ["QUEST.AREA"]          = { gfxType = "canvas", stroke = {r = 0.9, g = 0.6, b = 0.2, a = 1, thickness = 2}, fill = { type = "solid", r = 1, g = 0.7, b = 0.3, a = 0.2}, layer = 2},
  ["QUEST.CARNAGE"]       = { gfxType = "canvas", stroke = {r = 0.8, g = 0.2, b = 0.2, a = 1, thickness = 2}, fill = { type = "solid", r = 1, g = 0.4, b = 0.4, a = 0.2}, layer = 2},
  
  ["PORTAL"]              = {path = "Map_Travel.png.dds", width = 32, height = 32, layer = LAYER_POI },
  
  ["RIFT.POST.FIRE"]     = { addon = "LibMap", path = "gfx/mapIcons/iconFootholdFire.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.POST.AIR"]      = { addon = "LibMap", path = "gfx/mapIcons/iconFootholdAir.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.POST.DEATH"]    = { addon = "LibMap", path = "gfx/mapIcons/iconFootholdDeath.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.POST.LIFE"]     = { addon = "LibMap", path = "gfx/mapIcons/iconFootholdLife.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.POST.WATER"]    = { addon = "LibMap", path = "gfx/mapIcons/iconFootholdWater.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.POST.EARTH"]    = { addon = "LibMap", path = "gfx/mapIcons/iconFootholdEarth.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.POST.NEUTRAL"]  = { addon = "LibMap", path = "gfx/mapIcons/iconFootholdNeutral.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.POST.GUARDIAN"] = { addon = "LibMap", path = "gfx/mapIcons/iconFootholdGuardian.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.POST.DEFIANT"]  = { addon = "LibMap", path = "gfx/mapIcons/iconFootholdDefiant.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT},

  ["RIFT.INVASION.AIR"]       = { addon = "LibMap", path = "gfx/mapIcons/iconInvasionAir.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT + 1},
  ["RIFT.INVASION.DEATH"]     = { addon = "LibMap", path = "gfx/mapIcons/iconInvasionDeath.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT + 1},
  ["RIFT.INVASION.LIFE"]      = { addon = "LibMap", path = "gfx/mapIcons/iconInvasionLife.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT + 1},
  ["RIFT.INVASION.WATER"]     = { addon = "LibMap", path = "gfx/mapIcons/iconInvasionWater.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT + 1},
  ["RIFT.INVASION.EARTH"]     = { addon = "LibMap", path = "gfx/mapIcons/iconInvasionEarth.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT + 1},
  ["RIFT.INVASION.FIRE"]      = { addon = "LibMap", path = "gfx/mapIcons/iconInvasionFire.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT + 1},
  ["RIFT.INVASION.GUARDIAN"]  = { addon = "LibMap", path = "gfx/mapIcons/iconInvasionGuardian.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT + 1},
  ["RIFT.INVASION.DEFIANT"]   = { addon = "LibMap", path = "gfx/mapIcons/iconInvasionDefiant.png", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT + 1},
  
  ["RIFT.INVASION.NEUTRAL"] = {path = "indicator_invasion_neutral.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT},
    
  ["RIFT.COLOSSUS.AIR"] = {path = "indicator_collossus_air.png.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.COLOSSUS.DEATH"] = {path = "indicator_collossus_death.png.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.COLOSSUS.LIFE"] = {path = "indicator_collossus_life.png.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.COLOSSUS.WATER"] = {path = "indicator_collossus_water.png.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.COLOSSUS.EARTH"] = {path = "indicator_collossus_earth.png.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.COLOSSUS.FIRE"] = {path = "indicator_collossus_earth.png.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT},
  
  ["RIFT.CRAFTING"]				  = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftCraft.png"}, width = 36, height = 36, minZoom = 2, anim = "rotation", layer = LAYER_RIFT},
  
  ["RIFT.MINOR.ACTIVE.FIRE"]    = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftFire.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MINOR.ACTIVE.WATER"]   = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftWater.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MINOR.ACTIVE.LIFE"]    = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftLife.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MINOR.ACTIVE.AIR"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftAir.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MINOR.ACTIVE.EARTH"]   = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftDeath.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MINOR.ACTIVE.DEATH"]   = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftEarth.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},

  ["RIFT.MINOR.UNSTABLE.FIRE"]      = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftFire.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.MINOR.UNSTABLE.WATER"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftWater.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.MINOR.UNSTABLE.LIFE"]      = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftLife.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.MINOR.UNSTABLE.AIR"]       = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftAir.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.MINOR.UNSTABLE.EARTH"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftEarth.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.MINOR.UNSTABLE.DEATH"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftDeath.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  
  ["RIFT.MINOR.UNSTABLE.NIGHTMARE"] = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftNightmare.png"}, width = 34, height = 34, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.MINOR.ACTIVE.NIGHTMARE"]   = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftNightmare.png"}, width = 34, height = 34, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},

  ["RIFT.MAJOR.ACTIVE.FIRE"]    = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftMajorFire.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MAJOR.ACTIVE.WATER"]   = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftMajortWater.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MAJOR.ACTIVE.LIFE"]    = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftMajorLife.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MAJOR.ACTIVE.AIR"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftMajorAir.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MAJOR.ACTIVE.EARTH"]   = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftMajorDeath.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MAJOR.ACTIVE.DEATH"]   = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftMajorEarth.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},

  ["RIFT.MAJOR.UNSTABLE.FIRE"]    = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftMajorFire.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MAJOR.UNSTABLE.WATER"]   = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftMajortWater.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MAJOR.UNSTABLE.LIFE"]    = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftMajorLife.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MAJOR.UNSTABLE.AIR"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftMajorAir.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MAJOR.UNSTABLE.EARTH"]   = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftMajorDeath.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MAJOR.UNSTABLE.DEATH"]   = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftMajorEarth.png"}, width = 64, height = 64, anim = "rotation", minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MAJOR.ACTIVE.NIGHTMARE"]   = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftMajorNightmare.png"}, width = 34, height = 34, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.MAJOR.UNSTABLE.NIGHTMARE"] = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftMajorNightmare.png"}, width = 34, height = 34, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  
  ["RIFT.EXPERT.ACTIVE.FIRE"]      = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftExpertFire.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.EXPERT.ACTIVE.WATER"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftExpertWater.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.EXPERT.ACTIVE.LIFE"]      = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftExpertLife.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.EXPERT.ACTIVE.AIR"]       = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftExpertAir.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.EXPERT.ACTIVE.EARTH"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftExpertEarth.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.EXPERT.ACTIVE.DEATH"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftExpertDeath.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.EXPERT.ACTIVE.NIGHTMARE"] = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftExpertNightmare.png"}, width = 34, height = 34, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  
  ["RIFT.EXPERT.UNSTABLE.FIRE"]      = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftExpertFire.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.EXPERT.UNSTABLE.WATER"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftExpertWater.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.EXPERT.UNSTABLE.LIFE"]      = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftExpertLife.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.EXPERT.UNSTABLE.AIR"]       = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftExpertAir.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.EXPERT.UNSTABLE.EARTH"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftExpertEarth.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.EXPERT.UNSTABLE.DEATH"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftExpertDeath.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.EXPERT.UNSTABLE.NIGHTMARE"] = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftExpertNightmare.png"}, width = 34, height = 34, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  
  ["RIFT.RAID.ACTIVE.FIRE"]      = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftRaidFire.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.RAID.ACTIVE.WATER"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftRaidWater.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.RAID.ACTIVE.LIFE"]      = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftRaidLife.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.RAID.ACTIVE.AIR"]       = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftRaidAir.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.RAID.ACTIVE.EARTH"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftRaidEarth.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.RAID.ACTIVE.DEATH"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftRaidDeath.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.RAID.ACTIVE.NIGHTMARE"] = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftRaidNightmare.png"}, width = 34, height = 34, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  
  ["RIFT.RAID.UNSTABLE.FIRE"]      = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftRaidire.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.RAID.UNSTABLE.WATER"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftRaidWater.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.RAID.UNSTABLE.LIFE"]      = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftRaidLife.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.RAID.UNSTABLE.AIR"]       = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftRaidAir.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.RAID.UNSTABLE.EARTH"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftRaidEarth.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.RAID.UNSTABLE.DEATH"]     = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftRaidDeath.png"}, width = 36, height = 36, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},
  ["RIFT.RAID.UNSTABLE.NIGHTMARE"] = {fill = {type = "texture", source = "LibMap", texture = "gfx/mapIcons/iconRiftRaidNightmare.png"}, width = 34, height = 34, minZoom = 1, anim = "rotation", layer = LAYER_RIFT},

  ["RIFT.MINOR.UNOPENED"] = { addon = "LibMap", path = "gfx/mapIcons/iconRiftMinorUnopened.png", width = 64, height = 64, factor = 0.5, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.MAJOR.UNOPENED"] = { addon = "LibMap", path = "gfx/mapIcons/iconRiftMajorUnopened.png", width = 64, height = 64, factor = 0.5, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.RAID.UNOPENED"]  = { addon = "LibMap", path = "gfx/mapIcons/iconRiftRaidUnopened.png", width = 64, height = 64, factor = 0.5, minZoom = 1, layer = LAYER_RIFT},
  
  ["RIFT.STRONGHOLD.FIRE"] = {path = "indicator_stronghold_fire.png.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.STRONGHOLD.EARTH"] = {path = "indicator_stronghold_earth.png.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.STRONGHOLD.AIR"] = {path = "indicator_stronghold_air.png.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.STRONGHOLD.LIFE"] = {path = "indicator_stronghold_life.png.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.STRONGHOLD.DEATH"] = {path = "indicator_stronghold_death.png.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.STRONGHOLD.WATER"] = {path = "indicator_stronghold_water.png.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.STRONGHOLD.EMPYREAL"] = {path = "indicator_stronghold_empyreal_alliance.png.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT},
    
  ["RIFT.FOOTHOLD.ARCHITECT"] = {path = "indicator_foothold_architect.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT},
  ["RIFT.FOOTHOLD.ACHYATI"] = {path = "indicator_foothold_ogre.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT},
  
  ["RIFT.PLANE.ANCHOR"] = {addon = "LibMap", path = "gfx/map/icon_planeanchor.png", width = 35, height = 36, minZoom = 1, layer = LAYER_RIFT},
    
  ["RIFT.EVENT.WARDSTONE.PROTECT"] = {path = "ze_defend.png.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT + 5},
  ["RIFT.EVENT.WARDSTONE.DESTROYED"] = {path = "MainMap_I133.dds", width = 64, height = 64, minZoom = 1, layer = LAYER_RIFT + 5},
  ["RIFT.EVENT.POINT.NEUTRAL"] = {path = "indicator_invasion_neutral.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RIFT + 5},
  
  ["RESOURCE.ORE.COPPER"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.THALASIT"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.RHENIUM"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.KARTHITE"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.CARMINTIUM"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.TITANIUM"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.ATRAMENTIUM"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.TIN"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.CHROMITE"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.COBALT"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.IRON"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.SILVER"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.GOLD"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.ORICHALCUM"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.GANTIMITE"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE},
  ["RESOURCE.ORE.PLATINUM"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.ORE.BOLIDIUM"] = {path = "indicator_gathering_ore.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
      
  ["RESOURCE.WOOD.SAGEBRUSH"] = {path = "indicator_gathering_wood.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.WOOD.RUNEBIRCH"] = {path = "indicator_gathering_wood.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.WOOD.MADROSA"] = {path = "indicator_gathering_wood.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.WOOD.YEWLOG"] = {path = "indicator_gathering_wood.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.WOOD.SHADETHORN"] = {path = "indicator_gathering_wood.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.WOOD.KINGSWOOD"] = {path = "indicator_gathering_wood.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.WOOD.ASHWOOD"] = {path = "indicator_gathering_wood.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.WOOD.MAHOGANY"] = {path = "indicator_gathering_wood.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.WOOD.OAK"] = {path = "indicator_gathering_wood.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.WOOD.BIRCH"] = {path = "indicator_gathering_wood.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.WOOD.ELM"] = {path = "indicator_gathering_wood.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.WOOD.LINDEN"] = {path = "indicator_gathering_wood.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
        
  ["RESOURCE.PLANTS.BASILISKWEED"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.BLOODSHADE"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.DRAKEFOOT"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.TEMPESTFLOWER"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.LUCIDFLOWER"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.SARLEAF"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.GRIEVEBLOSSOM"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.TATTERTWIST"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.CREEPER"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.COASTALGLORY"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.GOLDENNETTLE"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.KRAKENWEED"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.WYVERNSPURR"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.ROCORCHID"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.TWILIGHT"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.FRAZZLE"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.CHIMERASCLOAK"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.DUSKGLORY"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE}, 
  ["RESOURCE.PLANTS.RAZORBRUSH"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE},
  ["RESOURCE.PLANTS.FAECAPMUSHROOMS"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE},
  ["RESOURCE.PLANTS.XARTHIANTENDRIL"] = {path = "indicator_gathering_plants.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE},
  
  ["RESOURCE.ARTIFACT"] = {addon = "LibMap", path = "gfx/map/iconArtifact.png", width = 36, height = 36, minZoom = 10, layer = LAYER_RESSOURCE},

  ["RESOURCE.FISH"]     = {addon = "LibMap", path = "gfx/mapIcons/iconFishingGround.png", width = 24, height = 24, layer = LAYER_RESSOURCE},
  ["RESOURCE.BOAT"] = {path = "Fish_icon.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_RESSOURCE},

  ["PROFESSION.TEACHER.SURVIVAL"]     = {addon = "LibMap", path = "gfx/mapIcons/iconCrafting.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.TEACHER.ARMORSMITH"]   = {addon = "LibMap", path = "gfx/mapIcons/iconCrafting.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.TEACHER.WEAPONSMITH"]  = {addon = "LibMap", path = "gfx/mapIcons/iconCrafting.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.TEACHER.BUTCHERING"]   = {addon = "LibMap", path = "gfx/mapIcons/iconCrafting.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.TEACHER.RUNECRAFTER"]  = {addon = "LibMap", path = "gfx/mapIcons/iconCrafting.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.TEACHER.FISHING"]      = {addon = "LibMap", path = "gfx/mapIcons/iconCrafting.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.TEACHER.OUTFITTER"]    = {addon = "LibMap", path = "gfx/mapIcons/iconCrafting.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.TEACHER.MINING"]       = {addon = "LibMap", path = "gfx/mapIcons/iconCrafting.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.TEACHER.APOTHECARY"]   = {addon = "LibMap", path = "gfx/mapIcons/iconCrafting.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.TEACHER.FORAGING"]     = {addon = "LibMap", path = "gfx/mapIcons/iconCrafting.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.TEACHER.ARTIFICER"]    = {addon = "LibMap", path = "gfx/mapIcons/iconCrafting.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.TEACHER.DREAMWEAVER"]  = {addon = "LibMap", path = "gfx/mapIcons/iconCrafting.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},

  ["PROFESSION.RECIPESELLER.GENERIC"]     = {addon = "LibMap", path = "gfx/mapIcons/iconCraftingRecipe.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.RECIPESELLER.DREAMWEAVER"] = {addon = "LibMap", path = "gfx/mapIcons/iconCraftingRecipe.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.RECIPESELLER.RUNECRAFTER"] = {addon = "LibMap", path = "gfx/mapIcons/iconCraftingRecipe.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.RECIPESELLER.OTHER"]       = {addon = "LibMap", path = "gfx/mapIcons/iconCraftingRecipe.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.RECIPESELLER.ARMORSMITH"]  = {addon = "LibMap", path = "gfx/mapIcons/iconCraftingRecipe.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.RECIPESELLER.WEAPONSMITH"] = {addon = "LibMap", path = "gfx/mapIcons/iconCraftingRecipe.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.RECIPESELLER.GENERIC"]     = {addon = "LibMap", path = "gfx/mapIcons/iconCraftingRecipe.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.RECIPESELLER.ARTIFICER"]   = {addon = "LibMap", path = "gfx/mapIcons/iconCraftingRecipe.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.RECIPESELLER.APOTHECARY"]  = {addon = "LibMap", path = "gfx/mapIcons/iconCraftingRecipe.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.RECIPESELLER.OUTFITTER"]   = {addon = "LibMap", path = "gfx/mapIcons/iconCraftingRecipe.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  ["PROFESSION.RECIPESELLER.FISHING"]     = {addon = "LibMap", path = "gfx/mapIcons/iconCraftingRecipe.png", width = SIZE_CITY, height = SIZE_CITY, layer = LAYER_CITY},
  
  ["PVP.CONQUEST.EXTRACTOR.NEUTRAL"]  = {path = "MainMap_ICA.dds", width = 64, height = 64, minZoom = 2, layer = LAYER_PVP},
  ["PVP.CONQUEST.EXTRACTOR.FIGHT"]  = {path = "MainMap_IDA.dds", width = 64, height = 64, minZoom = 2, layer = LAYER_PVP},
  ["PVP.CONQUEST.EXTRACTOR.DOMINION"]  = {path = "MainMap_I8D.dds", width = 64, height = 64, minZoom = 2, layer = LAYER_PVP},
  ["PVP.CONQUEST.EXTRACTOR.OATH"]  = {path = "MainMap_IA6.dds", width = 64, height = 64, minZoom = 2, layer = LAYER_PVP},
  ["PVP.CONQUEST.EXTRACTOR.NIGHTFALL"]  = {path = "MainMap_IB3.dds", width = 64, height = 64, minZoom = 2, layer = LAYER_PVP},
  ["PVP.CONQUEST.STEPPES.EXTRACTOR.ANTAPO"]  = {path = "MainMap_ICA.dds", width = 64, height = 64, layer = LAYER_PVP},
  ["PVP.CONQUEST.STEPPES.EXTRACTOR.BREVO"]  = {path = "MainMap_ICA.dds", width = 64, height = 64, layer = LAYER_PVP},
  ["PVP.CONQUEST.STEPPES.DREAMGENERATOR"]  = {path = "indicator_foothold_neutral.png.dds", width = 64, height = 64, layer = LAYER_PVP},
  ["PVP.CONQUEST.STEPPES.PICKUP.ANTAPO"]  = {path = "MainMap_I200.dds", width = 32, height = 32, layer = LAYER_PVP},
  ["PVP.CONQUEST.STEPPES.PICKUP.BREVO"]  = {path = "MainMap_I200.dds", width = 32, height = 32, layer = LAYER_PVP},
  ["PVP.CONQUEST.CARRIER.SOURCESTONE"]  = {path = "MainMap_I200.dds", width = 32, height = 32, minZoom = 2, layer = LAYER_PVP},
  ["PVP.CONQUEST.CARRIER.DOMINION"]  = {path = "MainMap_I225.dds", width = 32, height = 32, minZoom = 2, layer = LAYER_PVP},
  ["PVP.CONQUEST.CARRIER.OATH"]  = {path = "MainMap_I233.dds", width = 32, height = 32, minZoom = 2, layer = LAYER_PVP},
  ["PVP.CONQUEST.CARRIER.NIGHTFALL"]  = {path = "MainMap_I22D.dds", width = 32, height = 32, minZoom = 2, layer = LAYER_PVP},
    
  ["PVP.CONQUEST.FIGHT"]  = {path = "indicator_perimeter.png.dds", width = 128, height = 128, layer = LAYER_PVP},
  ["PVP.CONQUEST.BASE.OATHSWORN"]  = {path = "Icon_Oathsworn_sm.png.dds", width = 64, height = 64, layer = LAYER_PVP},
  ["PVP.CONQUEST.BASE.DOMINION"]  = {path = "Icon_Dominion_sm.png.dds", width = 64, height = 64, layer = LAYER_PVP},
  ["PVP.CONQUEST.BASE.NIGHTFALL"]  = {path = "Icon_Nightfall_sm.png.dds", width = 64, height = 64, layer = LAYER_PVP},
  
  ["PVP.INVASION.NEUTRAL"]  = { path = "indicator_invasion_neutral.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_PVP},
  
  ["PVP.CONTROLPOINT.GUARDIANS"]  = {path = "ControlPoint_Diamond_Blue.png.dds", width = 32, height = 32, minZoom = 2, layer = LAYER_PVP},
  ["PVP.CONTROLPOINT.DEFIANTS"]  = {path = "ControlPoint_Diamond_Red.png.dds", width = 32, height = 32, minZoom = 2, layer = LAYER_PVP},
  ["PVP.RELICT"]  = {path = "ControlPoint_Diamond_Blue.png.dds", width = 32, height = 32, minZoom = 2, layer = LAYER_PVP},
  
  ["EVENT.CARNIVAL"] = {path = "MainMap_IED.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_EVENT},
  ["EVENT.SUMMER"] = {path = "Fish_icon.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_EVENT},
  ["EVENT.AUTUMN"] = {path = "Mushrooms_icon.png.dds", width = 32, height = 32, minZoom = 1, layer = LAYER_EVENT},
  ["EVENT.FAEYULETREE"] = {path = "MainMap_I118.dds", width = 32, height = 32, layer = LAYER_EVENT},

  
}