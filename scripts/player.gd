extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var anim = $Pivot/Character/AnimationPlayer

var joystick = Vector2.ZERO

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if not is_on_floor():#my solution for standing on rigid2dboxes
		set_collision_mask_value(2,true)
	if is_on_floor():
		set_collision_mask_value(2,false)
	$Pivot.rotation.x = PI / 6 * velocity.y / JUMP_VELOCITY # lol

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		#This is how we can use discrete direction using simple keys,
		#now I replaced it with a joystick, for android only.
		# I would want a mouse control if I want to make games on pc.
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(joystick.x, 0, joystick.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		$Pivot.look_at(position + direction, Vector3.UP)
		$Pivot.rotation.x = PI / 6 * velocity.y / JUMP_VELOCITY # lol
		anim.play("Run_001")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		anim.play("Idle")

	move_and_slide()


func _on_joystick_use_move_vector(move_vector):
	joystick = move_vector
