# Data And Configuration

Vintage Story separates the server program files from the server data directory. In this Docker setup, the data directory is the mounted repository directory.

## Paths

| Location | Path |
| --- | --- |
| Container server files | `/home/vintagestory/server` |
| Container data directory | `/var/vintagestory/data` |
| Host data directory | Repository root, mounted as `./:/var/vintagestory/data` |
| Main server config | `/var/vintagestory/data/serverconfig.json` |
| Saves | `/var/vintagestory/data/Saves` |
| Mods | `/var/vintagestory/data/Mods` |
| Logs | `/var/vintagestory/data/Logs` |
| Backups | Usually under the data directory after `/genbackup` is used |

The exact generated folder set depends on the Vintage Story version and the server's first successful startup.

## Editing `serverconfig.json`

Stop the server before editing persistent configuration:

```bash
docker compose down
```

Edit `serverconfig.json` in the repository root after it has been generated. Keep valid JSON syntax: double quotes around strings, commas between fields, and no comments.

Start the server again:

```bash
docker compose up -d
```

Some settings can also be changed live with `/serverconfig`, but file edits normally require a restart to take effect.

Common settings:

| Setting | Purpose |
| --- | --- |
| `ServerName` | Name shown to players. |
| `Description` | Public server description. |
| `Password` | Optional server password. |
| `AdvertiseServer` | Whether the server appears in the public server list. |
| `MaxClients` | Maximum number of connected players. |
| `WhitelistMode` | Whitelist behavior for new connections. |
| `DefaultRoleCode` | Default role assigned to players. |
| `SaveFileLocation` | Active world save path. |
| `ModPaths` | Folders scanned for mods. |

## Saving And Backing Up

Force an autosave:

```bash
docker compose exec vintagestory ./server.sh command "autosavenow"
```

Create a full world backup:

```bash
docker compose exec vintagestory ./server.sh command "genbackup before-config-change"
```

Before editing important files manually, stop the server and copy the data directory or the relevant world save. For a Compose setup that mounts the repository root, this means copying the generated files and folders from this repository directory.

## Worlds And Saves

World saves are stored in `Saves`. The active save is selected by `SaveFileLocation` in `serverconfig.json`.

To move an existing world into this server:

1. Stop the container.
2. Copy the `.vcdbs` world file into `Saves`.
3. Update `SaveFileLocation` in `serverconfig.json` if the filename is not the default.
4. Start the container.
5. Watch the logs for load errors.

If a mod changes world generation, add the mod before creating a new world. Adding world-generation mods to an existing world can produce borders or missing content in already-generated areas.

## Mod Paths

For this container, `server.sh` uses:

```text
/var/vintagestory/data
```

Use a `ModPaths` configuration similar to:

```json
"ModPaths": [
  "Mods",
  "/var/vintagestory/data/Mods"
]
```

Keep the built-in `Mods` entry unless you intentionally know the consequences. The extra absolute path points the server at the mounted persistent mods folder.

## Logs

Logs are written under `Logs`, usually including `server-main.log`.

View container logs:

```bash
docker compose logs -f vintagestory
```

View the server log from inside the container:

```bash
docker compose exec vintagestory tail -f /var/vintagestory/data/Logs/server-main.log
```

If the server exits before creating data files, use the container logs first.
