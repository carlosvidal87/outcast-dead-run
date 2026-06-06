# Outcast: Dead Run - Grafo de Conceito e Design do Jogo

Este documento contém a estrutura conceitual e as regras principais do jogo. Ele serve como o **Grafo de Ideias** oficial do projeto para orientar o desenvolvimento e garantir que futuras implementações e agentes de IA sigam as diretrizes corretas.

---

## 🗺️ Fluxo Geral da Run (Grafo de Decisões e Estados)

```mermaid
graph TD
    %% Estilos de nós e conexões
    classDef preparacao fill:#2b3a4a,stroke:#4a90e2,stroke-width:2px,color:#fff;
    classDef safezone fill:#1c3d27,stroke:#2ecc71,stroke-width:2px,color:#fff;
    classDef progressao fill:#3a2f1d,stroke:#f39c12,stroke-width:2px,color:#fff;
    classDef climax fill:#4c1c1c,stroke:#e74c3c,stroke-width:2px,color:#fff;
    classDef extraido fill:#0f3d3d,stroke:#1abc9c,stroke-width:2px,color:#fff;
    classDef morte fill:#262626,stroke:#95a5a6,stroke-width:2px,color:#fff;

    %% Nós da preparação
    Menu[Menu Principal<br/>Preparação de Vantagens] :::preparacao
    Spawn[Spawn na Safezone<br/>Pistola + Faca + Pouca Munição] :::safezone
    
    %% Nós da progressão
    Explorar[Explorar Área Hostil<br/>Combate a Zumbis] :::progressao
    ColetaScrap[Coletar Sucata<br/>Moeda de Combate] :::progressao
    Loja[Economia de Combate:<br/>Abrir Portas / Comprar Armas & Perks] :::progressao
    Hordas[Picos de Horda Planejados] :::progressao
    Objetivos[Cumprir Objetivos do Mapa] :::progressao
    
    %% Clímax
    Boss[Liberar & Enfrentar Boss Final] :::climax
    Portal[Extração Habilitada] :::climax
    
    %% Finais (Regra de Ouro)
    Sucesso[Extração com Sucesso<br/>Mantém itens e conquistas da run] :::extraido
    Derrota[Morte na Run<br/>Perda Total de Itens] :::morte
    MetaProgressao[Meta-Progressão<br/>Pequenos pontos permanentes] :::preparacao

    %% Relações / Transições
    Menu -->|Inicia Sessão| Spawn
    Spawn -->|Sair da Safezone| Explorar
    Explorar --> ColetaScrap
    ColetaScrap --> Loja
    Loja -->|Evolução na Partida| Explorar
    Explorar --> Hordas
    Hordas -->|Testar Sobrevivência| Explorar
    Explorar --> Objetivos
    Objetivos -->|Todos Completos| Boss
    
    %% Bifurcação da Regra de Ouro (Risco vs Recompensa)
    Boss -->|Derrotado| Portal
    Portal -->|Extrair| Sucesso
    Sucesso -->|Retorna ao Menu com Loot| Menu
    
    Explorar -->|Morrer| Derrota
    Boss -->|Morrer| Derrota
    Derrota -->|Perde tudo da Run| MetaProgressao
    MetaProgressao -->|Melhorar personagem no Menu| Menu
```

---

## 🎮 Detalhamento dos Três Momentos da Run

### 1. Preparação (Menu Principal & Início)
*   **Menu Principal:** O jogador customiza suas vantagens iniciais (meta-progressão) obtidas com os pequenos pontos de runs anteriores.
*   **Spawn (Safezone):** O início de cada run ocorre em uma Safezone segura no mapa. 
*   **Equipamento Inicial:** O jogador surge apenas com uma pistola fraca (pouca munição) e uma faca. A segurança dura apenas dentro dos limites da Safezone.

