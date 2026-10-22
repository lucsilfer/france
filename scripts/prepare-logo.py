"""
Prepara o logotipo oficial do F.R.A.N.C.E a partir do arquivo enviado (sem redesenhar).
- Remove APENAS o fundo branco externo (região branca conectada à borda da imagem);
  os brancos internos do desenho (olhos, linhas, recortes) são preservados.
- Gera uma versão "contorno" com borda branca, para fundos escuros.
Uso: python3 scripts/prepare-logo.py caminho/para/logo.png
"""
import sys
import numpy as np
from PIL import Image
from scipy import ndimage

src = sys.argv[1]
out = sys.argv[2] if len(sys.argv) > 2 else "public/brand"
im = Image.open(src).convert("RGB")
im.save(f"{out}/france-logo-original.png")
rgb = np.asarray(im).astype(np.float32)
minc = rgb.min(axis=2)

# 1) Fundo = pixels claros conectados à borda
light = minc > 200
labels, _ = ndimage.label(light)
border = set(np.unique(np.concatenate([labels[0], labels[-1], labels[:, 0], labels[:, -1]]))) - {0}
bg = np.isin(labels, list(border))

# 2) Borda suave: pixels próximos ao fundo recebem alfa proporcional ao quão escuros são
near = ndimage.binary_dilation(bg, iterations=2) & ~bg
alpha = np.where(bg, 0.0, 1.0)
a_near = np.clip((255 - minc) / 200.0, 0, 1)
alpha = np.where(near, a_near, alpha)
# "Despremultiplica" o branco das bordas para não deixar halo claro
a_safe = np.maximum(alpha, 1e-3)[..., None]
fg = np.clip((rgb - (1 - alpha[..., None]) * 255.0) / a_safe, 0, 255)
fg = np.where(near[..., None], fg, rgb)
rgba = np.dstack([fg, alpha * 255]).astype(np.uint8)
logo = Image.fromarray(rgba, "RGBA")

# 3) Recorte com margem
ys, xs = np.where(alpha > 0.02)
pad = 24
box = (max(xs.min() - pad, 0), max(ys.min() - pad, 0), min(xs.max() + pad, rgb.shape[1]), min(ys.max() + pad, rgb.shape[0]))
logo_c = logo.crop(box)
logo_c.save(f"{out}/france-logo.png", optimize=True)

# 4) Versão com contorno branco (silhueta preenchida + dilatação), para fundos escuros
sil = ~bg
sil = ndimage.binary_fill_holes(sil)
yy, xx = np.ogrid[-9:10, -9:10]
disk = (xx * xx + yy * yy) <= 81
outline = ndimage.binary_dilation(sil, structure=disk)
# suaviza o contorno
outline_f = ndimage.gaussian_filter(outline.astype(np.float32), 1.2)
base = np.zeros_like(rgba)
base[..., :3] = 255
base[..., 3] = np.clip(outline_f * 255, 0, 255).astype(np.uint8)
sticker = Image.alpha_composite(Image.fromarray(base, "RGBA"), logo)
pad2 = 8
ys2, xs2 = np.where(outline_f > 0.02)
box2 = (max(xs2.min() - pad2, 0), max(ys2.min() - pad2, 0), min(xs2.max() + pad2, rgb.shape[1]), min(ys2.max() + pad2, rgb.shape[0]))
sticker = sticker.crop(box2)
sticker.save(f"{out}/france-logo-contorno.png", optimize=True)

def square(img, size):
    w, h = img.size
    s = max(w, h)
    canvas = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    canvas.paste(img, ((s - w) // 2, (s - h) // 2))
    return canvas.resize((size, size), Image.LANCZOS)

for size in (512, 256, 96):
    square(sticker, size).save(f"{out}/france-logo-contorno-{size}.png", optimize=True)
square(logo_c, 512).save(f"{out}/france-logo-512.png", optimize=True)
square(sticker, 64).save("src/app/icon.png", optimize=True)
square(sticker, 180).save("src/app/apple-icon.png", optimize=True)
print("ok", logo_c.size, sticker.size)
