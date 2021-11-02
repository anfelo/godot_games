extends Area2D


export(int) var SPEED := 50
var moving := false

onready var anim_player: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $Sprite


func _process(delta: float) -> void:
	moving = false
	if Input.is_action_pressed("ui_right"):
		move(SPEED, 0, delta)
		sprite.flip_h = false
	if Input.is_action_pressed("ui_left"):
		move(-SPEED, 0, delta)
		sprite.flip_h = true
	if Input.is_action_pressed("ui_up"):
		move(0, -SPEED, delta)
	if Input.is_action_pressed("ui_down"):
		move(0, SPEED, delta)
	
	if moving == true:
		anim_player.play("Run")
	else:
		anim_player.play("Idle")
		anim_player.play("Idle")


func move(xspeed: int, yspeed: int, delta: float) -> void:
	position.x += xspeed * delta
	position.y += yspeed * delta
	moving = true


func _on_Piggy_area_entered(area: Area2D) -> void:
	area.queue_free()
	scale *= 1.1
