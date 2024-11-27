extends Node
class_name AudioManager

@onready var fire_sfx: AudioStreamPlayer2D = $FireSFX
@onready var hit_sfx: AudioStreamPlayer2D = $HitSFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.connect("arrow_fired", _on_arrow_fired)
	Events.connect("arrow_hit", _on_arrow_hit)

func _on_arrow_fired():
	# TODO: why is this not correct?
	if !fire_sfx.playing:
		fire_sfx.pitch_scale = randf_range(0.95, 1.05)
		fire_sfx.play()

func _on_arrow_hit():
	hit_sfx.play()
