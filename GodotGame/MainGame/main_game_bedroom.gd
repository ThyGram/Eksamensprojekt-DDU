extends Node2D

@onready var SummaryPopup = preload("res://PopUps/game_summary.tscn")
@onready var PauseMenu = preload("res://PopUps/PauseMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	storage.GameStarted = true
	storage.DayStarted = true
	
	if (storage.GameWatch == 480 and storage.Day != 1):
		if (storage.Day == 11):
			pass
		else:
			get_tree().paused = true
			var SummaryNode = SummaryPopup.instantiate()
			add_child(SummaryNode)

func NewDay():
	if (storage.Day < 10):
		print("DAY DONEbed")
		storage.Day += 1
		get_tree().change_scene_to_file("res://switch_screen.tscn")
	elif (storage.Day == 10):
		storage.Gamestarted = false

func _input(event):
	if event.is_action_pressed("Escape"):
		get_tree().paused = true
		var PauseMenuNode = PauseMenu.instantiate()
		add_child(PauseMenuNode)

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


