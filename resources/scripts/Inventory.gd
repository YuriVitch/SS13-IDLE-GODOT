extends Node2D

var inventory : Array = []

var default := preload('res://resources/scripts/default.gd').new()
var inventorySlot := preload('res://scenes/Tabs/inventorypiece.tscn')

var sprites := preload('res://resources/scripts/Sprites.gd').new()
var materials = sprites.materialSprites

var coin := preload('res://resources/Sprites/Misc/coin.png')

var previousNull : bool = false
var inventoryLoaded : bool = false
var inventorySize = default.inventorySize
var money

var sellPrices := preload('res://resources/scripts/SellPrices.gd').new()

signal inventory_update(input)

# Called when the node enters the scene tree for the first time.
func _ready():
	var __ = get_node("../Actions").connect("item_gain", inventory_updater)
	__ = get_node('..').connect("tab_change", tab_update)
	__ = get_node('../TabChanger/MiningTab').connect("miningFinish", inventory_updater)
	tab_update(default.TAB_INVENTORY)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func inventory_updater(item, amount):
	if item && amount:
		if inventory.size() > 0:
			for i in range(inventory.size() - 1, -1, -1):
				if inventory[i][0] == item:
					inventory[i][1] = inventory[i][1] + amount
					break
				elif i == 0 && inventory.size() != inventorySize + 1:
					inventory.append([ item, amount ])
		else: inventory.append([ item, amount ])
		
	#range is the size of the inventory -1 to account for a base 0 array.
	for i in range(inventory.size() - 1, -1, -1):
		if(inventory[i][1] == null || inventory[i][1] <= 0) && inventory[i][0] != 'Coins':
			inventory.remove_at(i)
	get_node('../SidebarGUI/JobsContainer/VBoxContainer/Inventory/SlotsFilled').text = str(inventory.size() - 1) + '/' + str(inventorySize)
	print(inventory)
	get_node('../SidebarGUI/JobsContainer/VBoxContainer/Cargo/Coins').text = str(inventory[0][1])
	if inventoryLoaded:
		tab_update(default.TAB_INVENTORY)
	inventory_update.emit(inventory)

func tab_update(tab):
	if tab == default.TAB_INVENTORY:
		for child in self.get_children():
			child.queue_free()
		inventoryLoaded = true
		var offset = 0
		for i in range(inventory.size() - 1, -1, -1):
			if inventory[i][0] == 'Coins':
				continue
			var new_slot = inventorySlot.instantiate()
			match i:
				7: offset = 0
				14: offset = 0
				21: offset = 0
			new_slot.position.x = -350 + (offset*125)
			new_slot.position.y = -250 + (floor(i/8) * 200)
			var new_slot_texture = new_slot.get_child(0)
			match(inventory[i][0]):
				'oreGlass': new_slot_texture.texture = materials['oreGlass']
				'oreIron': new_slot_texture.texture = materials['oreIron']
				'oreSilver': new_slot_texture.texture = materials['oreSilver']
				'oreGold': new_slot_texture.texture = materials['oreGold']
				'oreTitanium': new_slot_texture.texture = materials['oreTitanium']
				'oreUranium': new_slot_texture.texture = materials['oreUranium']
				'orePlasma': new_slot_texture.texture = materials['orePlasma']
				'oreDiamond': new_slot_texture.texture = materials['oreDiamond']
				'oreAlien': new_slot_texture.texture = materials['oreAlien']
				'oreBluespace': new_slot_texture.texture = materials['oreBluespace']
				'oreBananium': new_slot_texture.texture = materials['oreBananium']
			#new_slot.get_child(0).texture = oreIron
			new_slot.get_child(2).text = str(inventory[i][1])
			new_slot.get_child(1).name = str(inventory[i][0])
			new_slot.find_child('Price').text = str(sellPrices.allSellPrices[new_slot.get_child(1).name])
			new_slot.connect('sell_all', _sell_item)
			print(inventory[i][0])
			add_child(new_slot)
			offset = offset + 1
	else:
		inventoryLoaded = false
		for child in self.get_children():
			child.queue_free()

func _on_main_inventory_update(input):
	for thing in input:
		inventory.append([thing, input[thing]])
	inventory_update.emit(inventory)
	print(inventory)
	get_node('../SidebarGUI/JobsContainer/VBoxContainer/Cargo/Coins').text = str(inventory[0][1])
	get_node('../SidebarGUI/JobsContainer/VBoxContainer/Inventory/SlotsFilled').text = str(inventory.size() - 1) + '/' + str(inventorySize)

func _on_cargo_tab_inventory_update(input):
	inventory = input
	inventory_update.emit(inventory)

func _on_main_upgrade(upgrade, number):
	if upgrade == 'inventoryup': 
		inventorySize = number
		get_node('../SidebarGUI/JobsContainer/VBoxContainer/Cargo/Coins').text = str(inventory[0][1])
		get_node('../SidebarGUI/JobsContainer/VBoxContainer/Inventory/SlotsFilled').text = str(inventory.size() - 1) + '/' + str(inventorySize)
	else: pass

func _sell_item(item, amount):
	var sellValue
	print(item)
	for arr in inventory:
		if arr[0] == item:
			match item:
				'oreGlass': sellValue = 2
				'oreIron': sellValue = 10
				'oreSilver': sellValue = 25
				'oreGold': sellValue = 45
				'oreTitanium': sellValue = 70
				'oreUranium': sellValue = 100
				'orePlasma': sellValue = 135
				'oreDiamond': sellValue = 175
				'oreAlien': sellValue = 200
				'oreBluespace': sellValue = 220 
				'oreBananium': sellValue = 300
			if sellValue != null:
				print(arr[1])
				print(arr[0])
				if typeof(amount) == typeof(1):
					inventory_updater('Coins', amount * sellValue)
					inventory_updater(arr[0], amount * -1)
				elif typeof(amount) == typeof('1'):
					inventory_updater('Coins', arr[1] * sellValue)
					inventory_updater(arr[0], arr[1] * -1)
