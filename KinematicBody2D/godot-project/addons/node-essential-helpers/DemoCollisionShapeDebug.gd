## This class is a simple debug shape to visualize Area2Ds.
##
## It isn't directly related to any demo functionality.
tool
class_name DemoCollisionShapeDebug, "DemoCollisionShapeDebug.svg"
extends Node2D

var _halo_circle = preload("./HaloCircle.tscn").instance()

enum ShapeType { AUTODETECT, SQUARE, CIRCLE }

export (ShapeType) var shape_type: int = ShapeType.AUTODETECT setget set_shape_type

export var outline_color := Color(1, 0, 0) setget set_outline_color
export var outline_thickness := 1.0 setget set_outline_thickness
export var shape_size: Vector2 setget set_shape_size

export var do_draw_fill := false


func _ready() -> void:
	autodetect_shape_if_necessary()
	add_to_group("CollisionShapeDebug")
	add_child(_halo_circle)
	_halo_circle.visible = false
	if not Engine.is_editor_hint() and is_main_scene():
		visible = false


func is_main_scene() -> bool:
	var current_scene = get_tree().current_scene.filename
	var main_scene = ProjectSettings.get_setting('application/run/main_scene')
	return current_scene == main_scene


func _draw() -> void:
	if shape_type == ShapeType.CIRCLE:
		_halo_circle.visible = true
		_halo_circle.halo_color = outline_color
		_halo_circle.size = shape_size.x * 2
		if do_draw_fill:
			draw_circle(Vector2.ZERO, shape_size.x, outline_color)
	elif shape_type == ShapeType.SQUARE:
		var rect = Rect2(-shape_size, shape_size * 2)
		draw_rect(rect, outline_color, do_draw_fill, outline_thickness, true)


func _get_configuration_warning() -> String:
	return "" if has_valid_parent() else "Parent isn't a CollisionShape2D"


func autodetect_shape_if_necessary() -> void:
	if shape_type == ShapeType.AUTODETECT:
		autodetect_shape()


func autodetect_shape() -> void:
	var parent: CollisionShape2D = get_parent()
	assert(
		has_valid_parent(), "Parent at '%s' isn't a valid CollisionShape2D" % [parent.get_path()]
	)
	if parent.shape is CircleShape2D:
		shape_type = ShapeType.CIRCLE
		shape_size = Vector2(parent.shape.radius, parent.shape.radius)
	elif parent.shape is RectangleShape2D:
		shape_type = ShapeType.SQUARE
		shape_size = parent.shape.extents
	else:
		push_error("Shape '%s' at '%s' isn't a supported shape" % [parent.shape, parent.get_path()])


func draw_dotted_circle(center, radius, color, resolution = 0) -> void:
	if resolution == 0:
		var circumference = 2 * PI * radius
		resolution = int(circumference / 20.0)
	var points_arc = PoolVector2Array()
	var angle_from = 0
	var angle_to = 360

	for i in range(resolution + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / resolution - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(resolution):
		if index_point % 2:
			draw_line(
				points_arc[index_point], points_arc[index_point + 1], color, outline_thickness, true
			)


func has_valid_parent() -> bool:
	var parent = get_parent()
	return parent is CollisionShape2D


func set_outline_color(new_outline_color: Color) -> void:
	outline_color = new_outline_color
	update()


func set_outline_thickness(new_outline_thickness: float) -> void:
	outline_thickness = new_outline_thickness
	update()


func set_shape_size(new_shape_size: Vector2) -> void:
	shape_size = new_shape_size
	update()


func set_shape_type(new_shape_type: int) -> void:
	shape_type = new_shape_type
	update()
