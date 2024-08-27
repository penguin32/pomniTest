extends TouchScreenButton

var move_vector = Vector2.ZERO
@onready var joystick = $"."
@onready var circle = $"../Circle"#The reason I added circle as sibling, its because of drawing orders/layers.
signal use_move_vector
@onready var joystick_middle_coord = Vector2(joystick.position.x+joystick.shape.get_radius(),joystick.position.y+joystick.shape.get_radius())
# A line above is the center of CircleShape2D I'm assuming.
## BE FUCKING BEWARE OF CHANGING CollisionShape2D, it affects the code functionality like movement controls!!!
## I DON"T KNOW WHY THE FUCK IT DOES THAT!
func _input(event):#btw, this instruction given below is not confined within this joystick
#This is how we override virtual function _input and it'll work everywhere the screen user has touched
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		#joystick.shape.get_radius()	#doesn't appear on intellisence, better keep it here as reminder.
		match event.index:#This looks like a switch case
			0:
				circle.position = event.position
	#	if joystick_middle_coord.distance_to(circle.position)/4 < joystick.shape.get_radius():
	#     could be use for designing ui moving little circle that follows index finger.
		#print (move_vector)

func _physics_process(_delta):
	#print(joystick_middle_coord.distance_to(circle.position)) # HEHEH I KNEW IT!
	#will be use to restrict Circle.position within its radius.
	emit_signal("use_move_vector",move_vector)	
	if joystick.is_pressed():
		circle.visible = true
		move_vector = calculate_move_vector(circle.position)
	if  joystick.is_pressed() == false:
		move_vector = Vector2.ZERO
		circle.position = joystick_middle_coord
		circle.visible = false

func calculate_move_vector(event_position):
	var texture_center = joystick.position + Vector2(joystick.shape.get_radius() ,joystick.shape.get_radius())
	return (event_position - texture_center).normalized()
