extends Area2D

var original := false
var dead := false
var alive := false
var speed := 20
var genome := []
var spotInGenome := 0
var fitness := 0.0
var goal: Area2D
var genomeSize := 75
var mutationAmount := 0.05

func _ready() -> void:
	# initial setup for the genome
	for i in genomeSize:
		genome.append(Vector2.ZERO)
	
	# random all
	randomize()
	
	# get goal node
	goal = get_parent().get_parent().get_node("Goal")
	
	if Global.bestDNA == null:
		# if is the first run and bestDNA isn't setted
		for i in genomeSize:
			# random genome
			var v := Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * speed
			genome[i] = v
	else:
		# isn't first run and we already have some progress
		for i in genomeSize:
			if randf() < mutationAmount:
				# if the mutation amount is bigger than a random float, then lets do some mutation
				var v := Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * speed
				genome[i] = v
			else:
				# else, just keeps the best genome
				genome[i] = Global.bestDNA[i]
