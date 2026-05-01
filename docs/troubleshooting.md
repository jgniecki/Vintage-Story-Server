# Troubleshooting

Start with the container logs:

```bash
docker compose logs --tail=200 vintagestory
```

Then check the server log if it exists:

```bash
docker compose exec vintagestory tail -n 200 /var/vintagestory/data/Logs/server-main.log
```

## Container Does Not Start

Validate the Compose file:

```bash
docker compose config
```

Check whether the image exists locally or can be pulled:

```bash
docker compose pull
```

If you built locally, confirm the tag in `docker-compose.yaml` matches the image you built.

## Known Runtime Version Risk

For Vintage Story `1.22.0`, the downloaded `server.sh` checks for `.NETCore.App 10.0`. The current `Dockerfile` installs:

```dockerfile
aspnetcore-runtime-8.0
```

This documentation update does not change the Dockerfile. If startup logs report a missing .NET runtime, rebuild the image with the runtime required by the downloaded Vintage Story server version, or use a server version compatible with the installed runtime.

## Port And Connection Problems

The Compose file publishes:

```yaml
ports:
  - "42420:42420"
```

That maps TCP only. If your server version or router setup needs UDP as well, add:

```yaml
ports:
  - "42420:42420"
  - "42420:42420/udp"
```

Check the container:

```bash
docker compose ps
```

For players outside the local network, forward the published `42420` protocol on the router. Vintage Story 1.20 and newer may require both TCP and UDP forwarding for the default port.

If the server should not be public, keep it off the public list and use whitelist or password protections.

## Cannot Join Because Of Whitelist

Dedicated servers use whitelist protections by default in modern Vintage Story versions.

Add a player:

```bash
docker compose exec vintagestory ./server.sh command "player PlayerName whitelist on"
```

Grant admin access where supported:

```bash
docker compose exec vintagestory ./server.sh command "op PlayerName"
```

If `op` is not available in the installed version, use `/help player`, `/help role`, and `/list privileges` to choose the correct role or privilege command.

## Configuration Changes Do Not Apply

Most `serverconfig.json` edits require a restart.

Recommended flow:

```bash
docker compose exec vintagestory ./server.sh command "autosavenow"
docker compose down
# edit serverconfig.json on the host
docker compose up -d
```

If the file fails to parse, validate the JSON syntax. JSON does not allow comments or trailing commas.

## Mods Do Not Load

Check these items:

- The mod ZIP is in `Mods`.
- `serverconfig.json` includes `/var/vintagestory/data/Mods` in `ModPaths`.
- The mod supports the installed Vintage Story version.
- Required dependency mods are also installed.
- The mod is server-side or universal if the server must load it.
- The server was restarted after manual ZIP changes.

List installed ModDB-managed mods:

```bash
docker compose exec vintagestory ./server.sh command "moddb list"
```

Search logs for mod errors:

```bash
docker compose exec vintagestory grep -i mod /var/vintagestory/data/Logs/server-main.log
```

## World Fails After Removing Or Updating Mods

Restore from backup when possible. If the world loads but reports missing mappings, inspect the log and consider repair commands such as:

```bash
docker compose exec vintagestory ./server.sh command "fixmapping applyall"
```

Only run repair commands after making a backup:

```bash
docker compose exec vintagestory ./server.sh command "genbackup before-repair"
```

## Server Appears Frozen

Check container state:

```bash
docker compose ps
```

Check server status inside the container:

```bash
docker compose exec vintagestory ./server.sh status
```

Inspect recent logs:

```bash
docker compose logs --tail=200 vintagestory
```

If the process is still running but players cannot interact, run:

```bash
docker compose exec vintagestory ./server.sh command "stats"
docker compose exec vintagestory ./server.sh command "list clients"
```

## Clean Shutdown

Use Compose stop/down for normal shutdowns. `launcher.sh` handles cleanup by calling `./server.sh stop`.

For planned maintenance, force a save and backup first:

```bash
docker compose exec vintagestory ./server.sh command "autosavenow"
docker compose exec vintagestory ./server.sh command "genbackup before-shutdown"
docker compose down
```
