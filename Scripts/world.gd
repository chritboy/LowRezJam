extends Node2D

@onready var player_spawn = $PlayerSpawn
@onready var bullet_container = $Bullets
@onready var hearts_container = $HUD/HeartsContainer
@onready var ammo_label = $HUD/AmmoAmount
@onready var potion_label = $HUD/PotionAmount

var player = null


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	hearts_container.set_max_hearts(player.max_health)
	hearts_container.update_hearts(player.current_health)
	player.health_change.connect(hearts_container.update_hearts)
	assert(player != null)
	player.global_position = player_spawn.global_position
	player.shoot.connect(player_shoot)
	
func _physics_process(_delta):
	ammo_label.text = str(player.ammo)
	potion_label.text = str(player.potions)

func player_shoot(bullet, location):
	var bullet_inst = bullet.instantiate()
	bullet_inst.global_position = location
	bullet_container.add_child(bullet_inst)
