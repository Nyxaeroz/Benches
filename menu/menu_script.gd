extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ButtonContainer.position.x = 1300
	var tween = get_tree().create_tween()
	#tween.tween_property($BackgroundImg, "modulate:a", 1, 1).from(0)
	tween.tween_property($Blue, "modulate:a", 1, 1.5).from(0)
	tween.tween_property($ButtonContainer, "position", Vector2(917,411), 1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_start_pressed() -> void:
	print("detected: start button pressed")
	get_tree().change_scene_to_file("res://vignettes/vignette_scene.tscn")

func _on_button_info_pressed() -> void:
	print("detected: info button pressed")
	$InfoPanel.visible = not $InfoPanel.visible

func _on_button_quit_pressed() -> void:
	print("detected: quit button pressed")
	get_tree().quit()
