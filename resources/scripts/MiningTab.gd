extends Control

var oreTemplate := preload('res://scenes/Tabs/mining/ore.tscn')
var sprites := preload('res://resources/scripts/Sprites.gd').new()
var leveling := preload('res://resources/scripts/Leveler.gd').new()
var materials = sprites.oreSprites

@onready var timer = $MiningTimer
@onready var levelBar = $MiningLevel
@onready var levelXP = $MiningLevel/MiningXP
var timeRequired = {
	'oreGlass': 1.5,
	'oreIron': 2,
	'oreSilver': 2.5,
	'oreGold': 3,
	'oreTitanium': 3.5,
	'oreUranium': 4,
	'orePlasma': 4.5,
	'oreDiamond': 5,
	'oreAlien': 5.5,
	'oreBluespace': 6,
	'oreBananium': 6.5
}
var xpGained = {
	'oreGlass': 0.6,
	'oreIron': 1,
	'oreSilver': 3,
	'oreGold': 5,
	'oreTitanium': 7,
	'oreUranium': 10,
	'orePlasma': 14,
	'oreDiamond': 18,
	'oreAlien': 24,
	'oreBluespace': 22,
	'oreBananium': 30
}
var levelRequired = {
	'oreGlass': 0,
	'oreIron': 5,
	'oreSilver': 10,
	'oreGold': 15,
	'oreTitanium': 20,
	'oreUranium': 25,
	'orePlasma': 30,
	'oreDiamond': 35,
	'oreAlien': 40,
	'oreBluespace': 45,
	'oreBananium': 50
}
var miningUpgrades = 3

var ores = ['oreGlass','oreIron','oreSilver','oreGold','oreTitanium','oreUranium','orePlasma','oreDiamond','oreAlien','oreBluespace','oreBananium']
var children = []
var activeChild = null
var currentXP = 0
var currentLevel = 50

signal miningFinish(item, amount)
signal miningLevelUp(newLevel)

func _ready():
	var i = 0
	var y = 60
	for ore in ores:
		var newOreSlot = oreTemplate.instantiate()
		newOreSlot.name = ore
		newOreSlot.find_child('OreIcon').texture = materials[ore]
		newOreSlot.find_child('OreLabel').text = ore.replace('ore', '')
		newOreSlot.find_child('TimerLabel').text = str(timeRequired[ore]) + ' Seconds'
		newOreSlot.find_child('OreProgressbar').max_value = timeRequired[ore]
		newOreSlot.find_child('XPLabel').text = str(xpGained[ore]) + ' XP'
		if(levelRequired[ore] > currentLevel):
			newOreSlot.find_child('LevelGate').visible = true
			newOreSlot.find_child('LevelReq').visible = true
			newOreSlot.find_child('LevelReq').text = 'level '+ str(levelRequired[ore])
		newOreSlot.position = Vector2(10+(120*i), y)
		$ScrollContainer/Control.add_child(newOreSlot)
		newOreSlot.connect('ore_button_pressed', button_pressed)
		children.push_front(newOreSlot)
		i = i + 1
		if(i > 6):
			i = 0
			y = y + 200
	update_time_label()
	_update_XP_bar()

func _process(_delta):
	if(activeChild):
		activeChild.find_child('OreProgressbar').value = timer.time_left

#func ore_button_pressed(ore):

func _on_mining_timer_timeout():
	match activeChild:
		null: pass
	miningFinish.emit(activeChild.name, 1)
	currentXP = currentXP + xpGained[activeChild.name]
	_update_XP_bar()

func clear_timers():
	for child in children:
		child.find_child('OreProgressbar').value = 0
	timer.stop()

func update_time_label():
	for child in children:
		child.find_child('TimerLabel').text = str(round(10 * (timeRequired[child.name] * (1-(0.15 * miningUpgrades))))/10) + ' Seconds'
		child.find_child('OreProgressbar').max_value = round(10 * (timeRequired[child.name] * (1-(0.15 * miningUpgrades))))/10

func button_pressed(ore):
	clear_timers()
	for child in children:
		if child.name == ore:
			if activeChild == child:
				activeChild = null
			else:
				activeChild = child
				timer.wait_time = round(10 * (timeRequired[child.name] * (1-(0.15 * miningUpgrades))))/10
				timer.start()
		else: pass

func _on_cargo_tab_cargo_upgrade(type, number):
	if type == 'miningup':
		miningUpgrades = miningUpgrades + number
		update_time_label()
	else: pass

func _update_XP_bar():
	var next_level = floor(leveling.xp_from_level(currentLevel + 1))
	while(currentXP >= next_level):
		currentLevel += 1
		miningLevelUp.emit(currentLevel)
		currentXP = floor((currentXP - next_level) * 10)/10
		next_level = floor(leveling.xp_from_level(currentLevel + 1))
		for child in children:
			if child.find_child('LevelGate').visible:
				if(currentLevel >= levelRequired[child.name]):
					child.find_child('LevelGate').visible = false
					child.find_child('LevelReq').visible = false
	levelBar.max_value = next_level
	levelBar.value = currentXP
	levelXP.text = str(currentXP)+'/'+str(next_level)
