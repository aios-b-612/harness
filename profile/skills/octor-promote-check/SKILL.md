---
name: octor-promote-check
description: >-
  Verifica se um promote dev→main (ou hotfix já em main) está pronto para
  merge/deploy na org 0ctor: CI verde no commit, escopo, timezone e ausência
  de WIP. Use when promoting to main, checking promote PRs, release gate,
  or when the user says octor-promote-check / promover para main.
---

# octor-promote-check

Gate antes de merge em `main`. Deploy só acontece em `main`.

## Quando rodar

- PR `dev` → `main` (ou `promote/*` → `main`)
- Pedido explícito de “podemos promover?”
- Pós-hotfix: confirmar que o mesmo fix foi (ou será) levado a `dev`

## Checklist

### Fluxo

- [ ] Base do PR é `main`
- [ ] Head é `dev` (ou branch de promote alinhada a `dev`) — exceto hotfix `fix/*` ← `main`
- [ ] Não há sync automático `main`→`dev` planejada após o merge (proibido no fluxo Octor)
- [ ] Sem `release/*`

### CI / qualidade

- [ ] Checks verdes no **SHA exato** que será mergeado
- [ ] Diff do promote revisado: só o que deve ir a produção (sem WIP, sem debug)
- [ ] Sem secrets no diff

### Timezone / tickets

- [ ] Se o intervalo `dev..main` tocou datas/instantes: contrato UTC/API + display operador ok
- [ ] Nenhum comentário público de ticket com ops interno pendente de limpeza

### Hotfix

- [ ] Se veio de hotfix: existe (ou está aberto) PR/cherry-pick do **mesmo fix** → `dev`

### Pós-merge (lembrar o operador)

- [ ] Deploy dispara só em `main` (platform-deploy-hook / CI do repo)
- [ ] Apagar branch de promote se existir
- [ ] Não rodar chore de sync `main`→`dev`

## Saída

```text
Promote: owner/repo PR #N
Veredito: PODE MERGEAR | ESPERAR CI | BLOQUEADO
SHA: …
Checks: …
Riscos: …
Pós-merge: deploy + (se hotfix) backports para dev
```

Este skill **não** faz o merge sozinho a menos que o usuário peça explicitamente.
