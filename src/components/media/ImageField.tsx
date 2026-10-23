"use client";

import { useEffect, useRef, useState } from "react";
import { ImagePlus, Move, RefreshCw, Trash2, UserRound, ZoomIn } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { Modal } from "@/components/ui/Modal";
import { useToast } from "@/components/ui/Toast";
import { MEDIA_INPUT_TYPES, MEDIA_MAX_BYTES, MEDIA_MAX_INPUT_BYTES } from "@/lib/media-shared";

export type Aspect = "portrait" | "square";
const OUT: Record<Aspect, { w: number; h: number }> = { portrait: { w: 600, h: 750 }, square: { w: 640, h: 640 } };

/** Moldura holográfica (azul) ou corrompida (forma Lenda). */
export function HoloFrame({
  url,
  alt,
  aspect = "portrait",
  variant = "holo",
  className = "",
  fallback,
}: {
  url: string | null;
  alt: string;
  aspect?: Aspect;
  variant?: "holo" | "corrupted";
  className?: string;
  fallback?: React.ReactNode;
}) {
  return (
    <div className={`holo-frame ${variant === "corrupted" ? "holo-frame-corrupted" : ""} ${aspect === "portrait" ? "aspect-[4/5]" : "aspect-square"} ${className}`}>
      {url ? (
        // eslint-disable-next-line @next/next/no-img-element
        <img src={url} alt={alt} className="h-full w-full object-cover" loading="lazy" draggable={false} />
      ) : (
        <div className="flex h-full w-full items-center justify-center bg-panel-3/70 text-fg-muted">{fallback ?? <UserRound className="h-1/3 w-1/3" aria-hidden />}</div>
      )}
      <span className="holo-frame-corner tl" aria-hidden />
      <span className="holo-frame-corner br" aria-hidden />
    </div>
  );
}

/**
 * Campo de imagem: escolher arquivo → recortar/enquadrar → enviar.
 * O componente só produz o arquivo final (WebP comprimido); quem usa decide o caminho e grava a referência.
 */
export function ImageField({
  url,
  label,
  aspect = "portrait",
  variant = "holo",
  disabled,
  onUpload,
  onRemove,
  compact,
}: {
  url: string | null;
  label: string;
  aspect?: Aspect;
  variant?: "holo" | "corrupted";
  disabled?: boolean;
  onUpload: (blob: Blob, ext: "webp" | "jpg" | "png") => Promise<boolean>;
  onRemove?: () => Promise<void> | void;
  compact?: boolean;
}) {
  const toast = useToast();
  const input = useRef<HTMLInputElement | null>(null);
  const [src, setSrc] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  function pick(file: File | undefined) {
    if (!file) return;
    if (!(MEDIA_INPUT_TYPES as readonly string[]).includes(file.type)) return toast("Use PNG, JPG ou WebP.", "error");
    if (file.size > MEDIA_MAX_INPUT_BYTES) return toast("Arquivo grande demais (máx. 15 MB).", "error");
    setSrc(URL.createObjectURL(file));
  }

  return (
    <div className={compact ? "flex items-center gap-3" : "space-y-2"}>
      <div className={compact ? "w-20 shrink-0" : "mx-auto w-full max-w-[14rem]"}>
        <HoloFrame url={url} alt={label} aspect={aspect} variant={variant} />
      </div>
      <div className={`flex flex-wrap gap-2 ${compact ? "" : "justify-center"}`}>
        <input
          ref={input}
          type="file"
          accept={MEDIA_INPUT_TYPES.join(",")}
          className="sr-only"
          aria-label={label}
          onChange={(e) => {
            pick(e.target.files?.[0]);
            e.target.value = "";
          }}
        />
        <Button type="button" size="sm" variant="secondary" disabled={disabled || busy} onClick={() => input.current?.click()}>
          {url ? <RefreshCw className="h-3.5 w-3.5" aria-hidden /> : <ImagePlus className="h-3.5 w-3.5" aria-hidden />} {url ? "Substituir" : "Enviar imagem"}
        </Button>
        {url && onRemove && (
          <Button
            type="button"
            size="sm"
            variant="ghost"
            disabled={disabled || busy}
            onClick={async () => {
              setBusy(true);
              await onRemove();
              setBusy(false);
            }}
          >
            <Trash2 className="h-3.5 w-3.5" aria-hidden /> Remover
          </Button>
        )}
      </div>
      {src && (
        <Cropper
          src={src}
          aspect={aspect}
          title={label}
          onCancel={() => {
            URL.revokeObjectURL(src);
            setSrc(null);
          }}
          onDone={async (blob, ext) => {
            setBusy(true);
            const ok = await onUpload(blob, ext);
            setBusy(false);
            if (ok) {
              URL.revokeObjectURL(src);
              setSrc(null);
            }
            return ok;
          }}
        />
      )}
    </div>
  );
}

function canvasBlob(canvas: HTMLCanvasElement, type: string, q: number): Promise<Blob | null> {
  return new Promise((r) => canvas.toBlob((b) => r(b), type, q));
}

