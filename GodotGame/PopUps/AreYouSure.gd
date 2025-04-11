extends Control

func _on_yes_pressed():
	storage.PlayerPosition = self.global_position
	get_tree().paused = false
	get_parent().NewDay()


func _on_no_pressed():
	get_tree().paused = false
	queue_free()
