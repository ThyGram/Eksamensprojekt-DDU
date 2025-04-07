extends Node2D

signal stocks_changed
signal news_changed

var DisplayUsername : String
var Money : int = 500
var Day : int
var Highscore : int
var GameStarted : bool = false
var rng = RandomNumberGenerator.new()
var DayStarted : bool = false
var GameWatch : int = 480
var PlayerPosition
var GameTimer = Timer.new()

var Goodnews : String = "No News"
var Badnews : String = "No News"

var BankMoney: int
var BankInterest: float = rng.randf_range(0.800, 1.200)
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
	BankMoney = storage.BankMoney
	Day = storage.Day
	Goodnews = storage.Goodnews
	Badnews = storage.Badnews

	# Stocks
	Stocks = storage.Stocks
	
	add_child(GameTimer)
	GameTimer.autostart = true
	GameTimer.start(0.5)
	GameTimer.timeout.connect(_on_gametimer_timeout)


func _on_gametimer_timeout():
	if GameWatch < 1440 and GameStarted:
		GameWatch += 5
		var hour : float = float(GameWatch) / 60.0
		if floor(hour) == hour and int(floor(hour)) % 2 == int(hour) % 2:
			for key in Stocks:
				var Increment : float = 0;
				var randomNumber = rng.randi_range(1,200)
				if randomNumber == 100 and Stocks[key][1] == null:
					Increment = rng.randf_range(0, 2)
				else:
					Increment = rng.randf_range(0.935, 1.065)
					if Stocks[key][1] == true:
						Increment += 0.5
						Stocks[key][1] = null
					elif Stocks[key][1] == false:
						Increment -= 0.5
						Stocks[key][1] = null
					
				Stocks[key][0] *= Increment
				Stocks[key][0] = round(Stocks[key][0])
			
			print(get_tree().current_scene.name)
			if get_tree().current_scene.name == "Stocks":
				stocks_changed.emit()
		if ((floor(hour) == 12.0 or floor(hour) == 16.0 or floor(hour) == 20.0) and (floor(hour) == hour)):
			for key in Stocks:
				Stocks[key][1] = null
			for n in 2:
				var randomstock : int = rng.randi_range(0, storage.Stocks.size() - 1)
				if n == 0:
					Stocks[randomstock][1] = true
					Goodnews = storage.Stocks[randomstock][2] + " has just been VERFIED on twitter !!!! CONGRATS"
				elif n == 1:
					Stocks[randomstock][1] = false
					Badnews = storage.Stocks[randomstock][2] + " has just been CANCELLED on twitter !!!! SHAME ON THEM"
			
			if get_tree().current_scene.name == "main_game_tv":
				news_changed.emit()
			
