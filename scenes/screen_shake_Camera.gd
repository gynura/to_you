extends Camera2D

# ScreenShake variables
var shake_amount: float = 0 
@onready var default_offset: Vector2 = offset
var pos_x: int
var pos_y: int 

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	randomize()

func _process(delta):
	offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)

func shakeCamera(time: float, amount: float):
	$ScreenShakeTimer.wait_time = time
	shake_amount = amount
	set_process(true)
	$ScreenShakeTimer.start()

func _on_screen_shake_timer_timeout():
	set_process(false)
	Tween.new().interpolate_value(self, "offset", 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)

func _on_player_hurt_enemy():
	shakeCamera(0.3, 0.65)


func _on_player_health_change():
	shakeCamera(0.3, 0.65)
