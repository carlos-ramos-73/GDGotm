class_name GotmContent


## A GotmContent is a piece of data that is used to affect your game's
## content dynamically, such as player-generated content, game saves,
## downloadable packs/mods or remote configuration.
##
## @tutorial: https://gotm.io/docs/content

##############################################################
# PROPERTIES
##############################################################

## UNIX epoch time (in milliseconds). Use OS.get_datetime_from_unix_time(content.created / 1000) to convert to date.
var created: int

## Unique immutable identifier.
var id: String

## Is true if this content was created with GotmContent.create_local and is only stored locally on the user's device.
## Is useful for data that does not need to be accessible to other devices, such as game saves for offline games.
var is_local: bool

## Optionally make this content inaccessible to other users. Private content can only be fetched by the user
## who created it via GotmContent.list. Is useful for personal data such as game saves.
var is_private: bool = false

## Optional unique key.
var key: String = ""

## Optional name searchable with partial search.
var name: String = ""

## Optionally make this content a child to other contents.
## If all parents are deleted, this content is deleted too.
var parent_ids: Array = []

## Optional metadata to attach to the content, 
## for example {level: "desert1", difficulty: "hard"}.
## When listing contents GotmContent.list, you can optionally 
## filter and sort with these properties. 
var properties: Dictionary = {}

## The size of the contents's data in bytes.
var size: int # TODO: Might need to check where code uses this and do changes

## UNIX epoch time (in milliseconds). Use OS.get_datetime_from_unix_time(content.created / 1000) to convert to date.
var updated: int

## Unique identifier of the user who owns the content.
## Is automatically set to the current user's id when creating the content.
## If the content is created while the game runs outside gotm.io, this user will 
## always be an unregistered user with no display name.
## If the content is created while the game is running on Gotm with a signed in
## user, you can get their display name via GotmUser.fetch.
var user_id: String


##############################################################
# METHODS
##############################################################

## Create content for the current user.
## See PROPERTIES above for descriptions of the arguments.
static func create(data = null, _key: String = "", _properties: Dictionary = {}, _name: String = "", _parent_ids: Array = [], _is_private: bool = false)  -> GotmContent:
	return await _GotmContent.create(data, _properties, _key, _name, _parent_ids, _is_private)

## Create content that is only stored locally on the user's device. Local content is not accessible to any other player or device.
static func create_local(data = null, _key: String = "", _properties: Dictionary = {}, _name: String = "", _parent_ids: Array = [], _is_private: bool = false)  -> GotmContent:
	return await _GotmContent.create(data, _properties, _key, _name, _parent_ids, _is_private, true)

# Creates a local mark on the content
func create_local_mark(type: GotmMark.Types) -> GotmMark:
	return await _GotmMark.create(self, type, true)

# Creates a mark on the content
func create_mark(type: GotmMark.Types) -> GotmMark:
	return await _GotmMark.create(self, type)

## Delete existing content.
static func delete(content_or_id) -> bool:
	return await _GotmContent.delete(content_or_id)

## Delete existing content by key.
static func delete_by_key(_key: String) -> bool:
	return await _GotmContent.delete_by_key(_key)

## Get existing content.
static func fetch(content_or_id) -> GotmContent:
	return await _GotmContent.fetch(content_or_id)

## Get existing content by key.
static func get_by_key(_key: String) -> GotmContent:
	return await _GotmContent.get_by_key(_key)

## Get existing content's data as bytes.
static func get_data(content_or_id) -> PackedByteArray:
	return await _GotmContent.fetch(content_or_id, "data")

## Get existing content's data as bytes by key.
static func get_data_by_key(_key: String) -> PackedByteArray:
	return await _GotmContent.get_by_key(_key, "data")

## Get the number of marks all users have assigned to this content.
func get_mark_count() -> int:
	return await _GotmMark.get_count(self)

## Get the number of marks with a type all users have assigned to this content.
func get_mark_count_with_type(type: GotmMark.Types) -> int:
	return await _GotmMark.get_count_with_type(self, type)

## Get existing content's data as an instanced Node.
static func get_node(content_or_id) -> Node:
	return await _GotmContent.fetch(content_or_id, "node")

## Get existing content's data as an instanced Node by key.
static func get_node_by_key(_key: String) -> Node:
	return await _GotmContent.get_by_key(_key, "node")

## Get existing content's properties.
static func get_properties(content_or_id):
	return await _GotmContent.fetch(content_or_id, "properties")

## Get existing content's properties bytes by key.
static func get_properties_by_key(_key: String) -> Dictionary:
	return await _GotmContent.get_by_key(_key, "properties")

