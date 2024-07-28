extends CharacterBody2D

var speed = 40
var gravity: float = 600.0
var bounce_damping := 0.9 
var bounce_damping_partial := 0.6
var stop : bool = false

func _ready():
	z_index = 1
	randomize()
	var numba : float = randf_range(1, 1.15)
	set_as_top_level(true)
	velocity.y -= 300
	await get_tree().create_timer(numba).timeout
	stop = true
	z_index = 0
	$AnimationPlayer.stop()

	await get_tree().create_timer(5.0).timeout
	$AnimationPlayer.play("fade_away")


func _physics_process(delta):

	if !stop:
		if Global.player.dir == 0:
			velocity.x -= randf_range(0.88, 1.11)
		elif Global.player.dir == 1:
			velocity.x += randf_range(0.88, 1.11)
		velocity.y += gravity * delta
		if not is_on_floor():
			$AnimationPlayer.play("rotate")
		#else:
			#$AnimationPlayer.play("idle")
		#move_and_slide()
		
		var collision = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.bounce(collision.get_normal())
			velocity *= bounce_damping
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_away":
		queue_free()
