# Server Operations

This page covers day-to-day administration for the Docker Compose service in this repository.

## Compose Service

The service name is `vintagestory`.

```bash
docker compose up -d
docker compose ps
docker compose logs -f vintagestory
docker compose restart vintagestory
docker compose down
```

Legacy Compose:

```bash
docker-compose -f ./docker-compose.yaml up -d
docker-compose -f ./docker-compose.yaml logs -f vintagestory
docker-compose -f ./docker-compose.yaml down
```

The default port mapping is:

```yaml
ports:
  - "42420:42420"
```

This Compose file publishes TCP port `42420`. If your Vintage Story version or network setup also requires UDP on the same port, add an explicit UDP mapping:

```yaml
ports:
  - "42420:42420"
  - "42420:42420/udp"
```

Open the same protocol and port on the host firewall and router if players connect from outside the local network.

## Shell Access

Open a shell as the container user:

```bash
docker compose exec vintagestory bash
```

The working directory is `/home/vintagestory/server`, where the server archive is extracted and where `server.sh` and `launcher.sh` are located.

## Running Server Commands

Use `server.sh command` from the container:

```bash
docker compose exec vintagestory ./server.sh command "stats"
docker compose exec vintagestory ./server.sh command "list clients"
docker compose exec vintagestory ./server.sh command "serverconfig maxclients 12"
docker compose exec vintagestory ./server.sh command "genbackup before-update"
```

Do not add `/` at the beginning when using `server.sh command`. The wrapper sends the command into the screen session with the slash added.

From inside the game chat or attached console, commands are written with the slash:

```text
/stats
/list clients
/serverconfig maxclients 12
```

## `server.sh` Wrapper Commands

The Vintage Story server archive includes `server.sh`. In this image it is used by `launcher.sh`, but administrators can also call it manually.

| Command | Purpose |
| --- | --- |
| `./server.sh start` | Starts the dedicated server in a detached `screen` session. |
| `./server.sh stop` | Sends a save/shutdown command and stops the server process. |
| `./server.sh status` | Checks whether the server process is running. |
| `./server.sh restart` | Stops and starts the server. |
| `./server.sh update` | Runs the server script's built-in update flow. Test before using on a live world. |
| `./server.sh setup "user" "path"` | Rewrites script defaults for a user and server path. This is usually not needed inside this container. |
| `./server.sh command "command text"` | Sends a Vintage Story server command to the running server. |

The server runs in a screen session named `vintagestory_server`.

Attach to it from inside the container:

```bash
screen -r vintagestory_server
```

Detach without stopping the server by pressing `Ctrl+A`, then `D`.

## Dockerfile Build Arguments

The Dockerfile defines these build arguments:

| Argument | Default | Purpose |
| --- | --- | --- |
| `VERSION` | `1.22.0` | Vintage Story server version to download. |
| `FILENAME` | `vs_server_linux-x64_${VERSION}.tar.gz` | Archive filename downloaded from the official CDN. |
| `USERNAME` | `vintagestory` | Linux user created inside the image. |
| `VSPATH` | `/home/vintagestory/server` | Server installation directory. |
| `DATAPATH` | `/var/vintagestory/data` | Persistent data directory used by `server.sh`. |

Build locally with the default version:

```bash
docker build -t vintagestory-server .
```

Build a specific version:

```bash
docker build --build-arg VERSION=1.22.0 -t vintagestory-server:1.22.0 .
```

To use a local image with Compose, update `docker-compose.yaml` from the published image name to the tag you built.

## Lifecycle Checklist

Before planned maintenance:

```bash
docker compose exec vintagestory ./server.sh command "announce Server maintenance in 5 minutes"
docker compose exec vintagestory ./server.sh command "genbackup before-maintenance"
docker compose down
```

After maintenance:

```bash
docker compose up -d
docker compose logs -f vintagestory
```
