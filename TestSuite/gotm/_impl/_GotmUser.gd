class_name _GotmUser


static func fetch(id: String) -> GotmUser:
	var data: Dictionary = await get_implementation().fetch(id)
	return _format(data, GotmUser.new())


static func _format(data: Dictionary, user: GotmUser) -> GotmUser:
	if data.is_empty() || !user:
		return null
	user.id = data.path
	user.display_name = data.name
	return user


static func get_implementation():
	if !_Gotm.has_global_api():
		return _GotmUserLocal
	return _GotmStore
