extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	speed = (randf() / 10.0) + 0.04
	var scale_factor = 0.75 + randf() / 4.0
	scale = Vector2(scale_factor, scale_factor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.x < -300:
		queue_free()
	global_position.x -= speed
