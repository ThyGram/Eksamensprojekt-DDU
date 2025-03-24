extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func NewDay():
	print("DAY DONEbed")
	get_tree().change_scene_to_file("res://switch_screen.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var GameWatch = storage.GameWatch
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


