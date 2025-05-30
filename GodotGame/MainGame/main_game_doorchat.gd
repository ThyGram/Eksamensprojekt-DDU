extends Control

@onready var SummaryPopup = preload("res://PopUps/game_summary.tscn")

var Dialogue1 : Array = ["*KNOCK KNOCK KNOCK*", "Hello, I am Lånehajen Haj and I see you haven't paid back your debt.."
, "I DEMAND THAT YOU WORK FOR 14 DAYS, weekends off of course, AND GIVE ME ALL THE MONEY YOUR EARN TO CLEAR YOUR DEBT!!!", "*Leaves*"]

var Dialogue2 : Array = ["*KNOCK KNOCK*", "Hello again. I came to remind you that you better pay me back by Saturday the 13th.. or else..", "I EXPECT AT LEAST 1.000.000$ DOLLARS!!!", "MUAHAHAHHA!", "*Leaves*"]

var Dialogue3Win : Array = ["*CRASH*", "HAND OVER THE MONEY, NOW!!", "You've made quite a bit of money I must say.", "This will suffice for now.", "If you're ever in need of some quick cash you can come take a loan at my shop.", "MUAHAHAHAAA!", "*Leaves*"]
var Dialogue3Loss : Array = ["*CRASH*", "HAND OVER THE MONEY, NOW!!", "OH.", "This isn't nearly enough.", "*CLICK BANG BANG BANG*", "You did not pay back your debt in time..."]

var stop : bool = false
var currDialogue : Array = []
var timer = Timer.new()

var investmentMoney : int = 0

func _ready():
	if storage.Day == 1:
		$Panel/Dialogue.text = Dialogue1[0]
		currDialogue = Dialogue1
	elif storage.Day == 5:
		$Panel/Dialogue.text = Dialogue2[0]
		currDialogue = Dialogue2
		storage.SharkTalk5 = true
	elif storage.Day == 15:
		for key in storage.Stocks:
			investmentMoney += storage.Stocks[key][0]
		if (storage.Money + storage.BankMoney + investmentMoney) > 1000000:
			$Panel/Dialogue.text = Dialogue3Win[0]
			currDialogue = Dialogue3Win
		elif storage.Money <= 10000:
			$Panel/Dialogue.text = Dialogue3Loss[0]
			currDialogue = Dialogue3Loss
		

func _input(event):
	if (event.is_action_pressed("LeftClick") and !stop):
		var currIndex = currDialogue.find($Panel/Dialogue.text, 0)
		if (currIndex < currDialogue.size() - 1):
			$Panel/Dialogue.text = currDialogue[currIndex+1]
		elif storage.Day < 11:
			$ExitTimer.start()
			stop = true
		else:
			GameEnd()

func GameEnd():
	var SummaryNode = SummaryPopup.instantiate()
	add_child(SummaryNode)

func _on_exit_timer_timeout():
	get_tree().change_scene_to_file("res://MainGame/main_game_bedroom.tscn")
