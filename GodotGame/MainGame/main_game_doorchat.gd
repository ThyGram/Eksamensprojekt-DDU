extends Control

var Dialouge1 : Array = ["Hello. I am Lånehajen Haj and i seee you havent paid back your debt"
, "I DEMAND THAT YOU WORK FOR 10 DAYS, AND GIVE ME ALL THE MONEY TO CLEAR YOUR DEBT!!!"]

var Dialouge2 : Array = ["EEEE", "FWECW"]

var currDialouge : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if storage.Day == 1:
		$Name/Dialouge.text = Dialouge1[0]
		currDialouge = Dialouge1
	elif storage.Day == 5:
		$Name/Dialouge.text = Dialouge2[0]
		currDialouge = Dialouge2
		

func _input(event):
	if (event.is_action_pressed("LeftClick") and storage.Day == 1):
		var currIndex = Dialouge1.find($Name/Dialouge.text, 0)
		if (currIndex < currDialouge.size()):
			$Name/Dialouge.text = currDialouge[currIndex+1]
		else:
			pass #Start timer and end chat when it timeouts
