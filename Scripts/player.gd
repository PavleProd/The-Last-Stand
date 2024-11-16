extends CharacterBody2D


const SPEED : float = 10000.0
@export var speed_scale : float = 1.0

enum Direction { NONE, LEFT, RIGHT, UP, DOWN }
var last_direction : Direction = Direction.NONE

var animation_in_progress : bool = false

# TODO: improve this shit code

func _physics_process(delta: float) -> void:
	if not Input.is_anything_pressed():
		return
		
	var y_movement : float = Input.get_axis("player_move_up", "player_move_down")
	var x_movement : float = Input.get_axis("player_move_left", "player_move_right")
	
	velocity.y = y_movement * SPEED * speed_scale * delta
	velocity.x = x_movement * SPEED * speed_scale * delta
	
	move_and_slide()
	
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
func _process(_delta: float) -> void:
	
	var actionPerformed = false
		
	actionPerformed = process_player_movement(_delta)
	if actionPerformed:
		return
		
	actionPerformed = process_player_attack(_delta)
	if actionPerformed:
		return

	if not Input.is_anything_pressed() and not animation_in_progress:
		animated_sprite_2d.play("idle")
		return
		
func process_player_movement(_delta: float) -> bool:
	# We have the same animation for running in every direction
	# Only difference is flipping horizontally if going left (or left + any other key)
	if Input.is_action_pressed("player_move_left"):
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("run_right")
		last_direction = Direction.LEFT
		return true
	elif Input.is_action_pressed("player_move_right"):
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("run_right")
		last_direction = Direction.RIGHT
		return true
	
	# if we are going up or down we leave horizontal flipping
	if Input.is_action_pressed("player_move_down"):
		animated_sprite_2d.play("run_right")
		last_direction = Direction.DOWN
		return true
		
	if Input.is_action_pressed("player_move_up"):
		animated_sprite_2d.play("run_right")
		last_direction = Direction.UP
		return true
	
	return false

func process_player_attack(_delta: float) -> bool:
	if not Input.is_action_pressed("player_attack"):
		return false
		
	animation_in_progress = true
		
	if Input.is_action_pressed("player_move_up"):
		animated_sprite_2d.play("attack_up_1")
	elif Input.is_action_pressed("player_move_down"):
		animated_sprite_2d.play("attack_down_1")
	elif Input.is_action_pressed("player_move_left"):
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("attack_right_1")
	elif Input.is_action_pressed("player_move_right"):
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("attack_right_1")
	else:
		match last_direction:
			Direction.LEFT:
				animated_sprite_2d.flip_h = true
				animated_sprite_2d.play("attack_right_1")
			Direction.RIGHT:
				animated_sprite_2d.flip_h = false
				animated_sprite_2d.play("attack_right_1")
			Direction.UP:
				animated_sprite_2d.play("attack_up_1")
			Direction.DOWN:
				animated_sprite_2d.play("attack_down_1")
			_:
				animated_sprite_2d.flip_h = false
				animated_sprite_2d.play("attack_right_1")
	
	return true
	
	

func _on_animated_sprite_2d_animation_looped() -> void:
	animation_in_progress = false
