"use server";

import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { siteUrl } from "@/lib/supabase/env";
import type { ActionResult } from "@/lib/types";
import {
  fieldErrorsFrom,
  recoverSchema,
  resetPasswordSchema,
  signInSchema,
  signUpSchema,
  translateAuthError,
  type RecoverInput,
  type ResetPasswordInput,
  type SignInInput,
  type SignUpInput,
} from "@/lib/validation";

function safeNext(path: unknown): string {
  return typeof path === "string" && path.startsWith("/") && !path.startsWith("//") ? path : "/painel";
}

export async function signUp(input: SignUpInput): Promise<ActionResult<{ needsConfirmation: boolean }>> {
  const parsed = signUpSchema.safeParse(input);
  if (!parsed.success) return { ok: false, error: "Revise os campos.", fieldErrors: fieldErrorsFrom(parsed.error) };
  const { username, email, password } = parsed.data;
  const supabase = await createClient();

  const { data: available, error: rpcError } = await supabase.rpc("username_available", { p_username: username });
  if (rpcError) return { ok: false, error: "Não foi possível verificar o nome de usuário." };
  if (!available) return { ok: false, error: "Nome de usuário em uso.", fieldErrors: { username: "Este nome já está em uso." } };

  const { data, error } = await supabase.auth.signUp({
    email,
    password,
    options: { data: { username }, emailRedirectTo: `${siteUrl()}/auth/callback?next=/painel` },
  });
  if (error) return { ok: false, error: translateAuthError(error.message) };
  // Com confirmação de e-mail ativa o Supabase não devolve sessão.
  return { ok: true, data: { needsConfirmation: !data.session } };
}

export async function signIn(input: SignInInput, next?: string): Promise<ActionResult> {
  const parsed = signInSchema.safeParse(input);
  if (!parsed.success) return { ok: false, error: "Revise os campos.", fieldErrors: fieldErrorsFrom(parsed.error) };
  const supabase = await createClient();
  const { error } = await supabase.auth.signInWithPassword(parsed.data);
  if (error) return { ok: false, error: translateAuthError(error.message) };
  redirect(safeNext(next));
}

export async function requestPasswordReset(input: RecoverInput): Promise<ActionResult> {
  const parsed = recoverSchema.safeParse(input);
  if (!parsed.success) return { ok: false, error: "Revise os campos.", fieldErrors: fieldErrorsFrom(parsed.error) };
  const supabase = await createClient();
  const { error } = await supabase.auth.resetPasswordForEmail(parsed.data.email, {
    redirectTo: `${siteUrl()}/auth/callback?next=/redefinir-senha`,
  });
  // Mesma resposta exista ou não a conta (não revela e-mails cadastrados).
  if (error && error.message.toLowerCase().includes("rate")) return { ok: false, error: translateAuthError(error.message) };
  return { ok: true, message: "Se houver uma conta com este e-mail, você receberá um link para criar uma nova senha." };
}

export async function updatePassword(input: ResetPasswordInput): Promise<ActionResult> {
  const parsed = resetPasswordSchema.safeParse(input);
  if (!parsed.success) return { ok: false, error: "Revise os campos.", fieldErrors: fieldErrorsFrom(parsed.error) };
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) return { ok: false, error: "Sua sessão expirou. Peça um novo link de recuperação." };
  const { error } = await supabase.auth.updateUser({ password: parsed.data.password });
  if (error) return { ok: false, error: translateAuthError(error.message) };
  return { ok: true, message: "Senha atualizada." };
}

export async function signOut() {
  const supabase = await createClient();
  await supabase.auth.signOut();
  redirect("/entrar");
}
