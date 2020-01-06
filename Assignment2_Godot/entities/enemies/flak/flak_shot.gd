extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var movement_vector = Vector2(0, 0)
var explosion_timer = 0
var destuction_timer = 0.8
var is_queued_for_destr = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("shot")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += movement_vector
	explosion_timer -= delta
	if explosion_timer < 0 and not is_queued_for_destr:
		$AudioStreamPlayer.play(0)
		movement_vector = Vector2(0, 0)
		$AnimationPlayer.play("explosion")
		is_queued_for_destr = true
		var dst = 200.0 / (Globals.player.global_position - global_position).length()
		if dst > 0.5:
			Globals.current_camera.shake(0.4, dst * 1.2)
		
		
	if is_queued_for_destr:
		destuction_timer -= delta
		if destuction_timer < 0:
			queue_free()
	

func set_timer(time):
	explosion_timer = time

func _on_flak_shot_body_entered(body):
	if body.get_collision_mask_bit(2):
		body.take_damage()
