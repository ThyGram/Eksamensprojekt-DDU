extends Node2D

var DisplayUsername : String
var Money : int
var Highscore : int
var GameStarted : bool = false
var TimerStarted : bool = false
var rng = RandomNumberGenerator.new()

# First variable is money invested, and second is news boost or not
var Stocks : Dictionary = {
	"InvestedInRotschKid": [0, null],
	"InvestedInWhiteRock" : [0, null],
	"InvestedInZombieChampions" : [0, null],
	"InvestedInNewScandinavian" : [0, null],
	"InvestedInKarlsBjerg" : [0, null],
	"InvestedInHCØ" : [0, null]
	}

var NewsBoost : String
var NewsKill : String

func _ready():
	DisplayUsername = storage.DisplayUsername
	Money = storage.Money
	Highscore = storage.Highscore
	GameStarted = storage.GameStarted
	TimerStarted = storage.TimerStarted
	
	# Stocks
	Stocks = storage.Stocks
	
	
func _process(delta):
	if (GameStarted and !TimerStarted):
		print("START")
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 60
		timer.autostart = true
		timer.timeout.connect(_on_timer_timeout)
		TimerStarted = true



func _on_timer_timeout():
	var Increment
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

