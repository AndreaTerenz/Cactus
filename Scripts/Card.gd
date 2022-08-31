class_name Card
extends Control

enum MODE {
	FLIPPED,
	UNKNOWN,
	SHOWN
}

### Automatic References Start ###
onready var _label: Label = $Label
### Automatic References Stop ###

export(int, 0, 9, 1) var value = 0
export(MODE) var mode = MODE.SHOWN

func _ready() -> void:
	match mode:
		MODE.FLIPPED:
			_label.text = ""
		MODE.UNKNOWN:
			_label.text = "?"
		MODE.SHOWN:
			_label.text = str(value)
