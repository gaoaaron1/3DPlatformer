extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 12
const MAX_ROTATION_X = 45 # Maximum up rotation in degrees
const MIN_ROTATION_X = -45 # Maximum down rotation in degrees

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rotation_x = 0.0

# Camera movement variables
var horizontal_sensitivity = 0.01 # Sensitivity for horizontal mouse movement
var vertical_sensitivity = 0.2   # Sensitivity for vertical mouse movement (increased for faster movement)
var mouse_pressed = false # Track mouse button state

func _physics_process(delta):
	# Handle camera rotation with keyboard inputs
	if Input.is_action_pressed("ui_left"):
		$Camera_Controller.rotate_y(deg_to_rad(1))
		
	if Input.is_action_pressed("ui_right"):
		$Camera_Controller.rotate_y(deg_to_rad(-1))

	if Input.is_action_pressed("ui_up"):
		rotation_x -= 1
	if Input.is_action_pressed("ui_down"):
		rotation_x += 1

	# Clamp the x rotation to stay within the limits
	rotation_x = clamp(rotation_x, MIN_ROTATION_X, MAX_ROTATION_X)
	$Camera_Controller.rotation_degrees.x = rotation_x

	# Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle movement/deceleration
	var input_dir = Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down")
	
	# New Vector3 direction, considering the camera rotation
	var direction = ($Camera_Controller.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir != Vector2(0, 0):
		$MeshInstance3D.rotation_degrees.y = $Camera_Controller.rotation_degrees.y - rad_to_deg(input_dir.angle())
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	# Make Camera Controller follow the position smoothly
	$Camera_Controller.position = lerp($Camera_Controller.position, position, 0.12)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			mouse_pressed = event.pressed # Track if the left mouse button is pressed or released

	if event is InputEventMouseMotion and mouse_pressed:
		# Adjust camera rotation based on mouse input when mouse is pressed
		$Camera_Controller.rotate_y(-event.relative.x * horizontal_sensitivity)
		
		# Rotate the camera up/down with separate sensitivity
		rotation_x += -event.relative.y * vertical_sensitivity
		rotation_x = clamp(rotation_x, MIN_ROTATION_X, MAX_ROTATION_X)
		$Camera_Controller.rotation_degrees.x = rotation_x

