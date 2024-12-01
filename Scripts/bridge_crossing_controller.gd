extends Area2D

@export var change_layer_node : Node2D = null

func check_validity(body : Node2D) -> bool:
	var collision_object = body as CollisionObject2D
	
	# if node has no collision skip(should not happen)
	if collision_object == null:
		GodotLogger.warn("Body without collision entered!")
		return false
		
	# node is not on the same level
	if collision_object.collision_mask & collision_layer == 0:
		return false;

	var meta_data = body.get_node("MetaData")
	if meta_data == null:
		GodotLogger.warn("Node doesn't have meta data!")
		return false
		
	return true;

func _on_body_entered(body: Node2D) -> void:
	if not check_validity(body):
		return
	
	var meta_data = body.get_node("MetaData")
	GodotLogger.info("\"%s\" entered elevated surface" % [body.name])
	meta_data.enter_elevated_surface.emit(change_layer_node)

func _on_body_exited(body: Node2D) -> void:
	if not check_validity(body):
		return

	var meta_data = body.get_node("MetaData")
	GodotLogger.info("\"%s\" exited elevated surface" % [body.name])
	meta_data.exit_elevated_surface.emit()
