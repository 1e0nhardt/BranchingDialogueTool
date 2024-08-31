@tool
extends Control

@onready var panel: Panel = $Panel
var panel_style_box


func _ready() -> void:
    panel_style_box = panel.get_theme_stylebox("panel")
    panel_style_box.changed.connect(_redraw_style_box)


func _redraw_style_box() -> void:
    var parent_rid = panel.get_canvas_item()
    var local_rect = Rect2(Vector2.ZERO, panel.get_rect().size)
    RenderingServer.canvas_item_clear(parent_rid)
    panel_style_box.draw(parent_rid, local_rect)
