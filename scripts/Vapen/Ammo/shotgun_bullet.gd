extends Area2D

class_name Bullet

@export var speed = 500
var direction = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta
