---
name: personal-codemap
description: >-
  Gera codemaps hierárquicos (codemap.md por diretório + "Repository Atlas" na raiz)
  para navegação rápida de repositórios desconhecidos ou novos — operação cara,
  sob demanda explícita, nunca como hábito rotineiro.
---
# personal-codemap

## Quando usar

- Repositório novo ou desconhecido (140+ repos da org Octor)
- Precisa entender dependências cruzadas sem ler todo código
- Onboarding a um time ou substituindo outro desenvolvedor

## Checklist de uso

- [ ] Under explicit request ("me gerar codemap deste repo") — NUNCA gerar automaticamente
- [ ] Repo com mais de 50 arquivos fonte — caso contrário, leitura direta é mais rápida
- [ ] Após mudanças arquitetônicas significativas (ADRs, novas integrações)
- [ ] Só sob pedido do usuário ou para onboarding

## Execução

```bash
# Gera codemap.md na raiz e por diretório
octor-codemap generate

# Apenas atualização incremental (se .slim/codemap.json existir)
octor-codemap update

# Limpar e regenerar do zero
octor-codemap reset
```

## Output

- `codemap.md` na raiz: mapa hierárquico de módulos, interfaces, seams
- `Repository Atlas` na raiz: overview de paths críticos, configs, pontos de entrada
- `.slim/codemap.json`: registro idempotente para atualizações futuras (hash de arquivos)

## Regra de non-usage

- NÃO gerar codemap como parte de PR routine — polui histórico e atrapalha review
- NÃO commitar codemap.md no repo do usuário (é arquivo de auxílio do agente, não fonte de verdade)
- Atualizar apenas quando houver mudança estrutural relevante

## Referência

Adaptado do `codemap` do repo `akitaonrails/my-skills` (skill 4) com restrição org: codemap é operação cara, sob demanda, registrada em `.slim/` apenas, não versionada no repo.