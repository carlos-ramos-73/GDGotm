class_name _GotmBlobLocal


static func create(api: String, body: Dictionary) -> Dictionary:
	await _GotmUtility.get_tree().process_frame
	api = api.split("/")[0]
	var data = body.data
	if !(data is PackedByteArray):
		return {}

	var blob = {
		"path": _GotmUtility.create_resource_path(api),
		"author": _GotmAuthLocal.get_user(),
		"target": body.target,
		"size": data.size()
	}
	_GotmUtility.write_file(_Gotm.get_local_path(blob.path), data)
	return _format(_LocalStore.create(blob))


static func delete_sync(path: String) -> void:
	var blob := _LocalStore.fetch(path)
	if blob.is_empty():
		return
	_LocalStore.delete(path)
	_GotmUtility.write_file(_Gotm.get_local_path(blob.path), null)


static func fetch(path: String, _query: String = "", _params: Dictionary = {}, _authenticate: bool = false) -> Dictionary:
	await _GotmUtility.get_tree().process_frame
	var is_data := path.begins_with(_Gotm.get_global().storageApiEndpoint)
	if is_data:
		path = path.replace(_Gotm.get_global().storageApiEndpoint + "/", "")
	
	var blob := _LocalStore.fetch(path)
	if blob.is_empty():
		return {}

	if is_data:
		return _GotmUtility.read_file(_Gotm.get_local_path(blob.path), true)

	return _format(blob)


static func _format(data: Dictionary) -> Dictionary:
	if data.is_empty():
		return {}
	data = _GotmUtility.copy(data, {})
	return data
