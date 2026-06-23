extends Node3D

## Spawner — Sistema de rounds estilo CoD Zombies.
## Gerencia ondas progressivas de zumbis com escalonamento de dificuldade.
## Controla spawn, contagem de kills, transição entre rounds e HUD.

const ZOMBIE_SCENE     := preload("res://src/scenes/zombie.tscn")
const SPAWN_RADIUS_MIN := 10.0
const SPAWN_RADIUS_MAX := 20.0

# ─── Configuração de Rounds ─────────────────────────────────────────────────
const MAX_CONCURRENT_ZOMBIES := 10      ## Máximo de zumbis vivos no mapa ao mesmo tempo
const BASE_ZOMBIES_PER_ROUND := 4       ## Zumbis base no Round 1
const ZOMBIES_PER_ROUND_ADD  := 2       ## Zumbis adicionais por round
const SPAWN_COOLDOWN         := 2.0     ## Intervalo entre cada spawn individual (segundos)
const BETWEEN_ROUNDS_DELAY   := 10.0    ## Intervalo entre rounds (segundos)

# ─── Estado do Round ────────────────────────────────────────────────────────
enum SpawnerState { SPAWNING, WAITING_BETWEEN_ROUNDS }

var spawner_state        := SpawnerState.WAITING_BETWEEN_ROUNDS
var current_round        := 0
var zombies_total        := 0    ## Total de zumbis que devem nascer neste round
var zombies_spawned      := 0    ## Quantos já foram instanciados neste round
var zombies_killed       := 0    ## Quantos já morreram neste round
var zombies_active       := 0    ## Quantos zumbis estão vivos agora no mapa

var spawn_timer          := 0.0  ## Cooldown entre spawns individuais
var between_rounds_timer := 0.0  ## Timer de contagem regressiva entre rounds
var last_waiting_second  := -1

# ─── Contadores Globais ─────────────────────────────────────────────────────
var kill_count := 0

# ─── Referências UI ─────────────────────────────────────────────────────────
var kill_label  : Label = null
var round_label : Label = null


func _ready() -> void:

	# Aguarda o NavMap sincronizar antes do primeiro round.
	await NavigationServer3D.map_changed
	_start_next_round()


func _process(delta: float) -> void:
	match spawner_state:
		SpawnerState.SPAWNING:
			_process_spawning(delta)
		SpawnerState.WAITING_BETWEEN_ROUNDS:
			_process_waiting(delta)


## Durante o round ativo: spawna zumbis respeitando limites e cooldown.
func _process_spawning(delta: float) -> void:
	# Verifica se o round acabou (todos os zumbis foram mortos)
	if zombies_killed >= zombies_total:
		_end_round()
		return

	# Ainda há zumbis para spawnar?
	if zombies_spawned >= zombies_total:
		return

	# Respeitar o limite de zumbis simultâneos
	if zombies_active >= MAX_CONCURRENT_ZOMBIES:
		return

	# Cooldown entre spawns individuais
	spawn_timer -= delta
	if spawn_timer > 0.0:
		return

	# Spawna o próximo zumbi
	_spawn_zombie()
	spawn_timer = SPAWN_COOLDOWN


## Durante o intervalo entre rounds: faz a contagem regressiva.
func _process_waiting(delta: float) -> void:
	between_rounds_timer -= delta

	# Atualiza HUD com contagem regressiva
	var seconds_left := ceili(between_rounds_timer)
	if seconds_left != last_waiting_second:
		last_waiting_second = seconds_left
		_update_ui()
		if round_label:
			round_label.text = "PRÓXIMO ROUND EM %d..." % seconds_left

	if between_rounds_timer <= 0.0:
		_start_next_round()


