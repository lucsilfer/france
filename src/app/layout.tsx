import type { Metadata, Viewport } from "next";
import "./globals.css";
import { BOOT_SCRIPT, BootSequence } from "@/components/brand/BootSequence";
import { SYSTEM_NAME, SYSTEM_TAGLINE } from "@/components/brand/Logo";

export const metadata: Metadata = {
  title: { default: SYSTEM_NAME, template: `%s · ${SYSTEM_NAME}` },
  description: `${SYSTEM_NAME} — ${SYSTEM_TAGLINE}. Plataforma do RPG Tríade das Lendas: fichas, rolagens, campanhas e homebrew.`,
  applicationName: SYSTEM_NAME,
};

export const viewport: Viewport = {
  themeColor: "#050a12",
  width: "device-width",
  initialScale: 1,
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    // O script de inicialização ajusta atributos do <html> antes da hidratação.
    <html lang="pt-BR" suppressHydrationWarning>
      <head>
        <script dangerouslySetInnerHTML={{ __html: BOOT_SCRIPT }} />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        {/* eslint-disable-next-line @next/next/no-page-custom-font */}
        <link
          rel="stylesheet"
          href="https://fonts.googleapis.com/css2?family=Orbitron:wght@600;700&family=Rajdhani:wght@500;600;700&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&display=swap"
        />
      </head>
      <body>
        <BootSequence />
        {children}
      </body>
    </html>
  );
}
