extends Node2D

const PlayerScene = preload("res://Scenes/Characters/player.tscn")
signal player_died

#@onready var player_spawn = $PlayerSpawn
@onready var bullet_container = $Bullets
@onready var camera: = $Camera2D
@onready var dunk = preload("res://dialogue_4.tscn")

var player = null


func _ready():
	if Player.made_egg == true:
		$ChurchLights.queue_free()
		$CemetaryLight.queue_free()
		$ShoreLights.visible = true
	else:
		$ShoreLights.visible = false
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

func _on_dungeon_entrance_body_entered(body):
	if body == player:
		StageManager.change_stage(StageManager.DungeonStart, 32, 189)

func _on_creation_room_body_entered(body):
	if body == player:
		StageManager.change_stage(StageManager.CreationRoom, 26, 134)

func _on_shore_body_entered(_body):
	if Player.heart == true && Player.lungs == true && Player.stomach == true:
		var dunk_dialogue = dunk.instantiate()
		add_child(dunk_dialogue)
	else:
		pass
