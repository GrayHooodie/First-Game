extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	
	var direction := Input.get_axis("move_left", "move_right")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if not direction:
			if Input.is_action_pressed("flatten"):
				animated_sprite.play("loaf")
				_on_animated_sprite_2d_animation_finished()
			else:
				animated_sprite.play("idle_stnd")
		elif Input.is_action_pressed("run"):
			animated_sprite.play("run")
		else:
			animated_sprite.play("walk")

	# Handle jump.d
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animated_sprite.play("jump")
		_on_animated_sprite_2d_animation_finished()
		
	# if moving
	if direction:
		# move in the direction you're going, at your character's speed
		velocity.x = direction * SPEED
		# flip horizontal (left) if direction == -1
		animated_sprite.flip_h = direction < 0
	# not moving
	else:
		# slow down from moving?? probably
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_animated_sprite_2d_animation_finished() -> void:
	pass
