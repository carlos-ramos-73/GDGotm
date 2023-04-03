@tool
extends Panel

const ALPHA_TWEEN_DURATION := 1

@export var hovered_colors: PackedColorArray

@onready var background_texture: NoiseTexture2D = preload("res://addons/gotm/scenes/toolbar/gd_gotm_toolbar.tres")
@onready var background: TextureRect = $Background
@onready var gotm_button: Button = $GDGotmButton
var alpha_tween: Tween
var final_color: Color


func _ready() -> void:
	# assign gradient colors
	if hovered_colors.size() != 2:
		hovered_colors = PackedColorArray([Color8(41,121,255,255),Color8(101,31,255,255)]) # gotm colors
	background_texture.color_ramp.colors = hovered_colors

	background.modulate = Color.TRANSPARENT
	final_color = Color.TRANSPARENT
	alpha_tween = create_tween() # making sure is not null,
	alpha_tween.kill() # but don't run it


func _process(_delta: float) -> void:
	tween_alpha()


func tween_alpha() -> void:
	if gotm_button.is_hovered():
		if background.modulate == Color.WHITE:
			return
		if !alpha_tween.is_running() || final_color == Color.TRANSPARENT:
			final_color = Color.WHITE
			alpha_tween.kill()
			alpha_tween = create_tween()
			alpha_tween.tween_property(background, "modulate", final_color,ALPHA_TWEEN_DURATION).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	else:
		if background.modulate == Color.TRANSPARENT:
			return
		if !alpha_tween.is_running() || final_color == Color.WHITE:
			final_color = Color.TRANSPARENT
			alpha_tween.kill()
			alpha_tween = create_tween()
			alpha_tween.tween_property(background, "modulate", final_color,ALPHA_TWEEN_DURATION).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_gd_gotm_button_pressed() -> void:
	$Menu.popup()
