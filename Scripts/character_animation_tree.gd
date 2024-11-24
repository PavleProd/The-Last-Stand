extends AnimationTree

# parent character will update these parameters 
var character_direction : Vector2 = Vector2.ZERO
var is_attacking : bool = false

@onready var this: AnimationTree = $"."
func _process(_delta: float) -> void:
	
	var is_running : bool = character_direction != Vector2.ZERO
	this["parameters/conditions/is_idle"] = !is_running
	this["parameters/conditions/is_running"] = is_running
	this["parameters/conditions/is_attacking"] = is_attacking
	
	if is_running:
		this["parameters/Attack/blend_position"] = character_direction
		this["parameters/Run/blend_position"] = character_direction
		this["parameters/Idle/blend_position"] = character_direction
		
	# choose attack animation in the moment of the attack
	# only if character has random attacks
	if is_attacking and has_random_attack():
		choose_random_attack()

func choose_random_attack() -> void:
	var rand01 : float = randf()
	
	# TODO: traverse with for loop
	this["parameters/Attack/0/blend_position"] = rand01
	this["parameters/Attack/1/blend_position"] = rand01
	this["parameters/Attack/2/blend_position"] = rand01
	this["parameters/Attack/3/blend_position"] = rand01
	
func has_random_attack() -> bool:
	return ("parameters/Attack/0" in this)

func is_current_state_attack() -> bool:
	return this["parameters/playback"].get_current_node() == "Attack"
