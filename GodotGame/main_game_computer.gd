extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_calender_pressed():
	get_tree().change_scene_to_file("res://calender.tscn")

func _on_stocks_pressed():
	get_tree().change_scene_to_file("res://stocks.tscn")

func _on_bank_pressed():
	get_tree().change_scene_to_file("res://bank.tscn")


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://main_game_bedroom.tscn")
