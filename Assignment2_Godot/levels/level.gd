extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cloud_timer = Timer.new()
var clouds_min_time = 13
var clouds_wait_factor = 7
var clouds_min_y = 50
var clouds_max_y = 400

var scene_cloud1 = preload("res://entities/environment/cloud1.tscn")
var scene_cloud2 = preload("res://entities/environment/cloud2.tscn")
var scene_cloud3 = preload("res://entities/environment/cloud1.tscn")

# Enemies
var skyrod_timer = 10
var skyrod_cooldown = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	cloud_timer.connect("timeout", self, "spawn_clouds") 

	add_child(cloud_timer)
	
	OS.window_size = Vector2(1080, 800)
	
	spawn_clouds()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func spawn_enemies():
	pass

func spawn_clouds():
	var node
	var rnd = randi() % 2 + 1
	match rnd:
		1:
			node = scene_cloud1.instance()
		2:
			node = scene_cloud2.instance()
#		3:
#			node = scene_cloud3.instance()
	add_child(node)
	var pos = Vector2(1100, (clouds_min_y + randi() % clouds_max_y))
	node.global_position = pos
	cloud_timer.start((randf() * clouds_wait_factor) + clouds_min_time)