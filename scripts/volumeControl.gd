extends HSlider

@export var busName: String
var busIndex: int

func _ready():
	AudioServer.set_bus_volume_db(busIndex, linear_to_db(value) - 30)
	busIndex = AudioServer.get_bus_index(busName)
	value_changed.connect(volumeChanged)

func volumeChanged(value: float):
	AudioServer.set_bus_volume_db(busIndex, linear_to_db(value) - 30)
