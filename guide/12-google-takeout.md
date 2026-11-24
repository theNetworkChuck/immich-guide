# 12. Bring in Google Photos

▶ Video: 4:57 · [← Back it up](11-backups.md) · [Back to the path](../README.md#the-path)

If Google Photos has photos you don't have anywhere else (your phone freed up space by deleting its copies, or they came from an old phone), you have to get them out of Google first. Google's way out is **Google Takeout**. The way in to Immich is [`immich-go`](https://github.com/simulot/immich-go), which reads Takeout's files *and* the dates, places and albums Google stores beside them.

> [!TIP]
> **iPhone and iCloud people:** you may not need this. With "Download and Keep Originals" on in iCloud Photos settings, the Immich phone app backs up everything on the phone, full size (chapter 6).

## Step 1: Request your Takeout

1. Go to [takeout.google.com](https://takeout.google.com).
2. **Deselect all**, then tick only **Google Photos**.
3. Next step: **Export once**, file type **.zip**, and the biggest file size (50 GB) so there are fewer files.
4. **Create export.**

It takes hours to days. Google emails you when it's ready, and the download links expire after about a week. Download every zip.

## Step 2: Make an API key

In Immich: profile picture → **Account Settings → API Keys → New API Key**. Give it a name and **all** permissions (immich-go uploads, makes albums, and pauses Immich's background jobs while it works). Copy the key.

## Step 3: Get immich-go

Run immich-go on **the computer that downloaded the zips** (Mac, Windows or Linux). It uploads to your Immich server over the network, so you don't have to copy gigabytes of zips onto the server first.

Download the file for that computer from the [immich-go releases page](https://github.com/simulot/immich-go/releases/latest): `immich-go_Darwin_arm64.tar.gz` for an Apple Silicon Mac, `immich-go_Windows_x86_64.zip` for Windows, `immich-go_Linux_x86_64.tar.gz` for Linux. Unpack it, open a terminal in that folder, and check it:

```bash
./immich-go --version
```

(Windows: `.\immich-go.exe --version`. Mac: if macOS blocks it, run `xattr -d com.apple.quarantine immich-go` once.)

## Step 4: Upload

Point it at your downloaded zips. You don't need to unzip them.

Try it first with `--dry-run`, which shows what it would do and uploads nothing:

```bash
./immich-go upload from-google-photos --server=http://<server-ip>:2283 --api-key=<your-api-key> --dry-run ~/Downloads/takeout-*.zip
```

Then for real:

```bash
./immich-go upload from-google-photos --server=http://<server-ip>:2283 --api-key=<your-api-key> ~/Downloads/takeout-*.zip
```

It shows a progress screen and finishes with a summary (`uploaded successfully: N`). Uploaded photos land in your upload folder like phone backups, with Google's dates, and your Google albums become Immich albums.

Useful flags (`./immich-go upload from-google-photos --help` lists them all):

| Flag | What it does |
|---|---|
| `--dry-run` | Show what would happen, upload nothing |
| `--no-ui` | Plain text output instead of the progress screen (good over a flaky SSH session) |
| `--from-album-name "<album>"` | Only one album |
| `--date-range 2019-01-01,2019-12-31` | Only photos from those dates |
| `--include-partner=false` | Skip photos shared to you by a partner account |

Run it again later with the same files and it skips what's already there. Once everything is in Immich (and in your backups), you can delete the zips.

> [!NOTE]
> Tested with immich-go v0.32.0 against Immich v3.4.2: from a Mac to the server over the network with a Takeout-shaped `.zip` (2 of 2 uploaded, and a second run uploaded 0, skipping the duplicates), and on the Linux server itself with an unzipped folder (3 of 3). A real multi-gigabyte Takeout from Google was not part of the test.

---

[← Back it up](11-backups.md) · [Back to the path](../README.md#the-path)
