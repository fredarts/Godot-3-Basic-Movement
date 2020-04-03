extends KinematicBody2D

var velocity = Vector2()

var move_speed = 5*16

var gravity = 300

var jump_velocity = -180

var is_grounded

onready var raycasts = $Raycasts

onready var anim_player = $Body/AnimationPlayer

const UP = Vector2(0, -1)

const SLOPE_STOP = 16

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, UP, SLOPE_STOP)
	
	is_grounded = _check_is_grounded()
	
	_assign_animation()
	
func _input(event):
	if event.is_action_pressed("jump") && is_grounded:
		velocity.y = jump_velocity
		
	
func get_input():
	var move_direction = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	#velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
	velocity.x = move_speed * move_direction
	if move_direction != 0:
		$Body.scale.x = move_direction
		
#func _get_h_weight():
#	return 0.2 if is_grounded else 0.1
		
func _check_is_grounded():
	for raycast in raycasts.get_children():
		if raycast.is_colliding():
			return true
			
	# if  loop completes then raycast was not detected
	return false

func _assign_animation():
	var anim = "idle"
	
			
	if !is_grounded:
		anim = "jump"
		if velocity.y > 0:
			anim = "fall"
			
	elif velocity.x != 0:
		anim = "run"
	
	if anim_player.assigned_animation != anim:
		anim_player.play(anim)
