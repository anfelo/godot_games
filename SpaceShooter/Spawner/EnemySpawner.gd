extends Node2D


const Enemy: PackedScene = preload("res://Enemy/Enemy.tscn")

onready var spawn_points = $SpawnPoints


func get_spawn_position():
	var points = spawn_points.get_children()
	points.shuffle()
	return points[0].global_position


func spawn_enemy():
	var spawn_position = get_spawn_position()
	var enemy = Enemy.instance()
	var main = get_tree().current_scene
	main.add_child(enemy)
	enemy.global_position = spawn_position


func _on_Timer_timeout() -> void:
	spawn_enemy()
