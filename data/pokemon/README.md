# Arquivos do sistema Pokemon

Esta pasta concentra os dados gerados e persistidos pelos sistemas de Pokemon.

- `catch.txt`: historico usado pelo sistema de captura.
- `creatures.xml`: lista gerada pelo comando de atualizacao de criaturas.
- `extensions.xml`: extensoes geradas para o cliente.
- `statistics/`: tentativas, capturas e estatisticas gerais por Pokemon.
- `writeTable.txt`: tabela gerada pelo comando `/writeTable`.

Os scripts executaveis continuam dentro das pastas exigidas pelo TFS, mas foram
separados em subpastas `pokemon`:

- `data/actions/scripts/pokemon`
- `data/creaturescripts/scripts/pokemon`
- `data/monster/pokemon`
- `data/movements/scripts/pokemon`
- `data/spells/scripts/pokemon`
- `data/talkactions/scripts/pokemon`

As bibliotecas tambem foram organizadas em `data/lib/core`, `data/lib/pokemon`
e `data/lib/systems`. O arquivo `data/lib/000-loader.lua` preserva explicitamente
a ordem de inicializacao exigida pelo TFS 0.3.6.
