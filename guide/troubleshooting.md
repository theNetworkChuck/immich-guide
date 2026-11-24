# Troubleshooting

[← Back to the path](../README.md#the-path)

First stop for almost anything: what is Immich saying?

```bash
cd ~/immich-app
docker compose ps
docker compose logs --tail 50 immich-server
```

| Symptom | Likely cause | Fix |
|---|---|---|
| `permission denied while trying to connect to the Docker daemon socket` | You haven't logged out since `usermod -aG docker` | `exit`, SSH back in (chapter 2) |
| `/etc/fstab` has only one line in it | `tee` without `-a` replaced the whole file | **Don't reboot.** Ubuntu keeps no automatic copy, and without its root and boot lines it won't start. Rebuild them with `sudo nano /etc/fstab` from the UUIDs in `lsblk -f` (the partitions mounted at `/`, `/boot` and `/boot/efi`), then `sudo mount -a` must run with no errors before you reboot. |
| `ls /mnt/photos` is empty after a reboot | The drive wasn't plugged in at boot (`nofail` let it boot anyway) | Plug it in, `sudo mount -a`, `sudo systemctl start docker` |
| Docker or Immich won't start after a reboot | The wait rule is holding Docker until the drive (or NAS) is mounted, which is on purpose | Same as above. Check with `systemctl status docker` |
| `mount -a` hangs for minutes (NAS) | Wrong NAS IP or share path, or the NAS doesn't allow this server | Ctrl+C, check both on the NAS's admin page, and that the share is exported to this server's IP |
| `mapping values are not allowed` from `docker compose config` | YAML spacing | Spaces, not tabs; `- ` lines line up; `extends:` 4 spaces in, `file:`/`service:` 6 |
| `immich_server` keeps restarting; logs say `Failed to read ... /.immich` | `UPLOAD_LOCATION` points at a different (or empty, or unmounted) folder than the one Immich first started with. Immich checks for its marker files there at every start ([folder checks](https://docs.immich.app/administration/system-integrity#folder-checks)) | Point `UPLOAD_LOCATION` back, or move the old upload folder's contents to the new place, then `docker compose up -d`. Drive not mounted? `sudo mount -a`. |
| External Library scan finds nothing | You typed the server path instead of the container path | Use the right side of the compose line: `/mnt/media/usb`, not `/mnt/photos/...` |
| Videos show an error in the web page | Not converted yet | Wait for **Job Queues → Transcode videos** to finish, then refresh |
| Phone app: "server not reachable" | Missing `http://` or `:2283`, or the phone is off your Wi-Fi | `http://<server-ip>:2283`. Away from home, Twingate must be on (chapter 7) |
| `nvidia-smi`: "couldn't communicate with the NVIDIA driver" | Secure Boot blocked the driver | Reinstall the driver, reboot, choose **Enroll MOK** on the blue screen and enter the password you set |
| `docker run --gpus all ...` fails: `could not select device driver` | Container Toolkit not hooked into Docker | `sudo nvidia-ctk runtime configure --runtime=docker && sudo systemctl restart docker` |
| AI container fails on a Proxmox VM | VM CPU type lacks x86-64-v2 | Set the VM's CPU type to `host` |
| Search results are bad | The default model | [Chapter 10](10-smarter-search.md): swap the model, then **Job Queues → Smart Search → All** |

Still stuck? Immich's [FAQ](https://docs.immich.app/FAQ) and [Discord](https://discord.immich.app) are excellent.
