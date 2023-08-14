extends Sprite2D

@onready var Ammo = preload("res://Scenes/Interactables/ammo.tscn")
@onready var Potion = preload("res://Scenes/Interactables/potion.tscn")
var drops = null

var chance = null


func _ready():
	drops = get_tree().get_first_node_in_group("Drops")
	chance = randi_range(0, 10)
	
func _on_area_2d_area_entered(area):
	if chance > 0 && chance < 2:
		call_deferred("spawn_potion")
		queue_free()
	elif chance >= 2 && chance < 5:
		call_deferred("spawn_ammo")
		queue_free()
	else:
		queue_free()

func spawn_potion():
	var potion_inst = Potion.instantiate()
	potion_inst.global_position = global_position
	drops.add_child(potion_inst)

func spawn_ammo():
	var ammo_inst = Ammo.instantiate()
	ammo_inst.global_position = global_position
	drops.add_child(ammo_inst)

