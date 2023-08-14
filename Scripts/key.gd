extends Sprite2D

var player = null

func _ready():
	if Player.checkpoint == 2:
		queue_free()
	player = get_tree().get_first_node_in_group("Player")
	
func _on_area_2d_body_entered(_body):
	Player.checkpoint = 2
	$AnimationPlayer.play("Pickup")
	SoundPlayer.play_item_grab()
	Player.has_small_key = true
	Player.saved_potions = Player.potions
	Player.saved_ammo = Player.ammo
	Player.saved_health = Player.current_health
	vanish()

func vanish():
	await $AnimationPlayer.animation_finished
	queue_free()
	
