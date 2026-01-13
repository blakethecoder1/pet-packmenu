-- =====================================================
-- OFF-GRID MENU CONFIGURATION
-- =====================================================
-- This file contains all pack definitions and vehicle lists.
-- To add a new pack, simply add an entry to the Config.Packs table
-- and follow the existing structure.
-- =====================================================

Config = {}

-- =====================================================
-- DISCORD SETTINGS
-- =====================================================
Config.UseDiscordRoles = true -- Set to false to use ACE permissions instead
Config.DiscordBotToken = "" -- Get from Discord Developer Portal
Config.DiscordGuildId = "" -- Your Discord server ID

-- =====================================================
-- PACK DEFINITIONS
-- =====================================================
-- Each pack has:
--   - name: Display name in menu
--   - permission: ACE permission node (used if Discord disabled)
--   - discordRole: Discord role ID for this pack
--   - vehicles: List of vehicles unlocked by this pack
-- =====================================================

Config.Packs = {
    truck = {
        name = "Truck Pack",
        permission = "off-grid.truck",
        discordRole = "", -- Replace with your Discord role ID
        description = "Unlock heavy-duty trucks and haulers",
        vehicles = {
            { name = "GODz DC40 Mega Sematowsc", model = "GODzDC40MEGASEMATOWSC" },
            { name = "GODz KR23 F450 Mega", model = "GODzKR23F450MEGA" },
            { name = "Mexo Cat Eyes", model = "mexocateyes" },
            { name = "GODz RAM TRX Trax", model = "GODzRAMTRXTRAX" },
            { name = "Josh W Plati", model = "joshwplati" },
            { name = "BC AL450", model = "bcal450" },
            { name = "BC MRR", model = "bcmrr" },
            { name = "BC Sick 7", model = "bcsick7" },
            { name = "Blackjack", model = "blackjack" },
            { name = "Murder Ram", model = "MurderRam" },
            { name = "Skoop", model = "skoop" },
        }
    },
    
    offroad = {
        name = "Offroad Pack",
        permission = "off-grid.offroad",
        discordRole = "", -- Replace with your Discord role ID
        description = "Unlock extreme offroad vehicles",
        vehicles = {
            { name = "Bronco Rally", model = "broncorally" },
            { name = "Tylers Boat", model = "tylersboat" },
            { name = "Fakes Honda", model = "fakeshonda" },
            { name = "E Trene 1K", model = "ETrene1k" },
            { name = "E Touti 19", model = "etouti19" },
            { name = "Dug SRC", model = "dugsrc" },
            { name = "Dugs 1K HL", model = "Dugs1kHL" },
            { name = "Dugs 1K", model = "Dugs1K" },
            { name = "Offirds Bronco 170", model = "offirdsbronco170" },
            { name = "PB Jeep GGI", model = "pbjepggi" },
            { name = "PB Jeep God", model = "pbjepggod" },
            { name = "Drift AHB C", model = "driftahbc" },
            { name = "Mud Sportsman", model = "Mudsportsman" },
            { name = "Mobra Bus Crawler", model = "mobrabuscrawler" },
        }
    },
    
    mud = {
        name = "Mud Pack",
        permission = "off-grid.mud",
        discordRole = "", -- Replace with your Discord role ID
        description = "Heavy-duty mud runners and trail beasts",
        vehicles = {
            { name = "Sandking XL", model = "sandking" },
            { name = "Sandking SWB", model = "sandking2" },
            { name = "Rebel", model = "rebel" },
            { name = "Rebel Rusty", model = "rebel2" },
            { name = "Duneloader", model = "dloader" },
            { name = "Riata", model = "riata" },
            { name = "Kamacho", model = "kamacho" },
            { name = "Trophy Truck", model = "trophytruck" },
            { name = "Trophy Truck 2", model = "trophytruck2" },
            { name = "Desert Raid", model = "drafter" },
        }
    },
    
    donator = {
        name = "Donk Pack",
        permission = "off-grid.donk",
        discordRole = "", -- Replace with your Discord role ID
        description = "Classic donks and slabs",
        vehicles = {
            { name = "74 Nutta", model = "74nutta" },
            { name = "Red Eye", model = "redeye" },
            { name = "Owl Pontiac GTO 1965", model = "owlpontiacgto1965" },
            { name = "Floating HC", model = "floatinghc" },
            { name = "Friday 13", model = "friday13" },
            { name = "DTS 07 Slab", model = "dts07slab" },
            { name = "DDC Roll Z Slab", model = "ddcrollzslab" },
            { name = "Pnut Drop Cut", model = "pnutdropcut" },
            { name = "Dollar Bill 2", model = "dollarbill2" },
            { name = "Vanz 73", model = "vanz73" },
            { name = "73 SRT", model = "73SRT" },
            { name = "75 Grandville", model = "75grandville" },
            { name = "88 Cut 30s", model = "88cut30s" },
            { name = "DDC Jail Durc", model = "ddcjaildurc" },
            { name = "Devil Camo", model = "devilcamo" },
        }
    },
    
    leo = {
        name = "LEO Pack",
        permission = "off-grid.leo",
        discordRole = "", -- Replace with your Discord role ID
        description = "Law enforcement vehicles and tools",
        vehicles = {
            { name = "Ford F-150", model = "LTF150" },
            { name = "BMW 745", model = "nm_745" },
            { name = "Porsche 911", model = "nm_911" },
            { name = "Porsche 918", model = "nm_918" },
            { name = "Koenigsegg Agera", model = "nm_agera" },
            { name = "Mercedes AMG", model = "nm_amg" },
            { name = "Corvette C8", model = "nm_c8" },
            { name = "Camaro 69", model = "nm_cam69" },
            { name = "Corvette", model = "nm_corvette" },
            { name = "Jeep", model = "nm_jeep" },
            { name = "Toyota Supra", model = "nm_supra" },
        }
    },
    
    truck2 = {
        name = "Truck Pack 2",
        permission = "off-grid.truck2",
        discordRole = "", -- Replace with your Discord role ID
        description = "Additional truck collection",
        vehicles = {
            { name = "Big Red Cummins", model = "bcbigredcummins" },
            { name = "Razer Tree Fiddy", model = "razertreefiddy" },
            { name = "23 CW Sierra", model = "23cwsierra" },
            { name = "GODz Cencal Lift", model = "GODzCENCALLIFT" },
            { name = "KG1 SMG", model = "kg1smg" },
            { name = "Sam Scott", model = "SamScott" },
            { name = "GODz Cencal 3 Fiddy", model = "GODzCENCAL3FIDDY" },
            { name = "DCC10", model = "DCC10" },
            { name = "1 Deep Ram", model = "1deepram" },
            { name = "Jay Tahoe", model = "jaytahoe" },
            { name = "204s Welding Rig", model = "204sWeldingRig" },
        }
    },
    
    bike = {
        name = "Bike Pack",
        permission = "off-grid.bike",
        discordRole = "", -- Replace with your Discord role ID
        description = "High-performance motorcycles",
        vehicles = {
            { name = "DB NZX 6R", model = "DBnzx6r" },
            { name = "Dill 21 YFZ 450 SE", model = "dill21yfz450se" },
            { name = "Ninja 250 FI", model = "ninja250fi" },
            { name = "S1000RR Polar", model = "S1000RR_Polar" },
            { name = "DEFz Eevee H2", model = "DEFz_EeveeH2" },
            { name = "ZX10 Animated", model = "zx10animated" },
            { name = "R1", model = "R1" },
            { name = "Royal Custom Kawasaki SH2", model = "RoyalCustomKawasakiSH2" },
            { name = "GODz NINJA H2", model = "GODzNINJAH2" },
        }
    },
    
    mc = {
        name = "MC Pack",
        permission = "off-grid.mc",
        discordRole = "", -- Replace with your Discord role ID
        description = "Motorcycle club cruisers and customs",
        vehicles = {
            { name = "RD CVO", model = "rdcvo" },
            { name = "Inks Shop", model = "inksshop" },
            { name = "Low Minks", model = "lowminks" },
            { name = "Club RGT4", model = "clubrgt4" },
            { name = "Jango", model = "Jango" },
            { name = "Volva", model = "volva" },
            { name = "Vulture", model = "vulture" },
            { name = "Razor", model = "razor" },
            { name = "Blue Diamond", model = "bluediamond" },
            { name = "Dub Glide", model = "dubglide" },
            { name = "Dark Fate", model = "darkfate" },
        }
    }
}

-- =====================================================
-- UTILITY SETTINGS
-- =====================================================

Config.MenuKey = 244 -- M key (https://docs.fivem.net/docs/game-references/controls/)
Config.MenuTitle = "Off-Grid Menu"

-- Repair settings
Config.RepairCooldown = 30000 -- 30 seconds in milliseconds

-- Spawn settings
Config.SpawnInFrontOfPlayer = true
Config.SpawnDistance = 5.0 -- meters in front of player

-- =====================================================
-- HOW TO ADD A NEW PACK
-- =====================================================
-- 1. Add a new entry to Config.Packs with a unique key (e.g., "vip")
-- 2. Set the permission node (e.g., "off-grid.vip")
-- 3. Add vehicle models to the vehicles table
-- 4. The menu will automatically create entries for the new pack
-- 5. Make sure the ACE permission is set in your vMenu permissions
-- 
-- Example:
-- vip = {
--     name = "VIP Pack",
--     permission = "off-grid.vip",
--     description = "VIP exclusive content",
--     vehicles = {
--         { name = "Custom Car", model = "customcar" },
--     }
-- }
-- =====================================================
