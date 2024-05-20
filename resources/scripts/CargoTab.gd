extends Control

var cargo_inventory
var upgradeCosts := preload('res://resources/scripts/UpgradeCosts.gd').new()
var upgrades = {}

signal inventory_update(input)
signal cargo_upgrade(type,number)

func _process(_delta):
	pass

func _on_inventory_inventory_update(input):
	cargo_inventory = input

#inventorySize = inventorySize + 1
func _on_inventory_up_purchase_pressed():
	if cargo_inventory[0][1] >= int($ScrollContainer/Control/InventoryExpand/InvItemCost.text):
		cargo_inventory[0][1] = cargo_inventory[0][1] - int($ScrollContainer/Control/InventoryExpand/InvItemCost.text)
		inventory_update.emit(cargo_inventory)
		cargo_upgrade.emit('inventoryup', 1)
		var i = cargo_inventory.size() - 1
		$ScrollContainer/Control/InventoryExpand/InvItemCost.text = str(floor(2654570 * 50 * (i + 2) / (142015 ** (163 / (122 + i)))))


func _on_mining_up_purchase_pressed():
	if cargo_inventory[0][1] >= int($ScrollContainer/Control/MiningUpgrade/MiningItemCost.text):
		cargo_inventory[0][1] = cargo_inventory[0][1] - int($ScrollContainer/Control/MiningUpgrade/MiningItemCost.text)
		inventory_update.emit(cargo_inventory)
		cargo_upgrade.emit('miningup', 1)
		upgrades['miningup'] += 1
		$ScrollContainer/Control/MiningUpgrade/MiningItemCost.text = str(upgradeCosts.calcCost(upgrades['miningup'], 5))


func _on_main_upgrade(upgrade, number):
#	if upgrades.size() > 0:
	match upgrade:
		'inventoryup': upgrades[upgrade] = number
		'miningup':
			upgrades[upgrade] = number
			$ScrollContainer/Control/MiningUpgrade/MiningItemCost.text = str(upgradeCosts.calcCost(upgrades['miningup'], 5))
		upgrade: upgrades[upgrade] += number
	print(upgrades)
