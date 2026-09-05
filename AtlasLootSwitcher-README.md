# AtlasLoot Switcher

> ⚠️ **Before you log in the first time:** at the character-select screen, click **AddOns** and make sure only **one** of your two AtlasLoot editions is checked — disable **AtlasLootZHCN** (or whichever one you don't want to start with) if both are checked. Having both enabled at once causes a real bug (they share internal function/frame names and will collide, leaving the loot browser empty with nothing clickable). If you forget and end up with both enabled, don't worry — just run **`/als en`** or **`/als cn`** in-game and it'll disable the other one and reload for you. No need to go back to character select.

A tiny WoW 1.12 (Vanilla / Turtle WoW) addon that lets you swap between an **English** and a **Chinese** edition of AtlasLoot without editing files by hand — one slash command flips which one is enabled and reloads the UI for you.

It doesn't modify either AtlasLoot addon. It only toggles which one is *enabled*, so only one is ever loaded at a time — which avoids the two versions fighting over the same global functions and frame names.

You'll need both of these installed alongside this addon:
- **English edition:** [Otari98/AtlasLoot](https://github.com/Otari98/AtlasLoot)
- **Chinese edition:** [AtlasLootZHCN](https://github.com/mycoursehqazsedc00-boop/AtlasLootZHCN)

## Why this exists

AtlasLoot forks (an English edition and a translated zhCN edition) are built from the same codebase, so they share identical global function/frame names internally. If both are enabled at the same time, the second one to load overwrites hooks the first one set up, which causes errors like:

```
Core\AtlasLoot.lua:425: 'for' limit must be a number
attempt to index local `AL` (a nil value)
```

and the loot browser ends up empty with no buttons working. This addon exists to make sure only one edition is ever active, and to make switching between them a one-line command instead of a manual folder-checkbox dance.

## Requirements

- [Otari98/AtlasLoot](https://github.com/Otari98/AtlasLoot), in its own folder named `AtlasLoot` under `Interface\AddOns`.
- [AtlasLootZHCN](https://github.com/mycoursehqazsedc00-boop/AtlasLootZHCN), in its own folder named `AtlasLootZHCN` under `Interface\AddOns`.
- Both folder names must be exact — a folder's `.toc` filename must match its folder name for WoW to load it.

## Installation

1. Download this repo and place the `AtlasLootSwitcher` folder directly inside `Interface\AddOns`, so the path looks like:
   ```
   Interface\AddOns\AtlasLootSwitcher\AtlasLootSwitcher.toc
   Interface\AddOns\AtlasLootSwitcher\AtlasLootSwitcher.lua
   ```
2. Open `AtlasLootSwitcher.lua` in a text editor and check the two lines near the top match your actual AtlasLoot folder names:
   ```lua
   local ADDON_EN = "AtlasLoot"       -- folder name of your English version
   local ADDON_CN = "AtlasLootZHCN"   -- folder name of your Chinese edition
   ```
   If your folders are named differently, change these two values to match exactly.
3. In the character-select screen, click **AddOns** and confirm `AtlasLootSwitcher` is checked, **and that only one of the two AtlasLoot editions is checked** (see the warning at the top of this README).
4. Log in. You should see a load message in chat confirming it's active.

## Commands

| Command | What it does |
|---|---|
| `/als en` | Enables the English AtlasLoot, disables the Chinese one, reloads UI |
| `/als cn` | Enables the Chinese AtlasLoot, disables the English one, reloads UI |
| `/als` | Toggles to whichever edition isn't currently active, reloads UI |
| `/als status` | Prints which edition is currently active (per the last `/als` switch), without reloading |

## Troubleshooting

**Loot browser is empty / buttons don't work / chat shows `attempt to index local 'AL' (a nil value)`**
This means both editions ended up enabled at once — usually from forgetting to uncheck one at the character-select AddOns screen. Run `/als en` or `/als cn` to force only one on and reload.

**"Could not find an addon folder named 'X'"**
The folder name in `ADDON_EN` / `ADDON_CN` at the top of `AtlasLootSwitcher.lua` doesn't match your actual `Interface\AddOns` folder name. Fix it and reload.

**Switching seems to do nothing**
Confirm both AtlasLoot folders actually exist under `Interface\AddOns` and that their `.toc` file name matches their folder name exactly.

## How it works

The addon uses the client's own `EnableAddOn` / `DisableAddOn` API (the same calls behind the Blizzard AddOns list) scoped to your current character, so the setting persists per-character across sessions. It never edits, copies, or touches either AtlasLoot addon's files.

Note: `GetAddOnEnableState` isn't available on Turtle WoW's client, so the switcher tracks which edition it last switched to in its own SavedVariable instead of querying the game for it — `/als status` reflects that tracked state, not a live game query.

## License

MIT — do whatever you like with it.
