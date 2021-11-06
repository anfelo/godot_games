extends Node


onready var highscore_label = $HighScoreLabel


func _ready() -> void:
	set_highscore_label()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		var _r = get_tree().change_scene("res://Menus/StartMenu.tscn")


func set_highscore_label() -> void:
	var save_data = SaveAndLoad.load_data_from_file()
	highscore_label.text = "Highscore : " + str(save_data.highscore)
