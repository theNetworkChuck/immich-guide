# 8. Add a NAS

▶ Video: 17:06 · [← Access from anywhere](07-twingate.md) · [Next: Give Immich your GPU →](09-gpu.md)

The video goes fast here. This is the full version: mount a NAS share over NFS, then hand it to Immich the same way as the USB drive.

## On the NAS

Share the folder that holds your photos over **NFS** to the Immich server's IP address. Every NAS (Synology, QNAP, TrueNAS, Unraid, ZimaOS...) does this on its own settings page. You need two things from it: the NAS's **IP address** and the share's **path** (for example `/volume1/photos` on a Synology, `/mnt/tank/photos` on TrueNAS).

- **Read-only** is enough if Immich only *reads* your existing photos. **Read-write** if you want new phone uploads to go to the NAS too.
- Either way, Immich reads as **root** inside its container. Most NAS boxes "squash" root to a nobody account by default, which can stop Immich (and you) reading files that aren't world-readable. Turn root squashing off for this server's IP: `no_root_squash` in plain NFS, **Squash: No mapping** on Synology, **Maproot User: root** on TrueNAS. Check your NAS's own name for it.

## On the Immich server

```bash
sudo apt install -y nfs-common
sudo mkdir -p /mnt/nas
echo '<nas-ip>:<share-path> /mnt/nas nfs defaults,_netdev,nofail 0 0' | sudo tee -a /etc/fstab
sudo systemctl daemon-reload
sudo mount -a
ls /mnt/nas
```

`_netdev` tells Ubuntu this one needs the network, so it waits for it at boot. You should see your NAS's folders.

> [!NOTE]
> A wrong IP or share path can make `mount -a` hang for a couple of minutes before it says `access denied` or `connection refused`. Check both on the NAS's admin page.

Make Docker wait for the NAS too (this replaces the rule from chapter 3):

```bash
printf '[Unit]\nRequiresMountsFor=/mnt/photos /mnt/nas\n' | sudo tee /etc/systemd/system/docker.service.d/wait-for-storage.conf
sudo systemctl daemon-reload
```

> [!WARNING]
> With the NAS in this rule, if the NAS is off when the server boots, Docker and Immich stay down until it's back (`sudo mount -a && sudo systemctl start docker`). Prefer Immich to start anyway with only the USB drive? Leave `/mnt/nas` out of the rule.

## Hand it to Immich

```bash
cd ~/immich-app
nano docker-compose.yml
```

Under your USB line in `immich-server` → `volumes:`, add the NAS folder that holds your photos:

```yaml
      - /mnt/photos/immich-demo:/mnt/media/usb:ro
      - /mnt/nas/<photos-folder>:/mnt/media/nas:ro
```

Any time you add a volume, restart the containers so they see it:

```bash
docker compose config --quiet
docker compose down
docker compose up -d
```

Then in the web page: **Administration → External Libraries →** your library → **Add** folder `/mnt/media/nas` → **Scan**.

## Want new uploads on the NAS instead?

Do this **before** installing Immich (chapter 4), because Immich marks its upload folder the first time it starts:

```bash
sudo mkdir -p /mnt/nas/immich_upload
```

and set `UPLOAD_LOCATION=/mnt/nas/immich_upload` in `.env`. The database still stays on the server's SSD.

---

[← Access from anywhere](07-twingate.md) · [Next: Give Immich your GPU →](09-gpu.md)
