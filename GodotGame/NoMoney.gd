extends Control


func _on_delete_timer_timeout():
	queue_free()
