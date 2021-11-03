extends RigidBody2D


const HitEffect: PackedScene = preload("res://Effects/HitEffect.tscn") 

onready var laser_sound = $LaserSound


func _ready() -> void:
	laser_sound.play()


func create_hit_effect() -> void:
	var main = get_tree().current_scene
	var hit_effect = HitEffect.instance()
	main.add_child(hit_effect)
	hit_effect.global_position = global_position
