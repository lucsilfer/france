import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";
import { supabaseEnv } from "./env";

const PUBLIC_PATHS = ["/entrar", "/cadastro", "/recuperar-senha", "/auth"];

/** Renova a sessão a cada requisição e protege as rotas privadas. */
export async function updateSession(request: NextRequest) {
  let response = NextResponse.next({ request });
  const { url, anonKey } = supabaseEnv();

  const supabase = createServerClient(url, anonKey, {
    cookies: {
      getAll() {
        return request.cookies.getAll();
      },
      setAll(cookiesToSet) {
        cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value));
        response = NextResponse.next({ request });
        cookiesToSet.forEach(({ name, value, options }) => response.cookies.set(name, value, options));
      },
    },
  });

  const {
    data: { user },
  } = await supabase.auth.getUser();

  const path = request.nextUrl.pathname;
  const isPublic = path === "/" || PUBLIC_PATHS.some((p) => path === p || path.startsWith(`${p}/`));

  if (!user && !isPublic) {
    const to = request.nextUrl.clone();
    to.pathname = "/entrar";
    to.search = "";
    to.searchParams.set("voltar", path + request.nextUrl.search);
    return NextResponse.redirect(to);
  }
  if (user && (path === "/entrar" || path === "/cadastro")) {
    const to = request.nextUrl.clone();
    to.pathname = "/painel";
    to.search = "";
    return NextResponse.redirect(to);
  }
  return response;
}
