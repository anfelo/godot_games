## Loads one screen inside a SceneSlideshow
tool
class_name SlideshowScreenLoader
extends Node

const WARNING_MISSING_SCENE := "This node needs a valid scene to function. Please set the Scene property."

export var scene: PackedScene
export (String, MULTILINE) var text := ""


func display_scene() -> void:
	add_child(scene.instance())


func clear_scene() -> void:
	for child in get_children():
		child.queue_free()


func reset() -> void:
	clear_scene()
	add_child(scene.instance())


func _get_configuration_warning() -> String:
	return WARNING_MISSING_SCENE if scene == null else ""
