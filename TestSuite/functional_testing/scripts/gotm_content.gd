class_name GotmContentTest
extends Node

var print_console := true


func create(is_local: bool = false) -> void:
	var _data_option: OptionButton = $UI/ParamsScrollContainer/Params/Create/DataOptionButton
	var _data: LineEdit = $UI/ParamsScrollContainer/Params/Create/Data
	var _key: LineEdit = $UI/ParamsScrollContainer/Params/Create/Key
	var _name: LineEdit = $UI/ParamsScrollContainer/Params/Create/Name
	var _prop_name_1: LineEdit = $UI/ParamsScrollContainer/Params/Create/Prop1/PropName1
	var _prop_value_1: LineEdit = $UI/ParamsScrollContainer/Params/Create/Prop1/PropValue1
	var _prop_name_2: LineEdit = $UI/ParamsScrollContainer/Params/Create/Prop2/PropName2
	var _prop_value_2: LineEdit = $UI/ParamsScrollContainer/Params/Create/Prop2/PropValue2
	var _prop_name_3: LineEdit = $UI/ParamsScrollContainer/Params/Create/Prop3/PropName3
	var _prop_value_3: LineEdit = $UI/ParamsScrollContainer/Params/Create/Prop3/PropValue3
	var _parent_ID: LineEdit = $UI/ParamsScrollContainer/Params/Create/ParentID
	var _is_private: CheckButton = $UI/ParamsScrollContainer/Params/Create/Private

	var data
	match _data_option.selected:
		0: data = null
		1: data = _data.text
		2: data = _data.text.to_utf8_buffer()
		3: data = Node.new(); data.name = _data.text if !_data.text.is_empty() else "node"
	var props := {}
	if !_prop_name_1.text.is_empty(): props[_prop_name_1.text] = _prop_value_1.text
	if !_prop_name_2.text.is_empty(): props[_prop_name_2.text] = _prop_value_2.text
	if !_prop_name_3.text.is_empty(): props[_prop_name_3.text] = _prop_value_3.text
	var parents := []
	if !_parent_ID.text.is_empty(): parents.append(_parent_ID.text)
	var is_private := _is_private.button_pressed

	var content: GotmContent
	if is_local:
		content = await GotmContent.create_local(data, _key.text, props, _name.text, parents, is_private)
	else:
		content = await GotmContent.create(data, _key.text, props, _name.text, parents, is_private)
	if !content:
		push_error("Could not create content...")
		return
	if print_console:
		print("GotmContent created...")
		print(GotmContentTest.gotm_content_to_string(content))


func create_local() -> void:
	create(true)


func update(by_key: bool = false) -> void:
	var _id: LineEdit = $UI/ParamsScrollContainer/Params/Update/ID
	var _key: LineEdit = $UI/ParamsScrollContainer/Params/Update/Key
	var _data_option: OptionButton = $UI/ParamsScrollContainer/Params/Update/DataOptionButton
	var _data: LineEdit = $UI/ParamsScrollContainer/Params/Update/Data
	var _name: LineEdit = $UI/ParamsScrollContainer/Params/Update/Name
	var _new_key: LineEdit = $UI/ParamsScrollContainer/Params/Update/NewKey
	var _prop_name_1: LineEdit = $UI/ParamsScrollContainer/Params/Update/Prop1/PropName1
	var _prop_value_1: LineEdit = $UI/ParamsScrollContainer/Params/Update/Prop1/PropValue1
	var _prop_name_2: LineEdit = $UI/ParamsScrollContainer/Params/Update/Prop2/PropName2
	var _prop_value_2: LineEdit = $UI/ParamsScrollContainer/Params/Update/Prop2/PropValue2
	var _prop_name_3: LineEdit = $UI/ParamsScrollContainer/Params/Update/Prop3/PropName3
	var _prop_value_3: LineEdit = $UI/ParamsScrollContainer/Params/Update/Prop3/PropValue3

	@warning_ignore("incompatible_ternary")
	var new_name = _name.text if !_name.text.is_empty() else null
	@warning_ignore("incompatible_ternary")
	var new_key = _new_key.text if !_new_key.text.is_empty() else null
	var data
	match _data_option.selected:
		0: data = null
		1: data = _data.text
		2: data = _data.text.to_utf8_buffer()
		3: data = Node.new(); data.name = _data.text
	var props = {}
	if !_prop_name_1.text.is_empty(): props[_prop_name_1.text] = _prop_value_1.text
	if !_prop_name_2.text.is_empty(): props[_prop_name_2.text] = _prop_value_2.text
	if !_prop_name_3.text.is_empty(): props[_prop_name_3.text] = _prop_value_3.text
	if props.is_empty(): props = null

	var content: GotmContent
	if by_key:
		content = await GotmContent.update_by_key(_key.text, data, new_key, props, new_name)
	else:
		content = await GotmContent.update(_id.text, data, new_key, props, new_name)
	if !content:
		push_error("Could not update content...")
		return
	if print_console:
		print("GotmContent updated...")
		print(GotmContentTest.gotm_content_to_string(content))


