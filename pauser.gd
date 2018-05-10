extends Container

var game_is_paused = true
var separator
onready var start_text = get_node("start_text")
onready var unpause_text = get_node("unpause_text")
onready var keys_left = get_node("keys_left")
onready var keys_right = get_node("keys_right")

func _ready():
    separator = get_node("../../separator")
    get_tree().paused = true

func _process(dt):
    if Input.is_action_just_pressed("toggle_pause"):
        toggle_pause()

func pause():
    self.game_is_paused = true
    unpause_text.visible = true
    keys_left.visible = true
    keys_right.visible = true
    separator.visible = false
    get_tree().paused = true

func unpause():
    game_is_paused = false
    start_text.visible = false
    unpause_text.visible = false
    keys_left.visible = false
    keys_right.visible = false
    separator.visible = true
    get_tree().paused = false

func toggle_pause():
    if game_is_paused:
        unpause()
    else:
        pause()
