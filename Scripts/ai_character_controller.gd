extends CharacterBody2D

@onready var movement_component: Node2D = $MovementComponent
@onready var animation_tree: AnimationTree = $AnimationTree

const SPEED : float = 10000.0
@export var speed_scale : float = 1.0
@export var target : Node2D = null

var is_attacking : bool = false

# TODO: create enemy finder algorithm
func set_target(_target) -> void:
	if movement_component != null:
		movement_component.set_target(_target)

func _ready():
	set_target(target)

func _process(_delta: float) -> void:
	if animation_tree.is_current_state_attack(): # prevent character from moving while attacking
		return

	movement_component.update_movement()
	update_animations()
	
func update_animations() -> void:
	animation_tree.character_direction = movement_component.get_movement_direction()
	animation_tree.is_attacking = is_attacking
	
# process top-down movement 
func _physics_process(delta: float) -> void:
	if animation_tree.is_current_state_attack(): # prevent character from moving while attacking
		return

	velocity = movement_component.get_movement_direction() * SPEED * speed_scale * delta
	move_and_slide()
