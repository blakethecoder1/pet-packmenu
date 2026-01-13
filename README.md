# Off-Grid Menu System

A custom vehicle pack menu system for FiveM roleplay servers with Discord role-based permissions.

## Features

- ✅ Discord role-based access control using badger_discord_api
- ✅ Dynamic menu that only shows owned packs
- ✅ Server-side validation to prevent cheating
- ✅ Easy to expand with new packs
- ✅ Modern dark UI with red accents
- ✅ Custom OFF-GRID ROLEPLAY branding
- ✅ Multiple vehicle pack support (Truck, Offroad, Mud, Donk, LEO, Bike, MC, etc.)

## Installation

### 1. Install badger_discord_api

This menu requires badger_discord_api for Discord role checking.

1. Download from: https://github.com/JaredScar/Badger_Discord_API
2. Place in your resources folder
3. Add your Discord bot token to badger_discord_api's `discordtoken.txt`

### 2. Install Off-Grid Menu

1. Copy the `pet-Packmenu` folder to your server's resources directory
2. Keep the name as `pet-Packmenu` or update your server.cfg

### 3. Update server.cfg

Add these lines to your `server.cfg` (badger_discord_api MUST load first):

```cfg
# Discord API (required - must load first)
ensure badger_discord_api

# Off-Grid Menu
ensure pet-Packmenu
```

### 4. Configure Discord Bot

1. Go to Discord Developer Portal: https://discord.com/developers/applications
2. Create a new application (or use existing)
3. Go to **Bot** section
4. Copy the bot token and add it to badger_discord_api's `discordtoken.txt`
5. Enable **Privileged Gateway Intents**:
   - ✅ SERVER MEMBERS INTENT (REQUIRED!)
   - ✅ MESSAGE CONTENT INTENT (recommended)
6. Go to **OAuth2 → URL Generator**
7. Select scopes: `bot`, `applications.commands`
8. Select bot permissions: `Administrator` or `Manage Roles`
9. Copy the generated URL and use it to invite the bot to your Discord server

### 5. Configure Discord Roles

In `config.lua`, set your Discord role IDs:

```lua
Config.UseDiscordRoles = true
Config.DiscordBotToken = "YOUR_BOT_TOKEN" -- Just for reference
Config.DiscordGuildId = "YOUR_SERVER_ID"

-- Example pack configuration
truck = {
    name = "Truck Pack",
    permission = "off-grid.truck",
    discordRole = "1460524526344470684", -- Your actual Discord role ID
    description = "Unlock heavy-duty trucks and haulers",
    vehicles = { ... }
}
```

**To get Discord role IDs:**
1. Enable Developer Mode in Discord (Settings → Advanced → Developer Mode)
2. Go to Server Settings → Roles
3. Right-click a role → Copy ID
4. Paste the ID into config.lua

### 6. Alternative: ACE Permissions

If you don't want to use Discord roles, you can switch to ACE permissions:

In `config.lua`:
```lua
Config.UseDiscordRoles = false
```

Then in `server.cfg`:
```cfg
# Admin gets all packs
add_ace group.admin off-grid.truck allow
add_ace group.admin off-grid.offroad allow
add_ace group.admin off-grid.mud allow

# Give specific player a pack
add_ace identifier.steam:110000XXXXXXXX off-grid.truck allow
```

## Usage

### Opening the Menu

- Type `/openmenu` in chat, OR
- Press **M** key (if no other script is blocking it)
- If M key doesn't work, use F8 console: `bind keyboard "m" "/openmenu"`

### Menu Structure

```
OFF-GRID ROLEPLAY
 ├─ Your owned packs (Based on Discord roles or ACE permissions)
 │   ├─ Truck Pack
 │   ├─ Offroad Pack
 │   ├─ Mud Pack
 │   ├─ Donk Pack
 │   ├─ LEO Pack
 │   ├─ Truck Pack 2
 │   ├─ Bike Pack
 │   └─ MC Pack
 └─ < Back
```

### Navigation

