extends Node2D

var _movement_direction : Vector2 = Vector2.ZERO
var _target : Node2D = null

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var meta_data: Node = $"../MetaData"
func set_target(target : Node2D) -> void:
	_target = target
	
func get_target() -> Node2D:
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

	var target_meta_data : Node = _target.get_node("MetaData")
	if target_meta_data == null:
		GodotLogger.warn("Target doesn't have a meta data!")

	if target_meta_data != null and should_go_to_entrance(target_meta_data):
		navigation_agent_2d.target_position \
			= target_meta_data.get_elevated_surface_entrance_coords()
	else:
		navigation_agent_2d.target_position = _target.global_position
	
"""
Returns true if target is on elevated terrain
Movement will shift towards entrance of that elevated terrain
On colliding with entrance, movement will again be towards the target
"""
func should_go_to_entrance(target_meta_data : Node) -> bool:
		return target_meta_data.get_elevated_surface_entrance() != null and \
		meta_data.get_elevated_surface_entrance() != target_meta_data.get_elevated_surface_entrance()
		
	
