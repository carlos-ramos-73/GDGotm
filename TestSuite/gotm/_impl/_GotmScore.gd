class_name _GotmScore


static func _clear_cache() -> void:
	if get_implementation() == _GotmScoreLocal:
		_GotmScoreLocal.clear_cache("scores")
		_GotmScoreLocal.clear_cache("stats")
	else:
		_GotmStore.clear_cache("scores")
		_GotmStore.clear_cache("stats")


static func _coerce_id(resource_or_id) -> String:
	return _GotmUtility.coerce_resource_id(resource_or_id, "scores")


static func create(name: String, value: float, properties: Dictionary = {}, is_local: bool = false) -> GotmScore:
	value = _GotmUtility.clean_for_json(value)
	properties = _GotmUtility.clean_for_json(properties)
	var data: Dictionary
	if is_local || get_implementation() == _GotmScoreLocal:
		data = await _GotmScoreLocal.create("scores", {"name": name, "value": value, "props": properties})
	else:
		data = await _GotmStore.create("scores", {"name": name, "value": value, "props": properties})
	if !data.is_empty():
		_clear_cache()
	return _format(data, GotmScore.new())


static func delete(score_or_id) -> void:
	if !(score_or_id is GotmScore || score_or_id is String):
		push_error("Expected a GotmScore or GotmScore.id string.")
		return

	var id := _coerce_id(score_or_id)
	if get_implementation(id) == _GotmScoreLocal:
		await _GotmScoreLocal.delete(id)
	else:
		await _GotmStore.delete(id)
	_clear_cache()


static func encode_cursor(score_id_or_value, ascending: bool) -> String:
	score_id_or_value = _GotmUtility.clean_for_json(score_id_or_value)
	if score_id_or_value is String:
		var score := await fetch(score_id_or_value)
		if !score:
			return ""
		return _GotmUtility.encode_cursor([[score.value, score.created], score.id.replace("/", "-") + "~"])
	elif score_id_or_value is float || score_id_or_value is int:
		await _GotmUtility.get_tree().process_frame
		var created = 253402300799000 if ascending else 0
		return _GotmUtility.encode_cursor([[float(score_id_or_value), created], "~"])
	return ""


static func fetch(score_or_id) -> GotmScore:
	if !(score_or_id is GotmScore || score_or_id is String):
		push_error("Expected a GotmScore or GotmScore.id string.")
		return null

	var id := _coerce_id(score_or_id)
	var data: Dictionary
	if get_implementation(id) == _GotmScoreLocal:
		data = await _GotmScoreLocal.fetch(id)
	else:
		data = await _GotmStore.fetch(id)
	return _format(data, GotmScore.new())


static func _format(data: Dictionary, score: GotmScore) -> GotmScore:
	if data.is_empty() || !score:
		return null
	score.id = data.path
	score.user_id = data.author
	score.name = data.name
	score.value = float(data.value)
	score.properties = data.props if data.get("props") else {}
	score.created = data.created
	score.is_local = !_LocalStore.fetch(data.path).is_empty()
	return score


static func get_auth_implementation():
	if get_implementation() == _GotmScoreLocal:
		return _GotmAuthLocal
	return _GotmAuth


#static func get_counts(leaderboard: GotmLeaderboard, minimum_value: float, maximum_value: float, segment_count: int) -> Array: # TODO: implement leaderboard and then switch to this line
static func get_counts(leaderboard, minimum_value: float, maximum_value: float, segment_count: int) -> Array:
	minimum_value = _GotmUtility.clean_for_json(minimum_value)
	maximum_value = _GotmUtility.clean_for_json(maximum_value)
	segment_count = _GotmUtility.clean_for_json(segment_count)

	if segment_count > 20:
		segment_count = 20
	if segment_count < 1:
		segment_count = 1
	var project := await _get_project()
	var counts := []
	for i in range(0, segment_count):
		counts.append(0)
	if project.is_empty():
		return counts

	var params = _GotmUtility.delete_empty({
		"name": leaderboard.name,
		"target": project,
		"props": leaderboard.properties,
		"period": leaderboard.period.to_string(),
		"isUnique": leaderboard.is_unique,
		"isInverted": leaderboard.is_inverted,
		"isOldestFirst": leaderboard.is_oldest_first,
		"author": leaderboard.user_id,
		"limit": segment_count,
	})
	params.min = minimum_value
	params.max = maximum_value
	var stats: Array
	if leaderboard.is_local || get_implementation() == _GotmScoreLocal:
		stats = await _GotmScoreLocal.list("stats", "countByScoreSort", params)
	else:
		stats = await _GotmStore.list("stats", "countByScoreSort", params)
	
	if stats.size() != counts.size():
		return counts
	
	for i in range(stats.size()):
		counts[i] = stats[i].value
	return counts


static func get_implementation(id = ""):
	if !_Gotm.is_global_api("scores") || !_LocalStore.fetch(id).is_empty():
		return _GotmScoreLocal
	return _GotmStore


