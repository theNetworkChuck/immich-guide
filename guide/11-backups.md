# 11. Back it up

▶ Video: 21:26 · [← Smarter search](10-smarter-search.md) · [Next: Bring in Google Photos →](12-google-takeout.md)

Once Google and iCloud aren't holding your photos, this server is the only copy. Drives fail. RAID isn't a backup either: it copies a deletion or a ransomware encryption to every disk instantly.

The rule of thumb is **3-2-1**: three copies, on two kinds of storage, one of them somewhere else (another house, or the cloud).

## What Immich already backs up for you

Immich dumps its **database** every night (2 AM by default, last 14 kept) into a `backups` folder inside your upload location:

```bash
ls /mnt/photos/immich_upload/backups
```

The folder stays empty until the first 2 AM run. Change the schedule or the number kept under **Administration → Settings → Database Dump Settings**.

That's the *details*: albums, people and faces, descriptions, search index. **It is not your photos.** You need both: the photo files and that database dump.

## What to back up

| Folder | What's in it |
|---|---|
| `/mnt/photos/immich_upload` | Everything your phone uploaded, plus the nightly database dumps in `backups/` |
| `/mnt/photos/immich-demo` (your External Library folder) | The photos you already had |

## The simplest version: a second drive

Plug in a second drive, mount it at `/mnt/backup` the same way as chapter 3 (its own UUID, its own line in `/etc/fstab`), then copy:

```bash
mountpoint -q /mnt/backup && sudo rsync -a --info=progress2 /mnt/photos/ /mnt/backup/photos/
```

The `mountpoint -q` check stops the copy if the backup drive isn't plugged in, so it never fills the server's own disk. Run it again any time; it only copies what changed. Then take that drive to your parents' or a friend's house. That's your off-site copy.

## The automatic version: encrypted, every night, off-site

The video's setup uses [restic](https://restic.net) (a backup tool that encrypts everything **before** it leaves the server) and [Backblaze B2](https://www.backblaze.com/cloud-storage) (cheap cloud storage). Backblaze stores your photos, but it can't read them: only you have the key.

1. In Backblaze, create a **private bucket** and an **application key** limited to that bucket.
2. On the server, install restic and save your settings:

   ```bash
   sudo apt install -y restic
   sudo mkdir -p /etc/immich-backup
   sudo nano /etc/immich-backup/env
   ```

   Put this in it, with your values:

   ```bash
   export B2_ACCOUNT_ID=<your-keyID>
   export B2_ACCOUNT_KEY=<your-applicationKey>
   export RESTIC_REPOSITORY=b2:<your-bucket>:immich
   export RESTIC_PASSWORD_FILE=/etc/immich-backup/password
   ```

3. Make the encryption password and lock both files down:

   ```bash
   openssl rand -base64 32 | sudo tee /etc/immich-backup/password
   sudo chmod 600 /etc/immich-backup/env /etc/immich-backup/password
   ```

   > [!CAUTION]
   > **Save that password somewhere that isn't this server** (a password manager). Without it, the backup can't be opened by anyone, you included.

4. Create the backup repository and run the first backup (the first one takes a while):

   ```bash
   sudo bash -c 'source /etc/immich-backup/env && restic init'
   sudo bash -c 'source /etc/immich-backup/env && restic backup --tag immich /mnt/photos/immich_upload /mnt/photos/immich-demo'
   sudo bash -c 'source /etc/immich-backup/env && restic snapshots'
   ```

5. Make it nightly with [`scripts/immich-backup.sh`](../scripts/immich-backup.sh) from this repo. Download it, edit the folder paths at the top to match yours, and install it:

   ```bash
   wget https://raw.githubusercontent.com/theNetworkChuck/immich-guide/main/scripts/immich-backup.sh
   nano immich-backup.sh
   sudo install -m 755 immich-backup.sh /usr/local/bin/immich-backup.sh
   echo '30 3 * * * root /usr/local/bin/immich-backup.sh >> /var/log/immich-backup.log 2>&1' | sudo tee /etc/cron.d/immich-backup
   ```

   That runs at 3:30 AM in the server's timezone, after Immich's 2 AM database dump. Check the server is on your local time (`timedatectl`; fix it with `sudo timedatectl set-timezone America/Chicago`, using your zone). It keeps 7 daily, 4 weekly and 12 monthly snapshots. See how last night went with `sudo tail /var/log/immich-backup.log`.

6. **Test a restore.** A backup you've never restored is a guess:

   ```bash
   sudo bash -c 'source /etc/immich-backup/env && restic restore latest --target /tmp/restore-test --include /mnt/photos/immich_upload/backups'
   sudo ls -R /tmp/restore-test | head
   ```

restic's docs also suggest Backblaze's S3-compatible API as an alternative to the `b2:` backend used here; both work ([restic B2 docs](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html#backblaze-b2)). Restic works the same with other destinations: another drive (`RESTIC_REPOSITORY=/mnt/backup/restic`), an SFTP server, S3 and more ([restic docs](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html)).

> [!TIP]
> Restoring Immich onto a new server: put the photo folders back, install Immich (chapter 4), then restore the database dump. Immich's guide: [docs.immich.app/administration/backup-and-restore](https://docs.immich.app/administration/backup-and-restore).

---

[← Smarter search](10-smarter-search.md) · [Next: Bring in Google Photos →](12-google-takeout.md)
