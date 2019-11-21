extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var movement_vector = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	global_position += movement_vector

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
