# 3. Connect your hard drive

▶ Video: 4:43 · [← Ubuntu Server and Docker](02-ubuntu-and-docker.md) · [Next: Install Immich →](04-install-immich.md)

Plug the drive in. On Linux nothing pops up: you tell Ubuntu where the drive should appear, and you tell it to do that at every boot. This chapter does that, makes a folder for new uploads, and makes Docker wait for the drive so Immich never starts against an empty folder.

> [!IMPORTANT]
> Do this **before** you install Immich. Immich writes marker files into its upload folder the first time it starts, so the drive has to be mounted by then, or those files land on the server's own disk instead.

## Step 1: Find the drive

```bash
lsblk -f
```

This lists every drive and partition with its format (`FSTYPE`), name (`LABEL`) and ID (`UUID`). Your USB drive is the new one, usually `sda` or `sdb`, with a size and label you recognize. In the video it's `sda2`, `exfat`, label `Untitled`.

Copy the **UUID** of the partition that holds your photos (something like `6AF7-4F22` for exFAT, or a long one like `c748b28b-d484-...` for ext4).

## Step 2: Make a folder for the drive

```bash
sudo mkdir -p /mnt/photos
```

Linux shows a drive's contents through a folder. This is the one we'll use.

## Step 3: Mount it at every boot

```bash
echo 'UUID=<your-uuid> /mnt/photos exfat defaults,nofail 0 0' | sudo tee -a /etc/fstab
```

This adds one line to `/etc/fstab`, the list of drives Ubuntu connects when it boots: "the drive with this UUID shows up at `/mnt/photos`."

- Replace `<your-uuid>` with the UUID from step 1.
- Replace `exfat` with your drive's `FSTYPE` from step 1: `exfat`, `ntfs3` for NTFS drives, or `ext4`.
- `nofail` means the computer still boots if the drive is unplugged.

> [!CAUTION]
> Keep the `-a` in `tee -a`. It **adds** a line. Without it, `tee` replaces your whole `/etc/fstab` with this one line.

## Step 4: Mount it now

```bash
sudo systemctl daemon-reload
sudo mount -a
```

`daemon-reload` tells Ubuntu you changed `/etc/fstab`. `mount -a` connects everything listed there right now, no reboot needed. No output means it worked.

Look at your drive:

```bash
ls /mnt/photos
```

Then look inside the folder that holds your photos. In the video it's `immich-demo`:

```bash
ls /mnt/photos/immich-demo
```

Not sure where your photos are on the drive? This counts photos and videos per folder, biggest first:

```bash
find /mnt/photos -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.heic' -o -iname '*.png' -o -iname '*.mp4' -o -iname '*.mov' \) | sed 's|/[^/]*$||' | sort | uniq -c | sort -rn | head
```

Write down the top folder that holds them all. Immich reads every folder inside it.

## Step 5: Make a folder for new uploads

```bash
sudo mkdir -p /mnt/photos/immich_upload
```

Every new photo and video your phone backs up lands here. It sits **beside** your old photos, not inside them.

## Step 6: Make Docker wait for the drive

After a reboot, Docker can start before the drive is mounted. Immich would then see an empty folder. This rule stops that:

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d
printf '[Unit]\nRequiresMountsFor=/mnt/photos\n' | sudo tee /etc/systemd/system/docker.service.d/wait-for-storage.conf
sudo systemctl daemon-reload
```

The rule says "don't start Docker until `/mnt/photos` is mounted." It applies from the next boot.

> [!WARNING]
> With this rule, if the drive is unplugged at boot, Docker (and Immich) won't start until you plug it in and run `sudo mount -a && sudo systemctl start docker`. That's on purpose: no drive, no Immich, nothing written to the wrong place.

---

[← Ubuntu Server and Docker](02-ubuntu-and-docker.md) · [Next: Install Immich →](04-install-immich.md)
