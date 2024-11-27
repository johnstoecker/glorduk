extends Control


@onready var foreground: ColorRect = $Foreground

var amount: float = 1:
	get:
		return amount
	set(value):
		amount = clamp(value, 0, 1)
		foreground.size = Vector2(496 * amount, 48)
		if amount < .3:
			foreground.color = Color.RED
		elif amount < .7:
			foreground.color = Color.YELLOW
		else:
			foreground.color = Color.GREEN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.connect("update_health", _on_update_health)
	pass

func _on_update_health(ratio: float):
	print("updated health....")
	amount = ratio

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
