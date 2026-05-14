class_name Socket
extends Node2D

@export var graph_node: GraphNodeComponent
@export var socket_component: SocketComponent

var temp_connections: Array[GraphConnectionComponent]

func _ready() -> void:
	socket_component.new_socketed.connect(connect_nodes)
	socket_component.unsocketed.connect(disconnect_nodes)
	


func connect_nodes(socketed: DraggableComponent) -> void:
	var socketed_node: Node2D = socketed.owner
	
	assert(socketed_node is Node2D, "Sockedted entity must be Node2D")
	
	for connection in graph_node.connections:
		connection.hide()
		
		var temp_connection := GraphConnectionComponent.new()
		temp_connection.first_node = socketed_node
		temp_connection.second_node = connection.get_other_node(self)
		add_child(temp_connection)
		temp_connections.append(temp_connection)
	
	
func disconnect_nodes() -> void:
	for temp_connection in temp_connections:
		temp_connection.disconnect_and_free()
		
	for connection in graph_node.connections:
		connection.show()
	
	temp_connections.clear()
