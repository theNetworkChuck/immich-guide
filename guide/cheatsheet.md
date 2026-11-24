# Cheat sheet

Every command from chapters 2 to 4 in one place, in order. Replace `<...>` placeholders. Read the chapters for what each one does.

```bash
# --- Chapter 2: Docker ---
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
exit                       # then SSH back in
docker run --rm hello-world

# --- Chapter 3: the drive ---
lsblk -f                   # copy your drive's UUID and FSTYPE
sudo mkdir -p /mnt/photos
echo 'UUID=<your-uuid> /mnt/photos exfat defaults,nofail 0 0' | sudo tee -a /etc/fstab
sudo systemctl daemon-reload
sudo mount -a
ls /mnt/photos
sudo mkdir -p /mnt/photos/immich_upload
sudo mkdir -p /etc/systemd/system/docker.service.d
printf '[Unit]\nRequiresMountsFor=/mnt/photos\n' | sudo tee /etc/systemd/system/docker.service.d/wait-for-storage.conf
sudo systemctl daemon-reload

# --- Chapter 4: Immich ---
mkdir ~/immich-app
cd ~/immich-app
wget https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
wget -O .env https://github.com/immich-app/immich/releases/latest/download/example.env
nano .env                  # UPLOAD_LOCATION=/mnt/photos/immich_upload, TZ=..., DB_PASSWORD=...
nano docker-compose.yml    # under immich-server volumes: - /mnt/photos/<your-folder>:/mnt/media/usb:ro
docker compose config --quiet
docker compose up -d
docker compose ps
```

Then open `http://<server-ip>:2283`, create the admin account, and add `/mnt/media/usb` as an External Library (chapter 5).

## Everyday commands

```bash
cd ~/immich-app
docker compose ps                         # is it running?
docker compose logs --tail 50 immich-server
docker compose down && docker compose up -d   # restart (after any compose change)
docker compose pull && docker compose up -d   # update Immich (read the release notes first)
```

> [!WARNING]
> Before updating, read [Immich's release notes](https://github.com/immich-app/immich/releases) for breaking changes, and make sure your backup ran.
