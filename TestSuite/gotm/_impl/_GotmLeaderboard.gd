class_name _GotmLeaderboard


static func _coerce_id(resource_or_id) -> String:
	return _GotmUtility.coerce_resource_id(resource_or_id, "scores")


static func _get_surrounding_scores(leaderboard: GotmLeaderboard, center) -> GotmLeaderboard.SurroundingScores:
	if center is GotmScore || center is String:
		var id := _coerce_id(center)
		if id.is_empty():
			await _GotmUtility.get_tree().process_frame
			return null

		var score := await GotmScore.fetch(id)
		if !score:
			return null

		var before := await _GotmScore._list(leaderboard, id, true)
		before.reverse()
		var after := await _GotmScore._list(leaderboard, id, false)
		var surrounding_scores := GotmLeaderboard.SurroundingScores.new()
		surrounding_scores.before = before
		surrounding_scores.score = score
		surrounding_scores.after = after
		return surrounding_scores

	var scores := []
	# Attempt to get the nearest GotmScore from center value or rank
	if center is float:
		scores = await _GotmScore._list(leaderboard, center, false, 1)
	elif center is int && center > 1:
		scores = await _GotmScore._list(leaderboard, center - 1, false, 1)
	else:
		scores = await _GotmScore._list(leaderboard, null, false, 1) # TODO: what does this mean exactly? Does it mean get the latest score inserted?

	var score: GotmScore = scores[0] if !scores.is_empty() else null
	if !score:
		return null

	var before := await _GotmScore._list(leaderboard, score, true)
	before.reverse()
	var after := await _GotmScore._list(leaderboard, score, false)
	var surrounding_scores := GotmLeaderboard.SurroundingScores.new()
	surrounding_scores.before = before
	surrounding_scores.score = score
	surrounding_scores.after = after
	return surrounding_scores


static func get_surrounding_scores(leaderboard: GotmLeaderboard, center) -> GotmLeaderboard.SurroundingScores:
	if !(center is int || center is float || center is String || center is GotmScore):
		await _GotmUtility.get_tree().process_frame
		push_error("Expected an int, float, GotmScore or GotmScore.id string.")
		return null

	if center is int:
		center = float(center)
	return await _get_surrounding_scores(leaderboard, center)


static func get_surrounding_scores_by_rank(leaderboard: GotmLeaderboard, center) -> GotmLeaderboard.SurroundingScores:
	if !(center is int || center is float || center is String || center is GotmScore):
		await _GotmUtility.get_tree().process_frame
		push_error("Expected an int, float, GotmScore or GotmScore.id string.")
		return null

	if center is float:
		center = int(center)
	return await _get_surrounding_scores(leaderboard, center)