func update_by_key() -> void:
	update(true)


func delete(by_key: bool = false) -> void:
	var _id: LineEdit = $UI/ParamsScrollContainer/Params/Delete/ID
	var _key: LineEdit = $UI/ParamsScrollContainer/Params/Delete/Key
	
	if by_key:
		GotmContent.delete_by_key(_key.text)
	else:
		GotmContent.delete(_id.text)
	if print_console:
		print("GotmContent deleted...")


func delete_by_key() -> void:
	delete(true)


static func gotm_content_to_string(content: GotmContent) -> String:
	var result := "\nGotmContent:\n"
	result += "[id] %s\n" % content.id
	result += "[user_id] %s\n" % content.user_id
	result += "[created] %s\n" % Time.get_datetime_string_from_unix_time(content.created)
	result += "[is_local] %s\n" % str(content.is_local)
	result += "[is_private] %s\n" % str(content.is_private)
	result += "[key] %s\n" % content.key
	result += "[name] %s\n" % content.name
	result += "[parent_ids] %s\n" % str(content.parent_ids)
	result += "[properties] %s\n" % content.properties
	result += "[size] %d\n" % content.size
	result += "[updated] %s\n" % Time.get_datetime_string_from_unix_time(content.updated)
	return result


func _check_menu(_param = null) -> void:
	_disable_menu()
	# Update Button
	if $UI/ParamsScrollContainer/Params/Update/ID.text != "":
		$UI/MenuScrollContainer/Menu/Update.disabled = false
	# Update By Key Button
	if $UI/ParamsScrollContainer/Params/Update/Key.text != "":
		$UI/MenuScrollContainer/Menu/UpdateByKey.disabled = false
	# Delete Button
	if $UI/ParamsScrollContainer/Params/Delete/ID.text != "":
		$UI/MenuScrollContainer/Menu/Delete.disabled = false
	# Delete By Key Button
	if $UI/ParamsScrollContainer/Params/Delete/Key.text != "":
		$UI/MenuScrollContainer/Menu/DeleteByKey.disabled = false


func _disable_menu() -> void:
	$UI/MenuScrollContainer/Menu/Update.disabled = true
	$UI/MenuScrollContainer/Menu/UpdateByKey.disabled = true
	$UI/MenuScrollContainer/Menu/Delete.disabled = true
	$UI/MenuScrollContainer/Menu/DeleteByKey.disabled = true
	$UI/MenuScrollContainer/Menu/Fetch.disabled = true
	$UI/MenuScrollContainer/Menu/GetByKey.disabled = true
	$UI/MenuScrollContainer/Menu/CreateMark.disabled = true
	$UI/MenuScrollContainer/Menu/CreateLocalMark.disabled = true
	$UI/MenuScrollContainer/Menu/ListMarks.disabled = true
	$UI/MenuScrollContainer/Menu/ListMarksWithType.disabled = true
	$UI/MenuScrollContainer/Menu/GetMarkCount.disabled = true
	$UI/MenuScrollContainer/Menu/GetData.disabled = true
	$UI/MenuScrollContainer/Menu/GetNode.disabled = true
	$UI/MenuScrollContainer/Menu/GetVariant.disabled = true
	$UI/MenuScrollContainer/Menu/GetProperties.disabled = true
	$UI/MenuScrollContainer/Menu/GetDataByKey.disabled = true
	$UI/MenuScrollContainer/Menu/GetNodeByKey.disabled = true
	$UI/MenuScrollContainer/Menu/GetVariantByKey.disabled = true
	$UI/MenuScrollContainer/Menu/GetPropertiesByKey.disabled = true
	$UI/MenuScrollContainer/Menu/List.disabled = true


func _on_console_print_toggled(button_pressed: bool) -> void:
	print_console = button_pressed
