extends Node2D

const PlayerScene = preload("res://Scenes/Characters/player.tscn")
signal player_died

#@onready var player_spawn = $PlayerSpawn
@onready var bullet_container = $Bullets
@onready var camera: = $Camera2D

var player = null


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	player.connect_camera(camera)
	player.shoot.connect(player_shoot)
	StageManager.emit_signal("level_loaded")

func player_shoot(bullet, location):
	var bullet_inst = bullet.instantiate()
	bullet_inst.global_position = location
	bullet_container.add_child(bullet_inst)

func _on_north_hall_body_entered(body):
	if body == player:
		StageManager.change_stage(StageManager.EastWing, 236, 90)

func _on_room_2_body_entered(body):
	if body == player:
		StageManager.change_stage(StageManager.Room2, 90, 26)

func _on_dungeon_start_body_entered(body):
	if body == player:
		Player.north_wing = true
		StageManager.change_stage(StageManager.DungeonStart, 83, -15)
