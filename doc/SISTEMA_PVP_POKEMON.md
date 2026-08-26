<!-- START Pokemon PvP System -->
# Sistema de PvP com Pokémon — PokeZ

## Como iniciar uma batalha

Para um treinador atacar o Pokémon de outro jogador, estas condições precisam ser atendidas:

1. O sistema deve estar habilitado em `config.lua`.
2. Os dois treinadores precisam ter pelo menos o level configurado em `pokemonPvpMinLevel`.
3. Os dois jogadores precisam estar fora de Protection Zone.
4. O atacante deve ativar o botão de PvP do cliente.
5. Jogadores da mesma party não podem se atacar.
6. A diferença entre os levels dos dois Pokémon deve ser de, no máximo, 10 levels.

Ao selecionar o Pokémon adversário, o servidor confere todas essas regras antes de permitir o ataque.

## Regra da diferença de level

A configuração padrão permite uma diferença máxima de 10 levels:

```lua
pokemonPvpMaxLevelDifference = 10
```

Exemplos:

- Pokémon level 50 contra level 40: permitido.
- Pokémon level 50 contra level 39: bloqueado.
- Pokémon level 39 contra level 50: bloqueado.
- Pokémon level 100 contra level 90: permitido.
- Pokémon level 100 contra level 89: bloqueado.

A verificação funciona nos dois sentidos. Isso impede que um Pokémon fraco inicie uma batalha contra um Pokémon muito mais forte e depois deixe o adversário impossibilitado de revidar.

O level usado é o level real salvo no Pokémon, no storage `1000`. Caso esse storage ainda não exista, o sistema usa o level retornado pelo sistema de level dos Pokémon.

## Botão de PvP

O jogador que inicia o ataque precisa estar com o botão de PvP ativado no cliente. O cliente informa o estado do botão ao servidor pelo comando oculto `#f#ightmode`.

Um jogador pode revidar contra um treinador que já esteja marcado como PK sem precisar ativar novamente o botão.

## Skull e PZ lock

Quando o jogador inicia uma batalha válida:

- O atacante recebe white skull quando aplicável.
- O white skull permanece por 10 minutos sem atacar.
- Cada novo ataque válido do agressor renova os 10 minutos do white skull.
- O atacante recebe PZ lock.
- Os dois treinadores recebem a condição de combate.
- Cada novo dano renova o tempo de combate.
- O tempo padrão de PZ lock é de 60 segundos.

O treinador não pode recolher nem trocar o Pokémon enquanto estiver atacando. Depois de 10 segundos completos sem realizar um ataque válido, ele pode recolher ou trocar o Pokémon mesmo que ainda esteja com skull ou PZ lock. Cada novo ataque reinicia a contagem dos 10 segundos.

## Frags diários, semanais e mensais

O sistema registra um frag quando o jogador que abriu PK derrota o Pokémon de um treinador que não está marcado como PK. Os contadores são persistentes e reiniciam quando muda o dia, a semana ou o mês do servidor.

Limites padrão:

| Nível de PK | Por dia | Por semana | Por mês |
|---|---:|---:|---:|
| Red PK | 3 | 5 | 10 |
| Black PK | 6 | 10 | 20 |

Basta atingir qualquer um dos três limites para receber o nível de PK correspondente. Matar o Pokémon de um jogador que já possui white, red ou black skull não gera frag injustificado.

O jogador pode usar o comando `!frags` para consultar os contadores, o nível atual de PK, a porcentagem de perda de experiência e o tempo restante para trocar o Pokémon.

Quando um Pokémon de jogador é derrotado, somente o jogador responsável pela derrota recebe uma mensagem vermelha no formato: `Jogador X matou Pokémon do jogador Y.`

## Perda de experiência do Pokémon PK

Se o Pokémon derrotado pertencer ao jogador que abriu PK ou já estiver marcado como PK, ele perde uma porcentagem da própria experiência acumulada:

| Nível de PK do dono | Perda de experiência |
|---|---:|
| White PK | 5% |
| Red PK | 10% |
| Black PK | 20% |

A experiência é removida diretamente da ball. Se a experiência restante não for suficiente para manter o level atual, o Pokémon perde os levels correspondentes. O level nunca fica abaixo de 1.

O Pokémon do defensor inocente não perde experiência quando é derrotado pelo agressor.

## Protection Zone

O PvP entre Pokémon é bloqueado quando o atacante, o treinador adversário ou o Pokémon alvo estiver dentro de uma Protection Zone. O bloqueio acontece antes da aplicação de skull e PZ lock.

## Duelos e batalhas por equipes

As regras existentes de duelo e equipes continuam funcionando. A proteção de diferença máxima de level é central e também é aplicada quando os dois Pokémon pertencem a jogadores, inclusive nessas modalidades.

## Configuração

As opções ficam no arquivo `config.lua`:

```lua
pokemonPvpEnabled = true
pokemonPvpMinLevel = 30
pokemonPvpRequireButton = true
pokemonPvpMaxLevelDifference = 10
pokemonPvpReturnDelay = 10
pokemonPvpWhiteSkullTime = 10 * 60
pokemonPvpDailyFragsToRed = 3
pokemonPvpWeeklyFragsToRed = 5
pokemonPvpMonthlyFragsToRed = 10
pokemonPvpDailyFragsToBlack = 6
pokemonPvpWeeklyFragsToBlack = 10
pokemonPvpMonthlyFragsToBlack = 20
pokemonPvpWhiteExpLossPercent = 5
pokemonPvpRedExpLossPercent = 10
pokemonPvpBlackExpLossPercent = 20
pzLocked = 60 * 1000
```

- `pokemonPvpEnabled`: liga ou desliga o PvP aberto.
- `pokemonPvpMinLevel`: level mínimo dos treinadores.
- `pokemonPvpRequireButton`: exige o botão de PvP para iniciar um ataque.
- `pokemonPvpMaxLevelDifference`: diferença máxima entre os Pokémon.
- `pokemonPvpReturnDelay`: segundos sem atacar necessários para recolher ou trocar o Pokémon.
- `pokemonPvpWhiteSkullTime`: duração do white PK, em segundos, renovada a cada ataque.
- `pokemonPvp*FragsToRed`: limites diário, semanal e mensal para red PK.
- `pokemonPvp*FragsToBlack`: limites diário, semanal e mensal para black PK.
- `pokemonPvp*ExpLossPercent`: perda de experiência para white, red e black PK.
- `pzLocked`: duração do bloqueio de combate em milissegundos.

Depois de alterar essas configurações, reinicie o servidor.

## Arquivos principais do sistema

- `config.lua`
- `data/lib/pokemon/pvp system.lua`
- `data/lib/pokemon/some functions.lua`
- `data/creaturescripts/scripts/pokemon/playerattack.lua`
- `data/creaturescripts/scripts/pokemon/exp2.0.lua`
- `data/creaturescripts/scripts/pokemon/goback.lua`
- `data/actions/scripts/pokemon/goback.lua`
- `data/talkactions/scripts/pokemon/fightMode.lua`
- `data/talkactions/scripts/pokemon/pvpstatus.lua`
- `data/talkactions/talkactions.xml`
- `Src/player.cpp`
- `Src/luascript.cpp`
- `Src/luascript.h`

## Atualização do executável

As alterações nativas precisam do novo `PokeZ.exe` compilado. Antes de substituir o executável da raiz, encerre completamente o servidor que estiver em execução.
<!-- END Pokemon PvP System -->
