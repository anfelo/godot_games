extends Node


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://Menus/StartMenu.tscn")
