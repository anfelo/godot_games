## SceneSlideshow takes its children and allows you to cycle through them.
##
## To use with scenes that require a custom camera, for nodes like Camera2D,
## CanvasLayer, etc.
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
class_name SceneSlideshow, "DemoScreen.svg"
extends "Demo.gd"

const TopLabel := preload("TopLabel.tscn")


var index: int setget set_index

var _label := TopLabel.instance()
## Scenes to cycle through in the slideshow.
var _scene_loaders := []


func _ready() -> void:
	for child in get_children():
		if not child is SlideshowScreenLoader:
			continue
		_scene_loaders.append(child)
	assert(
		_scene_loaders.size() != 0,
		get_class() + " needs SlideshowSceneLoader instances as children, none found."
	)
	if not Engine.editor_hint:
		set_index(index)
	add_child(_label)


func set_index(value: int) -> void:
	var old_index := index
	index = wrapi(value, 0, _scene_loaders.size())
	var current_scene = _scene_loaders[old_index]
	var new_scene = _scene_loaders[index]

	current_scene.call_deferred("clear_scene")
	new_scene.call_deferred("display_scene")

	_label.set_text(_scene_loaders[index].text)


func go_to_next_screen() -> void:
	self.index += 1


func go_to_previous_screen() -> void:
	self.index -= 1


func reset_current_screen() -> void:
	_scene_loaders[index].reset()
