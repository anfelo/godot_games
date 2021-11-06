extends BasePlayerSideScroll

# ANCHOR: properties
# When dashing, we want to change the character's horizontal speed so we define
# two speed values.
export var base_speed := 600.0
export var dash_speed := 1800.0

# We use a timer to control the dash's duration.
onready var _dash_timer: Timer = $DashTimer
# END: properties


# ANCHOR: ready
func _ready() -> void:
	# When dashing, we'll start the timer. When it times out, we want to end the
	# dash. The `end_dash()` function takes care of that.
	_dash_timer.connect("timeout", self, "end_dash")
	speed = base_speed
# END: ready


# ANCHOR: direction
func _physics_process(delta: float) -> void:
	# We only update the move direction when the character isn't dashing to dash
	# in a continuous direction.
	if not is_dashing():
		_horizontal_direction = (
			Input.get_action_strength("move_right")
			- Input.get_action_strength("move_left")
		)
# END: direction

	# ANCHOR: dash_and_move
	# Dashing
	if Input.is_action_just_pressed("dash") and not is_dashing():
		start_dash()

	# Calculating the velocity and moving the character.
	_velocity.x = _horizontal_direction * speed
	# When dashing, we do not apply gravity to the character.
	if not is_dashing():
		_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity, UP_DIRECTION)
	# END: dash_and_move

	update_animation()
	update_look_direction()


# ANCHOR: start_end_dash
## Makes the character pass through walls and increases its speed for a short while.
func start_dash() -> void:
	speed = dash_speed
	_dash_timer.start()


## Resets the character's state to collide with wall and run normally.
func end_dash() -> void:
	speed = base_speed
	_dash_timer.stop()
# END: start_end_dash


# ANCHOR: is_dashing
## Returns `true` if the character is dashing.
func is_dashing() -> bool:
	return not _dash_timer.is_stopped()
# END: is_dashing


## Updates the character's animation depending on its current state.
func update_animation() -> void:
	if is_dashing():
		_anim_player.play("dash")
	elif is_running():
		_anim_player.play("run")
	elif is_falling():
		_anim_player.play("fall")
	else:
		_anim_player.play("idle")
