# 5. First login and your photos

▶ Video: 10:38 · [← Install Immich](04-install-immich.md) · [Next: Back up your phone →](06-phone-backup.md)

## Create the admin account

1. In a browser on your network, open `http://<server-ip>:2283`.
2. Click **Getting Started** and create your account. The first account is the admin.
3. Log in, then click through the setup:
   - **Theme:** dark mode, obviously.
   - **Server privacy:** map data and version checks are your call. Immich asks before it talks to anyone. Turning map data off also turns off the **Map** view.
   - **Google Cast:** off, unless you cast photos to a TV with Chromecast.
   - **Storage template:** turn it on if you want new uploads organized into folders by year and month on the drive.
   - **Backups:** Immich reminds you to have a backup plan. That's [chapter 11](11-backups.md).

The timeline is empty. Immich doesn't know about your old photos yet.

## Add the photos you already have (External Library)

1. Click your profile picture (top right) → **Administration**.
2. In the left menu, **External Libraries** → **Create Library**. Owner: you. Create it.
3. Open the new library and **Add** a folder. The path is the **right side** of the line you added in chapter 4: `/mnt/media/usb`. Not the server path.
4. Click **Scan**.

Photos start appearing in the timeline within seconds.

## Watch it work

**Administration → Job Queues** shows what Immich is doing in the background: generating thumbnails, extracting metadata (dates, places), face detection, smart search, and converting videos so they play in a browser.

Without a GPU this is the slow part, and video conversion is the slowest. On a 4-core test machine with no GPU, about 80 photos and videos showed up in under a minute, thumbnails and faces took about 3 minutes, and 57 videos took about 40 minutes to convert. Let it run.

> [!TIP]
> Videos show an error until they've been converted. Refresh later.

## Turn on Memories and People in the sidebar

Profile picture → **Account Settings**:

- **Features → Memories:** "on this day" photos from past years.
- **Features → People:** show People in the sidebar.

Save. Open **People** and you'll see faces grouped by person. Click one, give them a name, and every photo of them is one click away. It finds people in videos too.

---

[← Install Immich](04-install-immich.md) · [Next: Back up your phone →](06-phone-backup.md)
