extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var max_barrel_rot = 60
var is_tracking = false
var tracked_body

var health = 5
var respawn_cooldown = 20
var respawn_timer = respawn_cooldown

var shoot_cooldown = 3
var rnd_factor = 2
var shoot_timer = shoot_cooldown

var is_destroyed = false

var shot_speed = 4
var min_shooting_dist = 80
var leading_factor = 40
var shot = preload("res://entities/enemies/flak/flak_shot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_tracking and not is_destroyed:
		$barrel.look_at(tracked_body.global_position + tracked_body.movement_vector * leading_factor)
		$barrel.rotation_degrees = clamp($barrel.rotation_degrees, -max_barrel_rot-90, max_barrel_rot-90)
		
		if shoot_timer < 0:
			shoot_timer = shoot_cooldown + randf() * rnd_factor
			shoot(delta)

	if is_destroyed:
		respawn_timer -= delta
		if respawn_timer < 0:
			is_destroyed = false
			respawn_timer = respawn_cooldown
			shoot_timer = 0
	else:
		shoot_timer -= delta


func _on_flak_body_entered(body):
	if body.get_collision_mask_bit(2):
		tracked_body = body
		is_tracking = true

func _on_flak_body_exited(body):
	if body.get_collision_mask_bit(2):
		is_tracking = false

func _on_Area2D_body_entered(body):
	if body.get_collision_mask_bit(2):
		body.take_damage()
		take_damage()

func _on_Area2D_area_entered(area):
	if area.get_collision_mask_bit(5):
		take_damage()

func take_damage():
	print("Took Damage!")
	health -= 1
	if health < 1:
		is_destroyed = true
		
func shoot(delta):
	# Calculate target pos
	var target_pos = tracked_body.global_position
	target_pos += tracked_body.movement_vector * leading_factor * Globals.difficulty_factor
	
	var can_shoot = (target_pos - $barrel/spawn.global_position).length() > min_shooting_dist
	can_shoot = can_shoot and $barrel.rotation_degrees > -max_barrel_rot-90 and $barrel.rotation_degrees < max_barrel_rot-90
	
	if can_shoot:
		# Create shot and spawn instance
		var node = shot.instance()
		get_tree().current_scene.add_child(node)
		node.global_position = $barrel/spawn.global_position
		node.look_at(target_pos)
		node.movement_vector = node.transform.x * shot_speed
		node.set_timer((target_pos - $barrel/spawn.global_position).length() / (shot_speed / delta))
		
		$AudioStreamPlayer2D.play(0)



