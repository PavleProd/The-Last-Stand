extends CharacterBody2D

@onready var movement_component: Node2D = $MovementComponent
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var meta_data: Node = $MetaData
@onready var navigation_agent_2d: NavigationAgent2D = $MovementComponent/NavigationAgent2D

const SPEED : float = 3000.0
@export var speed_scale : float = 1.0
@export var target : Node2D = null

var is_attacking : bool = false

# TODO: create enemy finder algorithm
func set_target(_target) -> void:
	if movement_component != null:
		movement_component.set_target(_target)

func _ready():
	set_target(target)
	
	# Connect to Signals
	meta_data.enter_elevated_surface.connect(_on_enter_elevated_surface)
	meta_data.exit_elevated_surface.connect(_on_exit_elevated_surface)
	
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

	var new_velocity = movement_component.get_movement_direction() * SPEED * speed_scale * delta
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		velocity = new_velocity

	move_and_slide()
	
func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()
	
func _on_enter_elevated_surface(_entrance : Node2D) -> void:
	navigation_agent_2d.set_navigation_layer_value(2, false)
	navigation_agent_2d.set_navigation_layer_value(3, true)
	
func _on_exit_elevated_surface() -> void:
	navigation_agent_2d.set_navigation_layer_value(3, false)
	navigation_agent_2d.set_navigation_layer_value(2, true)
