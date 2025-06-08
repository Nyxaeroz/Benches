extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Title, "modulate:a", 1, 1).from(0)
	tween.tween_property($Title, "modulate:a", 1, 2)
	tween.tween_property($Title, "modulate:a", 0, 1)
	tween.tween_callback(func():
		get_tree().change_scene_to_file("res://menu/menu_scene.tscn")
	)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	pass
	#get_tree().change_scene_to_file("res://menu/menu_scene.tscn")
