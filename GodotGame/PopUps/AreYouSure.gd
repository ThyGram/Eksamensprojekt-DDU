extends Control

func _on_yes_pressed():
	storage.PlayerPosition = self.global_position
	get_parent().NewDay()
	get_tree().paused = false
	queue_free()


func _on_no_pressed():
	get_tree().paused = false
	queue_free()
