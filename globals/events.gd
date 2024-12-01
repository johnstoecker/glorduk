extends Node

signal player_position(position: Vector2)

signal player_damaged(damage: float)
signal update_health(ratio: float, player_id: int)

signal arrow_fired
signal arrow_hit

signal put_eye
