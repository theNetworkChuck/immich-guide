# 4. Install Immich

▶ Video: 7:46 · [← Connect your hard drive](03-connect-your-drive.md) · [Next: First login and your photos →](05-first-login-and-your-photos.md)

Immich is two files: `docker-compose.yml` (which containers to run and how they connect) and `.env` (your settings). You download both, change a few lines, and start it.

## Step 1: Download the two files

```bash
mkdir ~/immich-app
cd ~/immich-app
wget https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
wget -O .env https://github.com/immich-app/immich/releases/latest/download/example.env
```

`-O .env` saves the settings file with the name Immich expects. Files that start with a dot are hidden, so `ls` won't show it. `ls -alt` will.

## Step 2: Edit the settings

```bash
nano .env
```

Change three things:

| Line | Change it to | Why |
|---|---|---|
| `UPLOAD_LOCATION=./library` | `UPLOAD_LOCATION=/mnt/photos/immich_upload` | New uploads go to the folder you made on the drive. Uploads on a NAS instead? Do [chapter 8's mount and Docker rule](08-add-a-nas.md#on-the-immich-server) **first**, then use `/mnt/nas/immich_upload` |
| `# TZ=Etc/UTC` | `TZ=America/Chicago` | Delete the `#` and put your timezone ([list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)). Photo dates use it. |
| `DB_PASSWORD=postgres` | `DB_PASSWORD=<random>` | Letters and numbers only. Make one with `openssl rand -hex 16` |

Leave `IMMICH_VERSION=v3` alone too: it keeps you on version 3 when you update. Leave `DB_DATA_LOCATION=./postgres` alone. It keeps the database on the server's own SSD, which Immich requires (never a network share, and Postgres won't run on exFAT or NTFS).

Save and exit: **Ctrl+X**, then **Y**, then **Enter**.

## Step 3: Point Immich at the photos you already have

```bash
nano docker-compose.yml
```

Find the `immich-server:` section and its `volumes:` list. Under the `/etc/localtime` line, add one line for your photo folder:

```yaml
    volumes:
      # Do not edit the next line. If you want to change the media storage location on your system, edit the value of UPLOAD_LOCATION in the .env file
      - ${UPLOAD_LOCATION}:/data
      - /etc/localtime:/etc/localtime:ro
      - /mnt/photos/immich-demo:/mnt/media/usb:ro
```

- **Left of the colon:** the folder on the server (yours from chapter 3, step 4).
- **Right of the colon:** the name Immich sees inside its container. You'll type this in the web page in chapter 5.
- **`:ro` at the end:** read-only. Immich can show and index these photos but can never change or delete them. The video leaves `:ro` off; adding it is the safer choice for photos you can't replace. (The trade-off: Immich can't write `.xmp` sidecar files next to them, so date or location fixes you make in Immich live only in its database.)
- Don't add the `immich_upload` folder here. `UPLOAD_LOCATION` in `.env` already handles it.

YAML cares about spaces. The new line must line up with the two `-` lines above it, with spaces, not tabs.

Save and exit (**Ctrl+X**, **Y**, **Enter**), then check your edit:

```bash
docker compose config --quiet
```

No output means it's good.

## Step 4: Start it

```bash
docker compose up -d
```

The first time it downloads Immich, which takes a few minutes. Then check it:

```bash
docker compose ps
```

You should see four containers, each `Up` (and `healthy` after a minute):

| Container | What it does |
|---|---|
| `immich_server` | The app. The website and the phone app talk to it on port 2283. Handles uploads, thumbnails, and converting videos so they play anywhere. |
| `immich_machine_learning` | The local AI: smart search, faces, reading text in photos. |
| `immich_postgres` | The database: every photo's details, albums, people, and the search index. |
| `immich_redis` | A fast to-do list for background jobs (Valkey, a Redis-compatible server). |

---

[← Connect your hard drive](03-connect-your-drive.md) · [Next: First login and your photos →](05-first-login-and-your-photos.md)
