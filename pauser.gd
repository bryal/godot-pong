extends Label

var game_is_paused = false
onready var separator = get_node("../separator")

func _ready():
	pause("start")

func _process(dt):
    if Input.is_action_just_pressed("toggle_pause"):
        toggle_pause()

func pause(start_word = "unpause"):
    self.game_is_paused = true
    self.text = "Press SPACE to %s" % [start_word]
    separator.visible = false
    get_tree().paused = true

func unpause():
    game_is_paused = false
    self.text = ""
    separator.visible = true
    get_tree().paused = false

func toggle_pause():
    if game_is_paused:
        unpause()
    else:
        pause()
