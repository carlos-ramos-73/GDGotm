@tool
extends PopupMenu

const GOTM := "https://gotm.io/"
const GOTM_DOCS := "https://gotm.io/docs"
const GOTM_WEB_PLAYER := "https://gotm.io/web-player"
const y_offset := 10

@onready var build = $"../Build"
@onready var deploy = $"../Deploy"
@onready var panel = $".."


func _ready() -> void:
	close_requested.connect(func(): hide())


func build_and_upload_to_web_player() -> void:
	if build.build():
		deploy.deploy_to_web_player(GOTM_WEB_PLAYER)


func _set_menu_position() -> void:
	var main_window_position := DisplayServer.window_get_position()
	position.x = main_window_position.x + DisplayServer.window_get_size().x - size.x
	position.y = main_window_position.y + panel.size.y + y_offset


func _on_index_pressed(index: int) -> void:
	match index:
		0: build_and_upload_to_web_player()
		1: OS.shell_open(GOTM_DOCS)
		2: OS.shell_open(GOTM)


func _on_gd_gotm_button_pressed() -> void:
	popup()
