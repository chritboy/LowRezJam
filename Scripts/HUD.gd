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
		StageManager.change_stage(StageManager.DungeonStart, 32, 190)
		get_tree().reload_current_scene()
		player = get_tree().get_first_node_in_group("Player")
		Player.current_health = Player.max_health
		hearts_container.update_hearts(Player.current_health)
		Player.ammo = 6
		Player.potions = 1
		
	elif Player.checkpoint == 2:
		StageManager.change_stage(StageManager.Room5, 21, 30)
		get_tree().reload_current_scene()
		player = get_tree().get_first_node_in_group("Player")
		Player.current_health = Player.max_health
		hearts_container.update_hearts(Player.current_health)
		Player.ammo = Player.saved_ammo
		Player.potions = Player.saved_potions
		
	elif Player.checkpoint == 3:
		StageManager.change_stage(StageManager.Room2, 37, 57)
		get_tree().reload_current_scene()
		player = get_tree().get_first_node_in_group("Player")
		Player.current_health = Player.max_health
		hearts_container.update_hearts(Player.current_health)
		Player.ammo = Player.saved_ammo
		Player.potions = Player.saved_potions

	elif Player.checkpoint == 4:
		StageManager.change_stage(StageManager.DungeonStart, 32, 190)
		get_tree().reload_current_scene()
		player = get_tree().get_first_node_in_group("Player")
		Player.current_health = Player.max_health
		hearts_container.update_hearts(Player.current_health)
		Player.ammo = Player.saved_ammo
		Player.potions = Player.saved_potions
