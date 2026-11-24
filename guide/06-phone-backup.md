# 6. Back up your phone

▶ Video: 13:46 · [← First login and your photos](05-first-login-and-your-photos.md) · [Next: Access from anywhere →](07-twingate.md)

Your old photos are in. Now the phone: every new photo and video goes to your server on its own, the way Google Photos and iCloud do.

## Connect the app

1. Install **Immich** from the App Store or Google Play.
2. Server URL: `http://<server-ip>:2283` (the `http://` and the `:2283` both matter).
3. Log in with the account you made in chapter 5.
4. Allow access to your photos. That only lets the app *see* them; nothing uploads yet.

You can already scroll everything on the server from the phone.

## Turn on backup

1. Tap the **cloud icon** (top right).
2. **Select albums** to back up. It isn't all-or-nothing: pick the albums you want. Recents (or All Photos on Android) is everything.
3. **Enable backup.**

Take a photo, then open the web page on your computer. It shows up in the timeline within moments. It's a real file on your drive too:

```bash
sudo find /mnt/photos/immich_upload -type f -mmin -5
```

> [!TIP]
> **iPhone:** leave Background App Refresh on for Immich so it keeps backing up when the app is closed. iOS decides when that runs, so for the first big backup keep the app open and the phone plugged in.

## Why it stops working when you leave the house

Turn Wi-Fi off and try to open a video. It won't play. The thumbnails you see are cached; the server is only on your home network, and nothing has been opened to the internet. The next chapter fixes that.

---

[← First login and your photos](05-first-login-and-your-photos.md) · [Next: Access from anywhere →](07-twingate.md)
