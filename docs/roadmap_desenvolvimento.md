# Roadmap de Desenvolvimento: Outcast - Dead Run

Este documento divide o desenvolvimento nas próximas 3 semanas. Ele está estruturado para permitir que o **Trabalho de Código (Programação)** e o **Trabalho de Mapa (Level Design)** aconteçam de forma simultânea (em paralelo) sem que um bloqueie ou quebre o trabalho do outro.

> [!TIP]
> **Como trabalhar em paralelo:** Enquanto um de vocês mexe nos códigos e na cena do personagem (`src/scenes/character.tscn`), o outro pode montar todo o mapa do zero em uma cena limpa e separada (sugestão: criar `src/scenes/mapa_principal.tscn`). Quando ambos terminarem suas partes básicas, o programador só precisará arrastar o Jogador para dentro do mapa no final. Assim, nunca haverá "conflito" no Git!

## 📌 Status das Tarefas
Legenda: 
- `[ ]` A Fazer
- `[~]` Em Andamento
- `[x]` Concluído

---

## Fase 1: Fundação Básica (Semana 1)

**Para o Programador:**
- `[ ]` Criar conexão básica de Multiplayer (Host/Client).
- `[ ]` Sincronizar movimentação dos jogadores pela rede.
- `[ ]` Base das armas: atirar, dar dano e recarregar (com sincronia na rede).
- `[ ]` Criar um HUD inicial e simples (Barra de Vida e Munição).

**Para o Level Designer (O Amigo):**
- `[ ]` Criar a cena `mapa_principal.tscn` para começar o cenário.
- `[ ]` Construir a estrutura física da **Safezone** inicial (lugar isolado e seguro).
- `[ ]` Montar o trajeto usando os modelos 3D (`assets/city` e `assets/roads`): definir onde são as áreas abertas e onde são os becos de tensão (vibe S.T.A.L.K.E.R).
- `[ ]` Deixar "espaços reservados" físicos para as portas bloqueadas e compras de armas nas paredes.

---

## Fase 2: Inimigos e Economia (Semana 2)

**Para o Programador:**
- `[ ]` Lógica do Zumbi (NavMesh) para seguir e atacar o jogador mais próximo.
- `[ ]` Sistema de Sucata: Zumbis dão pontos ao morrer.
- `[ ]` Lógica de Interação ('E'): Pagar sucata para abrir portas e comprar armas.
- `[ ]` Gerador de Hordas: Sistema invisível que spawna zumbis aos poucos, e ativa ondas gigantes por barulho ou avanço.

**Para o Level Designer:**
- `[ ]` Gerar e assar o **NavMesh** no mapa para os zumbis saberem onde podem pisar.
- `[ ]` **Iluminação e Clima:** Configurar neblina pesada (fog), luzes piscantes e uma iluminação dessaturada e fria.
- `[ ]` Distribuir "Spawn Points" (pontos invisíveis) pelo mapa dizendo onde os zumbis vão brotar da terra.
- `[ ]` Posicionar sons ambientes (vento, ruídos assustadores).

---

## Fase 3: Extração e Clímax (Semana 3)

**Para o Programador:**
- `[ ]` Lógica dos Objetivos (coletar X itens ou ativar geradores).
- `[ ]` Spawno e Lógica do Boss Final (inimigo com mais vida e padrões de ataque).
- `[ ]` Ativar a Extração apenas quando o Boss morrer.
- `[ ]` Salvar a sucata do jogador no arquivo (Meta-progressão) e Menu Principal.

**Para o Level Designer:**
- `[ ]` Construir a "Arena" final, um local propício para a luta contra o Boss.
- `[ ]` Decorar e sinalizar visualmente a Zona de Extração (luzes fortes ou um helicóptero de fundo).
- `[ ]` Polimento final do mapa (consertar colisões onde o jogador enrosca, tapar buracos no chão).
