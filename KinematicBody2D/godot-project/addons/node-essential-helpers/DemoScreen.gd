## DemoScreen represents one screen in the demo.
##
## It has utilities for displaying a label, and creating physical walls so
## physics bodies can't walk out the screen.
##
## It serves as a container for the various demos and isn't directly related to
## any demo functionality.
##
## You can create a node of this type directly to add a screen to any demo, it
## instantiates the nodes it needs in code.
tool
class_name DemoScreen, "DemoScreen.svg"
extends Node2D

const TopLabel := preload("TopLabel.tscn")

const PHYSICS_LAYER_WALLS := 4

const DEFAULT_LABEL_FONT = preload("res://common/TitleFont.tres")
const BOUNDS_THICKNESS = 40.0

export var scene: PackedScene
export (String, MULTILINE) var text: String setget set_text, get_text

var _label := TopLabel.instance()
var _bounds := StaticBody2D.new()
var _collisions = {
	"left": CollisionShape2D.new(),
	"top": CollisionShape2D.new(),
	"right": CollisionShape2D.new(),
	"bottom": CollisionShape2D.new(),
	"label": CollisionShape2D.new()
}

var _scene_instance: Node


func _init() -> void:
	_initialize_bounds()


func _ready() -> void:
	assert(scene != null, "Missing scene to instantiate.")
	_scene_instance = scene.instance()
	if Engine.editor_hint:
		add_child(_scene_instance)
	name = _scene_instance.name

	# We need to wait for the instanced scene to be in the tree to add the label in front.
	yield(_scene_instance, "ready")
	add_child(_label)
	add_child(_bounds)
	_ready_bounds()
	_label.follow_viewport_enable = true
	_label.transform = transform



func _get_configuration_warning() -> String:
	if scene == null:
		return "Missing scene to instantiate."
	return ""


func activate() -> void:
	add_child(_scene_instance)


func deactivate() -> void:
	remove_child(_scene_instance)


func reset() -> void:
	_scene_instance.queue_free()
	_scene_instance = scene.instance()
	add_child(_scene_instance)


func set_text(new_text: String) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	_label.text = new_text


func get_text() -> String:
	return _label.text


func _initialize_bounds() -> void:
	_bounds.layers = PHYSICS_LAYER_WALLS
	for collision_name in _collisions:
		var collision_shape: CollisionShape2D = _collisions[collision_name]
		collision_shape.shape = RectangleShape2D.new()
		_bounds.add_child(collision_shape)
	_bounds.visible = false


func _ready_bounds() -> void:
	var size = get_viewport().get_size_override() / 2
	var offset = BOUNDS_THICKNESS / 2

	_collisions.left.position.y = size.y
	_collisions.left.position.x = -offset
	_collisions.left.shape.extents = Vector2(BOUNDS_THICKNESS, size.y)

	_collisions.top.position.x = size.x
	_collisions.top.position.y = -offset
	_collisions.top.shape.extents = Vector2(size.x, BOUNDS_THICKNESS)

	_collisions.right.position.x = size.x * 2 + offset
	_collisions.right.position.y = size.y
	_collisions.right.shape.extents = Vector2(BOUNDS_THICKNESS, size.y)

	_collisions.bottom.position.y = size.y * 2 + offset
	_collisions.bottom.position.x = size.x
	_collisions.bottom.shape.extents = Vector2(size.x, BOUNDS_THICKNESS)

	var collision_label_size = _label.get_size() / 2
	_collisions.label.position.x = collision_label_size.x
	_collisions.label.position.y = collision_label_size.y
	_collisions.label.shape.extents = collision_label_size + Vector2(10, 10)
