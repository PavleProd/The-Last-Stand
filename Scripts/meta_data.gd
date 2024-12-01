extends Node

var _height_level : int = 0

# node is on the that are accessible by the bridge
var _is_on_elevated_surface : bool = false
var _elevated_surface_entrance : Node2D = null

# PUBLIC

func set_height_level(height_level : int):
	_height_level = height_level
	
func get_elevated_surface_entrance_coords() -> Vector2:
	if _elevated_surface_entrance == null:
		GodotLogger.error("Node is not on the elevated surface!")
		return Vector2.ZERO

	return _elevated_surface_entrance.global_position 
	
func on_enter_elevated_surface(surface_entrance : Node2D) -> void:
	_is_on_elevated_surface = true
	_elevated_surface_entrance = surface_entrance
	
func on_exit_elevated_surface() -> void:
	_is_on_elevated_surface = false
	_elevated_surface_entrance = null