- **Arrow Up/Down** - Navigate menu items
- **Enter** - Select item
- **BiscordRole = "YOUR_DISCORD_ROLE_ID", -- Get from Discord Server Settings → Roles
    description = "VIP exclusive vehicles",
    vehicles = {
        { name = "Custom Supercar", model = "adder" },
        { name = "Luxury SUV", model = "baller" },
        -- Add more vehicles here
    }
}
```

### 2. Create Discord Role (if using Discord roles)

1. Create a new role in your Discord server
2. Copy the role ID (right-click role → Copy ID)
3. Paste it into the `discordRole` field above
4. Assign the role to players in Discord

### 3. Or use ACE Permission (if using ACE)

In your `server.cfg`:

```cfg
add_ace group.vip "off-grid.vip" allow
}
```

### 2. Add vMenu Permission

In your `permissions.cfg`:

```cfg
add_ace group.vip "off-grid.vip" allow
```

### 3. Assign to Players

```cfg
# Add player to VIP group
add_principal identifier.steam:110000XXXXXXXX group.vip
```

The menu will automatically display the new pack!

## CSwitch Between Discord and ACE Permissions

Edit `config.lua`:

```lua
Config.UseDiscordRoles = true  -- Use Discord roles
-- OR
Config.UseDiscordRoles = false -- Use ACE permissions
```

### Change Menu Key

Edit `config.lua`:

```lua
Config.MenuKey = 244 -- M key (default)
-- Note: M key detection runs every frame to override conflicts
-- Other keys: 182 = L, 166 = F5, etc.
-- See: https://docs.fivem.net/docs/game-references/controls/
```

### Configure Discord Settings

```lua
Config.DiscordBotToken = "YOUR_BOT_TOKEN" -- From Discord Developer Portal
Config.DiscordGuildId = "YOUR_SERVER_ID"  -- Your Discord server ID
```

## Current Vehicle Packs

### Truck Pack
- GODz DC40 Mega, KR23 F450 Mega, RAM TRX Trax
- BC AL450, Murder Ram, Skoop, and more

### Truck Pack 2  
- BC Big Red Cummins, Razer Tree Fiddy
- Mud Treg, Blazer Mud, Yonkers, and more

### Offroad Pack
- Bronco Rally, Tyler's Boat, E Trene 1K
- Dugs 1K, PB Jeep variants, and more

### Mud Pack
- Default GTA V mud/offroad vehicles
- Sandking, Rebel, Kamacho, Trophy Truck, etc.

### Donk Pack
- 74 Nutta, Red Eye, Pontiac GTO 1965
- Floating HC, Murder Nova, and more

### LEO Pack
- LTF150, NM 745, NM 911
- LTD 80, Police vehicles
Try `/openmenu` command instead of M key
- If M key doesn't work, another script may be blocking it
- Use F8 console: `bind keyboard "m" "/openmenu"` to force-bind
- Check F8 console for errors
- Verify the resource is started: `/ensure pet-Packmenu`

### Discord roles not working / All packs showing
1. **Enable Server Members Intent** in Discord Developer Portal:
   - Go to Bot section → Privileged Gateway Intents
   - Enable "SERVER MEMBERS INTENT" (critical!)
   - Save and restart FiveM server
2. Verify bot is in your Discord server with Administrator permission
3. Check badger_discord_api is started before pet-Packmenu
4. Verify Discord role IDs match exactly (right-click role → Copy ID)
5. Restart entire server and reconnect (not just resource restart)

### Only seeing 3 packs (or wrong packs)
- This means Discord roles ARE working correctly!
- You only see packs for Discord roles you have
- To see all packs, get all Discord roles OR switch to ACE permissions

### No packs showing
- Check Config.UseDiscordRoles setting
- If using Discord: verify bot token in badger_discord_api
- If using ACE: check server.cfg has ACE permissions
- Look for debug logs in server console when opening menu  
✅ **Discord role verification** - Real-time role checking via badger_discord_api  
✅ **No client-side bypasses** - Cannot spawn vehicles without proper permissions  
✅ **Pack validation** - Checks that requested vehicles belong to owned packs  
✅ **Model validation** - Verifies vehicle models exist in pack definitions  

## Technical Details

- **UI System**: Custom native UI with DrawRect/DrawText (no NativeUI dependency)
- **Permission System**: Discord roles via badger_discord_api OR ACE permissions
- **Control Detection**: IsControlJustPressed with every-frame checking
- **Menu Key**: Control 244 (M key) with force-enable to override conflicts
- **Commands**: `/openmenu` to open menu manually

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review server console logs for [Off-Grid Menu] messages
3. Verify badger_discord_api is working (check for Discord API connection messages)
4. Test with `/openmenu` command if M key doesn't work

## Credits

- Built for Off-Grid Roleplay
- Uses badger_discord_api for Discord integration
- Custom native UI implementation (no external dependencies)
- Compatible with Qbox Framework.Packs.truck.discordRole` |
| Truck Pack 2 | `off-grid.truck2` | `Config.Packs.truck2.discordRole` |
| Offroad Pack | `off-grid.offroad` | `Config.Packs.offroad.discordRole` |
| Mud Pack | `off-grid.mud` | `Config.Packs.mud.discordRole` |
| Donk Pack | `off-grid.donk` | `Config.Packs.donator.discordRole` |
| LEO Pack | `off-grid.leo` | `Config.Packs.leo.discordRole` |
| Bike Pack | `off-grid.bike` | `Config.Packs.bike.discordRole` |
| MC Pack | `off-grid.mc` | `Config.Packs.mc.discordRole` |
### No packs showing
- Check that vMenu permissions are set correctly
- Use `/offgrid:debug` (console) to see loaded packs
- Ensure player has proper ACE permissions assigned

### Vehicles not spawning
- Check that vehicle models exist on your server
- Verify vehicle spawn codes in config.lua match your server's models
- Check server console for permission errors

### Permission denied errors
- Permissions are checked server-side for security
- Verify ACE permissions are set in permissions.cfg
- Restart the server after changing permissions

## Security

This menu includes several security features:

✅ **Server-side permission validation** - All spawns are validated on the server
✅ **No client-side bypasses** - Cannot spawn vehicles without proper permissions
✅ **Pack validation** - Checks that requested vehicles belong to owned packs
✅ **Model validation** - Verifies vehicle models exist in pack definitions

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review server console logs
3. Verify vMenu permissions are configured correctly

## Credits

- Built for Off-Grid Roleplay
- Uses NativeUI for menu rendering
- Compatible with vMenu permission system

## License

This resource is provided as-is for Off-Grid Roleplay.
