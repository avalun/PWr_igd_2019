extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var max_barrel_rot = 60
var is_tracking = false
var tracked_body

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_tracking:
		$barrel.look_at(tracked_body.global_position)
		$barrel.rotation_degrees = clamp($barrel.rotation_degrees, -max_barrel_rot-90, max_barrel_rot-90)


func _on_flak_body_entered(body):
	if body.get_collision_mask_bit(2):
		tracked_body = body
		is_tracking = true
	pass # Replace with function body.
