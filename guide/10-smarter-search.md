# 10. Smarter search

▶ Video: 18:29 · [← Give Immich your GPU](09-gpu.md) · [Next: Back it up →](11-backups.md)

Immich's smart search lets you type what's *in* a photo ("dog", "soccer ball", "blue shirt") and finds it, with no tags. The default model works, but a bigger one finds the right photo far more often.

| Model | Search accuracy* | Memory it uses |
|---|---|---|
| `ViT-B-32__openai` (default) | 69.9% | about 1 GB |
| `ViT-SO400M-16-SigLIP2-384__webli` (the video's pick) | 86.0% | about 3.9 GB |

\* Recall on Immich's English benchmark (roughly: how often the right photo comes back near the top), from the model table in Immich's [smart search docs](https://docs.immich.app/features/searching). Searching in another language? That page lists the best model per language.

## Swap the model

1. **Administration → Settings → Machine Learning Settings → Smart Search.**
2. In **CLIP model**, replace `ViT-B-32__openai` with:

   ```text
   ViT-SO400M-16-SigLIP2-384__webli
   ```

   (Immich's models live at [huggingface.co/immich-app](https://huggingface.co/immich-app); that page is where the name comes from.)
3. **Save.**
4. **Job Queues → Smart Search → All.** Changing the model means every photo has to be re-indexed.

The machine-learning container downloads the model the first time (a few minutes), then works through your library.

## Do you need a GPU for it?

No, it runs on the CPU, but it needs about **4 GB of free RAM** on top of everything else Immich uses. On an 8 GB machine without a GPU, stay on the default model (or pick a mid-size one from Immich's table). With enough RAM, it's just slower to index: on a 4-core test machine with no GPU it took about 2 seconds per photo, which is fine for a few thousand photos and days for a hundred thousand. With a GPU ([chapter 9](09-gpu.md)) the model runs in the GPU's memory and the re-index is far faster. Searching itself is fast either way once the index is built.

## Also worth a look

- **Reading text in photos** (signs, shirts, documents): same settings page, **OCR**. The default is fast; the `server` variant reads more.
- **Faces:** keep the default `buffalo_l`; Immich's docs say it's typically considered the best. Name a person once in **People**, and every photo of them groups up.

---

[← Give Immich your GPU](09-gpu.md) · [Next: Back it up →](11-backups.md)
