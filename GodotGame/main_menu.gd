extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_pressed():
	storage.GameStarted = true
	storage.DayStarted = true
	get_tree().change_scene_to_file("res://main_game_bedroom.tscn")


func _on_leaderboard_pressed():
	get_tree().change_scene_to_file("res://leaderboard.tscn")

func _on_logout_pressed():
	#Reset current display name???
	get_tree().change_scene_to_file("res://login.tscn")

func _on_quit_pressed():
	get_tree().quit()



