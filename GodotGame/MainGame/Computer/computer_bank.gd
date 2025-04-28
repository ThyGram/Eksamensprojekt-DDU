extends Control

@onready var NoMoneyNode = preload("res://PopUps/NoMoney.tscn")
@onready var single_ton = storage

func _ready():
	Gamewatch_Increase()
	storage.connect("gamewatch_changed", Gamewatch_Increase)
	
	var bankinterest : float = (storage.BankInterest - 1.0)*100.0
	if bankinterest > 0:
		$Interest.text = str(round(bankinterest)) + "%"
		var green = Color(0.0,1.0,0.0,1.0)
		$Interest.set("theme_override_colors/font_color",green)
	elif bankinterest < 0:
		$Interest.text = str(round(bankinterest)) + "%"
		#https://www.reddit.com/r/godot/comments/x6l82x/how_to_change_color_of_label_text_via_code/ 
		var red = Color(1.0,0.0,0.0,1.0)
		$Interest.set("theme_override_colors/font_color",red)
	if !storage.BankTutorial or storage.BankTutorial == null:
		storage.BankTutorial = false
		$TutorialPanel.visible = true
	else:
		$TutorialPanel.queue_free()
	

func _process(delta):
	$Money.text = "Wallet: $" + str(storage.Money)
	$BankMoney.text = str(storage.BankMoney) + "$"

func _input(event):
	if (event.is_action_pressed("Escape")):
		get_tree().change_scene_to_file("res://MainGame/main_game_computer.tscn")
	if (event.is_action_pressed("LeftClick") and !storage.BankTutorial):
		$TutorialPanel.queue_free()
		storage.BankTutorial = true

func _on_transfer_in_pressed():
	var transfermoney : int = int($MoneyToTransfer.text)
	if transfermoney != null and transfermoney <= storage.Money and transfermoney > 0:
		storage.BankMoney += transfermoney
		storage.Money -= transfermoney
	elif transfermoney > storage.Money:
		var NoMoney = NoMoneyNode.instantiate()
		add_child(NoMoney)


func _on_transfer_out_pressed():
	var transfermoney : int = int($MoneyToTransfer.text)
	if transfermoney != null and transfermoney <= storage.BankMoney and transfermoney > 0:
		storage.BankMoney -= transfermoney
		storage.Money += transfermoney
	elif transfermoney > storage.Money:
		var NoMoney = NoMoneyNode.instantiate()
		add_child(NoMoney)

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

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://MainGame/main_game_computer.tscn")
