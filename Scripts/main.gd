class_name Main extends Node


	

func print_group_members(group_name: String) -> void:
	var nodes = get_tree().get_nodes_in_group(group_name)
	print("--- Nodes in group '" + group_name + "' ---")
	print("Total count: ", nodes.size())
	
	for i in range(nodes.size()):
		var node = nodes[i]
		print(str(i+1) + ". " + node.name + " (", node.get_path(), ")")
