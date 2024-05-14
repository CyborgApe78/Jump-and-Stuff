extends HSlider
class_name AudioSliderBase


@export_range(0, 1, 0.01) var defaultValue: float = 0.8
@export_enum("Master", "UI", "Music", "Player", "Enemy", "Ambient") var busName: String

var busIndex: int

func _ready() -> void:
	#TODO: add preload of userpref to set levels
	AudioServer.set_bus_volume_db(busIndex,defaultValue)
	value = defaultValue
	busIndex = AudioServer.get_bus_index(busName)
	value_changed.connect(_on_value_changed)


func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		busIndex,
		linear_to_db(value)
	)
