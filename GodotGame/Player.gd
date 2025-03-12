extends CharacterBody2D


const SPEED : int = 300
var in_computerRange : bool = false

func _process(delta):
	velocity = Vector2.ZERO
	var x_axis = Input.get_axis("Left","Right")
	var y_axis = Input.get_axis("Up","Down")
	
	var move_direction = Vector2(x_axis,y_axis).normalized()
	var movement = move_direction * SPEED
	velocity = movement
	move_and_slide()
	

func _input(event):
	if (event.is_action_pressed("ui_accept") and in_computerRange == true):
		get_tree().change_scene_to_file("res://main_game_computer.tscn")


func _on_area_2d_body_entered(body):
	in_computerRange = true


func _on_area_2d_body_exited(body):
	in_computerRange = false
