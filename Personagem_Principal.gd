extends KinematicBody2D

export var fall_gravity_scale := 150.0
export var low_jump_gravity_scale := 100.0
export var jump_power := -500.0
export var gravity_scale := 100.0

const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0,-1)
const FIREBALL = preload("res://Fireball.tscn")

var jump_released = false

var on_ground = false

var is_casting = false

var velocity = Vector2()

var is_dead = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if is_dead == false:
	
		if Input.is_action_pressed("ui_right"):
			if is_casting == false or is_on_floor() == false: 
				velocity.x = SPEED
				if is_casting == false:
					$AnimatedSprite.play("Run")
					$AnimatedSprite.flip_h = false
					if sign($Position2D.position.x) == -1:
						$Position2D.position.x *= -1
					
		elif Input.is_action_pressed("ui_left"):
			if is_casting == false or is_on_floor() == false: 
				velocity.x = -SPEED
				if is_casting == false:
					$AnimatedSprite.play("Run")
					$AnimatedSprite.flip_h = true
					if sign($Position2D.position.x) == 1:
						$Position2D.position.x *= -1
			
		else:
			velocity.x = 0
			if on_ground == true && is_casting == false:
				$AnimatedSprite.play("Idle")






		# JUMP
			
		if Input.is_action_just_released("ui_accept"):
			if is_casting == false:
				if on_ground == true:
					jump_released = true
					velocity += Vector2.DOWN * GRAVITY * gravity_scale * delta
					on_ground = false
				
		if Input.is_action_just_pressed("ui_select") && is_casting == false:
			if is_on_floor():
				velocity.x = 0
			is_casting = true
			$AnimatedSprite.play("Cast")
			var fireball = FIREBALL.instance()
			if sign($Position2D.position.x) == 1:
				fireball.set_fireball_direction(1)
			else:
				fireball.set_fireball_direction(-1)
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
			
			
				 
		
		velocity.y += GRAVITY
		
		if is_on_floor():
			if on_ground == false:
				is_casting = false
			on_ground = true
		else:
			if is_casting == false:
				on_ground = false
				if velocity.y < 0:
					$AnimatedSprite.play("Jump")
				else:
					$AnimatedSprite.play("Fall")	
			
		velocity = move_and_slide(velocity, FLOOR)
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name:
					dead()

func dead():
	is_dead = true
	velocity = Vector2(0 ,0)
	$AnimatedSprite.play("Dead")
	$CollisionShape2D.set_deferred("disabled", true)
	$Timer.start()


func _on_AnimatedSprite_animation_finished():
	is_casting = false


func _on_Timer_timeout():
	get_tree().change_scene("res://Titlescreen.tscn")
