extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var kill_time = 2
var movement_vector = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var rand = 0.3 + randf() * 0.8

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += movement_vector
	movement_vector *= 0.985
	scale *= 1.004
	
	$AnimationPlayer.play("smoke")
	kill_time -= delta
	if kill_time < 0:
		queue_free()
