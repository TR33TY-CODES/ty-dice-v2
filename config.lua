Config = {}

-----------------------------------------------------
-- FRAMEWORK
-----------------------------------------------------
-- Supported: "qbcore", "esx", "auto"
-- auto = tries to detect the framework automatically
Config.Framework = "auto"


-----------------------------------------------------
-- LANGUAGE SETTINGS
-----------------------------------------------------
-- Active language / locale
Config.Locale = "en"

-- Supported languages:
-- en = English
-- de = German
-- fr = French
-- es = Spanish
-- pl = Polish
-- tr = Turkish
-- ru = Russian


-----------------------------------------------------
-- ITEM SETTINGS
-----------------------------------------------------
-- Item name used in inventory (database / shared items)
Config.DiceItem = "dice"


-----------------------------------------------------
-- 3D TEXT DISPLAY (DICE RESULT)
-----------------------------------------------------
-- Maximum distance to see the dice result above the player
Config.DrawDistance = 15.0

-- Time the dice result stays visible (in milliseconds)
Config.DisplayTime = 6000

-- Base size of the 3D text / sprite
Config.BaseSpriteSize = 0.018


-----------------------------------------------------
-- ANIMATION SETTINGS
-----------------------------------------------------
-- Animation dictionary and animation name
Config.AnimDict = "anim@mp_player_intcelebrationmale@wank"
Config.AnimName = "wank"

-- Duration of the animation (in milliseconds)
Config.AnimDuration = 1800