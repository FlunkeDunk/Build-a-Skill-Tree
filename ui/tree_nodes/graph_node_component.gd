class_name GraphNodeComponent
extends Node

var connections: Array[GraphConnectionComponent]

func add_connection(c: GraphConnectionComponent) -> void:
	if not connections.has(c):
		connections.append(c)


func remove_connection(c: GraphConnectionComponent) -> void:
	connections.erase(c)
