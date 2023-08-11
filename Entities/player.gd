extends CharacterBody2D

@export var movement_data : PlayerMovementData

var air_jump = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var starting_position = global_position

func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	handle_walljump()
	var input_axis = Input.get_axis("move_left", "move_right")
	handle_acceleration(input_axis, delta)
	handle_air_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = (was_on_floor != is_on_floor()) and velocity.y >=0
	if just_left_ledge:
		coyote_jump_timer.start()
#		print("start coyote!")
	update_animations(input_axis, velocity.x)

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta 

func handle_walljump():
	if not is_on_wall():
		return
	velocity.y = min(velocity.y, movement_data.wall_slide_speed)
	
	var wall_normal = get_wall_normal()
	if not is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jump_velocity
		
func handle_jump():
	if is_on_floor() and !air_jump:
		air_jump = true
#		print("Reset Double Jump.")
	if is_on_floor(): 
		if Input.is_action_just_pressed("jump"):
#			print("Regular Jump!")
			velocity.y = movement_data.jump_velocity
	elif coyote_jump_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
#			print("Coyote Jump!")
			velocity.y = movement_data.jump_velocity
			coyote_jump_timer.stop()
	elif !is_on_floor() and !is_on_wall():
		if Input.is_action_just_released("jump") and velocity.y < movement_data.jump_velocity / 2:
			velocity.y = movement_data.jump_velocity / 2
		if Input.is_action_just_pressed("jump") and air_jump:
#			print("Double Jumped.")
			velocity.y = movement_data.jump_velocity * 0.8
			air_jump = false

func handle_acceleration(input_axis, delta):
	if not is_on_floor():
		return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)

func handle_air_acceleration(input_axis, delta):
	if is_on_floor():
		return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta)

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func apply_air_resistance(input_axis, delta):
	if !is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)


func update_animations(input_axis, x_velocity):	
	if input_axis:
		animated_sprite_2d.flip_h = (input_axis < 0)
		animated_sprite_2d.play("run")
		animated_sprite_2d.speed_scale = max(abs(x_velocity)/movement_data.speed, 0.2)
	else:
		animated_sprite_2d.play("idle")

	if not is_on_floor():
		animated_sprite_2d.play("jump")


func _on_hitbox_area_entered(area):
	global_position = starting_position
