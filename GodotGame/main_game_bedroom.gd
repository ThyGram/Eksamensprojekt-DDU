extends Node2D

var GameWatch : int

# Called when the node enters the scene tree for the first time.
func _ready():
	storage.GameTimer.timeout.connect(_on_gametimer_timeout)

func _on_gametimer_timeout():
	print("!#!WADWAD")
	GameWatch += 1
	
	if GameWatch == 420:
		print("DAY DONE")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$GameTimer.text = str(int(GameWatch/60)) + ": " + str(GameWatch % 60)
	