static func _get_project() -> String:
	var auth
	var local := false
	if get_auth_implementation() == _GotmAuthLocal:
		auth = _GotmAuthLocal.get_auth()
		local = true
	else:
		auth = _GotmAuth.get_auth()
	if !auth:
		if local: auth = await _GotmAuthLocal.get_auth_async()
		else: auth = await _GotmAuth.get_auth_async()
	if !auth:
		return ""
	return auth.project


#static func get_rank(leaderboard: GotmLeaderboard, score_id_or_value) -> int: # TODO: implement leaderboard and then switch to this line
static func get_rank(leaderboard, score_id_or_value) -> int:
	if !(score_id_or_value is GotmScore || score_id_or_value is String
			|| score_id_or_value is int || score_id_or_value is float):
		push_error("Expected a GotmScore, GotmScore.id string, int, or float.")
		return 0

	if score_id_or_value is float || score_id_or_value is int:
		score_id_or_value = _GotmUtility.clean_for_json(score_id_or_value)
	else:
		score_id_or_value = _coerce_id(score_id_or_value)
	var project := await _get_project()
	if project.is_empty():
		return 0

	var params = _GotmUtility.delete_empty({
		"name": leaderboard.name,
		"target": project,
		"props": leaderboard.properties,
		"period": leaderboard.period.to_string(),
		"isUnique": leaderboard.is_unique,
		"isInverted": leaderboard.is_inverted,
		"isOldestFirst": leaderboard.is_oldest_first,
		"author": leaderboard.user_id,
	})
	if score_id_or_value is float || score_id_or_value is int:
		params.value = float(score_id_or_value)
	elif score_id_or_value is String && !(score_id_or_value as String).is_empty():
		params.score = score_id_or_value
	else:
		return 0

	var stat: Dictionary
	if leaderboard.is_local || get_implementation(params.get("score")) == _GotmScoreLocal:
		stat = await _GotmScoreLocal.fetch("stats/rank", "rankByScoreSort", params)
	else:
		stat = await _GotmStore.fetch("stats/rank", "rankByScoreSort", params)
	if stat.is_empty():
		return 0
	return stat.value


#static func _list(leaderboard: GotmLeaderboard, after, ascending: bool, limit: int = 0) -> Array: # TODO: implement leaderboard and then switch to this line
static func _list(leaderboard, after, ascending: bool, limit: int = 0) -> Array:
	if !(after is GotmScore || after is String
			|| after is int || after is float):
		push_error("Expected a GotmScore, GotmScore.id string, int, or float.")
		return []

	if after is int || after is float:
		after = _GotmUtility.clean_for_json(after)
	else:
		after = _coerce_id(after)
	var after_id: String = after if after is String else ""
	var project := await _get_project()
	if project.is_empty():
		return []
	var after_rank = null
	if after is String && !(after as String).is_empty() || after is float:
		after = await encode_cursor(after, ascending)
	elif after is int:
		after_rank = after
		after = null
	else:
		after = null
	var params = _GotmUtility.delete_empty({
		"name": leaderboard.name,
		"target": project,
		"props": leaderboard.properties,
		"period": leaderboard.period.to_string(),
		"isUnique": leaderboard.is_unique,
		"isInverted": leaderboard.is_inverted,
		"isOldestFirst": leaderboard.is_oldest_first,
		"author": leaderboard.user_id,
		"after": after,
		"descending": !ascending,
		"limit": limit
	})
	if after_rank is int:
		params.afterRank = after_rank

	var data_list: Array
	if leaderboard.is_local || get_implementation(after_id) == _GotmScoreLocal:
		data_list = await _GotmScoreLocal.list("scores", "byScoreSort", params)
	else:
		data_list = await _GotmStore.list("scores", "byScoreSort", params)
	if data_list.is_empty():
		return []

	var scores = []
	for data in data_list:
		scores.append(_format(data, GotmScore.new()))
	return scores 


#static func list(leaderboard: GotmLeaderboard, after, ascending: bool) -> Array: # TODO: implement leaderboard and then switch to this line
static func list(leaderboard, after, ascending: bool) -> Array:
	if after is int:
		after = float(after)
	return await _list(leaderboard, after, ascending)


#static func list_by_rank(leaderboard: GotmLeaderboard, after, ascending: bool) -> Array: # TODO: implement leaderboard and then switch to this line
static func list_by_rank(leaderboard, after, ascending: bool) -> Array:
	if after is float:
		after = int(after)
	return await _list(leaderboard, after, ascending)


static func update(score_or_id, value = null, properties = null) -> GotmScore:
	if !(score_or_id is GotmScore || score_or_id is String):
		push_error("Expected a GotmScore or GotmScore.id string.")
		return null

	var id := _coerce_id(score_or_id)
	value = _GotmUtility.clean_for_json(value)
	properties = _GotmUtility.clean_for_json(properties)
	var data: Dictionary
	if get_implementation(id) == _GotmScoreLocal:
		data = await _GotmScoreLocal.update(id, _GotmUtility.delete_null({"value": value, "props": properties}))
	else:
		data = await _GotmStore.update(id, _GotmUtility.delete_null({"value": value, "props": properties}))
	if !data.is_empty():
		_clear_cache()
	return _format(data, GotmScore.new() if id is String else score_or_id)