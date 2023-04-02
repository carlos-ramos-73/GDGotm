extends Node

var force_offline := false


func _enter_tree() -> void:
	get_tree().root.gui_embed_subwindows = true


func initialize_gotm() -> void:
	var config := GotmConfig.new()
	config.project_key = $UI/FunctionalMenu/ProjectKey.text
	if force_offline:
		config.force_local_contents = true
		config.force_local_marks = true
		config.force_local_scores = true
		print("Forcing offline...")
	Gotm.initialize(config)
	get_tree().change_scene_to_file("res://scenes/functional_testing/gotm_score.tscn")


func _on_start_functional_pressed() -> void:
	$UI/Menu.hide()
	$UI/FunctionalMenu.show()


func _on_offline_toggled(button_pressed: bool) -> void:
	force_offline = button_pressed
