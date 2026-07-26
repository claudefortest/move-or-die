extends Node2D

@onready var timer = $CountDownTimer
@onready var label = $CanvasLayer/TimerLabel
@onready var win_screen = $CanvasLayer/WinScreen

var is_dead := false
var has_won := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = str(ceil(timer.time_left))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_dead or has_won:
		return

	label.text = str(int(ceil(timer.time_left)))

	if timer.time_left <= 3.0:
		label.modulate = Color.RED
	else:
		label.modulate = Color.WHITE

func _on_count_down_timer_timeout() -> void:
	die()


func die() -> void:
	if is_dead or has_won:
		return
	is_dead = true
	label.text = "0"
	label.modulate = Color.RED
	get_tree().paused = true
	await get_tree().create_timer(0.6, true, false, true).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()


# Called by the player whenever it actually moves, so staying still is what kills you.
func reset_timer() -> void:
	if not is_dead and not has_won:
		timer.start()


func _on_time_reset_body_entered(body):
	if body.name == "Player":
		$TimeReset/PickupSound.play()
		$TimeReset/Sprite2D.hide()
		$TimeReset/CollisionShape2D.set_deferred("disabled", true)


func _on_void_body_entered(body):
	if body.name == "Player":
		die()


func _on_flag_body_entered(body):
	if body.name == "Player" and not has_won and not is_dead:
		has_won = true
		timer.stop()
		win_screen.visible = true


func _on_play_again_pressed() -> void:
	get_tree().reload_current_scene()
