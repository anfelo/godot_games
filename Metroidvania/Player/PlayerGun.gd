extends Node2D


func _process(delta: float) -> void:
	var player = get_parent()
	rotation = player.get_local_mouse_position().angle()
