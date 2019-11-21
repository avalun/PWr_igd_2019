extends Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = get_node("../Player")
var lookahead = 120
var movement_factor = 5
var smoothing_factor = 0.2

var is_shaking = false
var shake_strength = 0
var shaking_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.current_camera = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var goal_pos = player.global_position + (-player.transform.y * lookahead) \
	+ player.movement_vector * player.movement_vector.length() * movement_factor
	
	global_position = lerp(global_position, goal_pos, smoothing_factor)
	
	if is_shaking:
		shaking_timer -= delta
		if shaking_timer < 0:
			is_shaking = false 
			set_offset(Vector2(0, 0))
		else:
			set_offset(Vector2(rand_range(-1.0, 1.0) * shake_strength, rand_range(-1.0, 1.0) * shake_strength))

func shake(duration, strength):
	shake_strength = strength
	shaking_timer = duration
	is_shaking = true
