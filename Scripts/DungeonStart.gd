extends Node2D

const PlayerScene = preload("res://Scenes/Characters/player.tscn")
signal player_died

#@onready var player_spawn = $PlayerSpawn
@onready var bullet_container = $Bullets
@onready var camera: = $Camera2D

var player = null


func _ready():
	if Player.heart == true:
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

func _on_crow_hub_door_body_entered(body):
	if body == player:
		StageManager.change_stage(StageManager.CrowHub, 75, 150)

func _on_west_wing_body_entered(body):
	if body == player:
		StageManager.change_stage(StageManager.WestWing, 332, 25)

func _on_east_wing_body_entered(body):
	if body == player:
		StageManager.change_stage(StageManager.EastWing, -154, 58)

func _on_north_wing_body_entered(body):
	if body == player && Player.north_wing == true:
		StageManager.change_stage(StageManager.NorthHall, 21, 10)
	else:
		SoundPlayer.play_door_locked()

func _on_escape_body_entered(body):
	if body == player && Player.heart == true && Player.lungs == true && Player.stomach == true:
		StageManager.change_stage(StageManager.CreationRoom, 27, 134)
	else:
		SoundPlayer.play_door_locked()
