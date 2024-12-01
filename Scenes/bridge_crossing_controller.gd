extends Area2D

enum Type {ENTER, EXIT}
@export var type : Type

func _on_body_entered(body: Node2D) -> void:
	var meta_data = body.get_node("$MetaData")
	if meta_data == null:
		GodotLogger.warn("Node doesn't have meta data!")
		return
	
	if type == Type.ENTER:
		meta_data.on_enter_elevated_surface()	
	else:
		meta_data.on_exit_elevated_surface()
