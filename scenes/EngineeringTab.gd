extends Control

var productionTemplate := preload('res://scenes/Tabs/actions/production.tscn')
var sprites := preload("res://resources/scripts/Sprites.gd").new()
var leveling := preload("res://resources/scripts/Leveler.gd").new()
var engineeringSprites = sprites.engineeringSprites

@onready var timer = $EngineeringTimer
@onready var levelBar = self.get_parent().get_node('ActionLevel')
@onready var levelXP = self.get_parent().get_node('ActionLevel/ActionXP')
@onready var miningLevelLabel = get_tree().get_root().get_node('Main/SidebarGUI/JobsContainer/VBoxContainer/Engineering/EngineeringLevel')

var timeRequired = {
	'default' = 5 
}

var actions = ['bicycle', 'treadmill', 'generator1', 'generator2']
var children = []
var activeChild = null
var currentXP = 0
var currentLevel = 0

signal engineeringFinish(item, amount)
signal engineeringLevelUp(newLevel)

func _ready():
	var i = 0
	var y = 60
	for action in actions:
		var consume = false
		var newProduction = productionTemplate.instantiate()
		newProduction.name = action
		newProduction.find_child('ProductionIcon').texture = engineeringSprites[action]
		match action:
			'bicycle':
				newProduction.find_child('ProductionLabel').text = 'stationary bicycle'
				newProduction.find_child('OutputAmount').text = 'x2'
			'treadmill':
				newProduction.find_child('OutputAmount').text = 'x4'
			'generator1':
				newProduction.find_child('ProductionLabel').text = 'portable generator'
				newProduction.find_child('OutputAmount').text = 'x10'
			'generator2':
				newProduction.find_child('ProductionLabel').text = 'improved generator'
				newProduction.find_child('OutputAmount').text = 'x10'
			_:
				newProduction.find_child('ProductionLabel').text = action
		match action:
			_:
				newProduction.find_child('TimerLabel').text = str(timeRequired['default']) + " Seconds"
		match action:
			_:
				newProduction.find_child('Output').texture = engineeringSprites['power']
		if not consume:
				newProduction.find_child('Output').position = Vector2(115,127)
				newProduction.find_child('OutputAmount').position = Vector2(55, 115)
		newProduction.position = Vector2(10+(220*i), y)
		i = i + 1
		$ScrollContainer/Control.add_child(newProduction)
