-- AtlasLoot Switcher
-- Toggles which AtlasLoot edition is enabled (English vs Chinese) and reloads the UI.
--
-- SETUP: edit the two folder names below so they match EXACTLY what your
-- two AtlasLoot addon folders are named inside Interface\AddOns.
-- (Folder name = the name that shows up in your AddOns list in-game,
-- and must match the .toc filename inside that folder.)

local ADDON_EN = "AtlasLoot"       -- folder name of the English (Otari98) version
local ADDON_CN = "AtlasLootZHCN"   -- folder name of the Chinese edition

local PREFIX = "|cff33ff99[AtlasLootSwitcher]|r "

local function Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. msg)
end

local function GetAddonIndex(name)
	local n = GetNumAddOns()
	for i = 1, n do
		local addonName = GetAddOnInfo(i)
		if addonName == name then
			return i
		end
	end
	return nil
end

-- NOTE: GetAddOnEnableState is not available on this client, so instead of
-- asking the game which edition is enabled, this addon just remembers what
-- IT last switched to, in its own SavedVariable.
AtlasLootSwitcherDB = AtlasLootSwitcherDB or {}

local function GetCurrent()
	return AtlasLootSwitcherDB.current
end

local function SwitchTo(target)
	local enIndex = GetAddonIndex(ADDON_EN)
	local cnIndex = GetAddonIndex(ADDON_CN)

	if not enIndex then
		Print("Could not find an addon folder named '" .. ADDON_EN .. "'. Open AtlasLootSwitcher.lua and fix ADDON_EN at the top.")
		return
	end
	if not cnIndex then
		Print("Could not find an addon folder named '" .. ADDON_CN .. "'. Open AtlasLootSwitcher.lua and fix ADDON_CN at the top.")
		return
	end

	local character = UnitName("player")

	if target == "en" then
		EnableAddOn(enIndex, character)
		DisableAddOn(cnIndex, character)
		Print("Switching to the English AtlasLoot. Reloading UI...")
	else
		EnableAddOn(cnIndex, character)
		DisableAddOn(enIndex, character)
		Print("Switching to the Chinese AtlasLoot. Reloading UI...")
	end

	AtlasLootSwitcherDB.current = target
	ReloadUI()
end

SLASH_ATLASLOOTSWITCH1 = "/als"
SlashCmdList["ATLASLOOTSWITCH"] = function(msg)
	msg = string.lower(msg or "")

	if msg == "en" then
		SwitchTo("en")
	elseif msg == "cn" then
		SwitchTo("cn")
	elseif msg == "status" then
		local current = GetCurrent()
		if current == "en" then
			Print(ADDON_EN .. " is the active edition (per last /als switch).")
		elseif current == "cn" then
			Print(ADDON_CN .. " is the active edition (per last /als switch).")
		else
			Print("No switch recorded yet - run /als en or /als cn once to set it.")
		end
	else
		-- no argument: toggle to whichever one wasn't last switched to
		if GetCurrent() == "en" then
			SwitchTo("cn")
		else
			SwitchTo("en")
		end
	end
end

Print("Loaded. Use /als en, /als cn, /als status, or /als to toggle.")
