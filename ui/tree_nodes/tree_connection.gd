@tool
class_name tree_connection
extends Line2D

@export var start: Node2D:
	set(node):
		start = node
		update()

@export var end: Node2D:
	set(node):
		end = node
		update()


func _ready() -> void:
	update()

func update():
	if start == null or end == null:
		return
	
	clear_points()
	add_point(to_local(start.global_position))
	add_point(to_local(end.global_position))
	
