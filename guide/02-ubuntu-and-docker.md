# 2. Ubuntu Server and Docker

▶ Video: 3:29 · [← What you need](01-what-you-need.md) · [Next: Connect your hard drive →](03-connect-your-drive.md)

## Install Ubuntu Server

1. Download **Ubuntu Server 26.04 LTS** from [ubuntu.com/download/server](https://ubuntu.com/download/server).
2. Flash it to a USB stick with [balenaEtcher](https://etcher.balena.io) (or [Rufus](https://rufus.ie) on Windows).
3. Plug the stick into the Immich computer, power on, and open the boot menu (usually Esc, F2, F8 or F12 at power-on; it depends on the maker). Pick the USB stick.
4. Click through the installer. Three screens matter:
   - **Storage:** the default LVM layout gives Ubuntu only part of the disk. On the storage summary, edit `ubuntu-lv` and set it to the full size. (Missed it? Fix it later with `sudo lvextend -r -l +100%FREE /dev/ubuntu-vg/ubuntu-lv`.)
   - **SSH:** tick **Install OpenSSH server** so you can log in from your main computer. You can import your SSH keys from GitHub on the same screen.
   - **Your user:** remember the username and password.
5. Reboot, log in at the keyboard once, and find the IP address:

```bash
ip -br addr
```

Look for the address on your network card (something like `192.168.1.50`).

> [!TIP]
> Give the server a fixed address. The easiest way is a DHCP reservation in your router's settings. Your phone app points at this address, so it should never change.

### Laptop? Don't let the lid put it to sleep

```bash
sudo mkdir -p /etc/systemd/logind.conf.d
printf '[Login]\nHandleLidSwitch=ignore\nHandleLidSwitchExternalPower=ignore\n' | sudo tee /etc/systemd/logind.conf.d/lid.conf
sudo systemctl restart systemd-logind
```

Leave it plugged in.

## Log in over SSH

From your main computer (Mac, Linux, or Windows Terminal):

```bash
ssh <your-user>@<server-ip>
```

Type `yes` to trust the fingerprint the first time, then your password. Everything from here runs on the server through this SSH session.

## Install Docker

Immich runs as a few Docker containers. Docker's install script sets everything up:

```bash
curl -fsSL https://get.docker.com | sh
```

Let your user run Docker without `sudo`:

```bash
sudo usermod -aG docker $USER
```

Log out and back in so the change takes effect:

```bash
exit
ssh <your-user>@<server-ip>
```

Check it:

```bash
docker run --rm hello-world
```

You should see `Hello from Docker!`.

> [!NOTE]
> **GPU people:** don't install GPU drivers yet. Everything up to the first photos works on the CPU. The GPU comes in [chapter 9](09-gpu.md).

---

[← What you need](01-what-you-need.md) · [Next: Connect your hard drive →](03-connect-your-drive.md)
