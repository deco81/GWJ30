extends KinematicBody

enum States {IDLE, RUNNING, JUMPING}
var state = States.IDLE
onready var gimbal_x = $GimbalY/GimbalX 	# vertical gimbal (looking up and down)
onready var gimbal_y = $GimbalY				# horizontal gimbal (left and right)

var gravity = Vector3.DOWN * 12
var velocity = Vector3()
var speed = 16

func _ready():
	# Capture mouse movement
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):	
	#velocity += gravity * delta
	
	velocity += gravity * delta		
		
	var vy = velocity.y
	velocity = Vector3()
	
	if Input.is_action_pressed("ui_down"):
		velocity += transform.basis.z * speed
	if Input.is_action_pressed("ui_up"):
		velocity += -transform.basis.z * speed
	if Input.is_action_pressed("ui_left"):
		velocity += -transform.basis.x * speed
	if Input.is_action_pressed("ui_right"):
		velocity += transform.basis.x * speed
		
	velocity.y = vy
	
			

	
				
	velocity = move_and_slide(velocity)
	if state == States.JUMPING:
		state = States.IDLE 
		velocity.y = 6
		print("jumped")	

		
		
# check inputs like mouse movement or key pressing
func _input(event):
	state = States.IDLE 
	if Input.is_action_just_pressed("ui_jump"):
		state = States.JUMPING
		
	# if mouse is moving and we are capturing mouse movement
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		#rotate_y(- event.relative.x/10)
		rotate_y(-lerp(0.0, 0.1, event.relative.x))

		# rotate up and down
		gimbal_x.rotate_x(deg2rad(-event.relative.y * 0.2))

