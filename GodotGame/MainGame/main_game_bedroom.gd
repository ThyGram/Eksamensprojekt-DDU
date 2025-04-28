extends Node2D

@onready var SummaryPopup = preload("res://PopUps/game_summary.tscn")
@onready var PauseMenu = preload("res://PopUps/PauseMenu.tscn")

@onready var single_ton = storage

func _ready():
	
	Gamewatch_Increase()
	if (storage.Day == 11):
		storage.GameStarted = false
	else:
		storage.GameStarted = true
	storage.DayStarted = true
	storage.connect("gamewatch_changed", Gamewatch_Increase)
	
	if (storage.GameWatch == 480 and storage.Day != 1):
		if (storage.Day < 11):
			get_tree().paused = true
			var SummaryNode = SummaryPopup.instantiate()
			add_child(SummaryNode)
		
	if !storage.BedroomTutorial or storage.BedroomTutorial == null:
		storage.BedroomTutorial = false
		storage.MovingAllowed = false
		$TutorialPanel.visible = true
	else:
		$TutorialPanel.queue_free()
	
	if storage.Day == 5 and (!storage.SharkTalk5 or storage.SharkTalk5 == null):
		$"SHARK IS HERE".visible = true

func NewDay():
	if (storage.Day < 11):
		storage.Day += 1
		get_tree().change_scene_to_file("res://switch_screen.tscn")

func _input(event):
	if event.is_action_pressed("Escape"):
		get_tree().paused = true
		var PauseMenuNode = PauseMenu.instantiate()
		add_child(PauseMenuNode)
	if event.is_action_pressed("LeftClick") and !storage.BedroomTutorial:
		$TutorialPanel.queue_free()
		storage.BedroomTutorial = true
		storage.MovingAllowed = true
		

func Gamewatch_Increase():
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
	if int(GameWatch/60) >= 20:
		self.modulate = Color(0.639, 0.659, 0.784)
	elif int(GameWatch/60) >= 18:
		self.modulate = Color(1, 0.773, 0.663)
	elif int(GameWatch/60) >= 10:
		self.modulate = Color(1, 1, 1)
	elif int(GameWatch/60) >= 8:
		self.modulate = Color(1, 0.918, 0.663)
