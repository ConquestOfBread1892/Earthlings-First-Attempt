 #Claude Made
# pushable_object.gd
class_name PushableObject extends CharacterBody2D

@export var properties: PushableProperties
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Movement state
enum MovementState { IDLE, BEING_PUSHED, MOVING }
var current_state: MovementState = MovementState.IDLE
var push_direction: Vector2 = Vector2.ZERO
var push_timer: float = 0.0
var target_position: Vector2
var start_position: Vector2
var move_progress: float = 0.0
var pusher_entity = null

func _ready():
	if not properties:
		properties = PushableProperties.new()
		push_warning("No properties assigned to pushable object, using defaults")

func _physics_process(delta):
	match current_state:
		MovementState.IDLE:
			# Check for pushers and reset timer if none found
			if pusher_entity == null:
				push_timer = 0.0
				
		MovementState.BEING_PUSHED:
			# Accumulate push time
			push_timer += delta
			
			# Start movement when threshold reached
			if push_timer >= properties.push_threshold:
				start_movement()
				
		MovementState.MOVING:
			# Update movement progress
			move_progress += (properties.push_speed * delta) / properties.move_distance
			if move_progress >= 1.0:
				# Movement complete
				position = target_position
				move_progress = 0.0
				current_state = MovementState.IDLE
			else:
				# Interpolate position
				position = start_position.lerp(target_position, move_progress)
				
			# Handle collisions during movement
			var collision = move_and_collide(Vector2.ZERO, true)
			if collision and collision.get_collider() != pusher_entity:
				# Stop if we hit something other than the pusher
				position = start_position
				current_state = MovementState.IDLE
				move_progress = 0.0

func start_movement():
	# Snap direction to nearest cardinal direction (straight lines only)
	if abs(push_direction.x) > abs(push_direction.y):
		#sign returns 1 for positive numbers, -1 for negative numbers, and 0 for the number 0.
		#in this case it allows us to only get the direction without the magnitude
		push_direction = Vector2(sign(push_direction.x), 0)
	else:
		push_direction = Vector2(0, sign(push_direction.y))
	
	start_position = position
	target_position = position + push_direction * properties.move_distance
	move_progress = 0.0
	current_state = MovementState.MOVING
	
	## Play push sound if available
	#if properties.push_sound:
		#var audio_player = AudioStreamPlayer2D.new()
		#add_child(audio_player)
		#audio_player.stream = properties.push_sound
		#audio_player.play()
		#await audio_player.finished
		#audio_player.queue_free()

func _on_push_area_body_entered(body: Node2D) -> void:
	# Check if this body is allowed to push
	var can_push = false
	#only detect bodies who could push")
	if body is BasePlayer || body is BaseActiveFriend:
		if "push" in body.capabilities:
			can_push = true
		
		if not can_push:
			return
			
		# Determine push direction based on relative positions
		var direction_to_pusher = (body.global_position - global_position).normalized()
		
		# Only allow pushing when entity is on a side, not top/bottom
		if current_state == MovementState.IDLE:
			pusher_entity = body
			push_direction = -direction_to_pusher  # Push away from pusher
			current_state = MovementState.BEING_PUSHED
			push_timer = 0.0

func _on_push_area_body_exited(body: Node2D) -> void:
	if body == pusher_entity:
		pusher_entity = null
		if current_state == MovementState.BEING_PUSHED:
			current_state = MovementState.IDLE
