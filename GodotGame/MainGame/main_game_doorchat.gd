extends Control

var Dialogue1 : Array = ["*KNOCK KNOCK KNOCK*", "Hello, I am Lånehajen Haj and I see you havent paid back your debt.."
, "I DEMAND THAT YOU WORK FOR 10 DAYS, weekends off of course, AND GIVE ME ALL THE MONEY YOUR EARN TO CLEAR YOUR DEBT!!!"]

var Dialogue2 : Array = ["*KNOCK KNOCK*", "Hello again. I came to remind you that you better pay me back.. or else..", "I EXPECT AT LEAST A BILLION GAZILLION DOLLARS!!!", "MUAHAHAHHA!"]

var Dialogue3 : Array = []

var stop : bool = false
var currDialogue : Array = []
var timer = Timer.new()

func _ready():
	if storage.Day == 1:
		$Panel/Name/Dialogue.text = Dialogue1[0]
		currDialogue = Dialogue1
	elif storage.Day == 5:
		$Panel/Name/Dialogue.text = Dialogue2[0]
		currDialogue = Dialogue2
	elif storage.Day == 10:
		$Panel/Name/Dialogue.text = Dialogue3[0]
		currDialogue = Dialogue3
		

func _input(event):
	if (event.is_action_pressed("LeftClick") and !stop):
		var currIndex = currDialogue.find($Panel/Name/Dialogue.text, 0)
		if (currIndex < currDialogue.size() - 1):
			$Panel/Name/Dialogue.text = currDialogue[currIndex+1]
		else:
			$ExitTimer.start()
			stop = true

func _on_exit_timer_timeout():
	get_tree().change_scene_to_file("res://MainGame/main_game_bedroom.tscn")
