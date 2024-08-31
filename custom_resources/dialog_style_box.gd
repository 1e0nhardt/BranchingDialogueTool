@tool
class_name DialogueStyleBox
extends CustomStyleBox


func _init() -> void:
    super._init()
    add_custom_properties({
        "Bubble/border_width_int": 4,
        "Bubble/corner_radius_int": [12, 0, 99, 1],
        "Bubble/corner_detail_int": [8, 1, 20, 1],
        "Bubble/arrow_side_enum": 1,
        "Bubble/arrow_width_int": 40,
        "Bubble/arrow_height_int": 60,
        "Bubble/border_color": Color.GOLDENROD,
        "Bubble/bg_color": Color.KHAKI,
    })


## 注意：Godot的y轴朝下
func _get_corner_round_points(radius: float, count: int = 8) -> PackedVector2Array:
    var delta := 0.5*PI/count
    var points := PackedVector2Array()
    for i in range(count, 0, -1):
        points.append(Vector2(radius * cos(delta * i + PI), radius * sin(delta * i + PI)))
    return points


## border包含在rect内
func _draw(to_canvas_item: RID, rect: Rect2) -> void:
    var border_width = get("Bubble/border_width")
    var corner_radius = get("Bubble/corner_radius")
    var corner_detail = get("Bubble/corner_detail")
    var arrow_side = get("Bubble/arrow_side")
    var arrow_width = get("Bubble/arrow_width")
    var arrow_height = get("Bubble/arrow_height")
    var border_color = get("Bubble/border_color")
    var bg_color = get("Bubble/bg_color")

    var shrinked_rect = rect.grow(-border_width/2.0)
    var points := PackedVector2Array()
    points.append(Vector2.ZERO)
    points.append(Vector2(shrinked_rect.size.x, 0))
    points.append(Vector2(shrinked_rect.size.x, shrinked_rect.size.y))
    points.append(Vector2(0, shrinked_rect.size.y))

    # generate corner point
    var corner_points = _get_corner_round_points(corner_radius, corner_detail)

    # bevel
    for i in range(3, -1, -1):
        var prev = points[i-1]
        var curr = points[i]
        var next = points[(i+1)%points.size()]
        var v_prev = (prev - curr).normalized() * corner_radius
        var v_next = (next - curr).normalized() * corner_radius
        points[i] = curr + v_prev

        var transform := Transform2D().rotated(0.5*PI*i).translated(curr + v_prev + v_next)
        var rps: PackedVector2Array = transform * corner_points
        for pi in rps.size():
            points.insert(i+1, rps[pi])

    var center_point = shrinked_rect.get_center()
    var start_index = corner_detail * (arrow_side + 1) + arrow_side
    var end_index = (start_index + 1) % points.size()
    var start_point = points[start_index]
    var end_point = points[end_index]
    var mid_point = (start_point + end_point) / 2
    var p1 = mid_point + (start_point - mid_point).normalized() * 0.5 * arrow_width
    var p2 = mid_point + (mid_point - center_point).normalized() * arrow_height
    var p3 = mid_point + (end_point - mid_point).normalized() * 0.5 * arrow_width

    points.insert(start_index + 1, p3)
    points.insert(start_index + 1, p2)
    points.insert(start_index + 1, p1)

    points.append(points[0])

    points = Transform2D().translated_local(Vector2.ONE * border_width / 2.0) * points

    RenderingServer.canvas_item_add_polygon(to_canvas_item, points, PackedColorArray([bg_color]))
    RenderingServer.canvas_item_add_polyline(to_canvas_item, points, PackedColorArray([border_color]), border_width, true)
