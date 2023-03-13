class_name _GotmAuthLocal


static func get_auth():
	return _get_cache()


static func get_auth_async():
	await _GotmUtility.get_tree().process_frame
	return get_auth()


static func _get_cache() -> _GotmAuthLocalCache:
	var _cache: _GotmAuthLocalCache = _GotmUtility.get_static_variable(_GotmAuthLocal, "_cache", _GotmAuthLocalCache.new())

	if _cache.token:
		return _cache

	var file_path := _Gotm.get_local_path("auth.json")
	var content = _GotmUtility.read_file(file_path)
	if content:
		_GotmUtility.copy(JSON.parse_string(content), _cache)
		# TODO is code below useless now that there is a _GotmAuthLocalCache class?
		if !_cache.get("owner") && _cache.get("user"):
			_cache.owner = _cache.user
			_cache.erase("user")
			_GotmUtility.write_file(file_path, JSON.stringify(_cache))
	else:
		_cache.token = _GotmUtility.create_id()
		_cache.project = _GotmUtility.create_resource_path("games")
		_cache.owner = _GotmUtility.create_resource_path("users")
		_GotmUtility.write_file(file_path, JSON.stringify(_cache))
	_cache.is_guest = true
	return _cache


static func get_user() -> String:
	return _get_cache().owner


class _GotmAuthLocalCache:
	var owner: String
	var project: String
	var token: String
	var is_guest: bool
