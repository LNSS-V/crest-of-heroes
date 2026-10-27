extends CharacterBody3D

const WALK_SPEED := 5.0
const RUN_SPEED := 8.0
const JUMP_VELOCITY := 4.5
const GRAVITY := 9.8
const MOUSE_SENSITIVITY := 0.002

@onready var camera = $Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5)

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= GRAVITY * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement
	var direction := Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	if Input.is_action_pressed("move_back"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x

	direction = direction.normalized()

	var speed := WALK_SPEED
	if Input.is_action_pressed("run"):
		speed = RUN_SPEED

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	move_and_slide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
