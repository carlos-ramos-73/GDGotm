class_name _GotmBlob

enum Implementation { GOTM_STORE, GOTM_BLOB_LOCAL }


# TODO: Validate changes from 3.X, old code didnt make sense to me since "data" is type Dictionary from fetch functions, but cannot be used in 'bytes_to_var_with_objects'
static func get_data(id: String, type: String = "bytes"):

	if type.is_empty():
		return null

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
			return bytes_to_var_with_objects(binary_data).instantiate()
		"variant":
			return bytes_to_var_with_objects(binary_data)
		_:
			return binary_data


static func get_implementation(id = null) -> Implementation:
	if !_LocalStore.fetch(id).is_empty() || !_Gotm.has_global_api():
		return Implementation.GOTM_BLOB_LOCAL
	return Implementation.GOTM_STORE
