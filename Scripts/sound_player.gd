extends Node

@onready var hub_music = $HubMusic
@onready var player_shoot = $PlayerShoot
@onready var player_sword = $PlayerSword
@onready var enemy_hurt = $EnemyHurt
@onready var player_hurt = $PlayerHurt
@onready var player_heal = $PlayerHeal
@onready var player_death = $PlayerDeath
@onready var enemy_explosion = $EnemyExplosion


func play_hub():
	hub_music.play()

func play_shoot():
	player_shoot.play()

func play_sword():
	player_sword.play()

func play_enemy_hurt():
	enemy_hurt.play()

func play_player_hurt():
	player_hurt.play()

func play_player_heal():
	player_heal.play()

func play_player_death():
	player_death.play()
	
func play_enemy_explosion():
	enemy_explosion.play()


func stop_music():
	hub_music.stop()
