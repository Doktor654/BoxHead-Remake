extends Area2D

var hp = 25

func _ready():
	set_as_top_level(true)

func _on_body_entered(body):
	body.heal(hp)
	queue_free()


func _on_timer_timeout():
	$AnimationPlayer.play("fade away")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade away":
		queue_free()
