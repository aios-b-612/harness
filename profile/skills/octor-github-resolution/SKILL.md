---
name: octor-github-resolution
description: >-
  Transforma tickets/PRs já auditados da org 0ctor em código mergeado em dev
  (ou hotfix em main), um de cada vez, com teste de regressão antes da correção.
  Use when resolving approved GitHub items, github-resolution, fixing audited
  issues/PRs, or when the user says octor-github-resolution.
---

# octor-github-resolution

Um item de cada vez. Só processar o que `octor-pr-audit` (ou o usuário) já aprovou.

## Pré-condições

1. Item aprovado (PR auditado ou issue com escopo claro).
2. Clone local na pasta do repo sob `~/SSD_BACKUP/Workspace/octor/<repo>`.
3. Preferir `ai-memory run` / handoff se a sessão for longa.

## Fluxo (feature / fix do dia a dia)

```text
1. git fetch && checkout -b feature/<slug>  (ou fix/<slug>) a partir de origin/dev
2. Escrever teste de regressão que falha (ou checklist reproduzível) ANTES do fix
3. Implementar o mínimo que faz o teste passar
4. Sem abstrações especulativas, sem refatoração de passagem
5. Commit na feature (nunca stash como depósito)
6. Push + PR → base dev
7. Rodar octor-pr-audit no PR criado
8. Só então sugerir merge; apagar branch após merge
```

## Fluxo (hotfix em produção)

Se o bug **já está em main** ou precisa ir já para produção:

```text
fix/<slug> ← main → PR → main (deploy) → PR/cherry-pick do mesmo fix → dev
```

Proibido “acelerar” via `feature`/`fix` ← `dev` + promote.

## Regras duras Octor

- Nunca editar/push em `main` ou `dev` direto
- Timezone: se tocar instantes/UI de data, corrigir o contrato no mesmo PR
- Tickets: comentário público só se pedido; sem jargão de ops
- Dados clínicos / LGPD: não logar PHI; não exfiltrar dumps

## Sandbox

Para trabalho com `.env`, vault ou tokens: preferir

```bash
ai-jail --agent-state --allow-host api.github.com --allow-host github.com --allow-host registry.npmjs.org --allow-host index.crates.io --allow-host pypi.org <agent>
```

Ajustar `--allow-host` ao que a tarefa precisa. Ver `~/.ai-jail` e skill/docs em `agent-skills/README.md`.

## Saída

Por item:

```text
Item: #N
Branch: feature/…
PR: url
Teste: …
Status: pronto para audit/merge | bloqueado (motivo)
```

Não abrir promote `dev→main` aqui — usar `octor-promote-check`.
