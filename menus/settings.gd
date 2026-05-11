extends CanvasLayer

signal closed

@onready var slider: HSlider = $Panel/Margin/VBox/Volume/Slider
@onready var percent: Label = $Panel/Margin/VBox/Volume/Percent
@onready var back_button: Button = $Panel/Margin/VBox/Back


func _ready() -> void:
	slider.min_value = 0.0
	slider.max_value = 1.0
	slider.step = 0.01
	slider.value = Settings.master_volume
	_update_percent(Settings.master_volume)

	slider.value_changed.connect(_on_volume_changed)
	back_button.pressed.connect(_close)
	slider.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_close()


func _on_volume_changed(value: float) -> void:
	Settings.set_master_volume(value)
	_update_percent(value)


func _update_percent(value: float) -> void:
	percent.text = "%d%%" % roundi(value * 100.0)


func _close() -> void:
	closed.emit()
	queue_free()