### 2. Progressão na Run (Combate, Exploração e Economia)
*   **Loop de Sucata (Scrap):** Ao sair da Safezone, o jogador explora o ambiente hostil e elimina zumbis para coletar **Sucata** (a moeda do jogo).
*   **Economia em Tempo Real:** A sucata acumulada é usada ativamente durante a partida para:
    *   Abrir portas e portões trancados para liberar novas áreas do mapa.
    *   Comprar novas armas (disponíveis nas paredes ou caixas).
    *   Fazer melhorias em armas e comprar vantagens/perks nas máquinas (Juggernog, Speed Cola, Double Tap).
*   **Picos de Horda:** Ondas ou eventos de horda planejados ocorrem dinamicamente para pressionar o jogador e testar sua estratégia de economia de munição e posicionamento.

### 3. Clímax e Desfecho (Extração ou Morte)
*   **Boss Final:** O jogador deve cumprir uma série de objetivos espalhados pelo mapa para liberar a arena ou o spawn do Boss Final.
*   **Habilitação da Extração:** A extração só se torna ativa e utilizável após o Boss Final ser completamente derrotado.

---

## ⚠️ A Regra de Ouro (Risco vs. Recompensa)

| Destino da Run | O que acontece com o inventário / loot? | Meta-Progressão |
| :--- | :--- | :--- |
| **Extração com Sucesso** | **Mantém tudo.** Armas compradas, sucata convertida e itens coletados voltam para o inventário persistente do jogador para uso no menu/partidas futuras. | Recebe bônus adicionais de experiência e pontos. |
| **Morte no Caminho** | **Perda Total.** O jogador perde todas as armas, munições e recursos acumulados durante aquela sessão específica. | Restam apenas pequenos pontos obtidos de metas cumpridas para comprar upgrades simples de meta-progressão no Menu. |

---

## 🛠️ Mapeamento de Arquivos e Código do Projeto

Para facilitar a futura implementação e ajudar novas instâncias da IA a se localizarem no código Godot da pasta `res://`:

*   [character.gd](file:///c:/Users/Cadu/Documents/3d/character.gd)
    *   *Papel atual:* Controla movimentação do jogador, vida, sistema de armas, compra de perks, inventário e hud.
    *   *Implementação futura:* Precisará separar os itens temporários da run (armas compradas na run, sucata acumulada) dos itens persistentes salvos no perfil. O comportamento de morte (`_die()`) deve acionar a perda total e retorno ao menu principal.
*   [menu_controller.gd](file:///c:/Users/Cadu/Documents/3d/menu_controller.gd)
    *   *Papel atual:* Exibe menus de início e pause em runtime.
    *   *Implementação futura:* Irá conter o painel de vantagens da Preparação antes do jogo iniciar e listagem de meta-progressão.
*   [spawner.gd](file:///c:/Users/Cadu/Documents/3d/spawner.gd)
    *   *Papel atual:* Controla o nascimento dinâmico dos zumbis.
    *   *Implementação futura:* Gerenciar os picos de horda e o acionamento do Boss Final após a conclusão dos objetivos.
*   [node_3d.gd](file:///c:/Users/Cadu/Documents/3d/node_3d.gd) (GameManager)
    *   *Papel atual:* Inicializa a navegação dos inimigos e spawna as perk machines.
    *   *Implementação futura:* Gerenciar os estados da sessão (Safezone ativa, portas trancadas, gatilhos de objetivos do mapa e controle da extração final).

---

## 📌 Guia de Manutenção para IAs futuras
> [!IMPORTANT]
> Ao receber instruções para codificar novas mecânicas neste repositório:
> 1. Consulte este arquivo (`concept_graph.md`) para garantir que o fluxo de jogo respeita os três momentos (Preparação, Progressão, Clímax) e a Regra de Ouro.
> 2. Qualquer nova arma, perk ou porta adicionada deve consumir **Sucata** (gerenciada por pontos/scrap no script de jogador).
> 3. Certifique-se de que a morte resete o progresso e a extração salve os itens no salvamento persistente do jogo (futuro Save System).
