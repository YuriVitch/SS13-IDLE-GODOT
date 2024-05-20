extends Node2D

func _ready():
	var __ = get_node("..").connect("tab_change", change_tab)
	for child in get_children():
		child.visible = false

func change_tab(tab):
	print(tab)
	for child in get_children():
		child.visible = false
	match tab:
		'cargo':
			$CargoTab.visible = true
	#get_node('CargoTab/ScrollContainer/Control/InventoryExpand').get_child(2).text = str(1000)
		'mining':
			enable_level_bar()
			$MiningTab.visible = true
		'engineering':
			enable_level_bar()
			$EngineeringTab.visible = true
		_:
			for child in get_children():
				child.visible = false
			pass

func enable_level_bar():
	$ActionLevel.visible = true
	$ActionLevel/ActionXP.visible = true

func disable_level_bar():
	$ActionLevel.visible = false
	$ActionLevel/ActionXP.visible = false
