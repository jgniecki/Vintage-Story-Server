# Mods

Vintage Story dedicated servers can load server-side and universal mods. Players joining a modded server are prompted to download the server mod list when the mods support that flow.

## Install Mods From ZIP Files

1. Stop the server:

   ```bash
   docker compose down
   ```

2. Create the persistent mods folder if it does not exist:

   ```bash
   mkdir Mods
   ```

3. Put mod `.zip` files into `Mods`.

4. Confirm `serverconfig.json` includes the persistent mod path:

   ```json
   "ModPaths": [
     "Mods",
     "/var/vintagestory/data/Mods"
   ]
   ```

5. Start the server:

   ```bash
   docker compose up -d
   ```

6. Check logs for mod loading errors:

   ```bash
   docker compose logs -f vintagestory
   ```

Keep mod ZIP files zipped unless a mod's own instructions say otherwise.

## Install Mods With `/moddb`

You can manage supported mods from the running server:

```bash
docker compose exec vintagestory ./server.sh command "moddb search some-mod-name"
docker compose exec vintagestory ./server.sh command "moddb install modid 1.22.0"
docker compose exec vintagestory ./server.sh command "moddb list"
docker compose exec vintagestory ./server.sh command "moddb remove modid"
```

Use the exact mod id from the Vintage Story mod database. The game version argument should match the server version when the command requires it.

## Updating Mods

Recommended process:

1. Announce maintenance.
2. Run a backup:

   ```bash
   docker compose exec vintagestory ./server.sh command "genbackup before-mod-update"
   ```

3. Stop the server.
4. Replace ZIP files in `Mods` or use `/moddb` management commands.
5. Start the server.
6. Watch logs until all mods finish loading.

Do not update many gameplay or world-generation mods at once unless you have a tested backup to return to.

## Mod Configuration Files

Many mods generate config files after the server has started at least once with the mod installed. Look for generated files under a mod configuration folder in the data directory, commonly `ModConfig`.

Stop the server before editing mod config files unless the mod explicitly supports live reload.

## Server-Side, Universal, And Client-Side Mods

| Mod type | Server behavior | Player behavior |
| --- | --- | --- |
| Server-side | Runs only on the server. | Usually no client install required. |
| Universal | Runs on both server and client. | Players are prompted to download server-required mods when joining. |
| Client-side | Runs only on the player client. | Players install these manually; the server does not provide every client-only mod. |

When troubleshooting, first confirm that the mod supports the installed Vintage Story version and the dedicated server environment.

## Removing Mods

Removing mods can affect worlds that already contain modded blocks, items, entities, or worldgen. Before removing a mod:

```bash
docker compose exec vintagestory ./server.sh command "genbackup before-removing-modid"
```

Then stop the server and remove the ZIP from `Mods`, or run:

```bash
docker compose exec vintagestory ./server.sh command "moddb remove modid"
```

After restart, check logs for missing asset, block id, item id, or remapping warnings.
