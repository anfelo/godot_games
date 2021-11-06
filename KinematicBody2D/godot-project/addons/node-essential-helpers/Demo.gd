## Base class for nodes that help navigate demo screens.
##
## Displays a label at the top of the screen.
##
## Expects the demo UI to be available in the scene.
extends Node2D

onready var _ui := $UI
onready var _button_previous: TextureButton = _ui.find_node("PreviousButton")
onready var _button_next: TextureButton = _ui.find_node("NextButton")
onready var _button_visible_shapes: Button = _ui.find_node("ShowDebugButton")
onready var _button_reset: Button = _ui.find_node("ResetButton")


func _ready() -> void:
	_ready_buttons()


func set_visible_areas(are_visible: bool) -> void:
	for debug_shape in get_tree().get_nodes_in_group("CollisionShapeDebug"):
		debug_shape.visible = are_visible


func _ready_buttons() -> void:
	_button_previous.connect("pressed", self, "go_to_previous_screen")
	_button_next.connect("pressed", self, "go_to_next_screen")
	_button_visible_shapes.connect("toggled", self, "set_visible_areas")
	_button_reset.connect("pressed", self, "reset_current_screen")
