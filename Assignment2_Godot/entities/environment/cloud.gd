extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 0

var scene_puff = preload("res://entities/environment/cloud_puff.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	speed = (randf() / 10.0) + 0.04
	var scale_factor = 0.75 + randf() / 4.0
	scale = Vector2(scale_factor, scale_factor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.x < -300:
		queue_free()
	global_position.x -= speed


func _on_Cloud_body_exited(body):
	if body.get_collision_mask_bit(2):
		var pos = body.global_position
		var vel = body.movement_vector
		var puff = scene_puff.instance()
		get_tree().current_scene.add_child(puff)
		puff.global_position = pos - vel * 4
		puff.look_at(pos + vel)
