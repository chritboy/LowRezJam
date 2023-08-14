extends Node2D

const PlayerScene = preload("res://Scenes/Characters/player.tscn")
signal player_died

#@onready var player_spawn = $PlayerSpawn
@onready var bullet_container = $Bullets
@onready var camera: = $Camera2D
@onready var hud = $HUD


var player = null

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Player.intro_over == true:
		$IntroDialogue.queue_free()
	player = get_tree().get_first_node_in_group("Player")
	player.connect_camera(camera)
	player.shoot.connect(player_shoot)
	if SoundPlayer.hub_music.is_playing():
		SoundPlayer.hub_music.stop()
	StageManager.emit_signal("level_loaded")

func _physics_process(_delta):
	pass

func player_shoot(bullet, location):
	var bullet_inst = bullet.instantiate()
	bullet_inst.global_position = location
	bullet_container.add_child(bullet_inst)

func _on_crow_hub_body_entered(body):
	if body == player:
		StageManager.change_stage(StageManager.CrowHub, -73, 47)
