class_name InfiniteCanvas
extends SubViewportContainer

@onready var _camera: Camera2D = $SubViewport/Camera2D


func _ready() -> void:
    pass


func _on_gui_input(event: InputEvent) -> void:
    if !get_tree().root.get_viewport().is_input_handled():
        _camera.tool_event(event)
