extends Control

const MAIN_SCENE := "res://scenes/main/main.tscn"


func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return
	if event is InputEventKey and event.pressed:
		_start_game()
	elif event is InputEventJoypadButton and event.pressed:
		_start_game()
	elif event is InputEventMouseButton and event.pressed:
		_start_game()


func _start_game() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE)
