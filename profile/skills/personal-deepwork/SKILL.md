---
name: personal-deepwork
description: >-
  Workflow orquestrador de alto custo para esforços grandes/arriscados/multi-fase
  com dependências — proibido para mudanças rotineiras. Orquestrador agenda em
  vez de implementar; arquivo de progresso persistente em .slim/deepwork/; gate
  obrigatório de review @oracle após cada fase com no máximo 2 re-reviews.
---
# personal-deepwork

## Quando usar

- Mudanças que atravessam múltiplos repos/serviços da org
- Work with LGPD/PHI implications (healthtech multi-tenant)
- Refactors de escala que afetam contratos cross-app
- Qualquer mudança que, se der errado, exige rollback em produção

## Gate obrigatório @oracle

**Após cada fase**, antes de prosseguir:

- [ ] Revisor `@oracle` (subagente designado) review do progresso e decisão
- [ ] Máximo 2 re-reviews por fase — terceira rodada exige intervenção humana
- [ ] Decisão registrada: `continue` / `pivot` / `stop`
- [ ] Se `stop`: arquivo `.slim/deepwork/terminated.md` com causa e lições

## Arquivo de progresso `.slim/deepwork/`

Persiste across phases com:

- `phase`: número da fase atual
- `status`: `planning|working|review|integrating|terminated`
- `claims`: claims declarados e seu status (test, build, lint, command, fileExists, oracle, observer, manual)
- `next_steps`: próximo passo explícito antes de próxima fase
- `handoff`: se handoff for necessário para próxima fase

## Tipos de sucesso declarados

Cada fase deve terminar com um dos tipos de sucesso:

- `test` — testes passam (unitários + integration)
- `build` — código compila
- `lint` — lint passa
- `command` — comando customizado executou com sucesso
- `fileExists` — arquivo esperado criado
- `oracle` — review @oracle aprovou
- `observer` — observação manual/externos aprovou
- `manual` — review manual pausou o loop (never auto-resolve)

## Regra de non-usage

- **Proibido para mudanças rotineiras** — use octor-pr-audit + octor-github-resolution ao invés
- **Nunca auto-resolver** o gate manual/oracle — pausar e solicitar decisão humana
- **Handoff congelado** — design visual do @designer congela para fases posteriores (não reabrir sem nova decisão @oracle)

## Referência

Baseado no `deepwork` do repo `akitaonrails/my-skills` (skill 5) com adaptações ao contrato org: gates @oracle em vez de auto-resolve, hierarquia de success types declarados, e integração com o bloco octor-ecosystem (política de fusos, LGPD, git-flow).