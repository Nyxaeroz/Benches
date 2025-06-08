extends PanelContainer

@onready var marker = $marker

var qte_start_pos : Vector2 = Vector2(25,25)
var qte_lower_bound : Vector2
var qte_upper_bound : Vector2

var active = false
var dir = 1
var speed = 5

signal finished(pos)
signal marker_moved_to_end

func _process(delta: float) -> void:
	if not active: return
	if (marker.position.x <= 25 and dir == -1) or (marker.position.x >= 575 and dir == 1): dir = dir * -1
	marker.position.x += dir * speed
		
func emit_position() -> void:
	finished.emit(marker.position.x)
	
func move_marker_to_end() -> void:
	var tween = get_tree().create_tween()
	if dir == -1: tween.tween_property(marker, "position", Vector2(25,25), 2.5)
	tween.tween_property(marker, "position", Vector2(575,25), 4)
	tween.tween_callback(func():
		marker_moved_to_end.emit()
	)
