extends Node


func is_power_of_two(value : int) -> bool:
	return (value & (value - 1)) == 0;
	
func log2(value: float) -> float:
	return log(value) / log(2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
