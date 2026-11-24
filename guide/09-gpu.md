# 9. Give Immich your NVIDIA GPU

▶ Video: 17:36 · [← Add a NAS](08-add-a-nas.md) · [Next: Smarter search →](10-smarter-search.md)

Optional. Immich works fine on the CPU. A GPU makes two things much faster: the AI jobs (smart search, faces, reading text) and video conversion. It matters most on a big library and with the bigger search model in [chapter 10](10-smarter-search.md).

This chapter is for **NVIDIA** cards (GTX 900 series or newer). Intel and AMD: see Immich's [hardware transcoding](https://docs.immich.app/features/hardware-transcoding) and [ML hardware acceleration](https://docs.immich.app/features/ml-hardware-acceleration) docs; the shape is the same with a different `service:` name.

Why there are two installs: after the driver, Ubuntu can see the GPU, but containers can't. The NVIDIA Container Toolkit is what lets Docker hand the GPU to a container.

Stop Immich first:

```bash
cd ~/immich-app
docker compose down
```

## Step 1: The NVIDIA driver

```bash
sudo ubuntu-drivers install
sudo reboot
```

After the reboot:

```bash
nvidia-smi
```

You should see your card, the driver version and the CUDA version. (The video: RTX 3070, 8 GB, driver 595.99.02, CUDA 13.2.)

> [!IMPORTANT]
> **Secure Boot on?** The driver install may ask you to set a password. After the reboot a blue **MOK management** screen appears: choose **Enroll MOK**, then type that password. Skip it and the driver won't load (`nvidia-smi` says it can't communicate with the driver).

## Step 2: The NVIDIA Container Toolkit

NVIDIA's own steps ([docs.nvidia.com](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)):

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt update
sudo apt install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

Prove Docker can see the GPU:

```bash
docker run --rm --gpus all ubuntu nvidia-smi
```

Same table as before, from inside a container.

## Step 3: Hand the GPU to Immich

Download Immich's two add-on files:

```bash
cd ~/immich-app
wget https://github.com/immich-app/immich/releases/latest/download/hwaccel.ml.yml
wget https://github.com/immich-app/immich/releases/latest/download/hwaccel.transcoding.yml
```

```bash
nano docker-compose.yml
```

**Video conversion on the GPU.** In `immich-server`, replace the three commented `# extends:` lines with:

```yaml
    extends:
      file: hwaccel.transcoding.yml
      service: nvenc
```

**AI on the GPU.** In `immich-machine-learning`, add `-cuda` to the end of the `image:` line:

```yaml
    image: ghcr.io/immich-app/immich-machine-learning:${IMMICH_VERSION:-release}-cuda
```

and replace its three commented `# extends:` lines with:

```yaml
    extends:
      file: hwaccel.ml.yml
      service: cuda
```

Check and start:

```bash
docker compose config --quiet
docker compose up -d
```

If `config` says `mapping values are not allowed`, the spacing is off: `extends:` sits 4 spaces in, `file:` and `service:` 6 spaces in.

Your photos, faces and settings stay. You don't need to redo any jobs.

## Step 4: Turn on hardware transcoding in Immich

The compose file gave Immich the GPU, but video conversion stays on the CPU until you flip it:

**Administration → Settings → Video Transcoding Settings → Hardware Acceleration → Acceleration API: NVENC** → Save.

To watch it work, run this while a video converts (upload one, or **Job Queues → Transcode videos → All**):

```bash
watch -n 5 nvidia-smi
```

You'll see `ffmpeg` (video) and `python` (the AI) in the process list.

---

[← Add a NAS](08-add-a-nas.md) · [Next: Smarter search →](10-smarter-search.md)
