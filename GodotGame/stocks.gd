extends Control

var stocks : Dictionary = storage.Stocks

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	for key in stocks:
		$Label/CurrentInvestsments.add_item(stocks[key][2] + ": " + str(stocks[key][0]) + "$", null, true)

	#"InvestedInRotschKid": [0, null],
	#"InvestedInWhiteRock" : [0, null],
	#"InvestedInZombieChampions" : [0, null],
	#"InvestedInNewScandinavian" : [0, null],
	#"InvestedInKarlsBjerg" : [0, null],
	#"InvestedInHCØ" : [0, null]

func _input(event):
	if (event.is_action_pressed("Escape")):
		get_tree().change_scene_to_file("res://main_game_bedroom.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_invest_pressed():
	var index = $Label/CurrentInvestsments.get_selected_items()
	var amount : int = int($Label/InvestingAmount.text)
	if storage.Money > amount:
		storage.Stocks[index[0]][0] += amount
		$Label/CurrentInvestsments.set_item_text(index[0], stocks[index[0]][2] + ": " + str(stocks[index[0]][0]) + "$")
	else:
		$Label/InvestingAmount.text = "You dont have that typa money"
