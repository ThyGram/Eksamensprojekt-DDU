extends Control

func _ready():
	storage.GameStarted = false
	storage.DayStarted = false

func _process(delta):
	pass


func _on_play_pressed():
	storage.GameWatch = 480
	storage.Money = 500
	storage.BankMoney = 0
	for key in storage.Stocks:
		storage.Stocks[key][0] = 0
	storage.Day = 1
	get_tree().change_scene_to_file("res://MainGame/main_game_doorchat.tscn")

func _on_leaderboard_pressed():
	get_tree().change_scene_to_file("res://Menu/Leaderboard.tscn")

func _on_logout_pressed():
	storage.displayname = ""
	get_tree().change_scene_to_file("res://Menu/Login.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_tutorial_pressed():
	pass # Replace with function body.
