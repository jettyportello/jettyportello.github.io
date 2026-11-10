extends CharacterBody3D

@onready var nav = $NavigationAgent3D
@export var player : Node3D
@onready var tbb = $TBB
@onready var ray = $RayCast3D
@onready var chase = $Chase

var t
var et = 0
var ct = 0

var igotblackigotwhitewhatchuwant = true

var SPEED = 0.0
var SPRINTSPEED = 5.65
var ROAMSPEED = 3.63

var SEEING_RANGE = 12.5

func _physics_process(delta):

	if !player:
		return
	
	var c_loc = global_transform.origin
	
	var dir = ray.to_local(player.global_position).normalized()
	ray.target_position = dir * SEEING_RANGE
	ray.force_raycast_update()
	
	t = (ray.is_colliding() and ray.get_collider() == player)
	
	if t:
		et = 3
		ct = 6.5
		SPEED = SPRINTSPEED
		ROAMSPEED = 3.63
		igotblackigotwhitewhatchuwant = true
		if !chase.playing:
			chase.play()
	else:
		et -= delta
		ct -= delta
		if et <= 0:
			SPEED = ROAMSPEED
			igotblackigotwhitewhatchuwant = false
		if ct <= 0:
			if chase.playing:
				chase.stop()
	
	var n_loc = nav.get_next_path_position()
	var n_vol = (n_loc - c_loc).normalized() * SPEED

	velocity = velocity.move_toward(n_vol, 20 * delta)
	move_and_slide()

func _process(_delta):

		if !igotblackigotwhitewhatchuwant:
			tbb.modulate = Color.BLACK
		else:
			tbb.modulate = Color.WHITE

func update_target_location(tl):
	nav.set_target_position(tl)

func _on_navigation_agent_3d_target_reached() -> void:
	Globplayer.GameOver()
	if !Globplayer.SPANISH:
		Globplayer.CAUSE_OF_DEATH = "THE ANGEL"
	else:
		Globplayer.CAUSE_OF_DEATH = "LA ANGEL"
