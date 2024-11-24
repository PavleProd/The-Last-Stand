extends Node

"""
Z-Index order (starts from 0):
	level 0:
		tiles: 0
		other: 1
	level 1:
		tiles: 2
		other: 3
	level 2:
		tiles: 4
		other: 5
and so on..

height_level is a collision layer/mask value(starts from 1).
That's why we are substracting 1
"""
func height_level_to_z_index(height_level : int, is_tile : bool) -> int:
	var add_one : int = 0 if is_tile else 1
	return (height_level - 1) * 2 + add_one
