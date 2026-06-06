extends Control

# script de controle do menu (funciona durante o pause)

var start_menu: ColorRect
var pause_menu: ColorRect

func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS

func _ready() -> void:
	# Ajusta âncoras para cobrir toda a tela
	anchor_left = 0.0
	anchor_right = 1.0
	anchor_top = 0.0
	anchor_bottom = 1.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	_create_start_menu()
	_create_pause_menu()
	
	# Inicia o jogo mostrando o menu inicial e pausando a simulação
	show_start_menu()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or (event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE):
		# Impede fechar/abrir menu se o menu inicial estiver ativo
		if start_menu.visible:
			return
		
		# Consome o evento para evitar que outros nós processem
		get_viewport().set_input_as_handled()
		
		if pause_menu.visible:
			resume_game()
		else:
			pause_game()

# criacao dinamica da ui

func _create_start_menu() -> void:
	start_menu = ColorRect.new()
	start_menu.color = Color(0.04, 0.04, 0.04, 0.85) # Escuro semi-transparente
	start_menu.anchor_left = 0.0
	start_menu.anchor_right = 1.0
	start_menu.anchor_top = 0.0
	start_menu.anchor_bottom = 1.0
	add_child(start_menu)
	
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	start_menu.add_child(center)
	
	# Container central
	var container := VBoxContainer.new()
	container.alignment = BoxContainer.ALIGNMENT_CENTER
	container.custom_minimum_size = Vector2(300, 400)
	center.add_child(container)
	
	# Título do Jogo
	var title := Label.new()
	title.text = "OUTCAST"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 72)
	title.add_theme_color_override("font_color", Color(0.85, 0.1, 0.1)) # Vermelho CoD
	title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	title.add_theme_constant_override("shadow_offset_x", 4)
	title.add_theme_constant_override("shadow_offset_y", 4)
	container.add_child(title)
	
	# Subtítulo
	var subtitle := Label.new()
	subtitle.text = "DEAD RUN"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 20)
	subtitle.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	container.add_child(subtitle)
	
	# Espaçador
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 40)
	container.add_child(spacer)
	
	# Estilos de Botão
	var style_normal = _create_button_style(Color(0.12, 0.12, 0.12, 0.9), Color(0.5, 0.05, 0.05, 0.8))
	var style_hover = _create_button_style(Color(0.25, 0.05, 0.05, 0.95), Color(0.9, 0.1, 0.1, 1.0))
	var style_pressed = _create_button_style(Color(0.4, 0.05, 0.05, 1.0), Color(1.0, 0.2, 0.2, 1.0))
	
	# Botão Jogar
	var btn_play := Button.new()
	btn_play.text = "INICIAR JOGO"
	btn_play.custom_minimum_size = Vector2(250, 50)
	_apply_button_theme(btn_play, style_normal, style_hover, style_pressed)
	btn_play.pressed.connect(self._on_play_pressed)
	container.add_child(btn_play)
	
	# Espaçador curto
	var spacer2 := Control.new()
	spacer2.custom_minimum_size = Vector2(0, 15)
	container.add_child(spacer2)
	
	# Botão Sair
	var btn_quit := Button.new()
	btn_quit.text = "SAIR"
	btn_quit.custom_minimum_size = Vector2(250, 50)
	_apply_button_theme(btn_quit, style_normal, style_hover, style_pressed)
	btn_quit.pressed.connect(self._on_quit_pressed)
	container.add_child(btn_quit)


