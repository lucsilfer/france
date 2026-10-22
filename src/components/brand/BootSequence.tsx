import { LOGO, SYSTEM_NAME } from "./Logo";
import { BootSkip } from "./BootSkip";

/**
 * Executa ANTES da pintura: decide se a animação de inicialização deve aparecer.
 * - Só no primeiro acesso da sessão (sessionStorage) e não de novo em outra aba aberta nos últimos 30 min.
 * - Nunca com "reduzir animações" (perfil salvo localmente ou preferência do sistema).
 */
export const BOOT_SCRIPT = `(function(){try{var d=document.documentElement;
if(localStorage.getItem('france:reduce-motion')==='true'){d.setAttribute('data-reduce-motion','true');}
var last=+(localStorage.getItem('france:boot-at')||0);
if(sessionStorage.getItem('france:booted')||Date.now()-last<1800000||matchMedia('(prefers-reduced-motion: reduce)').matches){d.setAttribute('data-boot','done');}
else{sessionStorage.setItem('france:booted','1');localStorage.setItem('france:boot-at',String(Date.now()));}
}catch(e){}})();`;

/**
 * Animação de inicialização em CSS puro (≈2,9 s). A página real carrega por baixo;
 * a camada some sozinha e não intercepta cliques depois disso.
 */
export function BootSequence() {
  return (
    <div className="boot" role="status" aria-label="Inicializando o sistema F.R.A.N.C.E">
      <div className="boot__line" />
      <div className="boot__frame" />
      <div className="boot__core">
        <div className="boot__emblem">
          <svg className="boot__energy" viewBox="0 0 200 200" aria-hidden>
            <line x1="0" y1="100" x2="60" y2="100" stroke="var(--color-holo)" strokeWidth="0.8" />
            <line x1="200" y1="100" x2="140" y2="100" stroke="var(--color-holo)" strokeWidth="0.8" />
            <line x1="100" y1="0" x2="100" y2="48" stroke="var(--color-cyan)" strokeWidth="0.6" />
            <line x1="100" y1="200" x2="100" y2="152" stroke="var(--color-cyan)" strokeWidth="0.6" />
          </svg>
          <svg className="boot__ring" viewBox="0 0 200 200" aria-hidden>
            <circle cx="100" cy="100" r="96" fill="none" stroke="var(--color-holo)" strokeWidth="1.5" strokeDasharray="60 20 8 20" strokeLinecap="round" />
          </svg>
          <svg className="boot__ring boot__ring--rev" viewBox="0 0 200 200" aria-hidden>
            <circle cx="100" cy="100" r="96" fill="none" stroke="var(--color-cyan)" strokeWidth="1" strokeDasharray="2 9" />
          </svg>
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src={LOGO.medium} alt="" width={146} height={146} />
        </div>
        <div className="boot__name">{SYSTEM_NAME}</div>
        <div className="boot__bar">
          <i />
        </div>
        <div className="boot__text">
          <span className="t1">{SYSTEM_NAME} {"//"} INICIALIZANDO SISTEMA</span>
          <span className="t2">SISTEMA ONLINE</span>
        </div>
      </div>
      <BootSkip />
    </div>
  );
}
