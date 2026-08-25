# Bibliotecas

As bibliotecas foram separadas por responsabilidade:

- `core/`: compatibilidade e funcoes fundamentais do TFS.
- `pokemon/`: captura, movimentos, status, level, Pokedex, icones e demais regras de Pokemon.
- `systems/`: sistemas independentes, como autoloot, arena, duelo, tarefas e TV.

O TFS 0.3.6 nao carrega subpastas de `data/lib` automaticamente. Por isso,
`000-loader.lua` e o unico arquivo Lua mantido na raiz e carrega explicitamente
as 46 bibliotecas na mesma ordem alfabetica utilizada antes da reorganizacao.

Ao adicionar uma biblioteca nova, coloque-a na categoria apropriada e registre
seu caminho em `000-loader.lua`, respeitando as dependencias de inicializacao.
