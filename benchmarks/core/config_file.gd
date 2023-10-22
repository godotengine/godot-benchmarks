extends Benchmark

const NUM_VALUES := 1000
const ITERATIONS := 50
const CONFIG_FILE := "user://benchmark_config_file.ini"
const CONFIG_FILE_ENCRYPTED := "user://benchmark_config_file.ini.encrypted"
var config: ConfigFile = ConfigFile.new()

func _init() -> void:
	create_config_file()
	config.save(CONFIG_FILE)
	config.save_encrypted_pass(CONFIG_FILE_ENCRYPTED, "PasswordIsGodot")

func create_config_file() -> void:
	for i in 1000:
		config.set_value("Sec" + str(i % 10), "Key" + str(i), "Val" + str(i))

func benchmark_save() -> void:
	for i in ITERATIONS:
		config.save(CONFIG_FILE)

func benchmark_load() -> void:
	for i in ITERATIONS:
		config.load(CONFIG_FILE)

func benchmark_save_with_password() -> void:
	for i in ITERATIONS:
		config.save_encrypted_pass(CONFIG_FILE_ENCRYPTED, "PasswordIsGodot")

func benchmark_load_with_password() -> void:
	for i in ITERATIONS:
		config.load_encrypted_pass(CONFIG_FILE_ENCRYPTED, "PasswordIsGodot")

