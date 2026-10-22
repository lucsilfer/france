import { z } from "zod";
import { isValidDice } from "@/rules/dice.ts";

const email = z.string().trim().min(1, "Informe o e-mail.").email("E-mail inválido.");
const password = z
  .string()
  .min(8, "A senha precisa de pelo menos 8 caracteres.")
  .max(72, "Senha longa demais.")
  .regex(/[A-Za-zÀ-ÿ]/, "Use pelo menos uma letra.")
  .regex(/\d/, "Use pelo menos um número.");

export const usernameSchema = z
  .string()
  .trim()
  .min(3, "Mínimo de 3 caracteres.")
  .max(24, "Máximo de 24 caracteres.")
  .regex(/^[A-Za-z0-9_.-]+$/, "Use apenas letras sem acento, números, ponto, hífen ou sublinhado.");

export const signUpSchema = z
  .object({
    username: usernameSchema,
    email,
    password,
    confirmPassword: z.string(),
  })
  .refine((d) => d.password === d.confirmPassword, { path: ["confirmPassword"], message: "As senhas não coincidem." });

export const signInSchema = z.object({
  email,
  password: z.string().min(1, "Informe a senha."),
});

export const recoverSchema = z.object({ email });

export const resetPasswordSchema = z
  .object({ password, confirmPassword: z.string() })
  .refine((d) => d.password === d.confirmPassword, { path: ["confirmPassword"], message: "As senhas não coincidem." });

export const profileSchema = z.object({
  username: usernameSchema,
  display_name: z.string().trim().max(60, "Máximo de 60 caracteres."),
  reduce_motion: z.boolean(),
  roll_speed: z.enum(["instant", "fast", "normal"]),
});

export const campaignSchema = z.object({
  name: z.string().trim().min(1, "Dê um nome à campanha.").max(120, "Máximo de 120 caracteres."),
  description: z.string().trim().max(5000, "Máximo de 5000 caracteres."),
  cover_url: z
    .string()
    .trim()
    .max(500)
    .refine((v) => v === "" || /^https:\/\/\S+$/.test(v), "Use um link https:// válido para a imagem."),
});

export const homebrewSchema = z.object({
  kind: z.enum(["item", "arma", "modificador", "monstro", "npc", "outro"]),
  name: z.string().trim().min(1, "Dê um nome.").max(120, "Máximo de 120 caracteres."),
  description: z.string().trim().max(10000, "Texto longo demais."),
  effect_dice: z
    .string()
    .trim()
    .max(60)
    .refine((v) => v === "" || isValidDice(v), "Expressão de dados inválida (ex.: 1d6, 2d8+3, 1d12+1d6)."),
  effect_kind: z.enum(["", "dano", "cura", "condicao", "utilidade", "personalizado", "outro"]),
  range: z.string().trim().max(60),
  special_rules: z.string().trim().max(5000),
});

export type SignUpInput = z.infer<typeof signUpSchema>;
export type SignInInput = z.infer<typeof signInSchema>;
export type RecoverInput = z.infer<typeof recoverSchema>;
export type ResetPasswordInput = z.infer<typeof resetPasswordSchema>;
export type ProfileInput = z.infer<typeof profileSchema>;
export type CampaignInput = z.infer<typeof campaignSchema>;
export type HomebrewInput = z.infer<typeof homebrewSchema>;

export function fieldErrorsFrom(error: z.ZodError): Record<string, string> {
  const out: Record<string, string> = {};
  for (const issue of error.issues) {
    const key = issue.path.join(".") || "_";
    if (!out[key]) out[key] = issue.message;
  }
  return out;
}

/** Traduz mensagens comuns do Supabase Auth. */
export function translateAuthError(message: string): string {
  const m = message.toLowerCase();
  if (m.includes("invalid login credentials")) return "E-mail ou senha incorretos.";
  if (m.includes("email not confirmed")) return "Confirme seu e-mail antes de entrar (veja sua caixa de entrada).";
  if (m.includes("user already registered")) return "Já existe uma conta com este e-mail.";
  if (m.includes("rate limit") || m.includes("too many")) return "Muitas tentativas. Aguarde um pouco e tente novamente.";
  if (m.includes("same") && m.includes("password")) return "A nova senha precisa ser diferente da atual.";
  if (m.includes("password")) return "A senha não atende aos requisitos.";
  return "Não foi possível concluir. Tente novamente.";
}
