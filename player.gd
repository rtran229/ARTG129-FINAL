extends CharacterBody3D # Use KinematicBody in Godot 3.x

const SPEED = 10.0
const JUMP_VELOCITY = 10.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input direction using custom actions
	# get_vector automatically normalizes diagonal movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# Calculate direction relative to the player's rotation
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		# Smoothly stop movement when no keys are pressed
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
