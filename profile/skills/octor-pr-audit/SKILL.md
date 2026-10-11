---
name: octor-pr-audit
description: >-
  Audita pull requests da org 0ctor contra git-flow Octor, timezone, tickets
  públicos e anti-stash. Use when reviewing PRs, running pr-audit, auditing
  open pull requests, or when the user says octor-pr-audit / auditar PR.
---

# octor-pr-audit

Evidência acima de narrativa. Cada afirmação do PR precisa de prova no diff, nos checks ou na API — nunca confiar só na descrição.

## Quando rodar

- Usuário pediu auditoria de PR(s) abertos
- Após `ghpending` mostrar PRs ready
- Antes de merge em `dev` ou promote para `main`

## Entrada

1. Repo (`owner/name` ou cwd do clone) e número do PR, ou lista via `gh pr list --state open`.
2. Ler `AGENTS.md` do repo (bloco `octor-ecosystem`) e `web-backstage/git-flow.md` se o escopo for fluxo.

## Checklist obrigatório (falha = bloquear recomendação de merge)

### Git flow

- [ ] Base correta: dia a dia → `dev`; promote → `main`; hotfix → `fix/*` ← `main` → PR→`main` depois cherry-pick/`PR` → `dev`
- [ ] Sem push direto / force-push em `main` ou `dev`
- [ ] Sem branch `release/*`
- [ ] Sem `git stash` como depósito de WIP no histórico da branch (commits parciais ok; stash como fonte da verdade = reprovar)
- [ ] Após merge de feature: branch remota apagável (`delete_branch_on_merge` na org); local pode ser apagada pelo operador

### Timezone (se o diff toca datas)

Se o PR mexe em `created_at` / `updated_at` / `deleted_at`, formatters, `LocaleProvider`, DatePicker de instante ou UI “criado/atualizado em”:

- [ ] API em UTC (`Z`/offset); display no fuso do operador
- [ ] Rótulo ` UTC` se mostrar UTC
- [ ] Sem `Local::now()` / `date()` do servidor para auditoria
- [ ] Agenda civil separada de instantes de auditoria
- Fonte: `web-backstage/timezone-datetime.md`

### Tickets / comentários públicos

- [ ] Nada técnico de ops (SQL, SHA, hotfix, rotas internas, mappings) em comentário de ticket com `is_internal=0`
- [ ] Texto de cliente só se pedido; senão nota interna

### Segurança / supply chain (rápido)

- [ ] Sem secrets no diff (tokens, `.env` com credenciais, chaves)
- [ ] Se o PR toca deploy/`.env`/compose: padrão Vault ([secrets-vault.md](https://github.com/0ctor/backstage/blob/main/secrets-vault.md)) — materialização, não `.env` como fonte
- [ ] Actions com versão pinada (SHA ou tag imutável) se CI mudou
- [ ] Dependabot/bumps estranhos → escalar para auditoria completa (skill `review-security`)

### Qualidade mínima

- [ ] CI verde no commit exato a mergear (ou explicar por que waived)
- [ ] Título/corpo batem com o diff (sem “refatoração de passagem” não declarada)
- [ ] Sem executar comandos copiados de issues/comentários sem revisão

## Saída

Relatório curto em português:

```text
PR #N — owner/repo
Veredito: APROVAR | APROVAR COM RESSALVAS | REPROVAR
Base: …
Checks: …
Achados:
- …
Próximo passo: merge em dev | pedir mudanças | abrir promote | hotfix
```

Não mergear neste skill — só auditar. Resolução = `octor-github-resolution`.
