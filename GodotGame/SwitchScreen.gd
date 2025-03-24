extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start(3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	storage.GameWatch = 480
	get_tree().change_scene_to_file("res://main_game_bedroom.tscn")
