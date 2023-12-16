extends CharacterBody2D

@export var GRAVITY: float = 200.0
@export var jump_force: float = 10.0
@export var walk_velocity: float = 200.0
@export var mass: float = 30
@export var spawn: Marker2D
@export var accumulative_jump_seconds: float = 1
@export var should_reset_light: bool = true

var _key: Node2D
var _direction: int = 0
var _jumping: bool = false
var _initial_jump_force: float = 0;
var _dead: bool = false
var _stop: bool = false
var _has_the_key: bool = false
var _on_blue_switch: bool = false
var _on_red_switch: bool = false
var _jump_acc: float = 0
var _jump_sfx: AudioStreamPlayer
var _land_sfx: AudioStreamPlayer
var _key_pickup_sfx: AudioStreamPlayer

var _footstep_sfx = []
var _footstep_acc = 0

func _ready():
	_initial_jump_force = jump_force
	position = spawn.position
	_jump_sfx = $Jump
	_land_sfx = $Land
	_key_pickup_sfx = $KeyPick
	_footstep_sfx.append($FootstepsSFX/FS1)
	_footstep_sfx.append($FootstepsSFX/FS2)
	_footstep_sfx.append($FootstepsSFX/FS3)

func _process(delta):
	if _stop:
		return

	if _dead:
		if $AnimatedSprite2D.animation != "dead":
			$AnimatedSprite2D.play("dead")
		return
	
	if Input.is_action_just_pressed("interact"):
		if (
			(_on_blue_switch and LightSwitchController._actual) or
			(_on_red_switch and !LightSwitchController._actual)
		   ):
			LightSwitchController.switch()
			if $ClickSound != null:
				$ClickSound.play()
	
	if Input.is_action_just_pressed("jump") and !_jumping:
		_jumping = true
		if _jump_sfx != null:
			_jump_sfx.play()

	if Input.is_action_pressed("left"):
		_direction = -1
		$AnimatedSprite2D.flip_h = true
		
		if !_jumping:
			_play_footstep_sfx(delta)
	elif Input.is_action_pressed("right"):
		_direction = 1
		$AnimatedSprite2D.flip_h = false
		
		if !_jumping:
			_play_footstep_sfx(delta)
	else:
		_direction = 0
		_footstep_acc = 1
	
	if _jumping and !Input.is_action_pressed("jump") and jump_force > 0:
		jump_force = 0

	if !_jumping:
		if _direction != 0:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")
	elif _jumping and $AnimatedSprite2D.animation != "jump":
		$AnimatedSprite2D.play("jump")

func _physics_process(delta):
	if _dead:
		return

	velocity.y += GRAVITY - (int(_jumping) * jump_force)
	velocity.x = walk_velocity * _direction

	if _jumping:
		jump_force -= mass

	if jump_force < 0:
		jump_force = 0

	move_and_slide()

# Foot
func _on_area_2d_body_entered(body):
	if _dead:
		return
		
	if _jumping:
		if _land_sfx != null:
			_land_sfx.play()

	_jumping = false
	jump_force = _initial_jump_force
	$AnimatedSprite2D.play("idle")

	if body.is_in_group("trap") and !_dead:
		_dead = true
		_direction = 0
		velocity = Vector2.ZERO

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "dead":
		$RespawnTimer.start()

func _on_respawn_timer_timeout():
	position = spawn.position
	_dead = false
	
	if _has_the_key:
		_has_the_key = false
		_key.show()
	
	if should_reset_light:
		LightSwitchController.reset()

func _on_pick_area_entered(area: Area2D):
	if area.is_in_group("key"):
		_has_the_key = true
		_key = area.get_parent()
		_key.hide()
		
		if _key_pickup_sfx != null:
			_key_pickup_sfx.play()

		if area.is_in_group("light_switch_blue"):
			LightSwitchController.blue()
		elif area.is_in_group("light_switch_red"):
			LightSwitchController.red()

func _on_blue_switch_area_entered(area):
	_on_blue_switch = true

func _on_blue_switch_area_exited(area):
	_on_blue_switch = false

func _on_area_2d_area_entered(area):
	if _has_the_key:
		_stop = true
		_direction = 0
		get_node('/root/main/Map/Door/DoorSprite').play("default")
		$AnimatedSprite2D.play("idle")
		$AnimatedSprite2D.stop()

		var next_scene = get_node("/root/main/NextSceneTimer")
		if next_scene != null:
			next_scene.start()

func _on_red_switch_area_entered(area):
	_on_red_switch = true

func _on_red_switch_area_exited(area):
	_on_red_switch = false

func _on_body_body_entered(body):
	if body.is_in_group("trap") and !_dead:
		_dead = true
		_direction = 0
		velocity = Vector2.ZERO
		_jumping = false

func _play_footstep_sfx(delta: float):
	var r = randi() % 3
	
	if _footstep_acc < 0.3:
		_footstep_acc += delta

	if _footstep_sfx[r] != null and _footstep_acc > 0.16666:
		_footstep_sfx[r].play()
		_footstep_acc = 0
