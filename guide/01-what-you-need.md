# 1. What you need

▶ Video: 1:30 · [Next: Ubuntu Server and Docker →](02-ubuntu-and-docker.md)

Three questions, answered before you type anything.

## 1. Where will your photos live?

Somewhere you can hold. Any of these works:

| Option | Good for | Notes |
|---|---|---|
| **An external hard drive** | Most people, and the video | Plug it into the Immich computer. More photos than one drive holds? Get a few. |
| **A NAS** (network-attached storage) | Big libraries, several drives | Shared to the Immich computer over the network. See [chapter 8](08-add-a-nas.md). |
| **The Immich computer's own disk** | Small libraries | Simplest, but your photos and the server die together. |

Whatever you pick, plan for a second copy somewhere else. That's [chapter 11](11-backups.md).

> [!TIP]
> **Photos that only live in Google Photos?** Request your Google Takeout now ([chapter 12](12-google-takeout.md), step 1). Google takes hours to days to prepare it, so it'll be ready by the time Immich is.

> [!IMPORTANT]
> Don't reformat a drive that already has your photos on it. That erases them. Linux reads exFAT and NTFS drives fine. Starting with an empty drive? Format it ext4, which is what Immich recommends.

## 2. What will run Immich?

Immich's own minimum ([docs.immich.app/install/requirements](https://docs.immich.app/install/requirements)):

| | Minimum | Recommended |
|---|---|---|
| OS | 64-bit Linux | Ubuntu or Debian |
| CPU | 2 cores | 4 cores |
| RAM | 6 GB | 8 GB |
| Database disk | SSD, local | SSD, local (never a network share) |
| Software | Docker with Docker Compose | |
| GPU | not needed | NVIDIA, Intel or AMD makes the AI and video conversion faster |

Good homes for it:

- **A spare laptop or desktop.** The video uses an old gaming laptop with an RTX 3070. That's more than you need.
- **A VM** on Proxmox or similar. Set the VM's CPU type to `host` (Immich's AI container needs the x86-64-v2 feature set), and pass your GPU through if you want to use it.
- **An app on your NAS.** TrueNAS, ZimaOS, Unraid and others have an Immich app. If you go that way, skip to [chapter 5](05-first-login-and-your-photos.md); chapters 2 to 4 are what that app does for you.

> [!NOTE]
> Windows and macOS can run Immich through Docker Desktop, but Immich's docs say non-Linux systems tend to give a poor experience. This guide uses Ubuntu Server.

## 3. How will you reach it from anywhere?

At home your phone talks to Immich directly. Away from home it can't, because the server is only on your home network. [Chapter 7](07-twingate.md) fixes that with Twingate, without opening a port on your router.

---

[Next: Ubuntu Server and Docker →](02-ubuntu-and-docker.md)
