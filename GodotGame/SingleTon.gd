extends Node2D

signal stocks_changed
signal news_changed
signal gamewatch_changed

var displayname : String
var Highscore : int
var Money : int = 500
var Day : int = 1
var GameStarted : bool = false
var rng = RandomNumberGenerator.new()
var DayStarted : bool = false
var GameWatch : int = 480
var PlayerPosition
var GameTimer = Timer.new()
var MovingAllowed : bool = true

#TUTORIAL CONFIRMATIONS
var ComputerTutorial : bool
var TVTutorial : bool
var BankTutorial : bool
var StockTutorial : bool
var CalenderTutorial : bool
var BedroomTutorial : bool

var SharkTalk5 : bool

var Goodnews : String = "No News"
var Badnews : String = "No News"

var BankMoney: int
var BankInterest: float = rng.randf_range(0.800, 1.200)
# First variable is money invested, second is news boost or not and third is the name of the stock.
var Stocks : Dictionary = {
	0 : [0, null, "HCOE"],
	1 : [0, null, "WhiteRock"],
	2 : [0, null, "ZombieChampions"],
	3 : [0, null, "NewScandinavian"],
	4 : [0, null, "Karlsbjerg"],
	5 : [0, null, "guardVan"]
	}

func _ready():
	displayname = storage.displayname
	Highscore = storage.Highscore
	Money = storage.Money
	GameStarted = storage.GameStarted
	DayStarted = storage.DayStarted
	GameWatch = storage.GameWatch
	GameTimer = storage.GameTimer
	PlayerPosition = storage.PlayerPosition
	BankMoney = storage.BankMoney
	Day = storage.Day
	Goodnews = storage.Goodnews
	Badnews = storage.Badnews
	MovingAllowed = storage.MovingAllowed
	
	#TUTORIALS
	BedroomTutorial = storage.BedroomTutorial
	ComputerTutorial = storage.ComputerTutorial
	TVTutorial = storage.TVTutorial
	StockTutorial = storage.StockTutorial
	BankTutorial = storage.BankTutorial
	CalenderTutorial = storage.CalenderTutorial
	
	SharkTalk5 = storage.SharkTalk5
	
	# Stocks
	Stocks = storage.Stocks
	
	add_child(GameTimer)
	GameTimer.autostart = true
	GameTimer.start(1.167)
	GameTimer.timeout.connect(_on_gametimer_timeout)

func StockChange(hoursremaining : int):
		for n in hoursremaining:
			for key in Stocks:
				var Increment : float = 0;
				var randomNumber = rng.randi_range(1,200)
				if randomNumber == 100 and Stocks[key][1] == null:
					Increment = rng.randf_range(0, 2)
				else:
					Increment = rng.randf_range(0.935, 1.065)
					if Stocks[key][1] == true:
						Increment += 0.25
					elif Stocks[key][1] == false:
						Increment -= 0.25
					
				Stocks[key][0] *= Increment
				Stocks[key][0] = round(Stocks[key][0])
			for key in Stocks:
				Stocks[key][1] = null
			var storagestock : int
			for j in 2:
				var randomstock : int = rng.randi_range(0, storage.Stocks.size() - 1)
				if (randomstock == storagestock):
					for i in 6:
						randomstock = rng.randi_range(0, storage.Stocks.size() - 1)
						if (randomstock != storagestock):
							break
				else:
					storagestock = randomstock
				if j == 0:
					Stocks[randomstock][1] = true
				elif j == 1:
					Stocks[randomstock][1] = false

func _on_gametimer_timeout():
	if GameWatch < 1440 and GameStarted and BedroomTutorial:
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
						Increment += 0.10
					elif Stocks[key][1] == false:
						Increment -= 0.10
				Stocks[key][0] *= Increment
				Stocks[key][0] = round(Stocks[key][0])
			if get_tree().current_scene != null:
				if get_tree().current_scene.name == "computer_stocks":
					stocks_changed.emit()
		if ((GameWatch == 485 or floor(hour) == 12.0 or floor(hour) == 16.0 or floor(hour) == 20.0) and (floor(hour) == hour or GameWatch == 485)):
			for key in Stocks:
				Stocks[key][1] = null
			var storagestock : int
			for n in 2:
				var randomstock : int = rng.randi_range(0, storage.Stocks.size() - 1)
				if (randomstock == storagestock):
					for i in 6:
						randomstock = rng.randi_range(0, storage.Stocks.size() - 1)
						if (randomstock != storagestock):
							break
				else:
					storagestock = randomstock
				if n == 0:
					Stocks[randomstock][1] = true
					Goodnews = storage.Stocks[randomstock][2] + " has just won the lottery!!!"
				elif n == 1:
					Stocks[randomstock][1] = false
					Badnews = storage.Stocks[randomstock][2] + " has just lost the lottery..."
		if get_tree().current_scene != null:
			gamewatch_changed.emit()
			if get_tree().current_scene.name == "main_game_tv":
				news_changed.emit()
