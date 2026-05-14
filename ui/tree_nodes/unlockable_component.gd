class_name UnlockableComponent
extends Node

signal unlocked_changed(value: bool)

@export var is_source := false
@export var graph_node: GraphNodeComponent

var _distance_to_source: int = -1
var distance_to_source: int:
	get():
		if is_source:
			return 0
		return _distance_to_source
	set(value):
		_distance_to_source = value

var _is_unlocked := false
@export var is_unlocked: bool:
	get:
		return _is_unlocked
	set(value):
		_is_unlocked = value
		unlocked_changed.emit(value)

func can_unlock() -> bool:
	if is_source:
		return true

	for c: GraphConnectionComponent in graph_node.connections:
		var unlockable := c.get_other_unlockable(self)

		if unlockable and unlockable.is_unlocked:
			return true

	return false

func can_lock() -> bool:
	if is_source:
		return false

	# Already locked
	if not is_unlocked:
		return false
	
	for connection: GraphConnectionComponent in graph_node.connections:
		var other: UnlockableComponent = connection.get_other_unlockable(self)
		if not other or not other.is_unlocked:
			continue
		
		# if other is longer away then cannot lock
		if other.get_minimum_neighbor_distance(self) == -1:
			return false
		if distance_to_source < other.get_minimum_neighbor_distance(self):
			return false
	
	return true

func try_unlock() -> void:
	if can_unlock():
		update_distance_to_source()
		is_unlocked = true


func try_lock() -> void:
	if can_lock():
		distance_to_source = -1
		is_unlocked = false


func update_distance_to_source() -> void:
	distance_to_source = get_minimum_neighbor_distance() + 1
	
func get_minimum_neighbor_distance(ignore: UnlockableComponent = null) -> int:
	var minimum_neighbor_distance: int = -1
	for connection: GraphConnectionComponent in graph_node.connections:
		var other: UnlockableComponent = connection.get_other_unlockable(self)
		if not other or not other.is_unlocked or other == ignore:
			continue
		
		if minimum_neighbor_distance == -1:
			minimum_neighbor_distance = other.distance_to_source
		else:
			minimum_neighbor_distance = mini(minimum_neighbor_distance, other.distance_to_source)
	
	return minimum_neighbor_distance
