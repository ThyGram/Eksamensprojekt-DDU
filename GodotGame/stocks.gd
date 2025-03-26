extends Control

var stocks : Dictionary = storage.Stocks
@onready var single_ton = storage
# Called when the node enters the scene tree for the first time.

func _ready():
	print(single_ton)
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
	if storage.Money >= amount:
		storage.Stocks[index[0]][0] += amount
		$Label/CurrentInvestments.set_item_text(index[0], stocks[index[0]][2] + ": " + str(stocks[index[0]][0]) + "$")
		storage.Money -= amount
	else:
		$Label/InvestingAmount.text = "You dont have that typa money"
