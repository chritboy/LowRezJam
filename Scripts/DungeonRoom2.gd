extends Node2D

const PlayerScene = preload("res://Scenes/Characters/player.tscn")
signal player_died

#@onready var player_spawn = $PlayerSpawn
@onready var bullet_container = $Bullets
@onready var camera: = $Camera2D

var player = null


func _ready():
	if Player.lungs == true:
		$Enemies/OrganEnemy.queue_free()
	player = get_tree().get_first_node_in_group("Player")
	player.connect_camera(camera)
	player.shoot.connect(player_shoot)
	if SoundPlayer.hub_music.is_playing():
		pass
	else:
		SoundPlayer.play_hub()
	StageManager.emit_signal("level_loaded")

func player_shoot(bullet, location):
	var bullet_inst = bullet.instantiate()
	bullet_inst.global_position = location
	bullet_container.add_child(bullet_inst)

func _on_north_hall_body_entered(body):
	if body == player:
		StageManager.change_stage(StageManager.NorthHall, 236, 90)
