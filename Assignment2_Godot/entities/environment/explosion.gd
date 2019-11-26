extends Sprite

var destuction_timer = 0.8

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("play")
	$AudioStreamPlayer2D.play(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	destuction_timer -= delta
	if destuction_timer < 0:
		queue_free()
