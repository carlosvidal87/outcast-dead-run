extends Node3D

## GameManager — Configura NavigationRegion3D (flat NavMesh) e o Spawner em runtime.
## A navegação é criada programaticamente porque o chão é um plano simples.

func _ready() -> void:
	_setup_navigation()
	_setup_spawner()
	_setup_perk_machines()


## Cria um NavigationRegion3D com um quad cobrindo a área jogável.
## Para mapas com obstáculos complexos, substituir por NavMesh baked no editor.
func _setup_navigation() -> void:
	var nav_region := NavigationRegion3D.new()
	var nav_mesh := NavigationMesh.new()

	# Quad plano cobrindo 1000x1000 metros centrado na origem.
	nav_mesh.vertices = PackedVector3Array([
		Vector3(-500, 0, -500),
		Vector3( 500, 0, -500),
		Vector3( 500, 0,  500),
		Vector3(-500, 0,  500)
	])
	nav_mesh.add_polygon(PackedInt32Array([0, 1, 2]))
	nav_mesh.add_polygon(PackedInt32Array([0, 2, 3]))

	nav_region.navigation_mesh = nav_mesh
	add_child(nav_region)


func _setup_spawner() -> void:
	var spawner := Node3D.new()
	spawner.name = "Spawner"
	spawner.set_script(preload("res://src/scripts/spawner.gd"))
	add_child(spawner)


func _setup_perk_machines() -> void:
	var perks_info = [
		{"id": "juggernog", "name": "Juggernog", "cost": 2500, "color": Color(0.8, 0.1, 0.1), "pos": Vector3(-5.0, 0.0, -5.0)},
		{"id": "speed_cola", "name": "Speed Cola", "cost": 3000, "color": Color(0.1, 0.7, 0.1), "pos": Vector3(0.0, 0.0, -8.0)},
		{"id": "double_tap", "name": "Double Tap", "cost": 2000, "color": Color(0.8, 0.7, 0.1), "pos": Vector3(5.0, 0.0, -5.0)}
	]
	
	var perk_script = preload("res://src/scripts/perk_machine.gd")
	for info in perks_info:
		var machine = StaticBody3D.new()
		machine.set_script(perk_script)
		machine.perk_id = info["id"]
		machine.perk_name = info["name"]
		machine.cost = info["cost"]
		machine.machine_color = info["color"]
		machine.name = "Perk_" + info["id"].capitalize()
		add_child(machine)
		machine.global_position = info["pos"]
		print("[GAME] Spawned perk machine: ", info["name"], " em ", info["pos"])

