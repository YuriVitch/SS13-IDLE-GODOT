extends Node2D

func _ready():
	var __ = get_node("..").connect("tab_change", change_tab)
	for child in get_children():
		child.visible = false

func change_tab(tab):
	print(tab)
	for child in get_children():
		child.visible = false
	if tab == 'cargo':
		$CargoTab.visible = true
	#get_node('CargoTab/ScrollContainer/Control/InventoryExpand').get_child(2).text = str(1000)
	elif tab == 'mining':
		$MiningTab.visible = true
	else:
		for child in get_children():
			child.visible = false
		pass
