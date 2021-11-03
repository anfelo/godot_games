extends Area2D


const Bullet: PackedScene = preload("res://Bullet/Bullet.tscn")
const ExplosionEffect: PackedScene = preload("res://Effects/ExplosionEffect.tscn")

export(int) var SPEED = 100

signal player_death


func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		move(SPEED, 0, delta)
	if Input.is_action_pressed("ui_left"):
		move(-SPEED, 0, delta)
	if Input.is_action_pressed("ui_down"):
		move(0, SPEED, delta)
	if Input.is_action_pressed("ui_up"):
		move(0, -SPEED, delta)
	if Input.is_action_just_pressed("ui_accept"):
		fire()


func move(x_speed: int, y_speed: int, delta: float) -> void:
	position.x += x_speed * delta
	position.y += y_speed * delta


func fire() -> void:
	var bullet = Bullet.instance()
	var main = get_tree().current_scene
	main.add_child(bullet)
	bullet.global_position = global_position


func _on_Player_area_entered(area: Area2D) -> void:
	area.queue_free()
	queue_free()


func _exit_tree() -> void:
	var main = get_tree().current_scene
	var explosion_effect = ExplosionEffect.instance()
	main.add_child(explosion_effect)
	explosion_effect.global_position = global_position
	emit_signal("player_death")
