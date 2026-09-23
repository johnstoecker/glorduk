extends Node
class_name AudioManager

@onready var fire_sfx: AudioStreamPlayer2D = $FireSFX
@onready var hit_sfx: AudioStreamPlayer2D = $HitSFX
@onready var orc_death_sfx: AudioStreamPlayer2D = $OrcDeathSFX
@onready var human_death_sfx: AudioStreamPlayer2D = $HumanDeathSFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.connect("arrow_fired", _on_arrow_fired)
	Events.connect("arrow_hit", _on_arrow_hit)
	Events.orc_died.connect(_on_orc_died)
	Events.human_died.connect(_on_human_died)

func _on_arrow_fired():
	# TODO: why is this not correct?
	if !fire_sfx.playing:
		fire_sfx.pitch_scale = randf_range(0.95, 1.05)
		fire_sfx.play()

func _on_arrow_hit():
	hit_sfx.play()

func _on_orc_died():
	if !orc_death_sfx.playing:
		orc_death_sfx.pitch_scale = randf_range(0.95, 1.05)
		orc_death_sfx.play()

func _on_human_died():
	if !human_death_sfx.playing:
		human_death_sfx.pitch_scale = randf_range(0.95, 1.05)
		human_death_sfx.play()
