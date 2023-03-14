class_name _GotmStore


const _EVICTION_TIMEOUT_SECONDS = 5


static func _cached_get_request(path: String, authenticate: bool = false) -> Dictionary:
	if path.is_empty():
		await _GotmUtility.get_tree().process_frame
		return {}

	var _cache: Dictionary = _GotmUtility.get_static_variable(_GotmStore, "_cache", {})
	if path in _cache:
		var value = _cache[path]
		await _GotmUtility.get_tree().process_frame
		return value

	var _signal_cache: Dictionary = _GotmUtility.get_static_variable(_GotmStore, "_signal_cache", {})
	if path in _signal_cache:
		await _GotmUtility.get_tree().process_frame
		return _cache[path]

	var queue_signal = _GotmUtility.QueueSignal.new()
	_signal_cache[path] = queue_signal
	var value := await _request(path, HTTPClient.METHOD_GET, null, authenticate)
	if !value.is_empty():
		value = _set_cache(path, value)
		if value is Dictionary && value.get("data") is Array && value.get("next") is String:
			for resource in value.data:
				_set_cache(resource.path, resource)

	_signal_cache.erase(path)
	queue_signal.trigger()
	return value


static func clear_cache(path: String) -> void:
	var _cache: Dictionary = _GotmUtility.get_static_variable(_GotmStore, "_cache", {})
	for key in _cache.keys():
		if key == path || key.begins_with(path):
			_cache.erase(key)


static func create(api, data: Dictionary, _options: Dictionary = {}) -> Dictionary:
	var created := await _request(create_request_path(api, "", {}, {}), HTTPClient.METHOD_POST, data, true)
	if !created.is_empty():
		_set_cache(created.path, created)
	return created


static func create_request_path(path: String, query: String = "", params: Dictionary = {}, options: Dictionary = {}) -> String:
	var query_object := {}
	if query:
		query_object.query = query
		_GotmUtility.copy(params, query_object)
	if options.get("expand"):
		var expands = options.get("expand").keys()
		expands.sort()
		query_object.expand = expands.join(",")
	return path + _GotmUtility.create_query_string(query_object)


static func delete(path) -> void:
	await _request(path, HTTPClient.METHOD_DELETE, null, true)
	var _cache: Dictionary = _GotmUtility.get_static_variable(_GotmStore, "_cache", {})
	_cache.erase(path)


static func fetch(path, query: String = "", params: Dictionary = {}, authenticate: bool = false, options: Dictionary = {}) -> Dictionary:
	return await _cached_get_request(create_request_path(path, query, params, options), authenticate)


static func list(api, query: String, params: Dictionary = {}, authenticate: bool = false, options: Dictionary = {}) -> Array:
	var data := await _cached_get_request(create_request_path(api, query, params, options), authenticate)
	if data.is_empty() || !data.has(data):
		return []
	return data.data


static func _request(path, method: int, body = null, authenticate: bool = false) -> Dictionary:
	if !path:
		await _GotmUtility.get_tree().process_frame
		return {}
	var headers := {}
	if authenticate:
		var auth = _GotmAuth.get_auth()
		if !auth:
			auth = await _GotmAuth.get_auth_async()
		if !auth:
			return {}
		headers.authorization = "Bearer " + auth.token

	if method != HTTPClient.METHOD_GET && method != HTTPClient.METHOD_HEAD && method != HTTPClient.METHOD_POST:
		match method:
			HTTPClient.METHOD_DELETE:
				headers.method = "DELETE"
			HTTPClient.METHOD_PATCH:
				headers.method = "PATCH"
			HTTPClient.METHOD_PUT:
				headers.method = "PUT"
		method = HTTPClient.METHOD_POST
	if !headers.is_empty():
		var header_string := ""
		for key in headers:
			header_string += key + ":" + headers[key] + "\n"
		var path_parts = path.split("?")
		if path_parts.size() < 2:
			path += "?"
		elif path_parts.size() > 2 || path_parts[1].length() > 0:
			path += "&"
		path += "$httpHeaders=" + _GotmUtility.encode_url_component(header_string)

	while !_take_rate_limiting_token():
		await _GotmUtility.get_tree().process_frame

	var result
	if path.begins_with(_Gotm.get_global().storageApiEndpoint):
		result = await _GotmUtility.fetch_data(path, method, body)
	elif path.begins_with("blobs/upload") && body.get("data") is PackedByteArray:
		body = body.duplicate()
		var data = body.data
		body.erase("data")
		var bytes = PackedByteArray()
		bytes += (JSON.stringify(body)).to_utf8_buffer()
		bytes.append(0)
		bytes += data
		result = await _GotmUtility.fetch_json(_Gotm.get_global().apiWorkerOrigin + "/" + path, method, bytes)
	else:
		result = await _GotmUtility.fetch_json(_Gotm.get_global().apiOrigin + "/" + path, method, body)
	if !result.ok:
		return {}
	return result.data


static func _set_cache(path: String, data):
	var _eviction_timers: Dictionary = _GotmUtility.get_static_variable(_GotmStore, "_eviction_timers", {})
	var existing_timer = _eviction_timers.get(path)
	_eviction_timers.erase(path)

	var eviction_timer_on_timeout = func(path: String) -> void:
		var _cache: Dictionary = _GotmUtility.get_static_variable(_GotmStore, "_cache", {})
		_cache.erase(path)

	if existing_timer is SceneTreeTimer:
		if (existing_timer as SceneTreeTimer).timeout.is_connected(Callable(eviction_timer_on_timeout)):
			(existing_timer as SceneTreeTimer).timeout.disconnect(Callable(eviction_timer_on_timeout))

	var _cache: Dictionary = _GotmUtility.get_static_variable(_GotmStore, "_cache", {})
	if !data:
		_cache.erase(path)
		return
	if data is Dictionary:
		for key in ["created", "updated", "expired"]:
			if key in data:
				data[key] = _GotmUtility.get_unix_time_from_iso(data[key])
	_cache[path] = data
	var timer := _GotmUtility.get_tree().create_timer(_EVICTION_TIMEOUT_SECONDS)
	timer.timeout.connect(Callable(eviction_timer_on_timeout).bind(path))
	_eviction_timers[path] = timer
	return data


static func _take_rate_limiting_token() -> bool:
	var _token_bucket: Dictionary = _GotmUtility.get_static_variable(_GotmStore, "_token_bucket", {})
	if !_token_bucket.has("count"):
		_token_bucket.capacity = 60
		_token_bucket.count = _token_bucket.capacity
		_token_bucket.fill_per_second = 2
		@warning_ignore("integer_division")
		_token_bucket.tick_seconds = Time.get_ticks_msec() / 1000

	@warning_ignore("integer_division")
	var tick_seconds = Time.get_ticks_msec() / 1000
	var fill = _token_bucket.fill_per_second * (tick_seconds - _token_bucket.tick_seconds)
	_token_bucket.count = min(_token_bucket.count + fill, _token_bucket.capacity)
	_token_bucket.tick_seconds = tick_seconds

	if _token_bucket.count <= 0:
		return false

	_token_bucket.count -= 1
	return true


static func update(path, data: Dictionary, options: Dictionary = {}) -> Dictionary:
	var updated := await _request(create_request_path(path, "", {}, options), HTTPClient.METHOD_PATCH, data, true)
	if !updated.is_empty():
		_set_cache(path, updated)
	return updated
