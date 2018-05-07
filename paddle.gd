extends Area2D

const MOVE_SPEED = 200

func _process(delta):
    var which = get_name()
    
    # move up and down based on input
    if Input.is_action_pressed(which+"_move_up") and position.y > 0:
        position.y -= MOVE_SPEED * delta
    if Input.is_action_pressed(which+"_move_down") and position.y < get_viewport_rect().size.y:
        position.y += MOVE_SPEED * delta
        
