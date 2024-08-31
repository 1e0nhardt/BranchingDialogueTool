@tool
extends Node2D

var _node_data: Dictionary = {}
var _default_node_data: Dictionary = {}
var _text_buffer: TextLine = TextLine.new()


func _ready() -> void:
    update_node_data()


#region custom properties
func update_node_data() -> void:
    _node_data["title_color"] = Color(0x674636ff)
    _node_data["title_size"] = Vector2(80, 20)
    _node_data["panel_color"] = Color(0xaab396ff)
    _node_data["panel_size"] = Vector2(80, 100)
    _default_node_data = _node_data.duplicate()


func _get_property_list() -> Array[Dictionary]:
    var property_list: Array[Dictionary] = []
    for p_name: String in _node_data:
        if p_name.ends_with("color"):
            property_list.append({
                name = p_name,
                type = TYPE_COLOR,
                hint = PROPERTY_HINT_COLOR_NO_ALPHA,
            })
        elif p_name.ends_with("size"):
            property_list.append({
                name = p_name,
                type = TYPE_VECTOR2,
            })
    return property_list


func _get(property: StringName):
    if property in _node_data:
        return _node_data[property]


func _set(property: StringName, value: Variant) -> bool:
    if property in _node_data:
        _node_data[property] = value
        queue_redraw()
        return true

    return false


func _property_can_revert(property: StringName) -> bool:
    if property in _default_node_data:
        return true
    return false


func _property_get_revert(property: StringName):
    if property in _default_node_data:
        return _default_node_data[property]
#endregion


func _draw() -> void:
    var title_rect := Rect2(global_position, get("title_size"))
    var panel_rect := Rect2(
        global_position + Vector2(0, get("title_size").y),
        get("panel_size")
    )

    draw_rect(title_rect, get("title_color"))
    #draw_rect(panel_rect, get("panel_color"))
    _text_buffer.add_string("hello node", SystemFont.new(), 18)
    _text_buffer.draw(get_canvas_item(), position, Color.GHOST_WHITE)

    draw_style_box(StyleBoxFlat.new(), panel_rect)
