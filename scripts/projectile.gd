extends Area2D

class_name Projectile

var target: Enemy = null
var damage: int = 10
var speed: float = 400.0
var lifetime: float = 5.0

@onready var sprite = $Sprite2D

func _ready():
	area_entered.connect(_on_area_entered)
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta):
	if target == null or !target.is_alive():
		queue_free()
		return
	
	var direction = (target.global_position - global_position).normalized()
	global_position += direction * speed * delta
	
	# Face target
	rotation = direction.angle()

func _on_area_entered(area):
	if area == target:
		target.take_damage(damage)
		queue_free()
