extends Control

var stocks : Dictionary = storage.Stocks
@onready var single_ton = storage
@onready var NoMoneyNode = preload("res://PopUps/NoMoney.tscn")

func _ready():
	Gamewatch_Increase()
	storage.connect("stocks_changed", UpdateList)
	storage.connect("gamewatch_changed", Gamewatch_Increase)
	
	if !storage.StockTutorial or storage.StockTutorial == null:
		storage.StockTutorial = false
		$TutorialPanel.visible = true
	else:
		$TutorialPanel.queue_free()
	
	for key in stocks:
		$Panel/CurrentInvestments.add_item(stocks[key][2] + ": " + str(stocks[key][0]) + "$", null, true)

func UpdateList():
	var list = $Panel/CurrentInvestments.get_item_count()
	for i in list:
		$Panel/CurrentInvestments.set_item_text(i, stocks[i][2] + ": " + str(stocks[i][0]) + "$")

func _input(event):
	if (event.is_action_pressed("Escape")):
		get_tree().change_scene_to_file("res://MainGame/main_game_computer.tscn")
	if (event.is_action_pressed("LeftClick") and !storage.StockTutorial):
		$TutorialPanel.queue_free()
		storage.StockTutorial = true

func _process(delta):
	$MoneyAmount.text = "Wallet: $" + str(storage.Money)

func _on_invest_pressed():
	var index = $Panel/CurrentInvestments.get_selected_items()
	var amount : int = int($Panel/InvestingAmount.text)
	if !index.is_empty() and storage.Money >= amount and amount > 0:
		storage.Stocks[index[0]][0] += amount
		$Panel/CurrentInvestments.set_item_text(index[0], stocks[index[0]][2] + ": " + str(stocks[index[0]][0]) + "$")
		storage.Money -= amount
	elif storage.Money < amount:
		var NoMoney = NoMoneyNode.instantiate()
		add_child(NoMoney)
	elif index.is_empty():
		var NoMoney = NoMoneyNode.instantiate()
		add_child(NoMoney)
		var label = NoMoney.get_node("Panel/Label")
		label.text = "Select a company"

func _on_sell_pressed():
	var index = $Panel/CurrentInvestments.get_selected_items()
	var amount : int = int($Panel/InvestingAmount.text)
	if !index.is_empty() and storage.Stocks[index[0]][0] >= amount and amount > 0:
		storage.Stocks[index[0]][0] -= amount
		$Panel/CurrentInvestments.set_item_text(index[0], stocks[index[0]][2] + ": " + str(stocks[index[0]][0]) + "$")
		storage.Money += amount
	elif index.is_empty():
		var NoMoney = NoMoneyNode.instantiate()
		add_child(NoMoney)
		var label = NoMoney.get_node("Panel/Label")
		label.text = "Select a company"
	elif storage.Stocks[index[0]][0] < amount:
		var NoMoney = NoMoneyNode.instantiate()
		add_child(NoMoney)
		var label = NoMoney.get_node("Panel/Label")
		label.text = "You dont have that much in that stock"

func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://MainGame/main_game_computer.tscn")

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
