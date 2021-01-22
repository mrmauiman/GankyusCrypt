extends MarginContainer

export(Resource) var KeyIcon
export(Resource) var BoomerangIcon
export(Resource) var BossKey
export(Resource) var BossKey1
export(Resource) var BossKey2

var boss_key_count = 0

onready var KeyContainer = get_node("HBoxContainer/HBoxContainer/Keys")
onready var CurrentItem = get_node("HBoxContainer/HBoxContainer/ItemFrame/CurrentItem")
onready var BossKeyContainer = get_node("HBoxContainer/HBoxContainer/BossKey")
onready var HealthBar = get_node("HBoxContainer/HealthContainer/Health")

const min_health_val = 16
const max_health_val = 97

func GetBoomerang():
	CurrentItem.texture = BoomerangIcon

func GetBossKey1():
	boss_key_count += 1
	if boss_key_count == 2:
		GetBossKey()
	else:
		BossKeyContainer.texture = BossKey1

func GetBossKey2():
	boss_key_count += 1
	if boss_key_count == 2:
		GetBossKey()
	else:
		BossKeyContainer.texture = BossKey2

func GetBossKey():
	BossKeyContainer.texture = BossKey

func UseKey():
	if KeyContainer.get_child_count() > 0:
		KeyContainer.get_child(0).queue_free()

func GetKey():
	var key = TextureRect.new()
	key.texture = KeyIcon
	KeyContainer.add_child(key)

func SetHealth(percentage):
	var amount = (percentage * (max_health_val - min_health_val)) + min_health_val
	if HealthBar == null:
		HealthBar = get_node("HBoxContainer/HealthContainer/Health")
	HealthBar.value = amount
