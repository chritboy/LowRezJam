extends Node2D

const PlayerScene = preload("res://Scenes/Characters/player.tscn")

@onready var player_spawn = $PlayerSpawn
@onready var camera: = $Camera2D
@onready var bullet_container = $Bullets

var player = null


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	player.connect_camera(camera)
	player.global_position = player_spawn.global_position
	player.shoot.connect(player_shoot)
	
func player_shoot(bullet, location):
	var bullet_inst = bullet.instantiate()
	bullet_inst.global_position = location
	bullet_container.add_child(bullet_inst)
