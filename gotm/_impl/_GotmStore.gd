# MIT License
#
# Copyright (c) 2020-2022 Macaroni Studios AB
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

class_name _GotmStore
#warnings-disable

static func create(api: String, data: Dictionary) -> Dictionary:
	var created = yield(_request(api, HTTPClient.METHOD_POST, data, true), "completed")
	if created:
		_cache[created.path] = created
	return created

static func update(path: String, data: Dictionary) -> Dictionary:
	var updated = yield(_request(path, HTTPClient.METHOD_PATCH, data, true), "completed")
	if updated:
		_cache[path] = updated
	return updated

static func delete(path: String) -> void:
	yield(_request(path, HTTPClient.METHOD_DELETE, null, true), "completed")
	_cache.erase(path)
	
static func fetch(path: String, query: String = "", params: Dictionary = {}, authenticate: bool = false) -> Dictionary:
	return yield(_cached_get_request(create_request_path(path, query, params), authenticate), "completed")

static func list(api: String, query: String, params: Dictionary = {}, authenticate: bool = false) -> Array:
	var data = yield(_cached_get_request(create_request_path(api, query, params), authenticate), "completed")
	if not data or not data.data:
		return
	return data.data

const _cache = {}
const _signal_cache = {}

static func create_request_path(path: String, query: String, params: Dictionary) -> String:
	if query:
		var query_object := {}
		_GotmUtility.copy(params, query_object)
		query_object.query = query
		path += _GotmUtility.create_query_string(query_object)
	return path

static func _set_cache(path: String, data):
	if not data:
		_cache.erase(path)
		return
	for key in ["created", "updated"]:
		if key in data:
			data[key] = _GotmUtility.get_unix_time_from_iso(data[key])
	_cache[path] = data
	return data

static func _cached_get_request(path: String, authenticate: bool = false) -> Dictionary:
	if path in _cache:
		yield(_GotmUtility.get_tree(), "idle_frame")
		return _cache[path]
	
	if path in _signal_cache:
		yield(_signal_cache[path].add(), "completed")
		return _cache[path]
	
	
	var queue_signal = _GotmUtility.QueueSignal.new()
	_signal_cache[path] = queue_signal
	var value = yield(_request(path, HTTPClient.METHOD_GET, null, authenticate), "completed")
	if value:
		value = _set_cache(path, value)
		
	_signal_cache.erase(path)
	queue_signal.trigger()
	return value

static func _request(path: String, method: int, body = null, authenticate: bool = false) -> Dictionary:
	var headers = PoolStringArray()
	if authenticate:
		var token = _GotmAuth.get_token()
		if not token:
			token = yield(_GotmAuth.get_token_async(), "completed")
		if not token:
			return
		headers.push_back("authorization: Bearer " + token)
		
	var result = yield(_GotmUtility.fetch_json(_Gotm.get_global().apiOrigin + "/" + path, method, body), "completed")
	if not result.ok:
		return
	return result.data