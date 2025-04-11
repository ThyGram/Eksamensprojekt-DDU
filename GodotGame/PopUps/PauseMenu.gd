extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/Title.text = "Game Paused\nDay " + str(storage.Day)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_continue_pressed():
	get_tree().paused = false
	queue_free()

func _on_quit_pressed():
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file("res://Menu/main_menu.tscn")
