extends PanelContainer

@export var photo_img   : Texture2D
@export var purple_imgs : Array[Texture2D]
@export var coordinates : Array[Vector2]
@export var blue_img    : Texture2D
@export var pos_blue    : Vector2           = Vector2(113,300)
@export var audio_stream: AudioStream       = load("res://audio/westewagenhof-20250523.ogg")
@export var max_db      : int               = 0

@onready var photo      : TextureRect       = $Photo
@onready var blue       : Sprite2D          = $Blue
@onready var purple     : Sprite2D          = $Purple
@onready var audio      : AudioStreamPlayer = $Audio


func _ready() -> void:
	$Photo.texture = photo_img
	$Blue.texture = blue_img
	$Purple.texture = purple_imgs[0]
	$Audio.stream = audio_stream
	
	blue.position = pos_blue
	blue.visible = true
	purple.visible = false

# pos: slider value between 0 and 1
func place_purple_at(pos: float) -> void:
	# PERCENTAGE METHOD
	## map slider value to appropriate index:
	#var index : int = floor(pos * purple_imgs.size())
	## make sure index is within bounds of array:
	#index = min(purple_imgs.size() - 1, index)
	##set texture and position accordingly:
	
	# CLOSEST COORDINATE
	var min_dist = 1000
	var index = -1
	for c in coordinates:
		if abs(c.x - pos) < min_dist:
			index += 1
			min_dist = abs(c.x - pos)
	
	purple.texture  = purple_imgs[index]
	purple.position = coordinates[index]
	purple.visible = true

func play_audio():
	var r : float = randf_range(0.0, audio.stream.get_length() - 20)
	var tween = get_tree().create_tween()
	tween.tween_property(audio, "volume_db", max_db, 3).from(-30)
	audio.play(r)

func stop_audio():
	var tween = get_tree().create_tween()
	tween.tween_property(audio, "volume_db", -40, 3).from(max_db)
	tween.tween_callback(func():
		audio.stop()
	)
