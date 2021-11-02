extends Node


onready var anim_player: AnimationPlayer = $AnimationPlayer


func _on_LaunchButton_pressed() -> void:
	anim_player.play("Launch")
