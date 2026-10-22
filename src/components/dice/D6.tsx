"use client";

import { motion, useReducedMotion } from "motion/react";

/** Rotação que deixa a face `value` voltada para a frente. */
const FACE_ROTATION: Record<number, { x: number; y: number }> = {
  1: { x: 0, y: 0 },
  2: { x: -90, y: 0 },
  3: { x: 0, y: -90 },
  4: { x: 0, y: 90 },
  5: { x: 90, y: 0 },
  6: { x: 0, y: 180 },
};

const FACES: { value: number; transform: (h: number) => string }[] = [
  { value: 1, transform: (h) => `translateZ(${h}px)` },
  { value: 6, transform: (h) => `rotateY(180deg) translateZ(${h}px)` },
  { value: 3, transform: (h) => `rotateY(90deg) translateZ(${h}px)` },
  { value: 4, transform: (h) => `rotateY(-90deg) translateZ(${h}px)` },
  { value: 2, transform: (h) => `rotateX(90deg) translateZ(${h}px)` },
  { value: 5, transform: (h) => `rotateX(-90deg) translateZ(${h}px)` },
];

// Posições dos pips numa grade 3×3 (0..8).
const PIPS: Record<number, number[]> = {
  1: [4],
  2: [2, 6],
  3: [2, 4, 6],
  4: [0, 2, 6, 8],
  5: [0, 2, 4, 6, 8],
  6: [0, 2, 3, 5, 6, 8],
};

function Face({ value, transform, size, dim }: { value: number; transform: string; size: number; dim: boolean }) {
  return (
    <div
      className={`absolute inset-0 grid grid-cols-3 grid-rows-3 rounded-[16%] border p-[14%] ${
        dim ? "border-line bg-panel-3/95" : "border-holo/80 bg-panel/95 shadow-[inset_0_0_14px_rgb(72_199_255/0.35),0_0_10px_rgb(72_199_255/0.25)]"
      }`}
      style={{ transform, backfaceVisibility: "hidden", width: size, height: size }}
    >
      {Array.from({ length: 9 }, (_, i) => (
        <span key={i} className="flex items-center justify-center">
          {PIPS[value].includes(i) && (
            <span className={`block h-[62%] w-[62%] rounded-full ${dim ? "bg-fg-muted/60" : value === 1 ? "bg-holo shadow-[0_0_6px_var(--color-holo)]" : "bg-cyan shadow-[0_0_5px_var(--color-cyan)]"}`} />
          )}
        </span>
      ))}
    </div>
  );
}

interface D6Props {
  /** Valor definido pelo servidor ANTES da animação; a animação nunca o altera. */
  value: number;
  /** Muda a cada nova rolagem para reiniciar a animação. */
  rollKey: string;
  animate: boolean;
  delay?: number;
  size?: number;
  dim?: boolean;
  onSettled?: () => void;
}

export function D6({ value, rollKey, animate, delay = 0, size = 44, dim = false, onSettled }: D6Props) {
  const reduce = useReducedMotion();
  const target = FACE_ROTATION[value] ?? FACE_ROTATION[1];
  const spin = !reduce && animate;
  // Voltas extras determinísticas por rolagem (só visual).
  const seed = [...rollKey].reduce((a, c) => a + c.charCodeAt(0), 0) + delay * 1000;
  const turnsX = 2 + (seed % 2);
  const turnsY = 2 + ((seed >> 1) % 2);
  const h = size / 2;

  return (
    <div style={{ perspective: size * 8, width: size, height: size }} role="img" aria-label={`Dado de seis faces: ${value}`}>
      <motion.div
        key={rollKey}
        className="relative h-full w-full"
        style={{ transformStyle: "preserve-3d" }}
        initial={spin ? { rotateX: target.x - 360 * turnsX, rotateY: target.y + 360 * turnsY, y: -18, scale: 0.85 } : false}
        animate={{ rotateX: target.x, rotateY: target.y, y: 0, scale: 1 }}
        transition={spin ? { duration: 1.05, delay, ease: [0.15, 0.85, 0.3, 1] } : { duration: 0 }}
        onAnimationComplete={onSettled}
      >
        {FACES.map((f) => (
          <Face key={f.value} value={f.value} transform={f.transform(h)} size={size} dim={dim} />
        ))}
      </motion.div>
    </div>
  );
}
