## This class is is an overarching navigator to move between demo screens
##
## It isn't directly related to any demo functionality.
class_name DemoScreenNavigator, "DemoScreenNavigator.svg"
extends "Demo.gd"

signal screen_changed

const ROW_SIZE := 3
const DemoScreen := preload("DemoScreen.gd")

var _screens = []
var _current_screen_index: int setget set_current_screen_index

var _camera := Camera2D.new()
var _deactivate_timer := Timer.new()

var _screen_size := Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
)


func _init():
	_initialize_camera()


func _initialize_camera() -> void:
	_camera.current = true
	_camera.smoothing_enabled = true
	_camera.smoothing_speed = 5.0
	_camera.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	add_child(_camera)


func _ready() -> void:
	_ready_screens()
	_ready_deactivate_timer()
	if not Engine.editor_hint:
		var start_screen_index := int(get_javascript_parameter('screen', '0'))
		set_current_screen_index(start_screen_index)
		get_current_screen().activate()
		snap_camera_to_current_screen()


func _ready_screens():
	var index := 0
	for child in get_children():
		if child is DemoScreen:
			_screens.append(child)
			child.position = _screen_size * Vector2(index % ROW_SIZE, index / ROW_SIZE)
			index += 1
			assert(_screens.size() > 0, "No demo screen instances found as children.")


func _ready_deactivate_timer() -> void:
	_deactivate_timer.one_shot = true
	_deactivate_timer.wait_time = 1.0
	add_child(_deactivate_timer)


func get_current_screen() -> DemoScreen:
	return _screens[_current_screen_index]


func set_current_screen_index(new_index: int) -> void:
	if new_index == _current_screen_index:
		return

	emit_signal("screen_changed")
	var current_screen: DemoScreen = _screens[_current_screen_index]
	_current_screen_index = wrapi(new_index, 0, _screens.size())
	var next_screen: DemoScreen = _screens[_current_screen_index]
	next_screen.activate()
	_deactivate_timer.connect("timeout", current_screen, "deactivate", [], CONNECT_ONESHOT)
	# If the player goes to the next and previous screens quickly, we want to cancel deactivating the screen.
	connect(
		"screen_changed",
		_deactivate_timer,
		"disconnect",
		["timeout", current_screen, "deactivate"],
		CONNECT_ONESHOT
	)
	_deactivate_timer.start()
	snap_camera_to_current_screen()


func go_to_next_screen() -> void:
	set_current_screen_index(_current_screen_index + 1)


func go_to_previous_screen() -> void:
	set_current_screen_index(_current_screen_index - 1)


func get_javascript_parameter(parameter: String, default):
	if OS.has_feature('JavaScript'):
		var js_str = "new URL(window.location.href).searchParams.get('%s');" % [parameter]
		var response = JavaScript.eval(js_str)
		if response != null:
			return response
	return default


func set_visible_areas(are_they_visible: bool) -> void:
	for debug_shape in get_tree().get_nodes_in_group("CollisionShapeDebug"):
		debug_shape.visible = are_they_visible


func reset_current_screen() -> void:
	_screens[_current_screen_index].reset()


func snap_camera_to_current_screen() -> void:
	var grid_size: Vector2 = get_viewport().get_size_override()
	var current_screen: DemoScreen = get_current_screen()
	var ratio := current_screen.global_position / grid_size
	_camera.position = ratio.floor() * grid_size + grid_size / 2
