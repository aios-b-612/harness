---
name: octor-git-flow
description: >-
  Git-flow Octor: feature/fix → dev, promote → main, anti-stash, branches
  locais merged. Use when branching, committing WIP policy, promote, or
  cleaning local branches already in origin/dev.
metadata:
  opencode/slash: "true"
---

# octor-git-flow

Canônico: `0ctor/backstage` → `git-flow.md` (e `AGENTS.md` do clone).

## Regras

- Dia a dia: `feature/*` ou `fix/*` → PR → `dev`.
- Release: `promote/*` → PR → `main` (não `release/*`).
- Hotfix: a partir de `main`; depois espelhar em `dev`.
- **Proibido** `git stash` como depósito de funcionalidade — commit na branch ou worktree.
- Commit / push / PR só sob pedido do usuário.
- Locais já contidas em `origin/dev`: `git branch -d` (não apagar `dev`/`main`/checkout).
- Sem force-push em `main`/`dev` sem pedido explícito.

## Ao abrir clone / fechar tarefa

```bash
git fetch origin
git branch --merged origin/dev | rg 'feature/|fix/|promote/' || true
# apagar só as already-merged e fora de uso; preferir -d
```
