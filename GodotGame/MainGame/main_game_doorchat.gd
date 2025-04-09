extends Control

var Dialouge1 : Array = ["Hello. I am Lånehajen Haj and i seee you havent paid back your debt"
, "I DEMAND THAT YOU WORK FOR 10 DAYS, AND GIVE ME ALL THE MONEY TO CLEAR YOUR DEBT!!!"]

var Dialouge2 : Array = ["EEEE", "FWECW"]

var stop : bool = false
var currDialouge : Array = []
var timer = Timer.new()

func _ready():
	if storage.Day == 1:
		$Name/Dialouge.text = Dialouge1[0]
		currDialouge = Dialouge1
	elif storage.Day == 5:
		$Name/Dialouge.text = Dialouge2[0]
		currDialouge = Dialouge2
		

func _input(event):
	if (event.is_action_pressed("LeftClick") and !stop):
		var currIndex = currDialouge.find($Name/Dialouge.text, 0)
		print(currIndex)
		print(currDialouge.size())
		if (currIndex < currDialouge.size() - 1):
			$Name/Dialouge.text = currDialouge[currIndex+1]
		else:
			$ExitTimer.start()
			stop = true

func _on_exit_timer_timeout():
	get_tree().change_scene_to_file("res://MainGame/main_game_bedroom.tscn")
