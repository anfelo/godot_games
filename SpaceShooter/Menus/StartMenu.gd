extends Node


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var _r = get_tree().change_scene("res://World.tscn")
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
