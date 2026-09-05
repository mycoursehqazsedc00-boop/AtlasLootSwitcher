# AtlasLoot Switcher

A tiny WoW 1.12 (Vanilla / Turtle WoW) addon that lets you swap between an **English** and a **Chinese** edition of AtlasLoot without editing files by hand — one slash command flips which one is enabled and reloads the UI for you.

It doesn't modify either AtlasLoot addon. It only toggles which one is *enabled*, so only one is ever loaded at a time — which avoids the two versions fighting over the same global functions and frame names.

## Why this exists

AtlasLoot forks (like an English edition and a translated zhCN edition) are usually built from the same codebase, so they share identical global function/frame names internally. If both are enabled at the same time, the second one to load overwrites hooks the first one set up, which causes errors like:

```
Core\AtlasLoot.lua:425: 'for' limit must be a number
attempt to index local `AL` (a nil value)
```

and the loot browser ends up empty with no buttons working. This addon prevents that by making sure only one edition is ever active.

## Requirements

- Two separate AtlasLoot installations, each in their own folder under `Interface\AddOns`, for example:
  - `Interface\AddOns\AtlasLoot` (English)
  - `Interface\AddOns\AtlasLootZHCN` (Chinese)
- Both folder names must be exact — a folder's `.toc` filename must match its folder name for WoW to load it.

## Installation

1. Download this repo (or the release zip) and place the `AtlasLootSwitcher` folder directly inside `Interface\AddOns`, so the path looks like:
   ```
   Interface\AddOns\AtlasLootSwitcher\AtlasLootSwitcher.toc
   Interface\AddOns\AtlasLootSwitcher\AtlasLootSwitcher.lua
   ```
2. Open `AtlasLootSwitcher.lua` in a text editor and check the two lines near the top match your actual AtlasLoot folder names:
   ```lua
   local ADDON_EN = "AtlasLoot"       -- folder name of your English version
   local ADDON_CN = "AtlasLootZHCN"   -- folder name of your Chinese version
   ```
   If your folders are named differently, change these two values to match exactly.
3. In the character-select screen, click **AddOns** and confirm `AtlasLootSwitcher` is checked. **Also make sure only one of the two AtlasLoot editions is checked here — turn off `AtlasLootZHCN` (or whichever one you don't want to start with) before logging in.** Having both checked at once is what causes the bug described below.
4. Log in. You should see a load message in chat confirming it's active.
5. If you forget step 3 and end up with both enabled, don't worry — just run `/als en` or `/als cn` in-game and it'll disable the other one and reload for you.

## Commands

| Command | What it does |
|---|---|
| `/als en` | Enables the English AtlasLoot, disables the Chinese one, reloads UI |
| `/als cn` | Enables the Chinese AtlasLoot, disables the English one, reloads UI |
| `/als` | Toggles to whichever edition isn't currently active, reloads UI |
| `/als status` | Prints whether each edition is currently enabled for your character, without reloading |

## Troubleshooting

**Loot browser is empty / buttons don't work / chat shows `attempt to index local 'AL' (a nil value)`**
This means both editions ended up enabled at once — usually from forgetting to uncheck one at the character-select AddOns screen. Run `/als status` to confirm, then run `/als en` or `/als cn` to force only one on and reload. You don't need to go back to the character-select screen — the slash command fixes it from in-game.

**"Could not find an addon folder named 'X'"**
The folder name in `ADDON_EN` / `ADDON_CN` at the top of `AtlasLootSwitcher.lua` doesn't match your actual `Interface\AddOns` folder name. Fix it and reload.

**Switching seems to do nothing**
Confirm both AtlasLoot folders actually exist under `Interface\AddOns` and that their `.toc` file name matches their folder name exactly.

## How it works

The addon uses the client's own `EnableAddOn` / `DisableAddOn` / `GetAddOnEnableState` API (the same calls behind the Blizzard AddOns list) scoped to your current character, so the setting persists per-character across sessions. It never edits, copies, or touches either AtlasLoot addon's files.

## License

MIT — do whatever you like with it.
