extends Node

const SETTINGS_PATH := "user://settings.cfg"

var master_volume: float = 0.0


func _ready() -> void:
	_load()
	_apply()


func set_master_volume(value: float) -> void:
	master_volume = clampf(value, 0.0, 1.0)
	_apply()
	_save()


func _apply() -> void:
	var bus := AudioServer.get_bus_index("Master")
	if master_volume <= 0.0001:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, linear_to_db(master_volume))


func _load() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_PATH) == OK:
		master_volume = cfg.get_value("audio", "master_volume", 1.0)


func _save() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("audio", "master_volume", master_volume)
	cfg.save(SETTINGS_PATH)
