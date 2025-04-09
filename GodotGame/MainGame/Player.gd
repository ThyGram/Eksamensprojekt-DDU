extends CharacterBody2D

var in_computerRange : bool = false
var in_bedRange : bool = false
var in_tvRange : bool = false
var in_doorRange : bool = false
var is_moving : bool = false

@onready var anim = $AnimatedPlayerSprite
const SPEED : float = 300.0
var direction : String = "none"

func _process(delta):
	if Input.is_action_pressed("Up"):
		velocity = Vector2.UP * SPEED
		is_moving = true
		direction = "Up"
	
	if Input.is_action_pressed("Left"):
		velocity = Vector2.LEFT * SPEED
		is_moving = true
		direction = "Left"
	
	if Input.is_action_pressed("Down"):
		velocity = Vector2.DOWN * SPEED
		is_moving = true
		direction = "Down"
	
	if Input.is_action_pressed("Right"):
		velocity = Vector2.RIGHT * SPEED
		is_moving = true
		direction = "Right"
	
	else:
		velocity = Vector2.ZERO
		is_moving = false
	
	move_and_slide()
	
	if is_moving:
		if direction == "Up":
			anim.play("walk_up")
		if direction == "Left":
			anim.play("walk_left")
		if direction == "Down":
			anim.play("walk_down")
		if direction == "Right":
			anim.play("walk_right")
	
	if !is_moving:
		if direction == "Up":
			anim.play("idle_up")
		if direction == "Left":
			anim.play("idle_left")
		if direction == "Down":
			anim.play("idle_down")
		if direction == "Right":
			anim.play("idle_right")

func _ready():
	if (storage.PlayerPosition):
		self.global_position = storage.PlayerPosition
	
func _input(event):
	if (event.is_action_pressed("ui_accept") and in_computerRange):
		storage.PlayerPosition = self.global_position
		get_tree().change_scene_to_file("res://MainGame/main_game_computer.tscn")
	elif (event.is_action_pressed("ui_accept") and in_tvRange):
		storage.PlayerPosition = self.global_position
		get_tree().change_scene_to_file("res://MainGame/main_game_tv.tscn")
	elif (event.is_action_pressed("ui_accept") and in_bedRange):
		storage.PlayerPosition = self.global_position
		get_parent().NewDay()
		
	elif (event.is_action_pressed("ui_accept") and in_doorRange and (storage.Day == 1 or storage.Day == 5)):
		get_tree().change_scene_to_file("res://MainGame/main_game_doorchat.tscn")


func _on_computer_body_entered(body):
	if body.name == "Player":
		in_computerRange = true

func _on_computer_body_exited(body):
	if body.name == "Player":
		in_computerRange = false

func _on_bed_body_entered(body):
	if body.name == "Player":
		in_bedRange = true

func _on_bed_body_exited(body):
	if body.name == "Player":
		in_bedRange = false

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
