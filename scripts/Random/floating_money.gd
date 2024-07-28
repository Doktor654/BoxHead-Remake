extends Marker2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Money.text = str("$", get_parent().price)
	set_as_top_level(true)
	$AnimationPlayer.play("PopUp")
