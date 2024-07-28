extends Bullet

var dmg : int
var hp = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta
	
	if hp <= 0:
		queue_free()





func _on_body_entered(body):

	if body.has_method("hit"):
		body.hit(dmg, self.position)
		
	if body.has_method("hit_barrel"):
		body.hit_barrel(dmg)
	hp -= 1
