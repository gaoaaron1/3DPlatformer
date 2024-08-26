extends Node

var touch_ui_scene : PackedScene = preload("res://Scenes/touchscreen.tscn")
var touch_ui_instance : Node = null

func _ready():
	# Determine the platform and touch capability
	var platform_name = OS.get_name()
	var touch_capable = OS.has_feature("touch")
	
	print("Platform detected: ", platform_name)
	print("Touch capability detected: ", touch_capable)
	
	if touch_capable:
		print("Touch feature detected. Showing touch UI.")
		_show_touch_ui()
	else:
		print("Touch feature not detected. Hiding touch UI.")
		_hide_touch_ui()

func _show_touch_ui():
	if touch_ui_instance == null:
		touch_ui_instance = touch_ui_scene.instantiate()
		get_tree().root.add_child(touch_ui_instance)
		touch_ui_instance.z_index = 1000  # Ensure it's above other elements
		print("Touch UI shown.")

func _hide_touch_ui():
	if touch_ui_instance:
		print("Hiding touch UI.")
		touch_ui_instance.queue_free()
		touch_ui_instance = null
