extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var max_rotation_speed = 0.16
var max_speed = 4
var gravity = 4

var rotation_force = 0.18
var acceleration_force = 10

var rotation_speed = 0
var movement_vector = Vector2(0,0)

var has_rotated = false
var is_right_cannon = true

var shot = preload("res://entities/player/Shot.tscn")
var shot_speed = 10
var shot_cooldown = 0.2
var shot_timer = 0

func _physics_process(delta):
	has_rotated = false
	if Input.is_action_pressed("rotate_left"):
		rotation_speed -= rotation_force * delta
		has_rotated = true

	if Input.is_action_pressed("rotate_right"):
		rotation_speed += rotation_force * delta
		has_rotated = true

	if Input.is_action_pressed("accelerate"):
		movement_vector += -transform.y * acceleration_force * delta
	
	if Input.is_action_just_pressed("accelerate"):
		$AnimationPlayer.play("start")
		$AnimationPlayer.queue("firing")
		
	if Input.is_action_just_released("accelerate"):
		$AnimationPlayer.stop(1)
		$Sprite2.visible = false
		$Sprite3.visible = false
	
	if Input.is_action_pressed("shoot"):
		shoot()

	# Apply Gravity
	movement_vector += Vector2(0, gravity * delta)

	cap_and_slow_rotation()
	rotate(rotation_speed)

	movement_vector = movement_vector.clamped(max_speed)
	move_and_collide(movement_vector)

func cap_and_slow_rotation():
	rotation_speed = clamp(rotation_speed, -max_rotation_speed, max_rotation_speed)
	if not has_rotated:
		rotation_speed *= 0.8

func shoot():
	if shot_timer < 0:
		var node
		node = shot.instance()
		get_tree().current_scene.add_child(node)
		if is_right_cannon:
			node.global_position = $bulletspawn_right.global_position
		else:
			node.global_position = $bullerspawn_left.global_position
		is_right_cannon = not is_right_cannon
		node.movement_vector = -transform.y * shot_speed
		shot_timer = shot_cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shot_timer -= delta
