extends Node

export (String, MULTILINE) var text : String setget set_text, get_text

onready var _label: Label= $Background/Label


func set_text(new_text: String) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	_label.text = new_text


func get_text() -> String:
	return _label.text


func get_size() -> Vector2:
	return _label.rect_size
