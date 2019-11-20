extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var movement_vector = Vector2(0, 0)

var gravity = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	# Apply Gravity
	movement_vector += Vector2(0, gravity * delta)
	move_and_collide(movement_vector)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
