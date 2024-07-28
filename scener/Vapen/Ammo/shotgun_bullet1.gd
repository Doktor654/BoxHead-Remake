extends Bullet

var dmg : int

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)
	$AnimationPlayer.play("destroy")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta





func _on_body_entered(body):

	if body.has_method("hit"):
		body.hit(dmg, self.position)
		
	if body.has_method("hit_barrel"):
		body.hit_barrel(dmg)
	queue_free()
