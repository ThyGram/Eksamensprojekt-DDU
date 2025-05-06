extends Control

func _ready():
	$Timer.start(4)

func _process(delta):
	if $Timer.time_left > 3:
		$Panel/ZZZ.text = "ZZZ"
	elif $Timer.time_left > 2:
		$Panel/ZZZ.text = "ZZZ."
	elif $Timer.time_left > 1:
		$Panel/ZZZ.text = "ZZZ.."
	elif $Timer.time_left > 0:
		$Panel/ZZZ.text = "ZZZ..."

func _on_timer_timeout():
	var hoursremaining : int = 16 - (int(storage.GameWatch/60) - 8)
	storage.StockChange(hoursremaining)
	storage.GameWatch = 480
	storage.BankMoney *= storage.BankInterest
	storage.BankInterest = RandomNumberGenerator.new().randf_range(0.800,1.200)
	get_tree().change_scene_to_file("res://MainGame/main_game_bedroom.tscn")
