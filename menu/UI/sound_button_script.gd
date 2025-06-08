extends TextureButton

@export var hover_sfx : AudioStream
@export var click_sfx : AudioStream

signal click_sfx_finished

func _ready():
	$HoverSFX.stream = hover_sfx
	$ClickSFX.stream = click_sfx

func _on_mouse_entered() -> void:
	if hover_sfx:
		$HoverSFX.play()

func _on_pressed() -> void:
	if click_sfx:
		$ClickSFX.play()
