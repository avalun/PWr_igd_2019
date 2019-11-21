extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var max_rotation_speed = 0.16
var max_speed = 5
var gravity = 3

var acceleration_force = 12
var rotation_force = 0.18
var rotation_falloff = 0.8

var rotation_speed = 0
var movement_vector = Vector2(0,0)
var bounds_speed = 0.2

var is_engine_disabled = false
var engine_cooldown = 1.2
var engine_timer = 0

var has_rotated = false
var is_right_cannon = true

var shot = preload("res://entities/player/Shot.tscn")
var shot_speed = 6
var shot_cooldown = 1
var shot_timer = 0

var smoke = preload("res://entities/player/smoke.tscn")
var smoke_timer = 0
var smoke_interval_h1 = 0.1
var smoke_interval_h2 = 0.4

var health = 3
var heal_timer = -1
var heal_cooldown = 10

var bulletspawns = []

func _ready():
	bulletspawns = [$bullet_0, $bullet_1, $bullet_2, $bullet_3, $bullet_4]
	Globals.player = self

func _physics_process(delta):
	has_rotated = false
	if Input.is_action_pressed("rotate_left"):
		rotation_speed -= rotation_force * delta
		has_rotated = true

	if Input.is_action_pressed("rotate_right"):
		rotation_speed += rotation_force * delta
		has_rotated = true

	if Input.is_action_pressed("accelerate") and not is_engine_disabled:
		movement_vector += -transform.y * acceleration_force * delta
	
	if Input.is_action_just_pressed("accelerate") and not is_engine_disabled:
		$AnimationPlayer.play("start")
		$AnimationPlayer.queue("firing")
		
	if Input.is_action_just_released("accelerate"):
		$AnimationPlayer.stop(1)
		$Sprite2.visible = false
		$Sprite3.visible = false
	
	# Apply Gravity
	movement_vector += Vector2(0, gravity * delta)

	cap_and_slow_rotation()
	rotate(rotation_speed)
	
	respect_bounds()
	movement_vector = movement_vector.clamped(max_speed)
	move_and_collide(movement_vector)
	
	if Input.is_action_pressed("shoot"):
		shoot()

func cap_and_slow_rotation():
	rotation_speed = clamp(rotation_speed, -max_rotation_speed, max_rotation_speed)
	if not has_rotated:
		rotation_speed *= rotation_falloff

func shoot():
	if shot_timer < 0:
		for spawn in bulletspawns: 
			var node
			node = shot.instance()
			get_tree().current_scene.add_child(node)
			node.global_position = $bulletspawn.global_position
			node.look_at(spawn.global_position)
			node.movement_vector = node.transform.x * shot_speed + movement_vector * 0.1
		shot_timer = shot_cooldown

func take_damage():
	health -= 1
	if health < 1:
		health = 1
	heal_timer = heal_cooldown
	

func respect_bounds():
	if global_position.x > 960:
		movement_vector.x += (960 - global_position.x) * 0.5
		movement_vector.x = min(bounds_speed, movement_vector.x)
		disable_engine(engine_cooldown)
	if global_position.x < 0:
		movement_vector.x -= global_position.x * 0.5
		movement_vector.x = max(bounds_speed, movement_vector.x)
		disable_engine(engine_cooldown)
	if global_position.y < 0:
		movement_vector.y -= global_position.y * 0.5
		movement_vector.y = max(bounds_speed, movement_vector.y)
		disable_engine(engine_cooldown)

func disable_engine(time):
	is_engine_disabled = true
	engine_timer = time
	$AnimationPlayer.stop(1)
	$Sprite2.visible = false
	$Sprite3.visible = false

func spawn_smoke():
	var node = smoke.instance()
	get_tree().current_scene.add_child(node)
	node.global_position = $smokespawn.global_position
	node.movement_vector = (-node.transform.y + movement_vector * 0.1).rotated(randf() * 0.3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shot_timer -= delta
	
	if health == 2:
		heal_timer -= delta
		if heal_timer < 0:
			health = 3
			heal_timer = heal_cooldown
			
		smoke_timer -= delta
		if smoke_timer < 0:
			spawn_smoke()
			smoke_timer = smoke_interval_h2 - randf() * 0.3

	elif health == 1:
		heal_timer -= delta
		if heal_timer < 0:
			health = 2
			heal_timer = heal_cooldown
		
		smoke_timer -= delta
		if smoke_timer < 0:
			spawn_smoke()
			smoke_timer = smoke_interval_h1  - randf() * 0.1
	
	if is_engine_disabled:
		engine_timer -= delta
		if engine_timer < 0:
			if Input.is_action_pressed("accelerate"):
				$AnimationPlayer.play("start")
				$AnimationPlayer.queue("firing")
			is_engine_disabled = false
	
	# Control rotation animation
	if 60 < rotation_degrees and rotation_degrees < 70:
		$Sprite.frame = 1
	elif 70 <= rotation_degrees and rotation_degrees <= 110:
		$Sprite.frame = 2
	elif 110 < rotation_degrees and rotation_degrees < 120:
		$Sprite.frame = 1
	elif -60 > rotation_degrees and rotation_degrees > -70:
		$Sprite.frame = 3
	elif -70 >= rotation_degrees and rotation_degrees >= -110:
		$Sprite.frame = 4
	elif -110 > rotation_degrees and rotation_degrees > -120:
		$Sprite.frame = 3
	else:
		$Sprite.frame = 0