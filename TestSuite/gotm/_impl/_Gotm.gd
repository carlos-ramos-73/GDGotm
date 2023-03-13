class_name _Gotm


const _version = "0.0.1" # TODO: Need to change? Is it useless?


static func get_config() -> GotmConfig:
	return get_global().config


static func get_global() -> _GotmGlobalData:
	var _global = _GotmUtility.get_static_variable(_Gotm, "_global", null)
	if !_global:
		_global = _GotmGlobalData.new()
		_GotmUtility.set_static_variable(_GotmUtility, "_global", _global)
	return _global


static func get_local_path(path: String = "") -> String:
	return get_path("local/" + path)


static func get_path(path: String = "") -> String:
	return "user://gotm/" + path


static func get_project_key() -> String:
	return get_global().config.project_key


static func get_singleton():
	if !Engine.has_singleton("Gotm"):
		return
	return Engine.get_singleton("Gotm")


static func has_global_api() -> bool:
	return is_global_api("scores") || is_global_api("contents") || is_global_api("marks")


static func initialize(config: GotmConfig) -> void:
	var global := get_global()
	global.config = _GotmUtility.copy(config, GotmConfig.new())
	var directory = DirAccess.open("res://")
	directory.make_dir_recursive(get_local_path(""))


static func is_global_api(api: String) -> bool:
	var config := get_config()
	match api:
		"scores":
			return is_global_feature(config.force_local_scores, config.beta_unsafe_force_global_scores)
		"contents":
			return is_global_feature(config.force_local_contents, config.beta_unsafe_force_global_contents)
		"marks":
			return is_global_feature(config.force_local_marks, config.beta_unsafe_force_global_marks)
		_:
			return false


static func is_global_feature(forceLocal: bool = false, forceGlobal: bool = false) -> bool:
	return !forceLocal && (is_live() || forceGlobal) && !get_project_key().is_empty()


static func is_live() -> bool:
	return !!get_singleton()


class _GotmGlobalData:
	var config: GotmConfig
	var version: String = "0.0.1" # TODO: Need to change? Is it useless?
	var apiOrigin: String = "https://api.gotm.io"
	var apiWorkerOrigin: String = "https://gotm-api-worker-eubrk3zsia-uk.a.run.app"
	var storageApiEndpoint: String = "https://storage.googleapis.com/gotm-api-production-d13f0.appspot.com"
