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

# AI Timer passed 0.05 seconds
func _on_Timer_timeout() -> void:
	if alive:
		# the ai is alive, so go to the next direction
		spotInGenome += 1
	else:
		# ai is dead
		dead = true

# runs about 60 times per second and tries to do equal pauses between each frame
func _physics_process(delta: float) -> void:
	if alive:
		# ai is alive
		if !dead and spotInGenome < genome.size():
			# ai is not dead and the next direction is a valid one
			# set next direction
			global_position += genome[spotInGenome]
		else:
			# die
			die()

# ai died
func die() -> void:
	dead = true
	# how far away the ai was from the goal
	fitness = ((global_position.distance_squared_to(goal.global_position)))

func _on_AI_body_entered(body: Node) -> void:
	if body:
		dead = true

func _on_AI_goal_entered(goal: Area2D) -> void:
	if goal:
		die()
