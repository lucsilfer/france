import { forwardRef } from "react";
import { Loader2 } from "lucide-react";

type Variant = "primary" | "secondary" | "ghost" | "danger";

const VARIANTS: Record<Variant, string> = {
  primary:
    "chamfer bg-gradient-to-r from-primary-deep to-primary/80 text-fg border border-holo/60 hover:from-primary/90 hover:to-holo/90 hover:shadow-[0_0_22px_-4px_rgb(72_199_255/0.75)] hover:text-white",
  secondary: "chamfer bg-panel-2/80 text-fg border border-line-strong hover:border-holo hover:text-cyan hover:shadow-[0_0_16px_-6px_rgb(72_199_255/0.6)]",
  ghost: "bg-transparent text-fg-dim border border-transparent hover:text-cyan hover:bg-panel-2/70",
  danger: "chamfer bg-transparent text-alert border border-alert/50 hover:bg-alert/10 hover:border-alert",
};

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: Variant;
  loading?: boolean;
  size?: "sm" | "md";
}

/** Botão de comando do sistema. */
export const Button = forwardRef<HTMLButtonElement, ButtonProps>(function Button(
  { variant = "primary", loading = false, size = "md", className = "", children, disabled, ...rest },
  ref,
) {
  return (
    <button
      ref={ref}
      disabled={disabled || loading}
      aria-busy={loading || undefined}
      className={[
        "relative inline-flex items-center justify-center gap-2 font-mono font-medium uppercase tracking-[0.18em] transition-[background,border-color,box-shadow,color] duration-200",
        "disabled:cursor-not-allowed disabled:opacity-45 disabled:shadow-none",
        size === "sm" ? "px-3 py-1.5 text-[0.64rem]" : "px-5 py-2.5 text-xs",
        VARIANTS[variant],
        className,
      ].join(" ")}
      {...rest}
    >
      {loading && <Loader2 className="h-3.5 w-3.5 animate-spin" aria-hidden />}
      {children}
    </button>
  );
});
