extends KinematicBody2D

# Import Nodes

const DOWN_BURST = preload("res://Objects/Weapons/DownBurst.tscn")

# Physics Constants

const GRAVITY = 20
const ACCELERATION = 20
const RUN_SPEED = 150
const JUMP_HEIGHT = -500
const LOW_JUMP_HEIGHT = -150
const FALL_SPEED = 800
const DASH_SPEED = 900

# Physics Values

var gravity = GRAVITY
var acceleration = ACCELERATION
var run_speed = RUN_SPEED
var jump_height = JUMP_HEIGHT
var low_jump_height = LOW_JUMP_HEIGHT
var fall_speed = FALL_SPEED

var ability_1 = 0
var ability_2 = 0
var passive_1 = 0
var passive_2 = 0
var ability_able = true

# DOUBLE JUMPS

var max_double_jumps = 1
var double_jumps = 1
const DOUBLE_JUMP_MODIFIER = 1.5

# Dashing

var dashing = false
var used_dash = false
var dash_time = 0

# Health, Mana, and Invincibility Frames

var max_hp = 20
var hp = max_hp
var max_mana = 20
var mana = max_mana
var mana_regen = 30
var max_i_frames = 60
var i_frames = 0
var flicker = false

# Other

var leaving = false
var no_death = false

# Ability Nodes

onready var ability_1_icon = get_node("../HUD/Abilities/Ability1")
onready var ability_2_icon = get_node("../HUD/Abilities/Ability2")
onready var passive_1_icon = get_node("../HUD/Abilities/Passive1")
onready var passive_2_icon = get_node("../HUD/Abilities/Passive2")

# Motion Values

const FLOOR = Vector2(0, -1)
var motion = Vector2()

# Death

func die():
	if !leaving:
		if !no_death:
			if !get_parent().temple:
				get_parent().save_data()
				get_tree().change_scene("res://GameOver.tscn")
			else:
				leaving = true
				get_node("../Base").leave()
		else:
			get_tree().reload_current_scene()

# Reload Icons

func reload_icons():
	Engine.time_scale = 1
	
	gravity = GRAVITY
	acceleration = ACCELERATION
	run_speed = RUN_SPEED
	jump_height = JUMP_HEIGHT
	low_jump_height = LOW_JUMP_HEIGHT
	fall_speed = FALL_SPEED
	
	if ability_1 == 0:
		ability_1_icon.play("None")
	if ability_2 == 0:
		ability_2_icon.play("None")
	
	if ability_1 == 1:
		ability_1_icon.play("Dash")
	if ability_2 == 1:
		ability_2_icon.play("Dash")
	
	if ability_1 == 2:
		ability_1_icon.play("DownBurst")
	if ability_2 == 2:
		ability_2_icon.play("DownBurst")
	
	
	if passive_1 == 0:
		passive_1_icon.play("None")
	if passive_2 == 0:
		passive_2_icon.play("None")
	
	if passive_1 == 1:
		passive_1_icon.play("Light")
		gravity /= 2
	if passive_2 == 1:
		passive_2_icon.play("Light")
		if passive_1 != 1:
			gravity /= 2
	
	if passive_1 == 2:
		passive_1_icon.play("Fast")
		Engine.time_scale = 1.5
	if passive_2 == 2:
		passive_2_icon.play("Fast")
		if passive_1 != 2:
			Engine.time_scale = 1.5

# Ability Functions

func ability_able():
	# Abilities
	
	if Input.is_action_pressed("ability_1"):
		ability1a()
	if Input.is_action_just_pressed("ability_1"):
		ability1b()
	if Input.is_action_just_released("ability_1"):
		ability1c()
	if Input.is_action_pressed("ability_2"):
		ability2a()
	if Input.is_action_just_pressed("ability_2"):
		ability2b()
	if Input.is_action_just_released("ability_2"):
		ability2c()

func ability1a():
	if ability_1 == 2 and mana >= 1 and !is_on_floor():
		down_burst()

func ability1b():
	if ability_1 == 1 and !used_dash and !dashing and mana >= 5:
		dash()

func ability1c():
	pass