function Cropper({ src, aspect, title, onCancel, onDone }: { src: string; aspect: Aspect; title: string; onCancel: () => void; onDone: (b: Blob, ext: "webp" | "jpg" | "png") => Promise<boolean> }) {
  const toast = useToast();
  const frame = useRef<HTMLDivElement | null>(null);
  const [img, setImg] = useState<HTMLImageElement | null>(null);
  const [zoom, setZoom] = useState(1);
  const [off, setOff] = useState({ x: 0, y: 0 });
  const [box, setBox] = useState({ w: 280, h: aspect === "portrait" ? 350 : 280 });
  const drag = useRef<{ x: number; y: number; ox: number; oy: number } | null>(null);
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    const i = new Image();
    i.onload = () => setImg(i);
    i.onerror = () => toast("Não foi possível ler esta imagem.", "error");
    i.src = src;
  }, [src, toast]);
  useEffect(() => {
    const el = frame.current;
    if (!el) return;
    const w = el.clientWidth;
    setBox({ w, h: aspect === "portrait" ? Math.round((w * 5) / 4) : w });
  }, [aspect, img]);

  const base = img ? Math.max(box.w / img.naturalWidth, box.h / img.naturalHeight) : 1;
  const scale = base * zoom;
  const dw = img ? img.naturalWidth * scale : 0;
  const dh = img ? img.naturalHeight * scale : 0;
  const clamp = (o: { x: number; y: number }) => ({ x: Math.min(0, Math.max(box.w - dw, o.x)), y: Math.min(0, Math.max(box.h - dh, o.y)) });
  // Centraliza quando a imagem carrega ou o zoom muda.
  useEffect(() => {
    if (!img) return;
    setOff((o) => clamp(o.x === 0 && o.y === 0 ? { x: (box.w - dw) / 2, y: (box.h - dh) / 2 } : o));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [img, zoom, box.w, box.h]);

  async function confirm() {
    if (!img) return;
    setSaving(true);
    const out = OUT[aspect];
    const canvas = document.createElement("canvas");
    canvas.width = out.w;
    canvas.height = out.h;
    const ctx = canvas.getContext("2d");
    if (!ctx) {
      setSaving(false);
      return toast("Seu navegador não conseguiu recortar a imagem.", "error");
    }
    ctx.imageSmoothingQuality = "high";
    ctx.drawImage(img, -off.x / scale, -off.y / scale, box.w / scale, box.h / scale, 0, 0, out.w, out.h);
    let blob: Blob | null = null;
    let ext: "webp" | "jpg" | "png" = "webp";
    for (const q of [0.86, 0.75, 0.6]) {
      blob = await canvasBlob(canvas, "image/webp", q);
      if (blob && blob.type !== "image/webp") {
        // Navegador sem WebP: usa JPEG.
        blob = await canvasBlob(canvas, "image/jpeg", q);
        ext = "jpg";
      }
      if (blob && blob.size <= MEDIA_MAX_BYTES) break;
    }
    if (!blob || blob.size > MEDIA_MAX_BYTES) {
      setSaving(false);
      return toast("Não foi possível reduzir a imagem para 2 MB.", "error");
    }
    await onDone(blob, ext);
    setSaving(false);
  }

  return (
    <Modal open onClose={onCancel} title={title} tag="Recorte" size="md">
      <div className="space-y-4">
        <div
          ref={frame}
          className="holo-frame relative mx-auto w-full max-w-xs cursor-grab touch-none overflow-hidden select-none active:cursor-grabbing"
          style={{ height: box.h }}
          onPointerDown={(e) => {
            (e.currentTarget as HTMLElement).setPointerCapture(e.pointerId);
            drag.current = { x: e.clientX, y: e.clientY, ox: off.x, oy: off.y };
          }}
          onPointerMove={(e) => {
            if (!drag.current) return;
            setOff(clamp({ x: drag.current.ox + e.clientX - drag.current.x, y: drag.current.oy + e.clientY - drag.current.y }));
          }}
          onPointerUp={() => (drag.current = null)}
          onPointerCancel={() => (drag.current = null)}
          role="img"
          aria-label="Prévia do recorte: arraste para reposicionar"
        >
          {img && (
            // eslint-disable-next-line @next/next/no-img-element
            <img src={src} alt="" draggable={false} className="pointer-events-none absolute max-w-none" style={{ width: dw, height: dh, left: off.x, top: off.y }} />
          )}
          <span className="holo-frame-corner tl" aria-hidden />
          <span className="holo-frame-corner br" aria-hidden />
        </div>
        <label className="flex items-center gap-3 text-xs text-fg-dim">
          <ZoomIn className="h-4 w-4 shrink-0" aria-hidden />
          <input type="range" min={1} max={4} step={0.01} value={zoom} onChange={(e) => setZoom(Number(e.target.value))} className="w-full accent-[var(--color-cyan)]" aria-label="Zoom" />
        </label>
        <p className="flex items-center gap-1.5 text-xs text-fg-muted">
          <Move className="h-3.5 w-3.5" aria-hidden /> Arraste para ajustar o enquadramento. A imagem é salva sem esticar ({OUT[aspect].w}×{OUT[aspect].h}).
        </p>
        <div className="flex justify-end gap-2">
          <Button type="button" variant="ghost" onClick={onCancel} disabled={saving}>
            Cancelar
          </Button>
          <Button type="button" onClick={confirm} loading={saving} disabled={!img}>
            Usar imagem
          </Button>
        </div>
      </div>
    </Modal>
  );
}
