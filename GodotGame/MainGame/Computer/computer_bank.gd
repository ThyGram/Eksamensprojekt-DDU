extends Control

@onready var NoMoneyNode = preload("res://NoMoney.tscn")

func _ready():
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
		

func _process(delta):
	$Money.text = str(storage.Money) + "$"
	$BankMoney.text = str(storage.BankMoney) + "$"

func _input(event):
	if (event.is_action_pressed("Escape")):
		get_tree().change_scene_to_file("res://main_game_computer.tscn")


func _on_transfer_in_pressed():
	var transfermoney : int = int($MoneyToTransfer.text)
	if transfermoney != null and transfermoney <= storage.Money:
		storage.BankMoney += transfermoney
		storage.Money -= transfermoney
	elif transfermoney > storage.Money:
		var NoMoney = NoMoneyNode.instantiate()
		add_child(NoMoney)


func _on_transfer_out_pressed():
	var transfermoney : int = int($MoneyToTransfer.text)
	if transfermoney != null and transfermoney <= storage.BankMoney:
		storage.BankMoney -= transfermoney
		storage.Money += transfermoney
	elif transfermoney > storage.Money:
		var NoMoney = NoMoneyNode.instantiate()
		add_child(NoMoney)


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://main_game_computer.tscn")