func ability2a():
	if ability_2 == 2 and mana >= 1 and !is_on_floor():
		down_burst()

func ability2b():
	if ability_2 == 1 and !used_dash and !dashing and mana >= 5:
		dash()

func ability2c():
	pass

# Abilities

func dash():
	dashing = true
	used_dash = true
	dash_time = 9
	
	mana -= 5
	mana_regen = 30

func down_burst():
	var DOWN_BURST_SPEED = -10
	
	var down_burst = DOWN_BURST.instance()
	get_parent().add_child(down_burst)
	down_burst.global_position.x = global_position.x
	down_burst.global_position.y = global_position.y + 10
	
	if motion.y > DOWN_BURST_SPEED:
		motion.y = DOWN_BURST_SPEED
	
	mana -= .1
	mana_regen = 30

func motion():
	# Walking
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + acceleration, run_speed)
		$AnimatedSprite.flip_h = false
		if is_on_floor():
			$AnimatedSprite.play("running")
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - acceleration, -run_speed)
		$AnimatedSprite.flip_h = true
		if is_on_floor():
			$AnimatedSprite.play("running")
	else:
		motion.x = lerp(motion.x, 0, .2)
		if is_on_floor():
			$AnimatedSprite.play("idle")
	
	# On Floor or Not
	
	if is_on_floor():
		
		# Reset Double Jumps
		
		if double_jumps != max_double_jumps:
			double_jumps = max_double_jumps
		
		# Reset Dash
		
		if used_dash:
			used_dash = false
		
		# Jump
		
		if Input.is_action_just_pressed("ui_up"):
			motion.y = jump_height
	else:
		
		# Gravity, Animation, and Airtime Physics
		
		motion.y = min(motion.y + (gravity * Engine.time_scale), fall_speed)
		if !Input.is_action_pressed("ui_up"):
			motion.y = max(motion.y, low_jump_height)
		if motion.y < 0:
			$AnimatedSprite.play("jumping")
		else:
			$AnimatedSprite.play("falling")
		
		# Double Jumping
		
		if Input.is_action_just_pressed("ui_up") and double_jumps > 0:
			double_jumps -= 1
			motion.y = jump_height/DOUBLE_JUMP_MODIFIER

func _physics_process(delta):
	
	if !dashing:
		motion()
	
	# Invincibility Frames
	
	if i_frames > 0:
		i_frames -= Engine.time_scale
		if !flicker:
			flicker = true
			$AnimatedSprite.hide()
		else:
			flicker = false
			$AnimatedSprite.show()
	elif flicker:
		flicker = false
		$AnimatedSprite.show()
	
	# HP and Mana
	
	if hp <= 0:
		get_tree().reload_current_scene()
	if hp > max_hp:
		hp = max_hp
	if mana > max_mana:
		mana = max_mana
	elif mana < max_mana:
		mana_regen -= Engine.time_scale
		if mana_regen <= 0:
			mana_regen = 1
			var mana_regen_value = float(max_mana)
			mana_regen_value /= 500
			mana += mana_regen_value
	
	# HP and Mana Display
	
	get_node("../HUD/HP_Box").margin_right = hp * 3
	get_node("../HUD/MANA_Box").margin_right = mana * 3
	
	get_node("../HUD/HP_Text").text = "HP: " + str(int(hp)) + "/" + str(max_hp)
	get_node("../HUD/MANA_Text").text = "MANA: " + str(int(mana)) + "/" + str(max_mana)
	
	# Abilities
	
	if ability_able:
		ability_able()
	else:
		ability_able = true
	
	# Dashing
	
	if dashing:
		if !$AnimatedSprite.flip_h:
			motion.x = DASH_SPEED
		else:
			motion.x = -DASH_SPEED
		motion.y = 0
		dash_time -= Engine.time_scale
		
		if dash_time <= 0 or is_on_wall():
			dashing = false
			dash_time = 0
			motion.x = 0
	
	# Motion Calculation
	
	motion = move_and_slide(motion, FLOOR)

# Tests Visibile on Camera

func _on_VisibilityNotifier2D_screen_exited():
	die()
