# Vintage Story Server

![image](https://media.vintagestory.at/monthly_2018_03/logo-gameaccount.png.2af97cf0b4bbcabccbacf465d74172b9.png)

Docker image and Compose setup for running a dedicated [Vintage Story](https://www.vintagestory.at/) server.

The image downloads the official Linux x64 dedicated server archive during build, installs the required Linux tools, exposes the default Vintage Story port `42420`, and starts the server through `launcher.sh`.

## Requirements

- Docker Engine
- Docker Compose v2 (`docker compose`) or the legacy `docker-compose` command
- Network access to download the image and, when building locally, the Vintage Story server archive

## Quick Start

Start the server with Docker Compose:

```bash
docker compose up -d
```

Legacy Compose syntax:

```bash
docker-compose -f ./docker-compose.yaml up -d
```

Check the container logs:

```bash
docker compose logs -f vintagestory
```

Stop the server:

```bash
docker compose down
```

The Compose service is named `vintagestory`. It publishes host port `42420` to container port `42420`.

## Data Persistence

`docker-compose.yaml` mounts the repository directory into the container:

```yaml
volumes:
  - ./:/var/vintagestory/data
```

Inside the container, Vintage Story uses `/var/vintagestory/data` as its data path. After the first successful start, server-generated files such as `serverconfig.json`, `Saves`, `Mods`, `Logs`, and backups are expected to appear in this repository directory.

Because the whole repository is mounted as server data, keep generated game data out of commits unless you intentionally want to version it.

## Common Operations

Start or recreate the container:

```bash
docker compose up -d
```

Restart the container:

```bash
docker compose restart vintagestory
```

Show current logs:

```bash
docker compose logs --tail=100 vintagestory
```

Open a shell in the container:

```bash
docker compose exec vintagestory bash
```

Run a server command through `server.sh`:

```bash
docker compose exec vintagestory ./server.sh command "stats"
docker compose exec vintagestory ./server.sh command "list clients"
docker compose exec vintagestory ./server.sh command "genbackup before-maintenance"
```

When using `server.sh command`, omit the leading `/`. The wrapper sends the command into the running server console.

## Launcher Behavior

`launcher.sh` is the container entrypoint. It:

1. Starts the Vintage Story background server with `./server.sh start`.
2. Runs `sleep infinity` so the container stays alive while the server runs in the background.
3. Waits for the container to receive a stop signal.
4. Calls `./server.sh stop` during cleanup so the server can save and shut down cleanly.

The launcher does not configure gameplay settings itself. Server settings live in the data directory, mainly in `serverconfig.json`.

## Documentation

- [Server operations](docs/server-operations.md)
- [Data and configuration](docs/data-and-configuration.md)
- [Mods](docs/mods.md)
- [Command reference](docs/command-reference.md)
- [Troubleshooting](docs/troubleshooting.md)

## Official References

- [Vintage Story Dedicated Server Guide](https://wiki.vintagestory.at/Guide%3A_Dedicated_Server)
- [Vintage Story Server Commands](https://wiki.vintagestory.at/List_of_server_commands)
