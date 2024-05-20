extends Node2D

signal tab_change(tab)

var newinputs := preload('res://resources/scripts/Inputs.gd').new()
var defaults := preload('res://resources/scripts/default.gd').new()
var xplevel := preload('res://resources/scripts/Leveler.gd').new()
var inventorySize
var miningTools
var inventory

signal inventory_update(input)
signal upgrade(upgrade, number)

# Called when the node enters the scene tree for the first time.
func _ready():
	if FileAccess.file_exists("user://savegame.txt"):
		var save = FileAccess.open("user://savegame.txt", FileAccess.READ).get_as_text()
		save = JSON.parse_string(save)
		inventorySize = save['upgrades']['upgrades']['inventorySize']
		if not inventorySize: inventorySize = defaults.inventorySize
		miningTools = save['upgrades']['upgrades']['miningTools']
		if not miningTools: miningTools = defaults.miningTools
		inventory = inventory
		if not inventory: inventory = defaults.inventory
	else: 
		inventory = defaults.inventory
		miningTools = defaults.miningTools
		inventorySize = defaults.inventorySize
	loaddata()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not $TabChanger/MiningTab/MiningTimer.is_stopped():
		$SidebarGUI/JobsContainer/VBoxContainer/Mining/MiningButton.add_theme_color_override("font_color" , Color("00ce00"))
	else: $SidebarGUI/JobsContainer/VBoxContainer/Mining/MiningButton.remove_theme_color_override("font_color")

func save():
	var save_dict = {
		"upgrades": {"upgrades": {"inventorySize": inventorySize, 'miningTools': miningTools}},
		"inventory": {"bank": inventory}
	}
	var save_game = FileAccess.open("user://savegame.txt", FileAccess.WRITE_READ)
	var json_save =  JSON.stringify(save_dict)
	save_game.store_string(json_save)

func loaddata():
	var save_data = FileAccess.open("user://savegame.txt", FileAccess.READ)
	var content = JSON.parse_string(save_data.get_as_text())
	inventory_update.emit(content['inventory']['bank'])
	upgrade.emit('inventoryup', content['upgrades']['upgrades']['inventorySize'])
	var i = content['upgrades']['upgrades']['inventorySize']
	$TabChanger/CargoTab/ScrollContainer/Control/InventoryExpand/InvItemCost.text = str(floor(2654570 * 50 * (i + 2) / (142015 ** (163 / (122 + i)))))
	upgrade.emit('miningup', content['upgrades']['upgrades']['miningTools'])

func _on_cargo_button_pressed():
	tab_change.emit('cargo')
func _on_inventory_button_pressed():
	tab_change.emit('inventory')
func _on_mining_button_pressed():
	tab_change.emit('mining')
	
	

func _on_save_button_pressed():
	if(!OS.is_debug_build()):
		save()
	else:
		print('Tried to save but in debug mode.')
func _on_load_button_pressed():
	if(!OS.is_debug_build()):
		loaddata()
	else:
		print('Tried to load save but in debug mode')

func _on_inventory_inventory_update(inventory):
	inventory = inventory

func _on_cargo_tab_cargo_upgrade(type, number):
	match type:
		'inventoryup': 
			inventorySize += number
			upgrade.emit(type, inventorySize)
		'miningup': miningTools += number


func _on_mining_tab_mining_level_up(newLevel):
	$SidebarGUI/JobsContainer/VBoxContainer/Mining/MiningLevel.text = str(newLevel)+"/50"


func _on_engineering_button_pressed():
	tab_change.emit('engineering')
