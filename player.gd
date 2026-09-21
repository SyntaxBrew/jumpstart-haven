extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = -400.0
const COYOTE_TIME = 0.1

var coyote_timer = COYOTE_TIME
var is_falling_anim_playing = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		coyote_timer += delta
		if coyote_timer > COYOTE_TIME:
			velocity += get_gravity() * delta
		$AnimatedSprite2D.play("jump")
		
	if is_on_floor():
		coyote_timer = 0
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or coyote_timer <= COYOTE_TIME):
		
		if Input.is_key_pressed(KEY_UP):
			velocity.y = JUMP_VELOCITY * 1.5
			$Jump.pitch_scale = 1.5
			$Jump.play(0.12)
		else:
			velocity.y = JUMP_VELOCITY
			$Jump.pitch_scale = 1
			$Jump.play(0.12)
			
		coyote_timer = COYOTE_TIME

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		if Input.is_key_pressed(KEY_UP):
			velocity.x *= 0.25
		if is_on_floor():
			$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = false if direction > 0 else true
	else:
		if is_on_floor():
			$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
