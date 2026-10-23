export function supabaseEnv() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !anonKey) {
    throw new Error("Configure NEXT_PUBLIC_SUPABASE_URL e NEXT_PUBLIC_SUPABASE_ANON_KEY em .env.local (veja .env.example).");
  }
  return { url, anonKey };
}

/**
 * Endereço público do site (links dos e-mails de confirmação e recuperação de senha).
 * Ordem: NEXT_PUBLIC_SITE_URL → domínio de produção da Vercel → URL da implantação da Vercel → localhost.
 */
export function siteUrl() {
  const explicit = process.env.NEXT_PUBLIC_SITE_URL;
  const vercelProd = process.env.VERCEL_PROJECT_PRODUCTION_URL;
  const vercel = process.env.VERCEL_URL;
  const url = explicit || (vercelProd ? `https://${vercelProd}` : vercel ? `https://${vercel}` : "http://localhost:3000");
  return url.replace(/\/$/, "");
}
