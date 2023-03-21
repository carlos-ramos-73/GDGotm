class_name _GotmBlob

enum Implementation { GOTM_STORE, GOTM_BLOB_LOCAL }


static func _coerce_id(resource_or_id) -> String:
	return _GotmUtility.coerce_resource_id(resource_or_id, "blobs")


static func fetch(blob_or_id) -> GotmBlob:
	if !(blob_or_id is GotmBlob || blob_or_id is String):
		await _GotmUtility.get_tree().process_frame
		push_error("Expected a GotmBlob or GotmBlob.id string.")
		return null

	var id := _coerce_id(blob_or_id)
	var data: Dictionary
	if get_implementation(id) == Implementation.GOTM_BLOB_LOCAL:
		data = await _GotmBlobLocal.fetch(id)
	else:
		data = await _GotmStore.fetch(id)
	return _format(data, GotmBlob.new())


static func _format(data: Dictionary, blob: GotmBlob) -> GotmBlob:
	if data.is_empty() || !blob:
		return
	blob.id = data.path
	blob.size = int(data.size)
	blob.is_local = !_LocalStore.fetch(data.path).is_empty()
	return blob


# TODO: Validate changes from 3.X, old code didnt make sense to me since "data" is type Dictionary from fetch functions, but cannot be used in 'bytes_to_var_with_objects'
static func get_data(blob_or_id, type: String = "bytes"):
	if !(blob_or_id is GotmBlob || blob_or_id is String):
		await _GotmUtility.get_tree().process_frame
		push_error("Expected a GotmBlob or GotmBlob.id string.")
		return null

	if type.is_empty():
		return null

	var id := _coerce_id(blob_or_id)
	if id.is_empty():
		await _GotmUtility.get_tree().process_frame
		return null
	var binary_data: PackedByteArray
	if get_implementation(id) == Implementation.GOTM_BLOB_LOCAL:
		binary_data = await _GotmBlobLocal.fetch_blob(id)
	else:
		binary_data = await _GotmStore.fetch_blob(_Gotm.get_global().storageApiEndpoint + "/" + id)
	if binary_data.is_empty() || type.is_empty():
		return null

	match type:
		"node":
			return bytes_to_var_with_objects(binary_data).instance()
		"variant":
			return bytes_to_var_with_objects(binary_data)
		_:
			return binary_data


static func get_implementation(id = null) -> Implementation:
	if !_LocalStore.fetch(id).is_empty() || !_Gotm.has_global_api():
		return Implementation.GOTM_BLOB_LOCAL
	return Implementation.GOTM_STORE
