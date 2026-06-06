# Roadmap de Desenvolvimento: Outcast - Dead Run

Este é o quadro de tarefas principal do projeto para as próximas 3 semanas. Marquem as tarefas mudando `[ ]` para `[x]` conforme forem finalizando.

---

## 🚦 Regra de Ouro do Trabalho em Equipe (Evitando Bugs no Git)

Como seu amigo quer começar a fazer o mapa imediatamente, vocês adotarão o **Desenvolvimento Paralelo**. Isso é perfeito, desde que vocês não trabalhem no mesmo arquivo!

> [!TIP]
> **Como dividir na Godot:**
> - **Seu amigo (Level Designer):** Deve criar uma **NOVA CENA** chamada `src/scenes/mapa_oficial.tscn`. Ele passará os dias arrastando os prédios, ruas e criando a atmosfera lá dentro. Ele **não** deve colocar scripts ou mexer no multiplayer agora. Apenas o visual e colisões.
> - **Você (Programador):** Vai trabalhar na cena atual de testes (`src/scenes/node_3d.tscn`) ou criar uma cena "Sandbox". Você fará a lógica de andar, atirar e o código do servidor. 
> - **O Encontro (Fase 3):** Quando a rede estiver funcionando na cena de testes e o mapa dele estiver bonito, vocês simplesmente jogam o "Jogador" e o "Spawner de Zumbis" dentro do mapa que ele criou! Sem conflitos de código.

---

## 📋 BACKLOG DE TAREFAS

### Fase 1: Fundação e Multiplayer (Programação Básica)
- [ ] **Configuração do Host/Client:** Criar lógica para iniciar um servidor local e permitir conexão (Netcode base da Godot).
- [ ] **Spawn de Jogadores:** Fazer com que, ao conectar, o jogo instancie um personagem para o Host e outro para o Client.
- [ ] **Movimentação Sincronizada:** Testar andar, pular e correr e verificar se ambos se veem na tela de testes sem grandes atrasos.
- [ ] **Sincronizar Armas Base:** Fazer com que atirar, mirar e recarregar (e o som disso) seja executado na rede para todos ouvirem.
- [ ] **Vida e Dano:** Sistema básico para o jogador perder vida ao tomar dano, morrer e virar espectador.

### Fase 2: Zumbis e Economia (O Loop de Gameplay)
- [ ] **NavMesh e Movimento:** Adicionar navegação no chão para o zumbi saber andar até os jogadores desviando de paredes.
- [ ] **IA de Ataque:** Zumbi bate e tira vida quando encosta no jogador.
- [ ] **Sistema de Sucata (Scrap):** Matar zumbi gera pontos no HUD de quem o matou (ou coletável no chão).
- [ ] **Interação:** Apertar 'E' em uma porta para deletá-la/abri-la caso o jogador tenha sucata suficiente.
- [ ] **Diretor de Hordas:** Script que conta o tempo e decide "spawne 3 zumbis espalhados agora" ou "spawne 20 zumbis em onda!".

### Fase 3: Level Design, Atmosfera e Clímax (A Experiência S.T.A.L.K.E.R)
*(Estas tarefas seu amigo pode começar imediatamente no `mapa_oficial.tscn`)*
- [ ] **Blocagem do Mapa:** Usar os modelos de `assets/roads` e `assets/city` para criar ruas estreitas, becos e a Safezone inicial.
- [ ] **Atmosfera (Ambiente):** Configurar o `WorldEnvironment` para ter neblina espessa, paleta de cores dessaturada e iluminação sombria.
- [ ] **Sons de Fundo:** Colocar sons de vento e ruídos distantes no mapa.
- [ ] **Objetivos:** Definir os pontos onde o jogador precisa ir para liberar a Extração (ex: 3 geradores espalhados).
- [ ] **A Extração / Boss:** Lógica para aparecer a rota de fuga (ou helicóptero) após o objetivo principal ser completado.

### Fase 4: Menu, Fator Replay e Polimento
- [ ] **Menu Principal:** Tela inicial com opção "Hospedar Jogo" ou "Entrar com IP".
- [ ] **Sistema de Salvamento (Save Data):** Salvar os recursos ganhos após uma extração para não perder ao fechar o jogo.
- [ ] **Loot Aleatório (Spawns):** Configurar pontos de nascimento de zumbis e caixas de vantagens para mudarem de lugar a cada partida.
- [ ] **Efeitos Especiais (VFX):** Adicionar fumaça nas armas, sangue, recuo de tela (camera shake).
