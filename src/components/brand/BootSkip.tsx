"use client";

import { useEffect } from "react";

function finish() {
  document.documentElement.setAttribute("data-boot", "done");
}

/** Botão "Pular" + tecla Esc. Também encerra a camada ao fim da animação. */
export function BootSkip() {
  useEffect(() => {
    if (document.documentElement.getAttribute("data-boot") === "done") return;
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape" || e.key === "Enter" || e.key === " ") finish();
    };
    window.addEventListener("keydown", onKey);
    const t = setTimeout(finish, 3200);
    return () => {
      window.removeEventListener("keydown", onKey);
      clearTimeout(t);
    };
  }, []);
  return (
    <button type="button" className="boot__skip" onClick={finish}>
      Pular ›
    </button>
  );
}
