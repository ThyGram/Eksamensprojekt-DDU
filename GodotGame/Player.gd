extends CharacterBody2D

const SPEED : int = 300
var in_computerRange : bool = false
var in_bedRange : bool = false
var in_tvRange : bool = false
var in_doorRange : bool = false

func _process(delta):
	velocity = Vector2.ZERO
	var x_axis = Input.get_axis("Left","Right")
	var y_axis = Input.get_axis("Up","Down")
	
	var move_direction = Vector2(x_axis,y_axis).normalized()
	var movement = move_direction * SPEED
	velocity = movement
	move_and_slide()
	

func _input(event):
	if (event.is_action_pressed("ui_accept") and in_computerRange):
		get_tree().change_scene_to_file("res://main_game_computer.tscn")
	elif (event.is_action_pressed("ui_accept") and in_bedRange):
		get_parent().NewDay()
	elif (event.is_action_pressed("ui_accept") and in_doorRange):
		get_tree().quit()


func _on_computer_body_entered(body):
	if body.name == "Player":
		in_computerRange = true
		print("infcomputer")

func _on_computer_body_exited(body):
	if body.name == "Player":
		in_computerRange = false
		print("out comput")


func _on_bed_body_entered(body):
	if body.name == "Player":
		in_bedRange = true
		print("in bed")


func _on_bed_body_exited(body):
	if body.name == "Player":
		in_bedRange = false
		print("out bed")


func _on_tv_body_entered(body):
	if body.name == "Player":
		in_tvRange = true


func _on_tv_body_exited(body):
	if body.name == "Player":
		in_tvRange = false


func _on_door_body_entered(body):
	if body.name == "Player":
		in_doorRange = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		in_doorRange = false
