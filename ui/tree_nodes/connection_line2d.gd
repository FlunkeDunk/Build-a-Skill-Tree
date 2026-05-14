class_name ConnectionLine2D
extends Line2D

const CONNECTED_TEXTURE_UID: String = "uid://x065y5m5mobx"
const DISCONNECTED_TEXTURE_UID: String = "uid://b1e112ih3vhmx"

@export var start: Node2D:
	set(node):
		start = node
		update()

@export var end: Node2D:
	set(node):
		end = node
		update()


func _ready() -> void:
	show_behind_parent = true
	texture_mode = Line2D.LINE_TEXTURE_STRETCH
	update()

func update() -> void:
	if start == null or end == null:
		return
	
	clear_points()
	add_point(to_local(start.global_position))
	add_point(to_local(end.global_position))


func show_connection(is_unlocked: bool) -> void:
	if is_unlocked:
		texture = load(CONNECTED_TEXTURE_UID)
	else:
		texture = load(DISCONNECTED_TEXTURE_UID)



	
	
	
	
	
	
	
	
