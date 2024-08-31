@tool
class_name CustomStyleBox
extends StyleBox

var _custom_data: Dictionary = {}
var _default_custom_data: Dictionary = {}


# 添加自定义属性
func _init() -> void:
    pass


#region custom properties
# 用于添加自定义属性
# property_dict的键为属性名，值为属性默认值。属性的类型信息由属性名决定。
# xx_color -> Color
# xx_size -> Vector2
# xx_eunm -> int 枚举类型。需要在custom_enums脚本中定义好相应的枚举类型。
# xx_float -> float
# xx_int -> int
# xx_float, xx_int的值可以为单个默认值。或者一个数组，数组的第一个元素为默认值，后续为min,max,step,spcial_words，详见PROPERTY_HINT_RANGE的说明。
func add_custom_properties(property_dict: Dictionary, overwrite: bool = false) -> void:
    for p_name in property_dict:
        if _custom_data.has(p_name):
            if overwrite:
                print("%s already defined! The new value %s will be default value." % [p_name, property_dict[p_name]])
            else:
                print("%s already defined! Will use original default value %s." % [p_name, _custom_data[p_name]])

    _custom_data.merge(property_dict, overwrite)
    _default_custom_data = _custom_data.duplicate(true)


func _get_property_list() -> Array[Dictionary]:
    var property_list: Array[Dictionary] = []
    for p_name: String in _custom_data:
        var property_info_dict := {}

        if p_name.ends_with("color"):
            property_info_dict = {
                name = p_name,
                type = TYPE_COLOR,
                hint = PROPERTY_HINT_COLOR_NO_ALPHA,
            }
        elif p_name.ends_with("size"):
            property_info_dict = {
                name = p_name,
                type = TYPE_VECTOR2,
            }
        elif p_name.ends_with("_enum"):
            var r_name = p_name.replace("_enum", "")
            property_info_dict = {
                name = r_name,
                type = TYPE_INT,
                hint = PROPERTY_HINT_ENUM,
                hint_string = CustomEnums.get_enum_hint_string(r_name.get_slice("/", 1))
            }
        elif p_name.ends_with("_int"):
            var r_name = p_name.replace("_int", "")
            property_info_dict["name"] = r_name
            property_info_dict["type"] = TYPE_INT
            if _custom_data[p_name] is Array:
                property_info_dict["hint"] = PROPERTY_HINT_RANGE
                property_info_dict["hint_string"] = ",".join(_custom_data[p_name].slice(1))
        elif p_name.ends_with("_float"):
            var r_name = p_name.replace("_float", "")
            property_info_dict["name"] = r_name
            property_info_dict["type"] = TYPE_FLOAT
            if _custom_data[p_name] is Array:
                property_info_dict["hint"] = PROPERTY_HINT_RANGE
                property_info_dict["hint_string"] = ",".join(_custom_data[p_name].slice(1))

        property_list.append(property_info_dict)
    return property_list


func _get_possible_names(raw_name: String) -> Array[String]:
    return [raw_name, raw_name + "_enum", raw_name + "_int", raw_name + "_float"]


func _get(property: StringName):
    for p_name in _get_possible_names(property):
        if p_name in _custom_data:
            if _custom_data[p_name] is Array:
                return _custom_data[p_name][0]
            else:
                return _custom_data[p_name]


func _set(property: StringName, value: Variant) -> bool:
    for p_name in _get_possible_names(property):
        if p_name in _custom_data:
            if _custom_data[p_name] is Array:
                _custom_data[p_name][0] = value
            else:
                _custom_data[p_name] = value
            print("Set")
            print(_custom_data[p_name])
            print(_default_custom_data[p_name])
            print("Set End")
            emit_changed()
            return true

    return false


func _property_can_revert(property: StringName) -> bool:
    for p_name in _get_possible_names(property):
        if p_name in _default_custom_data:
            return true
    return false


func _property_get_revert(property: StringName):
    for p_name in _get_possible_names(property):
        if p_name in _default_custom_data:
            if _default_custom_data[p_name] is Array:
                return _default_custom_data[p_name][0]
            else:
                return _default_custom_data[p_name]
#endregion


# 自定义绘制style_box
@warning_ignore("unused_parameter")
func _draw(to_canvas_item: RID, rect: Rect2) -> void:
    pass
