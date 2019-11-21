extends Area2D

var movement_vector = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	global_position += movement_vector

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.x > 1200 or global_position.x < -100 \
	or global_position.y < -600 or global_position.y > 1200:
		queue_free()
