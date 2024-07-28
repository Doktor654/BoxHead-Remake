extends Camera2D

@onready var timer : Timer = $Timer
@onready var tween : Tween = create_tween()

var shake_amount : float = 0
var default_offset : Vector2 = offset

func _ready():
	set_process(true)
	Global.Camera = self



func _process(delta):
	offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)
	
	# Scope test
	#if Input.is_action_pressed("right_click"):
		#global_position = lerp(global_position, get_global_mouse_position(), 1.5 )
	#elif Input.is_action_just_released("right_click"):
		#self.global_position = lerp(global_position, get_parent().global_position, 1.5 )
	

func shake(time : float, amount: float):
	timer.wait_time = time
	shake_amount = amount
	set_process(true)
	timer.start()

func _on_timer_timeout():
	set_process(false)
	tween.interpolate_value(self, "offset", 1, 1, tween.TRANS_LINEAR, tween.EASE_IN)
