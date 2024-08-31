class_name InfiniteCanvasGrid
extends Node2D

@export var _camera: Camera2D

var _pattern: int = 0:
    set(value):
        _pattern = value
        queue_redraw()

var _grid_size := 25:
    set(value):
        _grid_size = value
        queue_redraw()

var _grid_color: Color:
    set(value):
        _grid_color = value
        queue_redraw()


func _ready():
    _grid_size = 25
    _pattern = 1

    _camera.zoom_changed.connect(queue_redraw.unbind(1))
    _camera.position_changed.connect(queue_redraw.unbind(1))
    RenderingServer.set_default_clear_color(Color.hex(0x36f312ff))
    get_viewport().size_changed.connect(queue_redraw.unbind(1))


func enable(e: bool) -> void:
    set_process(e)
    visible = e


func _draw() -> void:
    var zoom := (Vector2.ONE / _camera.zoom).x
    var size = Vector2(get_viewport().size.x, get_viewport().size.y) * zoom
    var offset = _camera.offset
    var grid_size := int(ceil((_grid_size * pow(zoom, 0.75))))

    match _pattern:
        0:
            var dot_size := int(ceil(grid_size * 0.12))
            var x_start := int(offset.x / grid_size) - 1
            var x_end := int((size.x + offset.x) / grid_size) + 1
            var y_start := int(offset.y / grid_size) - 1
            var y_end = int((size.y + offset.y) / grid_size) + 1

            for x in range(x_start, x_end):
                for y in range(y_start, y_end):
                    var pos := Vector2(x, y) * grid_size
                    draw_rect(Rect2(pos.x, pos.y, dot_size, dot_size), _grid_color)
        1:
            # Vertical lines
            var start_index := int(offset.x / grid_size) - 1
            var end_index := int((size.x + offset.x) / grid_size) + 1
            for i in range(start_index, end_index):
                draw_line(Vector2(i * grid_size, offset.y + size.y), Vector2(i * grid_size, offset.y - size.y), _grid_color)

            # Horizontal lines
            start_index = int(offset.y / grid_size) - 1
            end_index = int((size.y + offset.y) / grid_size) + 1
            for i in range(start_index, end_index):
                draw_line(Vector2(offset.x + size.x, i * grid_size), Vector2(offset.x - size.x, i * grid_size), _grid_color)