func _create_pause_menu() -> void:
	pause_menu = ColorRect.new()
	pause_menu.color = Color(0.02, 0.02, 0.02, 0.8) # Escuro semi-transparente de pausa
	pause_menu.anchor_left = 0.0
	pause_menu.anchor_right = 1.0
	pause_menu.anchor_top = 0.0
	pause_menu.anchor_bottom = 1.0
	pause_menu.visible = false
	add_child(pause_menu)
	
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	pause_menu.add_child(center)
	
	# Container central
	var container := VBoxContainer.new()
	container.alignment = BoxContainer.ALIGNMENT_CENTER
	container.custom_minimum_size = Vector2(300, 400)
	center.add_child(container)
	
	# Título de Pausa
	var title := Label.new()
	title.text = "PAUSADO"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 54)
	title.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
	title.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	title.add_theme_constant_override("shadow_offset_x", 3)
	title.add_theme_constant_override("shadow_offset_y", 3)
	container.add_child(title)
	
	# Espaçador
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 40)
	container.add_child(spacer)
	
	# Estilos de Botão
	var style_normal = _create_button_style(Color(0.12, 0.12, 0.12, 0.9), Color(0.4, 0.4, 0.4, 0.8))
	var style_hover = _create_button_style(Color(0.2, 0.2, 0.2, 0.95), Color(0.8, 0.8, 0.8, 1.0))
	var style_pressed = _create_button_style(Color(0.3, 0.3, 0.3, 1.0), Color(1.0, 1.0, 1.0, 1.0))
	
	# Botão Retomar
	var btn_resume := Button.new()
	btn_resume.text = "RETOMAR JOGO"
	btn_resume.custom_minimum_size = Vector2(250, 50)
	_apply_button_theme(btn_resume, style_normal, style_hover, style_pressed)
	btn_resume.pressed.connect(self.resume_game)
	container.add_child(btn_resume)
	
	# Espaçador curto
	var spacer2 := Control.new()
	spacer2.custom_minimum_size = Vector2(0, 15)
	container.add_child(spacer2)
	
	# Botão Reiniciar
	var btn_restart := Button.new()
	btn_restart.text = "RECOMEÇAR"
	btn_restart.custom_minimum_size = Vector2(250, 50)
	_apply_button_theme(btn_restart, style_normal, style_hover, style_pressed)
	btn_restart.pressed.connect(self._on_restart_pressed)
	container.add_child(btn_restart)
	
	# Espaçador curto
	var spacer3 := Control.new()
	spacer3.custom_minimum_size = Vector2(0, 15)
	container.add_child(spacer3)
	
	# Botão Voltar ao Menu
	var btn_menu := Button.new()
	btn_menu.text = "MENU PRINCIPAL"
	btn_menu.custom_minimum_size = Vector2(250, 50)
	_apply_button_theme(btn_menu, style_normal, style_hover, style_pressed)
	btn_menu.pressed.connect(self._on_menu_pressed)
	container.add_child(btn_menu)
	
	# Espaçador curto
	var spacer4 := Control.new()
	spacer4.custom_minimum_size = Vector2(0, 15)
	container.add_child(spacer4)
	
	# Botão Sair
	var btn_quit := Button.new()
	btn_quit.text = "SAIR"
	btn_quit.custom_minimum_size = Vector2(250, 50)
	_apply_button_theme(btn_quit, style_normal, style_hover, style_pressed)
	btn_quit.pressed.connect(self._on_quit_pressed)
	container.add_child(btn_quit)

# funcoes de estado

func show_start_menu() -> void:
	get_tree().paused = true
	start_menu.visible = true
	pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func pause_game() -> void:
	get_tree().paused = true
	pause_menu.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func resume_game() -> void:
	get_tree().paused = false
	pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# eventos dos botoes

func _on_play_pressed() -> void:
	start_menu.visible = false
	resume_game()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed() -> void:
	get_tree().quit()

# helpers visuais

func _create_button_style(bg: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = border
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	return style

func _apply_button_theme(btn: Button, normal: StyleBoxFlat, hover: StyleBoxFlat, pressed: StyleBoxFlat) -> void:
	btn.add_theme_stylebox_override("normal", normal)
	btn.add_theme_stylebox_override("hover", hover)
	btn.add_theme_stylebox_override("pressed", pressed)
	btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	
	btn.add_theme_font_size_override("font_size", 18)
	btn.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))
	btn.add_theme_color_override("font_hover_color", Color(1.0, 1.0, 1.0))
	btn.add_theme_color_override("font_pressed_color", Color(1.0, 0.5, 0.5))