## Inicia o próximo round.
func _start_next_round() -> void:
	current_round += 1

	# Fórmula: R1 = 8, R2 = 11, R3 = 14, R4 = 17, ...
	zombies_total = BASE_ZOMBIES_PER_ROUND + current_round * ZOMBIES_PER_ROUND_ADD
	zombies_spawned = 0
	zombies_killed = 0
	spawn_timer = 0.0
	last_waiting_second = -1

	spawner_state = SpawnerState.SPAWNING

	# Atualiza HUD
	_update_ui()
	if round_label:
		round_label.text = "ROUND %d" % current_round
		round_label.add_theme_color_override("font_color", Color(0.85, 0.1, 0.1, 1.0))

	print("[SPAWNER] === ROUND %d INICIADO === | Zumbis no round: %d" % [current_round, zombies_total])


## Encerra o round atual e inicia contagem regressiva.
func _end_round() -> void:
	spawner_state = SpawnerState.WAITING_BETWEEN_ROUNDS
	between_rounds_timer = BETWEEN_ROUNDS_DELAY

	_update_ui()
	if round_label:
		round_label.add_theme_color_override("font_color", Color(0.9, 0.7, 0.1, 1.0))

	print("[SPAWNER] === ROUND %d COMPLETO === | Kills totais: %d" % [current_round, kill_count])


func _spawn_zombie() -> void:
	var player_group := get_tree().get_nodes_in_group("player")
	if player_group.is_empty():
		return
	var player_pos : Vector3 = player_group[0].global_position

	# Offset aleatório em anel (min..max radius) no plano XZ.
	var angle  := randf() * TAU
	var radius := randf_range(SPAWN_RADIUS_MIN, SPAWN_RADIUS_MAX)
	var raw_pos := player_pos + Vector3(cos(angle) * radius, 0.0, sin(angle) * radius)

	# Snap para o NavMesh — garante que o ponto está em chão navegável.
	var nav_map := get_world_3d().navigation_map
	var safe_pos := NavigationServer3D.map_get_closest_point(nav_map, raw_pos)

	var zombie := ZOMBIE_SCENE.instantiate()
	get_tree().current_scene.add_child(zombie)
	zombie.global_position = safe_pos

	# Configura os atributos do zumbi para este round
	zombie.setup_for_round(current_round)

	# Conecta o sinal de morte para contabilizar
	zombie.zombie_died.connect(_on_zombie_died)

	zombies_spawned += 1
	zombies_active += 1


func _on_zombie_died(death_pos: Vector3) -> void:
	kill_count += 1
	zombies_killed += 1
	zombies_active -= 1
	_update_ui()

	# 12% de chance de dropar um power-up
	if randf() < 0.12:
		_spawn_powerup_at(death_pos)


func _spawn_powerup_at(pos: Vector3) -> void:
	var powerup_types = ["max_ammo", "insta_kill", "double_points", "nuke", "instant_money"]
	var selected_type = powerup_types[randi() % powerup_types.size()]
	
	var powerup_script = preload("res://src/scripts/powerup.gd")
	var powerup = Node3D.new()
	powerup.set_script(powerup_script)
	powerup.type = selected_type
	get_tree().current_scene.add_child(powerup)
	# Garante que o power-up fique no chão
	powerup.global_position = Vector3(pos.x, 0.0, pos.z)
	print("[SPAWNER] Dropped power-up: ", selected_type, " em ", powerup.global_position)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.physical_keycode == KEY_F5:
			skip_to_round(10)


func skip_to_round(target: int) -> void:
	print("[SPAWNER] Skipping to round ", target)
	var zombies = get_tree().get_nodes_in_group("zombies")
	for z in zombies:
		z.queue_free()
	
	current_round = target - 1
	zombies_active = 0
	zombies_spawned = 0
	zombies_killed = 0
	
	_start_next_round()


func _update_ui() -> void:
	if not kill_label or not round_label:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			var hud = players[0].get_node_or_null("HUD")
			if hud:
				kill_label = hud.get_node_or_null("KillCounter")
				round_label = hud.get_node_or_null("RoundIndicator")
				
	if kill_label:
		kill_label.text = "KILLS: %d" % kill_count
