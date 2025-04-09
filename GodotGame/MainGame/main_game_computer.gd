extends Control

func _ready():
	if (!storage.ComputerTutorial or storage.ComputerTutorial == null):
		tutorial()
	else:
		tutorialclear()

func tutorial():
	$TutorialPanel.visible = true
	$TutorialPanel/Label.visible = true

func tutorialclear():
	$TutorialPanel.queue_free()
	storage.ComputerTutorial = true

func _input(event):
	if (event.is_action_pressed("Escape")):
		get_tree().change_scene_to_file("res://MainGame/main_game_bedroom.tscn")
	elif (event.is_action_pressed("LeftClick") and $TutorialPanel != null) :
		tutorialclear()

func _on_calender_pressed():
	if $TutorialPanel == null:
		get_tree().change_scene_to_file("res://MainGame/Computer/computer_calender.tscn")

func _on_stocks_pressed():
	if $TutorialPanel == null:
		get_tree().change_scene_to_file("res://MainGame/Computer/computer_stocks.tscn")

func _on_bank_pressed():
	if $TutorialPanel == null:
		get_tree().change_scene_to_file("res://MainGame/Computer/computer_bank.tscn")

func _on_return_button_pressed():
	if $TutorialPanel == null:
		get_tree().change_scene_to_file("res://MainGame/main_game_bedroom.tscn")
