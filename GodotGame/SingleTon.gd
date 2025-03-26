extends Node2D

signal stocks_changed


var DisplayUsername : String
var Money : int = 500
var Highscore : int
var GameStarted : bool = false
var rng = RandomNumberGenerator.new()
var DayStarted : bool = false
var GameWatch : int = 480
var PlayerPosition

var GameTimer = Timer.new()

# First variable is money invested, second is news boost or not and third is the name of the stock.
var Stocks : Dictionary = {
	0 : [0, null, "Rothskid"],
	1 : [0, null, "WhiteRock"],
	2 : [0, null, "ZombieChampions"],
	3 : [0, null, "NewScandinavian"],
	4 : [0, null, "KarlsBjerg"],
	5 : [0, null, "HCØ"]
	}

func _ready():
	DisplayUsername = storage.DisplayUsername
	Money = storage.Money
	Highscore = storage.Highscore
	GameStarted = storage.GameStarted
	DayStarted = storage.DayStarted
	GameWatch = storage.GameWatch
	GameTimer = storage.GameTimer
	PlayerPosition = storage.PlayerPosition

	# Stocks
	Stocks = storage.Stocks
	
	print("GameSTART")
	add_child(GameTimer)
	GameTimer.autostart = true
	GameTimer.start(0.5)
	GameTimer.timeout.connect(_on_gametimer_timeout)


func _on_gametimer_timeout():
	if GameWatch < 1440 and GameStarted:
		GameWatch += 5
		var hour : float = float(GameWatch) / 60.0
		if floor(hour) == hour:
			for key in Stocks:
				var Increment : float = 0;
				var randomNumber = rng.randi_range(1,200)
				if randomNumber == 100 and Stocks[key][1] == null:
					Increment = rng.randf_range(0, 2)
				else:
					Increment = rng.randf_range(0.935, 1.065)
					if Stocks[key][1] == true:
						Increment += 0.5
					elif Stocks[key][1] == false:
						Increment -= 0.5
					
				Stocks[key][0] *= Increment
				Stocks[key][0] = round(Stocks[key][0])
			print(get_tree().current_scene.name)
			if get_tree().current_scene.name == "Stocks":
				stocks_changed.emit()
