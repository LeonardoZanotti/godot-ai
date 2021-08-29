extends Node

onready var aiFolder := $AI_Folder
onready var goal := $Goal
export var spawnAmount := 100

func _ready() -> void:
	print("Generation: ", str(Global.geneartionNum))
	randomize()
	spawnFunction()
	
func spawnFunction() -> void:
	if Global.bestDNA:
		# revive all and get working again
		for i in spawnAmount:
			var ai := preload("res://src/AI.tscn").instance()
			ai.original = false
			aiFolder.add_child(ai)
		for ai in aiFolder.get_children():
			ai.alive = true
			ai.dead = false
	else:
		# original first geneartion
		for i in spawnAmount:
			var ai := preload("res://src/AI.tscn").instance()
			ai.original = true
			ai.alive = true
			aiFolder.add_child(ai)



func _on_Timer_timeout() -> void:
	var deadAmount := 0.0
	for ai in aiFolder.get_children():
		if ai.dead:
			deadAmount += 1
	if deadAmount == spawnAmount:
		# check the closest ai to the goal and get his fitness
		var bestFitnessSoFar := 10000000
		var idOfMin := 0
		# find the best fitness
		for i in aiFolder.get_child_count():
			var fitness: float = aiFolder.get_child(i).fitness
			if fitness < bestFitnessSoFar:
				idOfMin = i
				bestFitnessSoFar = fitness
		if Global.bestFit > bestFitnessSoFar:
			Global.bestFit = bestFitnessSoFar
			Global.bestDNA = aiFolder.get_child(idOfMin).genome
		Global.geneartionNum += 1
		get_tree().reload_current_scene()
