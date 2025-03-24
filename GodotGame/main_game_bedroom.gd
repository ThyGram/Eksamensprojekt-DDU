extends Node2D

var GameWatch : int = 480 # Starts 8 hours into the day

# Called when the node enters the scene tree for the first time.
func _ready():
	storage.GameTimer.timeout.connect(_on_gametimer_timeout)
	$GameTimer.text = "08:00"

func _on_gametimer_timeout():
	if GameWatch <= 960:
		GameWatch += 5
		if GameWatch % 60 > 9:
			if int(GameWatch/60) > 9:
				$GameTimer.text = str(int(GameWatch/60)) + ":" + str(GameWatch % 60)
			else:
				$GameTimer.text = "0" + str(int(GameWatch/60)) + ":" + str(GameWatch % 60)
		else:
			if int(GameWatch/60) > 9:
				$GameTimer.text = str(int(GameWatch/60)) + ":0" + str(GameWatch % 60)
			else:
				$GameTimer.text = "0" + str(int(GameWatch/60)) + ":0" + str(GameWatch % 60)


func NewDay():
	print("DAY DONEbed")
	get_tree().change_scene_to_file("res://switch_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

