extends Node

var force_offline := false


func initialize_gotm() -> void:
	var config := GotmConfig.new()
	if force_offline:
		config.force_local_contents = true
		config.force_local_marks = true
		config.force_local_scores = true
		print("Forcing offline...")
	Gotm.initialize(config)


func _on_start_functional_pressed() -> void:
	$UI/Menu.hide()
	$UI/FunctionalMenu.show()


func _on_offline_toggled(button_pressed: bool) -> void:
	force_offline = button_pressed


func _on_gotm_score_pressed() -> void:
	initialize_gotm()
	get_tree().change_scene_to_file("res://scenes/functional_testing/gotm_score.tscn")
