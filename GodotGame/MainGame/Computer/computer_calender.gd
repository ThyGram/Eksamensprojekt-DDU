extends Control

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var circle_shader = preload("res://Shaders/circle.gdshader")
	var shader_material = ShaderMaterial.new()
	shader_material.shader = circle_shader
	
	#Shader parametre indstilles for cirklen.
	shader_material.set_shader_parameter("inner_color", Color(1,1,1,0.0)) # Gennemsigtig
	shader_material.set_shader_parameter("border_color", Color.hex(0x1f1f1fff)) # Samme farve som kryds
	shader_material.set_shader_parameter("border_width", 0.075)
	
	# Sort Ring loades ind med rigtige shader indstillinger
	var black_ring := Sprite2D.new()
	black_ring.texture = preload("res://textures/circle.png")
	black_ring.material = shader_material
	
	# Størrelse indstilles
	#var size = black_ring.texture.get_size()
	black_ring.scale = Vector2(160,160)
	
	await get_tree().process_frame
	
	for n in storage.Day:
		var current_date = "Dates/" + str(n+1)
		if n == storage.Day-1:
			# Position indstilles alt efter dato
			black_ring.position = get_node(current_date).get_global_position() + Vector2((90+rng.randi_range(1,20)),(90+rng.randi_range(1,20)))
			add_child(black_ring)
		else:
			var current_cross = current_date + "/Cross";
			get_node(current_cross).visible = true;
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if (event.is_action_pressed("Escape")):
		get_tree().change_scene_to_file("res://MainGame/main_game_computer.tscn")


func _on_return_button_pressed():
	get_tree().change_scene_to_file("res://MainGame/main_game_computer.tscn")
