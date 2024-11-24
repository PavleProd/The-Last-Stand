extends CharacterBody2D


const SPEED : float = 10000.0
@export var speed_scale : float = 1.0

var movement_direction : Vector2 = Vector2(0.0, 1.0)
var is_attacking : bool = false

@onready var animation_tree: AnimationTree = $AnimationTree
func _process(_delta: float) -> void:
	if animation_tree.is_current_state_attack(): # prevent character from moving while attacking
		return

	process_input()
	update_animations()
	
func process_input() -> void:
	# default values
	movement_direction = Vector2.ZERO
	is_attacking = false

	if not Input.is_anything_pressed():
		return
		
	is_attacking = Input.is_action_just_pressed("player_attack")

	movement_direction = Input.get_vector(
		"player_move_left", 
		"player_move_right", 
		"player_move_up", 
		"player_move_down")
		
	# prevent moving faster when going diagonal
	movement_direction = movement_direction.normalized()

func update_animations() -> void:
	animation_tree.character_direction = movement_direction
	animation_tree.is_attacking = is_attacking

# process top-down movement 
func _physics_process(delta: float) -> void:
	if animation_tree.is_current_state_attack(): # prevent character from moving while attacking
		return

	velocity = movement_direction * SPEED * speed_scale * delta
	move_and_slide()
	
