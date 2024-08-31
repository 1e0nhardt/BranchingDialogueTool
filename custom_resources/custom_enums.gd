class_name CustomEnums
extends Object

const enums := {
    ARROW_SIDE = ["TOP", "RIGHT", "BOTTOM", "LEFT"]
}


static func get_enum_hint_string(name: String) -> String:
    return ",".join(enums[name.to_upper()])
