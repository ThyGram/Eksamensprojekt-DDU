extends Control

var db : SQLite
func _ready():
	db = SQLite.new()
	db.path = "res://Database.db"
	db.open_db()
	db.query("SELECT Username, Highscore FROM Leaderboard ORDER BY Highscore DESC;")
	var Leaderboard = db.query_result
	db.close_db()
	if Leaderboard.size() < 10:
		for n in range(Leaderboard.size()):
			$Panel/Position/PositionList.text += "#" + str(n+1) + "\n"
			$Panel/Player/PlayerList.text += Leaderboard[n]["Username"] + "\n"
			$Panel/Score/ScoreList.text += str(Leaderboard[n]["Highscore"]) + "\n"


func _on_return_pressed():
	get_tree().change_scene_to_file("res://Mainmenu.tscn")
