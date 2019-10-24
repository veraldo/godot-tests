extends KinematicBody2D

const MOVE_SPEED = 500
const JUMP_FORCE = 1000
const GRAVITY = 50
const MAX_FALL_SPEED = 1000 # pixels per second
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite

var y_speed = 0
var facing_right = false

func _physics_process(delta):
	var move_dir = 0
	if Input.is_action_pressed("move_right"):
		move_dir += 1
	if Input.is_action_pressed("move_left"):
		move_dir -= 1
	move_and_slide(Vector2(move_dir * MOVE_SPEED, y_speed), Vector2(0,-1))
	
	var grounded = is_on_floor()
	y_speed += GRAVITY
	if grounded and Input.is_action_pressed("jump"):
		y_speed = -JUMP_FORCE
	if grounded and y_speed >= 5:
		y_speed = 5
	if y_speed > MAX_FALL_SPEED:
		y_speed = MAX_FALL_SPEED
	
	if facing_right and move_dir < 0:
		flip()
	if !facing_right and move_dir > 0:
		flip()
		
	if grounded:
		if move_dir == 0:
			play_anim("idle")
		else:
			play_anim("walk")
	else:
		play_anim("jump")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func flip():
	facing_right = !facing_right
	sprite.flip_h = !sprite.flip_h

func play_anim(anim_name):
	if anim_player.is_playing() and anim_player.current_animation == anim_name:
		return
	anim_player.play(anim_name)