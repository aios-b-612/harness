---
name: personal-worktrees
description: >-
  Protocolo pessoal de Git worktrees como "lanes" isoladas para trabalho complexo,
  arriscado ou paralelo — sempre sob ~/.slim/worktrees/<slug>/.
  Diferente do stash (proibido no fluxo Octor): worktrees são branches físicas,
  seguras, com contrato orchestrator-only e confirmação obrigatória do usuário.
---
# personal-worktrees

## Quando usar

- Trabalho complexo/arriscado que precisa de lane isolada
- Contexto paralelo entre agentes sem conflitos de git
- Quando stash seria usado como depósito de WIP (proibido no Octor)

## Contrato orchestrator-only

**Confirmação obrigatória do usuário** para qualquer mutação git:

- `octor-worktrees add <slug>` — criar nova lane
- `octor-worktrees remove <slug>` — remover lane (após merge/abandon)
- `octor-worktrees merge <slug>` — merge dentro da lane (aprovado pelo usuário)
- `octor-worktrees rebase <slug>` — rebase dentro da lane (aprovado pelo usuário)
- `octor-worktrees prune` — remover lanes mortas (after explicit approval)

## Manifest de lanes

`.slim/worktrees.json` com ownership e áreas por lane para evitar conflito entre agentes paralelos:

```json
{
  "lanes": {
    "feature/login": {"owner": "alfred", "area": "auth"},
    "fix/payment": {"owner": "betty", "area": "billing"}
  }
}
```

## Blocos de ignora

Pastas `.slim/worktrees.json` e `.gitignore`/`.ignore` registram lanes ativas para evitar poluição do repo principal.

## Ciclo de vida em 4 fases

1. **Planning** — definir scope da lane, registrar no manifest, obter confirmação do usuário
2. **Working** — desenvolvimento isolado na lane; commits vivem ali; troca de tarefa: commit ou worktree (NUNCA stash como depósito)
3. **Review** — diff + aprovação antes da integração; blocker = abortar lane, não stash
4. **Integration** — merge/rebase de volta dev/main apenas com aprovação explícita; apagar lane; atualizar manifest

## Regra de ouro

Stash só é permitido como mecanismo temporário de troca de contexto DENTRO da mesma lane, nunca como depósito de funcionalidade ou WIP entre lanes. Para WIP entre tasks: commit na branch atual ou criar nova worktree lane.

## Referência

Inspirado no `worktrees` do repo `akitaonrails/my-skills` (skill 23) mas adaptado ao contrato org Octor de "commits vivem em branches, nunca stash como fonte da verdade".