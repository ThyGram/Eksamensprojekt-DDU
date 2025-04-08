extends Control

var stocks : Dictionary = storage.Stocks
@onready var single_ton = storage
@onready var NoMoneyNode = preload("res://NoMoney.tscn")
# Called when the node enters the scene tree for the first time.

func _ready():
	storage.connect("stocks_changed", UpdateList)
	
	for key in stocks:
		$Label/CurrentInvestments.add_item(stocks[key][2] + ": " + str(stocks[key][0]) + "$", null, true)
		
	
	#"InvestedInRotschKid": [0, null],
	#"InvestedInWhiteRock" : [0, null],
	#"InvestedInZombieChampions" : [0, null],
	#"InvestedInNewScandinavian" : [0, null],
	#"InvestedInKarlsBjerg" : [0, null],
	#"InvestedInHCØ" : [0, null]

func UpdateList():
	var list = $Label/CurrentInvestments.get_item_count()
	for i in list:
		$Label/CurrentInvestments.set_item_text(i, stocks[i][2] + ": " + str(stocks[i][0]) + "$")


func _input(event):
	if (event.is_action_pressed("Escape")):
		get_tree().change_scene_to_file("res://main_game_computer.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$MoneyAmount.text = "Amount: " + str(storage.Money) + "$"

func _on_invest_pressed():
	var index = $Label/CurrentInvestments.get_selected_items()
	var amount : int = int($Label/InvestingAmount.text)
	if !index.is_empty() and storage.Money >= amount:
		storage.Stocks[index[0]][0] += amount
		$Label/CurrentInvestments.set_item_text(index[0], stocks[index[0]][2] + ": " + str(stocks[index[0]][0]) + "$")
		storage.Money -= amount
	elif storage.Money < amount:
		var NoMoney = NoMoneyNode.instantiate()
		add_child(NoMoney)
	elif index.is_empty():
		var NoMoney = NoMoneyNode.instantiate()
		add_child(NoMoney)
		var label = NoMoney.get_node("Panel/Label")
		print(label)
		label.text = "Select a company"


func _on_sell_pressed():
	var index = $Label/CurrentInvestments.get_selected_items()
	var amount : int = int($Label/InvestingAmount.text)
	if !index.is_empty() and storage.Stocks[index[0]][0] >= amount:
		storage.Stocks[index[0]][0] -= amount
		$Label/CurrentInvestments.set_item_text(index[0], stocks[index[0]][2] + ": " + str(stocks[index[0]][0]) + "$")
		storage.Money += amount
	elif storage.Stocks[index[0]][0] < amount:
		var NoMoney = NoMoneyNode.instantiate()
		add_child(NoMoney)
		var label = NoMoney.get_node("Panel/Label")
		print(label)
		label.text = "You dont have that much in that stock"
	elif index.is_empty():
		var NoMoney = NoMoneyNode.instantiate()
		add_child(NoMoney)
		var label = NoMoney.get_node("Panel/Label")
		print(label)
		label.text = "Select a company"


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://main_game_computer.tscn")
