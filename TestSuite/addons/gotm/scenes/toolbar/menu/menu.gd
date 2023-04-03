@tool
extends PopupMenu


func _ready() -> void:
	close_requested.connect(func(): hide())


func build_and_upload_to_web_player() -> void:
	pass


func _set_menu_position() -> void:
	var main_window_position := DisplayServer.window_get_position()
	position.x = main_window_position.x + DisplayServer.window_get_size().x - size.x
	position.y = main_window_position.y + size.y


func _on_index_pressed(index: int) -> void:
	if index == 0:
		build_and_upload_to_web_player()
