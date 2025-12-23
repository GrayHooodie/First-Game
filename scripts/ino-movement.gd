extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.d
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if animated_sprite.is_on_floor():
		if direction == 0:
			if Input.is_action_pressed("flatten"):
				animated_sprite.play("loaf")
				_on_animation_finished("loaf")
			else:
				animated_sprite.play("idle_stnd")
		elif Input.is_action_pressed("run"):
			animated_sprite.play("run")
		else:
			animated_sprite.play("walk")
	else:
		animated_sprite.play("jump")
		animated_sprite.queue("air")
		
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


func _on_animation_finished(animation: String) -> void:
	animated_sprite.play(animation + "ing")
