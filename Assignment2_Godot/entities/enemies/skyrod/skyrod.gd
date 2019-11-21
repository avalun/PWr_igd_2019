extends Area2D

var movement_vector = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("play")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += movement_vector
	Globals.current_camera.shake(0.4, 100)
		
		

func _on_skyrod_body_entered(body):
	if body.get_collision_mask_bit(2):
		body.take_damage()
