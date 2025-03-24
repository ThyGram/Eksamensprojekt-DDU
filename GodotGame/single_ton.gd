extends Node2D

var DisplayUsername : String
var Money : int
var Highscore : int
var GameStarted : bool = false
var TimerStarted : bool = false
var rng = RandomNumberGenerator.new()
var GameTimerStarted : bool = false
var DayStarted : bool = false
var GameWatch : int
var PlayerPosition

var GameTimer = Timer.new()

# First variable is money invested, and second is news boost or not
var Stocks : Dictionary = {
	"InvestedInRotschKid": [0, null],
	"InvestedInWhiteRock" : [0, null],
	"InvestedInZombieChampions" : [0, null],
	"InvestedInNewScandinavian" : [0, null],
	"InvestedInKarlsBjerg" : [0, null],
	"InvestedInHCØ" : [0, null]
	}

func _ready():
	DisplayUsername = storage.DisplayUsername
	Money = storage.Money
	Highscore = storage.Highscore
	GameStarted = storage.GameStarted
	TimerStarted = storage.TimerStarted
	DayStarted = storage.DayStarted
	GameTimerStarted = storage.GameTimerStarted
	GameWatch = storage.GameWatch
	GameTimer = storage.GameTimer
	PlayerPosition = storage.PlayerPosition
	
	# Stocks
	Stocks = storage.Stocks
	
	print("GameSTART")
	add_child(GameTimer)
	GameTimer.autostart = true
	GameTimer.start(1)

func _process(delta):
	if (GameStarted and !TimerStarted):
		print("START")
		var timer = Timer.new()
		add_child(timer)
		timer.autostart = true
		timer.timeout.connect(_on_timer_timeout)
		timer.start(1)
		TimerStarted = true

func _on_timer_timeout():
	print("STOCKs")
	var Increment : float = 0
	for key in Stocks:
		var randomNumber = rng.randi_range(1,200)
		if randomNumber == 100 and Stocks[key][1] == null:
			Increment = rng.randf_range(0, 2)
			Stocks[key][0] *= Increment
		else:
			Increment = rng.randf_range(-0.935, 1.065)
			if Stocks[key][1] == true:
				Increment += 0.5
				Stocks[key][0] *= Increment
			elif Stocks[key][1] == false:
				Increment -= 0.5
				Stocks[key][0] *= Increment
			else:
				Stocks[key][0] *= Increment

