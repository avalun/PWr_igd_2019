extends Area2D

var movement_vector = Vector2(0, 0)
var explosion = preload("res://entities/environment/explosion.tscn")

var kill_timer = 2
var is_killed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("play")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_killed:
		kill_timer -= delta
		$Line2D.points[1].x *= (kill_timer * 0.5)
		if kill_timer < 0:
			queue_free()
	
	else:
		global_position += movement_vector
		
		if global_position.x > 1200 or global_position.x < -100 \
		or global_position.y < -600 or global_position.y > 1200:
			is_killed = true


func explode():
	# Spawn Explosion
		var node = explosion.instance()
		get_tree().current_scene.add_child(node)
		node.global_position = global_position
		
		$Sprite.visible = false
		$Sprite2.visible = false
		$CollisionShape2D.set_deferred("disabled",true)
		is_killed = true


func _on_skyrod_body_entered(body):
	if body.get_collision_mask_bit(2):
		body.take_damage()
		Globals.current_camera.shake(0.5, 40)
		explode()


func _on_skyrod_area_entered(area):
	if area.get_collision_mask_bit(5):
		explode()
