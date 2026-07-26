extends Node2D

@onready var timer = $CountDownTimer
@onready var label = $CanvasLayer/TimerLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	label.text = str(ceil(timer.time_left))
	
	if timer.time_left < 3.0:
		label.modulate = Color.RED
		
	else:
		label.modulate = Color.WHITE
		
func _on_count_down_timer_timeout() -> void:
	get_tree().reload_current_scene()


func _on_time_reset_body_entered(body):
	if body.name == "Player":
		timer.start() # this resets the ten second clock back to full
		$TimeReset/PickupSound.play()
		$TimeReset/Sprite2D.hide()
		$TimeReset/CollisionShape2D.queue_free() 
