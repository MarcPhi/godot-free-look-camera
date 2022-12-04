#Copyright © 2022 Marc Nahr: https://github.com/MarcPhi/godot-free-look-camera
extends Camera3D
#Key Exports for remapable keys
@export var RunKey : InputEventKey = KeyToInputEventKey(KEY_SHIFT)
@export var CrouchKey : InputEventKey = KeyToInputEventKey(KEY_C)
@export var ForwardsKey : InputEventKey = KeyToInputEventKey(KEY_W)
@export var BackwardsKey : InputEventKey = KeyToInputEventKey(KEY_S)
@export var LeftKey : InputEventKey = KeyToInputEventKey(KEY_A)
@export var RightKey : InputEventKey = KeyToInputEventKey(KEY_D)
@export var DownKey : InputEventKey = KeyToInputEventKey(KEY_Q)
@export var UpKey : InputEventKey = KeyToInputEventKey(KEY_E)
#Mouse sensitivy
@export_range(0, 10, 0.01) var sensitivity : float = 3
@export_range(0, 1000, 0.1) var DefaultAcceleration : float = 5
#Scales for affecting the base Acceleration
@export_range(0,100,0.1) var RunScale : float = 2
@export_range(0,100,0.1) var CrouchScale : float = 0.5
@export_range(0, 10, 0.01) var SpeedScale : float = 1.17

@export var MaxAccel : float = 1000
@export var MinAccel : float = 0.2

@onready var Acceleration = DefaultAcceleration

func _input(event):
	if not current:
		return
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotation.y -= event.relative.x / 1000 * sensitivity
			rotation.x -= event.relative.y / 1000 * sensitivity
			rotation.x = clamp(rotation.x, PI/-2, PI/2)
	
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE)
			MOUSE_BUTTON_WHEEL_UP: # increase fly velocity
				Acceleration = clamp(Acceleration * SpeedScale, MinAccel, MaxAccel)
			MOUSE_BUTTON_WHEEL_DOWN: # decrease fly velocity
				Acceleration = clamp(Acceleration / SpeedScale, MinAccel, MaxAccel)

func _process(delta):
	var Direction = Vector3(
		float(Input.is_key_pressed(RightKey.keycode)) - float(Input.is_key_pressed(LeftKey.keycode)),
		float(Input.is_key_pressed(UpKey.keycode)) - float(Input.is_key_pressed(DownKey.keycode)), 
		float(Input.is_key_pressed(BackwardsKey.keycode)) - float(Input.is_key_pressed(ForwardsKey.keycode))
	).normalized()
	if Input.is_key_pressed(RunKey.keycode):
		translate(Direction * Acceleration * RunScale * delta)
	elif Input.is_key_pressed(CrouchKey.keycode):
		translate(Direction * Acceleration * CrouchScale * delta)
	else:
		translate(Direction * Acceleration * delta)

#Converts Keycodes to InputKeyEvents mainly to be used for default key values
func KeyToInputEventKey(key):
	var newk = InputEventKey.new()
	newk.keycode = key
	return newk
