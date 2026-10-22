import { useId, cloneElement, isValidElement } from "react";

interface FieldProps {
  label: string;
  error?: string;
  hint?: string;
  children: React.ReactElement<Record<string, unknown>>;
}

/** Rótulo + controle + mensagem de erro, com ligações de acessibilidade. */
export function Field({ label, error, hint, children }: FieldProps) {
  const id = useId();
  const describedBy = [error ? `${id}-err` : null, hint ? `${id}-hint` : null].filter(Boolean).join(" ") || undefined;
  const control = isValidElement(children)
    ? cloneElement(children, { id, "aria-invalid": error ? true : undefined, "aria-describedby": describedBy })
    : children;
  return (
    <div className="space-y-1.5">
      <label htmlFor={id} className="label-mono block text-holo/90">
        {label}
      </label>
      {control}
      {hint && !error && (
        <p id={`${id}-hint`} className="text-xs text-fg-muted">
          {hint}
        </p>
      )}
      {error && (
        <p id={`${id}-err`} role="alert" className="text-xs text-alert">
          {error}
        </p>
      )}
    </div>
  );
}
