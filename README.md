# ty-dice V2
A modern, dice rolling script for FiveM. Designed for a seamless and immersive roleplay experience, supporting both ESX and QBCore frameworks out of the box.

### ⚠️ Disclaimer

* **WIP**: This script is currently a **Work In Progress (WIP)**. Expect frequent updates and potential refinements.
* **AI Translations**: The locale files have been generated using AI. Please be aware that there might be translation inaccuracies or awkward phrasing.

---

### Features

* **Native-Style UI**: A clean, high-end right-aligned interface controlled via keyboard.
* **No Dependency Crashes**: Uses native GTA textures (`.ytd`) for performance and stability.
* **Anti-Stretch Fix**: Automatically calculates screen aspect ratio to ensure dice textures always appear perfectly square.
* **Localization Support**: Easily switch between languages via `config.lua`.

---

### Installation

1. Download the latest release and place the `ty-dice` folder into your `resources` directory.
2. Add `ensure ty-dice` to your `server.cfg`.
3. **Important**: Ensure your folder name is exactly `ty-dice` to avoid issues with the texture streaming path.

---

### Item Configuration

To make the dice usable as an item, you need to add the item to your framework's shared items list.

#### For QBCore (`qb-core/shared/items.lua`):

```lua
['dice'] = {['name'] = 'dice', ['label'] = 'Dice', ['weight'] = 0, ['type'] = 'item', ['image'] = 'dice.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['combinable'] = nil, ['description'] = 'A pair of dice to test your luck.'},

```

#### For ESX (`es_extended/config.lua` or database):

Insert the item into your `items` table:

```sql
INSERT INTO `items` (`name`, `label`, `weight`) VALUES ('dice', 'Dice', 1);

```

*Note: Ensure the `Config.DiceItem` in the script's `config.lua` matches the item name defined in your database.*

---

### Configuration

You can customize the script in `config.lua`:

* **Framework**: Set to `"qbcore"`, `"esx"`, or `"auto"` (recommended).
* **DiceItem**: The name of the item used to trigger the menu.
* **DrawDistance**: Adjust how far away players can see the dice overhead.
* **DisplayTime**: Duration in milliseconds for the dice to stay visible.

---

### How to add your own Language

1. Navigate to `locales/`.
2. Copy `en.lua` and rename it to your desired language code (e.g., `fr.lua`).
3. Translate the values inside the table.
4. Update `Config.Locale` in `config.lua` to match your new file name.
