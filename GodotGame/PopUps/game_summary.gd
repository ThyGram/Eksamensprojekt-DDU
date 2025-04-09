extends Control

var investmentMoney : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/Title.text = "Day " + str(storage.Day-1) + " Summary"
	
	$Panel/CurrentMoney.text = "Current money: " + str(storage.Money)
	
	for key in storage.Stocks:
		investmentMoney += storage.Stocks[key][0]
	$Panel/InvestmentMoney.text = "Investment Money: " + str(investmentMoney)
	
	$Panel/BankMoney.text = "Bank Money: " + str(storage.BankMoney)

func _on_continue_pressed():
	get_tree().paused = false
	queue_free()

