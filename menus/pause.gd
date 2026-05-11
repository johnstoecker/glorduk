extends CanvasLayer

const TITLE_SCENE := "res://menus/title.tscn"
const SETTINGS_SCENE := preload("res://menus/settings.tscn")

var settings_menu: CanvasLayer = null


func _ready() -> void:
	$Panel/Margin/VBox/Resume.pressed.connect(_on_resume)
	$Panel/Margin/VBox/Settings.pressed.connect(_on_settings)
	$Panel/Margin/VBox/Restart.pressed.connect(_on_restart)
	$Panel/Margin/VBox/QuitGame.pressed.connect(_on_quit_game)
	$Panel/Margin/VBox/Resume.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if settings_menu != null:
		return
	if event.is_action_pressed("pause"):
		get_viewport().set_input_as_handled()
		_on_resume()


func _on_settings() -> void:
	settings_menu = SETTINGS_SCENE.instantiate()
	settings_menu.closed.connect(_on_settings_closed)
	add_child(settings_menu)
	$Panel.visible = false


func _on_settings_closed() -> void:
	settings_menu = null
	$Panel.visible = true
	$Panel/Margin/VBox/Settings.grab_focus()

func _on_resume() -> void:
	get_tree().paused = false
	queue_free()

func _on_restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_game() -> void:
	get_tree().quit()
