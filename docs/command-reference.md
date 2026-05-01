# Command Reference

This reference is written for administrators running this Dockerized server. It combines Docker commands, the `server.sh` wrapper, and Vintage Story server commands.

Sources checked on 2026-05-01:

- [Vintage Story Dedicated Server Guide](https://wiki.vintagestory.at/Guide%3A_Dedicated_Server)
- [Vintage Story Server Commands](https://wiki.vintagestory.at/List_of_server_commands)

The running server is the final authority. Use `/help` in-game or:

```bash
docker compose exec vintagestory ./server.sh command "help"
```

Loaded mods can add, remove, or change commands.

## How To Run Commands

From the host through Docker:

```bash
docker compose exec vintagestory ./server.sh command "stats"
```

From in-game chat or an attached console:

```text
/stats
```

When using `server.sh command`, omit the leading `/`.

## Docker And Container Commands

| Command | Purpose |
| --- | --- |
| `docker compose up -d` | Start the service in the background. |
| `docker compose down` | Stop and remove the service container. |
| `docker compose restart vintagestory` | Restart the server container. |
| `docker compose ps` | Show service state. |
| `docker compose logs -f vintagestory` | Follow container logs. |
| `docker compose exec vintagestory bash` | Open a shell in the running container. |
| `docker compose config` | Render and validate the Compose configuration. |
| `docker build -t vintagestory-server .` | Build the image locally. |

## `server.sh` Commands

| Command | Purpose |
| --- | --- |
| `./server.sh start` | Start the server in a detached screen session. |
| `./server.sh stop` | Save and stop the server. |
| `./server.sh status` | Check server process state. |
| `./server.sh restart` | Stop and start the server. |
| `./server.sh update` | Run the script's update flow. |
| `./server.sh setup "user" "path"` | Configure script defaults. Usually not needed in this container. |
| `./server.sh command "stats"` | Send a Vintage Story command to the running server. |

## Administration And Players

| Command | Purpose |
| --- | --- |
| `/help` | Show command help for the installed server and mods. |
| `/stats` | Show server performance and runtime statistics. |
| `/list clients` | List connected players. |
| `/list banned` | List banned players. |
| `/list role` | List configured roles. |
| `/list privileges` | List available privileges. |
| `/announce <message>` | Broadcast a server-wide message. |
| `/stop` | Stop the server from the console. |
| `/autosavenow` | Force an autosave. |
| `/genbackup [filename]` | Create a full save backup. |
| `/info ident` | Show world identifier. |
| `/info seed` | Show world seed. |
| `/info createdversion` | Show the version that created the world. |
| `/info mapsize` | Show world size. |

## Player Management

| Command | Purpose |
| --- | --- |
| `/player <name> whitelist on` | Allow a player to join when whitelist is enabled. |
| `/player <name> whitelist off` | Remove a player from the whitelist. |
| `/player <name> role <rolecode>` | Assign a role to a player. |
| `/player <name> privileges` | Inspect player privileges. |
| `/player <name> gamemode <mode>` | Change a player's game mode when permitted. |
| `/ban <name> [reason]` | Ban a player. |
| `/unban <name>` | Remove a ban. |
| `/kick <name> [reason]` | Disconnect a player. |
| `/op <name>` | Grant operator/admin access where supported by the installed version. |
| `/deop <name>` | Remove operator/admin access where supported by the installed version. |

Command names and exact subcommands can vary by server version. Use `/help player`, `/help ban`, or `/help privileges` on the running server when in doubt.

## Privileges And Roles

| Command | Purpose |
| --- | --- |
| `/role list` | List roles. |
| `/role create <rolecode>` | Create a role. |
| `/role remove <rolecode>` | Remove a role. |
| `/role <rolecode> privilege grant <privilege>` | Grant a privilege to a role. |
| `/role <rolecode> privilege revoke <privilege>` | Revoke a privilege from a role. |
| `/role <rolecode> defaultspawn <x> <y> <z>` | Set role-specific spawn behavior when supported. |
| `/privilege grant <player> <privilege>` | Grant a privilege directly to a player. |
| `/privilege revoke <player> <privilege>` | Revoke a player privilege. |

Common privileges include build, use, chat, attack, controlserver, gamemode, time, teleport, and grantrevoke. Check `/list privileges` for the exact installed list.

## Server Configuration

| Command | Purpose |
| --- | --- |
| `/serverconfig` | Display or modify server configuration. |
| `/serverconfig maxclients <number>` | Set maximum connected players. |
| `/serverconfig password <password>` | Set the server password. |
| `/serverconfig advertise <true|false>` | Toggle public server listing. |
| `/serverconfig WhitelistMode <default|off|on>` | Configure whitelist behavior. |
| `/serverconfig maxchunkradius <number>` | Set maximum client chunk radius. |
| `/serverconfig spawncapplayerscaling <0..1>` | Tune spawn cap scaling by player count. |
| `/serverconfig passtimewhenempty <true|false>` | Control whether time passes with no players online. |
| `/serverconfig allowfallingblocks <true|false>` | Enable or disable falling block behavior. |
| `/serverconfig setspawnhere` | Set default spawn to the caller's position. |
| `/serverconfig spawn <x> [y] <z>` | Set default spawn coordinates. |
| `/serverconfig temporaryipblocklist <0|1>` | Toggle temporary IP block list. |
| `/serverconfig loginfloodprotection <0|1>` | Toggle login flood protection. |

For persistent changes, also check `serverconfig.json` in the data directory.

## World Configuration

| Command | Purpose |
| --- | --- |
| `/worldconfig` | Display or modify world configuration. |
| `/worldconfig allowLandClaiming <true|false>` | Toggle land claiming when supported. |
| `/worldconfig temporalStability <true|false>` | Toggle temporal stability rules. |
| `/worldconfig temporalStorms <off|veryrare|rare|sometimes|often|veryoften>` | Adjust temporal storm frequency. |
| `/worldconfig deathPunishment <drop|keep>` | Adjust death item behavior where supported. |
| `/worldconfig creatureHostility <passive|aggressive|off>` | Adjust creature hostility where supported. |
| `/worldconfig seasons <enabled|spring|summer|autumn|winter>` | Adjust season behavior where supported. |
| `/worldconfig playerlives <number>` | Configure limited lives where supported. |
| `/worldconfig colorAccurateWorldmap <true|false>` | Toggle accurate color world map behavior. |

World configuration options are especially version-dependent. Use `/help worldconfig` on the running server before changing a production world.

## Time And Weather

| Command | Purpose |
| --- | --- |
| `/time` | Show current time. |
| `/time stop` | Stop time progression. |
| `/time resume` | Resume time progression. |
| `/time set <time-of-day>` | Set time to a named point such as morning, day, night, or midnight. |
| `/time set <hour>` | Set time by 24-hour value. |
| `/time setmonth <month>` | Set current month. |
| `/time add <hours>:<minutes>` | Advance the calendar. |
| `/time speed <number>` | Show or set time speed. |
| `/time hoursperday <number>` | Show or set hours per day. |
| `/time calendarspeedmul <number>` | Show or set calendar speed multiplier. |
| `/weather` | Show current weather state. |
| `/weather stoprain` | Move weather forward until rain stops. |
| `/weather setprecip <value>` | Override precipitation intensity. |
| `/weather setprecipa` | Return precipitation to automatic behavior. |
| `/weather setw <wind>` | Set wind pattern. |
| `/weather set <pattern>` | Set a weather pattern. |
| `/weather setirandom` | Switch to a random weather pattern. |
| `/whenwillitstopraining` | Report when the current rain should stop. |

Back up before heavy time manipulation on important worlds.

## Teleport, Game Mode, And Utility Commands

| Command | Purpose |
| --- | --- |
| `/gamemode <player> <mode>` | Change game mode when permitted. |
| `/tp <target>` | Teleport using supported target syntax. |
| `/tp <player> <target>` | Teleport another player when permitted. |
| `/setspawn` | Set spawn behavior where supported by version. |
| `/giveitem <code> [quantity]` | Give an item by code when permitted. |
| `/clearinv` | Clear inventory when permitted. |
| `/waypoint` | Manage waypoints where available. |

Use `/help` for exact syntax because these commands are sensitive to permissions and version.

## Mods

| Command | Purpose |
| --- | --- |
| `/moddb list` | List installed mods. |
| `/moddb search <query>` | Search the mod database. |
| `/moddb searchcompatible <modid>` | Search compatible releases for the current server version. |
| `/moddb searchfor <gameVersion> <modid>` | Search releases for a specific game version. |
| `/moddb searchforc <gameVersion> <modid>` | Search compatible releases for a specific game version. |
| `/moddb install <modid> [gameVersion]` | Install a mod from ModDB. |
| `/moddb remove <modid>` | Remove a ModDB-managed mod. |

Manual ZIP installation is covered in [Mods](mods.md).

## Entity And Creature Commands

| Command | Purpose |
| --- | --- |
| `/entity count [filter]` | Count entities matching an optional filter. |
| `/entity countg [filter]` | Count entities grouped by code prefix. |
| `/entity spawnat <entitytype> <amount> <position> <radius>` | Spawn entities near a position. |
| `/entity remove <filter>` | Remove matching entities. |
| `/entity cmd kill` | Kill the targeted or selected creature. |
| `/entity cmd wipeall` | Remove loaded non-player entities. |
| `/entity debug <0|1>` | Toggle entity debug output. |
| `/entity spawndebug <0|1>` | Toggle spawn debug output. |

Entity filters can target self, looked-at entity, players, or entity sets depending on command syntax. Test filters carefully before using removal commands.

## Chunk, Region, And Mapping Tools

| Command | Purpose |
| --- | --- |
| `/chunk cit` | Show current chunk generation information. |
| `/chunk printmap` | Export a map of loaded chunks. |
| `/chunk unload <0|1>` | Toggle automatic unloading of chunks. |
| `/chunk forceload <x1> <z1> <x2> <z2>` | Force load an area. |
| `/fixmapping applyall` | Apply block and item remapping during upgrades. |
| `/bir getid` | Inspect block id remapping information. |
| `/bir getcode` | Inspect block code remapping information. |
| `/bir remap` | Run block id remapping tools. |

Use these commands only with a backup when repairing an upgraded or modded world.

## Debug Commands

| Command | Purpose |
| --- | --- |
| `/debug logticks <milliseconds>` | Log tick breakdowns that exceed the threshold. |
| `/debug tickhandlers` | Summarize ticking handlers. |
| `/debug tickhandlers dump <type>` | Dump tick handler details to debug logs. |
| `/debug itemcodes` | Export item codes to the server log. |
| `/debug blockcodes` | Export block codes to the server log. |
| `/debug blockids` | List high block id usage. |
| `/debug blockstats` | Generate block id usage statistics. |
| `/debug privileges` | Toggle privilege debugging. |
| `/debug netbench` | Toggle network benchmarking. |
| `/debug stacktrace` | Print stack trace information. |
| `/debug mainthreadstate` | Print main thread state. |
| `/debug chunk stats` | Show loaded chunk statistics. |
| `/debug chunk here` | Show information for the current chunk. |
| `/debug chunk resend` | Resend a chunk to clients. |
| `/debug chunk relight` | Relight a chunk. |
| `/debug rooms list` | List detected rooms. |
| `/debug rooms hi` | Highlight rooms. |
| `/debug rooms unhi` | Remove room highlighting. |
| `/debug rift clear` | Remove loaded rifts. |
| `/debug rift fade` | Fade loaded rifts out. |
| `/debug rift spawn <number>` | Spawn rifts. |
| `/debug rift spawnhere` | Spawn one rift at the caller. |

Debug commands can affect performance or world state. Prefer using them during troubleshooting windows.

## World Generation Tools

| Command | Purpose |
| --- | --- |
| `/wgen autogen` | Change automatic worldgen mode. |
| `/wgen gt` | Toggle tree generation mode. |
| `/wgen testmap <type>` | Generate a sample worldgen map from a fixed seed. |
| `/wgen genmap <type>` | Generate worldgen map output where supported. |
| `/wgen region <type>` | Generate a map for the current region. |
| `/wgen regions <radius> <type> <name>` | Generate maps for nearby regions where supported. |
| `/wgen pos` | Show worldgen position information where supported. |
| `/wgen tree` | Run tree worldgen tools where supported. |

World generation tools usually write files near the server executable or data directory and are best used on test worlds first.