## Get existing content's data as a Variant.
static func get_variant(content_or_id):
	return await _GotmContent.fetch(content_or_id, "variant")

## Get existing content's data as a Variant by key.
static func get_variant_by_key(_key: String):
	return await _GotmContent.get_by_key(_key, "variant")

# TODO: Better formatting below...

## Use complex filtering with a GotmQuery instance.
## For example, calling yield(GotmContent.list(GotmQuery.new().filter("properties/difficulty", "hard").sort("created"))
## would fetch the latest created contents whose "properties" field contains {"difficulty": "hard"}.
##
## @param query List contents according to the filters and sorts of the GotmQuery instance.
## @param after_content_or_id List contents that come after a previously listed content.
## 
## The following keywords can be used to filter or sort contents:
## * properties/*: Any value within the content's properties field. For example, if a content's "properties" 
## field equals {"level": {"difficulty": "hard"}}, then a keyword of "properties/level/difficulty" refers to 
## the nested "difficulty" field. Contents that lack the keyword are excluded from the fetched results.
## * key: The content's key field.
## * name: The content's name field.
## * user_id: The content's user_id field.
## * is_private: The content's is_private field. If filtering on a true value, a user_id filter on the current
## user's id is implicitly added. For example, doing GotmQuery.new().filter("is_private", true) would result
## in GotmQuery.new().filter("is_private", true).filter("user_id", Gotm.user.id). This is because a user
## is not permitted to view another user's private contents.
## * is_local: The content's is_local field.
## * parent_ids: Array of ids of contents that are parents to the content. All contents that has all of the 
## provided ids as parents are included in the list. For example, filtering with a parent_ids value of [a, b]
## would include all content that have a and b as parents, such as [a, b, c] and [a, b], but not [a], [b] or [a, c].
## * directory: The "directory" of the content's key field. For example,
## if a content's key is "a/b/c", then its directory is "a/b".
## * extension: The "extension" of the content's key field. For example,
## if a content's key is "a/b/c.txt", then its extension is "txt".
## * name_part: Used for partial name search. For example, doing
## GotmQuery.new().filter("name_part", "garlic") would match all contents
## whose names contain "garlic". Does not support GotmQuery.filter_min, GotmQuery.filter_max or GotmQuery.sort.
## * score: The number of upvotes minus the number of downvotes a content has gotten. Does not support GotmQuery.filter.
## * updated: The content's updated field. Does not support GotmQuery.filter.
## * created: The content's created field. Does not support GotmQuery.filter.
## * size: The size of the data stored by the content. Does not support GotmQuery.filter.
##
## There is no limit to how many times you use GotmQuery.filter in a single query. However, some limitations apply to GotmQuery.filter_min, 
## GotmQuery.filter_max and GotmQuery.sort, which you can read about below.
##
## Limitations:
## * The following keywords do not support GotmQuery.filter_min, GotmQuery.filter_max or GotmQuery.sort: name_part
## * The following keywords do not support GotmQuery.filter: score, updated, created, size
## * Contents can only be sorted by one keyword. For example, doing GotmQuery.new().sort("name").sort("key") would
## sort the contents by key only, because it appeared last.
## * GotmQuery.filter_min and GotmQuery.filter_max can only be used on the same keyword as GotmQuery.sort. For example,
## doing GotmQuery.new().filter_min("key", "a").filter_min("created", 0).sort("created") would result in 
## GotmQuery.new().filter_min("created", 0).sort("created").
static func list(query = GotmQuery.new(), after_content_or_id = null) -> Array:
	return await _GotmContent.list(query, after_content_or_id)

## Get all marks the current user has created to this content.
func list_marks() -> Array:
	return await _GotmMark.list_by_target(self)

## Get the marks with a type the current user has created to this content.
func list_marks_with_type(type: GotmMark.Types) -> Array:
	return await _GotmMark.list_by_target_with_type(self, type)

## Update existing content.
## Null is ignored.
static func update(content_or_id, new_data = null, new_key = null, new_properties = null, new_name = null) -> GotmContent:
	return await _GotmContent.update(content_or_id, new_data, new_properties, new_key, new_name)

## Update existing content by key.
static func update_by_key(_key: String, new_data = null, new_key = null, new_properties = null, new_name = null) -> GotmContent:
	return await _GotmContent.update_by_key(_key, new_data, new_properties, new_key, new_name)


##############################################################
# PRIVATE
##############################################################

const _CLASS_NAME := "GotmContent"
