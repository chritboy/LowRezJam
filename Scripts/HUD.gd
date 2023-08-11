extends CanvasLayer

@onready var hearts_container = $HeartsContainer
@onready var ammo_label = $AmmoAmount
@onready var potion_label = $PotionAmount

var player = null

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	hearts_container.set_max_hearts(Player.max_health)
	hearts_container.update_hearts(Player.current_health)
	player.health_change.connect(hearts_container.update_hearts)
	Events.player_died.connect(self.on_player_died)
	
func _physics_process(_delta):
	ammo_label.text = str(Player.ammo)
	potion_label.text = str(Player.potions)

func on_player_died():
	if Player.checkpoint == 1:
		StageManager.change_stage(StageManager.MainHall, 32, 170)
		get_tree().reload_current_scene()
		player = get_tree().get_first_node_in_group("Player")
		Player.current_health = Player.max_health
		hearts_container.update_hearts(Player.current_health)
		Player.ammo = 6
		Player.potions = 1
		


#	var player_inst = PlayerScene.instantiate()
#	player_inst.global_position = $PlayerSpawn.global_position
#	add_child(player_inst)
#	player_inst.connect_camera(camera)
#	player_died.emit()
