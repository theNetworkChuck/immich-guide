# Family accounts and the API

▶ Video: 20:18 and 22:42 · [← Back to the path](../README.md#the-path)

## One account each, or one shared family account?

Immich supports multiple users (**Administration → Users → Create user**). Each user gets their own timeline, uploads and face names, and nobody sees anyone else's photos unless they share an album or turn on **Partner Sharing** (Account Settings → Partner Sharing).

That's great for privacy, but it means the names you give faces and the people you find in search are per user. The video's family takes the other route: **one shared family account** that every phone logs in to, so there's one library, one set of named faces, and one search. Pick what fits your house:

| | Separate accounts | One family account |
|---|---|---|
| Who sees what | Only your own, plus what's shared | Everyone sees everything |
| Face names | Each person names their own | Named once for the family |
| Good for | Teens, adults who want privacy | A family that already shares everything |

## The API: build Immich into your own stuff

Immich has a full REST API ([api.immich.app](https://api.immich.app)), which is how the video's family portal shows "on this day" photos on a kitchen screen.

1. Profile picture → **Account Settings → API Keys → New API Key.**
2. Give it a name and only the permissions it needs. Something that only shows photos needs read permissions (for the two calls below: `server.about` and `album.read`), never delete.
3. Copy the key (it's shown once).

Try it:

```bash
curl -s -H "x-api-key: <your-api-key>" http://<server-ip>:2283/api/server/about
curl -s -H "x-api-key: <your-api-key>" http://<server-ip>:2283/api/albums
```

> [!CAUTION]
> An API key is a password to your photos. Keep it on the server side of whatever you build; never put it in a web page's JavaScript, where any visitor can read it.

---

[← Back to the path](../README.md#the-path)
