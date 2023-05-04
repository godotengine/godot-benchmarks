extends Benchmark

const ITERATIONS = 1_000_000

# Benchmark various ways to modify strings.

func benchmark_begins_with() -> void:
	for i in ITERATIONS:
		"Godot Engine".begins_with("Godot")  # true


func benchmark_ends_with() -> void:
	for i in ITERATIONS:
		"Godot Engine".ends_with("Engine")  # true


func benchmark_count() -> void:
	for i in ITERATIONS:
		"Godot Engine".count("o")  # 2


func benchmark_countn() -> void:
	for i in ITERATIONS:
		"Godot Engine".countn("o")  # 2


func benchmark_contains() -> void:
	for i in ITERATIONS:
		"Godot Engine".contains("o")  # true


func benchmark_contains_gdscript_in() -> void:
	for i in ITERATIONS:
		"o" in "Godot Engine"  # true


func benchmark_find() -> void:
	for i in ITERATIONS:
		"Godot Engine".find("o")  # 1


func benchmark_findn() -> void:
	for i in ITERATIONS:
		"Godot Engine".findn("o")  # 1


func benchmark_rfind() -> void:
	for i in ITERATIONS:
		"Godot Engine".rfind("o")  # 3


func benchmark_rfindn() -> void:
	for i in ITERATIONS:
		"Godot Engine".rfindn("o")  # 3


func benchmark_substr() -> void:
	for i in ITERATIONS:
		"Hello Godot!".substr(6, 5)  # "Godot"


func benchmark_insert() -> void:
	for i in ITERATIONS:
		"Hello !".insert(6, "Godot")  # "Hello Godot!"


func benchmark_get_slice() -> void:
	for i in ITERATIONS:
		"1234,5678,90.12".get_slice(",", 1)  # "5678"


func benchmark_get_slice_count() -> void:
	for i in ITERATIONS:
		"1234,5678,90.12".get_slice_count(",")  # 3


func benchmark_bigrams() -> void:
	for i in ITERATIONS:
		"Godot Engine".bigrams()  # ["Go", "od", "do", "ot", "t ", " E", "En", "ng", "gi", "in", "ne"]


func benchmark_split() -> void:
	for i in ITERATIONS:
		"1234,5678,90.12".split(",")  #  ["1234", "5678", "90.12"]


func benchmark_rsplit() -> void:
	for i in ITERATIONS:
		"1234,5678,90.12".rsplit(",")  #  ["1234", "5678", "90.12"]


func benchmark_split_floats() -> void:
	for i in ITERATIONS:
		"1234,5678,90.12".split_floats(",")  #  [1234.0, 5678.0, 90.12]


func benchmark_pad_zeros_pre_constructed() -> void:
	for i in ITERATIONS:
		"12345".pad_zeros(7)  # "0012345"


func benchmark_pad_zeros() -> void:
	for i in ITERATIONS:
		str(12345).pad_zeros(7)  # "0012345"


func benchmark_pad_decimals_pre_constructed() -> void:
	for i in ITERATIONS:
		"1234.5678".pad_decimals(2)  # "1234.56"


func benchmark_pad_decimals() -> void:
	for i in ITERATIONS:
		str(1234.5678).pad_decimals(2)  # "1234.56"


func benchmark_lpad() -> void:
	for i in ITERATIONS:
		"Godot".lpad(7, "+")  # "++Godot"


func benchmark_rpad() -> void:
	for i in ITERATIONS:
		"Godot".rpad(7, "+")  # "Godot++"


func benchmark_similarity() -> void:
	for i in ITERATIONS:
		"Godot".similarity("Engine")


func benchmark_simplify_path() -> void:
	for i in ITERATIONS:
		"./path/to///../file".simplify_path()  # "path/file"


func benchmark_capitalize() -> void:
	for i in ITERATIONS:
		"godot_engine_demo".capitalize()  # "Godot Engine Demo"


func benchmark_to_snake_case() -> void:
	for i in ITERATIONS:
		"GodotEngineDemo".to_snake_case()  # "godot_engine_demo"


func benchmark_to_camel_case() -> void:
	for i in ITERATIONS:
		"godot_engine_demo".to_snake_case()  # "godotEngineDemo"


func benchmark_to_pascal_case() -> void:
	for i in ITERATIONS:
		"godot_engine_demo".to_pascal_case()  # "GodotEngineDemo"


func benchmark_to_lower() -> void:
	for i in ITERATIONS:
		"Godot Engine Demo".to_lower()  # "godot engine demo"


func benchmark_uri_decode() -> void:
	for i in ITERATIONS:
		"Godot%20Engine%3Adocs".uri_decode()  # "Godot Engine:docs"


func benchmark_uri_encode() -> void:
	for i in ITERATIONS:
		"Godot Engine:docs".uri_encode()  # "Godot%20Engine%3Adocs"


func benchmark_xml_escape() -> void:
	for i in ITERATIONS:
		"Godot Engine <&>".xml_escape()  # "Godot Engine &lt;&amp;&gt;"


func benchmark_xml_unescape() -> void:
	for i in ITERATIONS:
		"Godot Engine &lt;&amp;&gt;".xml_unescape()  # "Godot Engine <&>"


func benchmark_humanize_size() -> void:
	for i in ITERATIONS:
		String.humanize_size(123456)  # 120.5 KB


func benchmark_is_valid_filename() -> void:
	for i in ITERATIONS:
		"Godot Engine: Demo.exe".is_valid_filename()  # false


func benchmark_validate_filename() -> void:
	for i in ITERATIONS:
		"Godot Engine: Demo.exe".validate_filename()  # "Godot Engine_ Demo.exe"


func benchmark_validate_node_name() -> void:
	for i in ITERATIONS:
		"TestNode:123456".validate_node_name()  # "TestNode123456"


func benchmark_casecmp_to() -> void:
	for i in ITERATIONS:
		"2 Example".casecmp_to("10 Example")  # 1


func benchmark_nocasecmp_to() -> void:
	for i in ITERATIONS:
		"2 Example".nocasecmp_to("10 Example")  # 1


func benchmark_naturalnocasecmp_to() -> void:
	for i in ITERATIONS:
		"2 Example".naturalnocasecmp_to("10 Example")  # -1


func benchmark_to_utf8_buffer() -> void:
	for i in ITERATIONS:
		"Godot Engine".to_utf8_buffer()


func benchmark_to_utf16_buffer() -> void:
	for i in ITERATIONS:
		"Godot Engine".to_utf16_buffer()


func benchmark_to_utf32_buffer() -> void:
	for i in ITERATIONS:
		"Godot Engine".to_utf32_buffer()


func benchmark_to_wchar_buffer() -> void:
	for i in ITERATIONS:
		"Godot Engine".to_wchar_buffer()
