extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var hoursremaining : int = 16 - (int(storage.GameWatch/60) - 8)
	storage.StockChange(hoursremaining)
	storage.GameWatch = 480
	storage.BankMoney *= storage.BankInterest
	storage.BankInterest = RandomNumberGenerator.new().randf_range(0.800,1.200)
	get_tree().change_scene_to_file("res://MainGame/main_game_bedroom.tscn")
