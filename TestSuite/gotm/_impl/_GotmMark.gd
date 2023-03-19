class_name _GotmMark

enum AuthImplementation { GOTM_AUTH, GOTM_AUTH_LOCAL }
enum Implementation { GOTM_STORE, GOTM_MARK_LOCAL }

const ALLOWED_TYPES = ["downvote", "upvote"]
const ALLOWED_TARGET_APIS = {"contents": "GotmContent"}


static func _clear_cache() -> void:
	if get_implementation() == Implementation.GOTM_MARK_LOCAL:
		_GotmMarkLocal.clear_cache("marks")
		_GotmMarkLocal.clear_cache("stats")
	else:
		_GotmStore.clear_cache("marks")
		_GotmStore.clear_cache("stats")


static func _coerce_id(resource_or_id) -> String:
	return _GotmUtility.coerce_resource_id(resource_or_id, "marks")


static func create(target_or_id, type: String, is_local: bool = false) -> GotmMark:
	if !(target_or_id is String || ALLOWED_TARGET_APIS.values().has(target_or_id.get("_CLASS_NAME"))):
		await _GotmUtility.get_tree().process_frame
		push_error("Expected a GotmContent or GotmContent.id string.")
		return null

	var target_id: String = _GotmUtility.coerce_resource_id(target_or_id)
	if !_is_mark_allowed(target_id, type):
		await _GotmUtility.get_tree().process_frame
		push_error("Invalid mark target '" + _GotmUtility.to_stable_json(target_id) + "' or mark type '" + _GotmUtility.to_stable_json(type) + "'.")
		return null

	var data: Dictionary
	if is_local || get_implementation(target_id) == Implementation.GOTM_MARK_LOCAL || !((await _GotmAuth.fetch()).is_registered):
		data = await _GotmMarkLocal.create("marks", {"target": target_id, "name": type})
	else:
		data = await _GotmStore.create("marks", {"target": target_id, "name": type})
	if data:
		_clear_cache()
	return _format(data, GotmMark.new())


static func delete(mark_or_id) -> void:
	if !(mark_or_id is GotmMark || mark_or_id is String):
		await _GotmUtility.get_tree().process_frame
		push_error("Expected a GotmMark or GotmMark.id string.")
		return

	var id := _coerce_id(mark_or_id)
	if get_implementation(id) == Implementation.GOTM_MARK_LOCAL:
		await _GotmMarkLocal.delete(id)
	else:
		await _GotmStore.delete(id)
	_clear_cache()


static func fetch(mark_or_id) -> GotmMark:
	if !(mark_or_id is GotmMark || mark_or_id is String):
		await _GotmUtility.get_tree().process_frame
		push_error("Expected a GotmMark or GotmMark.id string.")
		return null

	var id = _coerce_id(mark_or_id)
	var data: Dictionary
	if get_implementation(id) == Implementation.GOTM_MARK_LOCAL:
		data = await _GotmMarkLocal.fetch(id)
	else:
		data = await _GotmStore.fetch(id)
	return _format(data, GotmMark.new())


static func _format(data: Dictionary, mark: GotmMark) -> GotmMark:
	if data.is_empty() || !mark:
		return
	mark.id = data.path
	mark.user_id = data.owner
	mark.target_id = data.target
	mark.type = data.name
	mark.created = data.created
	mark.is_local = !_LocalStore.fetch(data.path).is_empty()
	return mark


static func get_auth_implementation() -> AuthImplementation:
	if get_implementation() == Implementation.GOTM_MARK_LOCAL:
		return AuthImplementation.GOTM_AUTH_LOCAL
	return AuthImplementation.GOTM_AUTH


static func get_count(target_or_id, type: String) -> int:
	if !(target_or_id is String || ALLOWED_TARGET_APIS.values().has(target_or_id.get("_CLASS_NAME"))):
		await _GotmUtility.get_tree().process_frame
		push_error("Expected a GotmContent or GotmContent.id string.")
		return 0

	var target_id: String = _GotmUtility.coerce_resource_id(target_or_id)
	if target_id.is_empty() || type.is_empty() || !_is_mark_allowed(target_id, type):
		await _GotmUtility.get_tree().process_frame
		return 0

	var params = {
		"target": target_id,
		"name": "marks/" + type,
	}
	var stat: Dictionary
	var implementation: Implementation = get_implementation(target_id)
	if implementation == Implementation.GOTM_MARK_LOCAL:
		stat = await _GotmMarkLocal.fetch("stats/sum", "received", params)
	else:
		stat = await _GotmStore.fetch("stats/sum", "received", params)
	var local_stat := await _GotmMarkLocal.fetch("stats/sum", "received", params) if implementation != Implementation.GOTM_MARK_LOCAL else {}
	var value: int = 0
	if !stat.is_empty():
		value += stat.value
	if !local_stat.is_empty():
		value += local_stat.value
	return value


static func get_implementation(id: String = "") -> Implementation:
	if !_Gotm.is_global_api("marks") || !_LocalStore.fetch(id).is_empty():
		return Implementation.GOTM_MARK_LOCAL
	return Implementation.GOTM_STORE


static func _is_mark_allowed(target_id: String, type: String) -> bool:
	if target_id.is_empty() || type.is_empty() || !ALLOWED_TYPES.has(type):
		return false
	return ALLOWED_TARGET_APIS.has(target_id.split("/")[0])


static func list_by_target(target_or_id, type: String) -> Array:
	if !(target_or_id is String || ALLOWED_TARGET_APIS.values().has(target_or_id.get("_CLASS_NAME"))):
		await _GotmUtility.get_tree().process_frame
		push_error("Expected a GotmContent or GotmContent.id string.")
		return []

	var auth
	if get_auth_implementation() == AuthImplementation.GOTM_AUTH_LOCAL:
		auth = await _GotmAuthLocal.get_auth_async()
	else:
		auth = await _GotmAuth.get_auth_async()
	var target_id = _GotmUtility.coerce_resource_id(target_or_id)
	if !auth || !target_id || (!type.is_empty() && !_is_mark_allowed(target_id, type)):
		return []
	
	var params = _GotmUtility.delete_empty({
		"name": type,
		"target": target_id,
		"owner": auth.owner,
	})
	var implementation: Implementation = get_implementation(target_id)
	var query = "byTargetAndOwnerAndName" if !type.is_empty() else "byTargetAndOwner"
	var data_list: Array
	if implementation == Implementation.GOTM_MARK_LOCAL:
		data_list = await _GotmMarkLocal.list("marks", query, params)
	else:
		data_list = await _GotmStore.list("marks", query, params)
	var local_params = params.duplicate()
	local_params.owner = _GotmAuthLocal.get_user()
	var local_data_list = await _GotmMarkLocal.list("marks", query, local_params) if implementation != Implementation.GOTM_MARK_LOCAL else []
	var marks = []
	if !data_list.is_empty():
		for data in data_list:
			marks.append(_format(data, GotmMark.new()))
	if !local_data_list.is_empty():
		for data in local_data_list:
			marks.append(_format(data, GotmMark.new()))
	return marks
