extends Area2D

@onready var area_2d: Area2D = $"."
func _ready() -> void:
	# body_exited could be also used with same effect
	area_2d.body_entered.connect(_on_body_entered)

"""
First byte of collision is reserved for tileset objects on each level
When character goes to level i, it should interact only with levels i and i+1
i: objects on the ground
i+1: walls on that level
"""
func _on_body_entered(body: Node2D) -> void:
	if body is not CollisionObject2D: # if node has no collision skip(should not happen)
		GodotLogger.warn("Body without collision entered!")
		return

	if not Math.is_power_of_two(area_2d.collision_layer):
		GodotLogger.error("Wrong Collision Layer Value!")
		return

	var height_level = Math.log2(area_2d.collision_layer) + 1
	clear_tileset_collision_mask(body)
	set_tileset_collision_mask(body, height_level)
	
	body.z_index = RenderHelper.height_level_to_z_index(height_level, false)
	GodotLogger.info("Player height level changed to ", height_level)

# clear first byte of the collision mask
func clear_tileset_collision_mask(body: CollisionObject2D) -> void:
	body.collision_mask &= ~(0xFF)
	
# set first byte of the collision mask without modifying rest of the mask
func set_tileset_collision_mask(body: CollisionObject2D, height_level: int) -> void:
	if height_level > 8:
		GodotLogger.error("Wrong Height Level!")
		return

	body.set_collision_mask_value(height_level, true)
	if height_level != 8:
		body.set_collision_mask_value(height_level + 1, true)


func _process(delta: float) -> void:
	pass
