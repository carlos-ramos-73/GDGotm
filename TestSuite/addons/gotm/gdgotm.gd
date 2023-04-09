@tool
extends EditorPlugin

var gdgotm_toolbar: Control = preload("res://addons/gotm/scenes/toolbar/gd_gotm_toolbar.tscn").instantiate()


func _enter_tree() -> void:
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, gdgotm_toolbar)


func _exit_tree() -> void:
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, gdgotm_toolbar)
	gdgotm_toolbar.queue_free()