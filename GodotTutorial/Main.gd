extends Node

export (PackedScene) var Mob
var score

func _ready():
	randomize()	# initialises the rng seed, which is used by the mobs

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_StartTimer_timeout():
	$ScoreTimer.start()
	$MobTimer.start()

func _on_ScoreTimer_timeout():
	score += 1

func _on_MobTimer_timeout():
	# chooses a random position along the path, and get the correct direction the mob should be facing
	# this gets the direction, by using the information that pathfollow keeps about points along it's path
	# the direction will always be perpendicular to the wall, in the direction of the center of the screen
	$MobPath/MobSpawnLocation.offset = randi()
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	
	var mob = Mob.instance()
	add_child(mob)
	
	mob.position = $MobPath/MobSpawnLocation.position
	
	# this makes it so the angle that the mob goes is random between 45 degrees either way of the walls normal
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
