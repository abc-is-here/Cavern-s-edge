extends CanvasModulate

var NIGHT_COLOR = Color("#1e4d99")
var EVENING_COLOR = Color("#c39d7a")
var DAY_COLOR = Color("#fff")

func _process(delta: float) -> void:
	var time_dict = Time.get_time_dict_from_system()
	var current_hour = time_dict.hour
	var blend_factor = 0.0

	if current_hour >= 6 and current_hour < 18:  
		blend_factor = (current_hour - 6) / 12.0
		self.color = DAY_COLOR.lerp(EVENING_COLOR, blend_factor)
		
	elif current_hour >= 18 and current_hour < 24:
		blend_factor = (current_hour - 18) / 6.0
		self.color = EVENING_COLOR.lerp(NIGHT_COLOR, blend_factor)
		
	else:
		blend_factor = (current_hour / 6.0)
		self.color = NIGHT_COLOR.lerp(DAY_COLOR, blend_factor)
