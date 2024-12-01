extends Node2D

var _movement_direction : Vector2 = Vector2.ZERO
var _target : Node2D = null

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

func set_target(target : Node2D) -> void:
	_target = target
	
func get_target(target : Node2D) -> Node2D:
	return _target
	
func get_movement_direction() -> Vector2:
	return _movement_direction

func update_movement() -> void:	
	if navigation_agent_2d.is_navigation_finished():
		_movement_direction = Vector2.ZERO
		return

	_movement_direction = navigation_agent_2d.get_next_path_position() - global_position
	_movement_direction = _movement_direction.normalized()
	
func _on_timer_timeout() -> void:
	if _target == null:
		return

	navigation_agent_2d.target_position = _target.global_position
