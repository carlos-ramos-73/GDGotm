class_name GotmBlob


## A GotmBlob is a piece of arbitrary data stored as a PoolByteArray.
## The data can be anything, such as images, scenes or JSON files.


##############################################################
# PROPERTIES
##############################################################

## Unique immutable identifier.
var id: String

## Is true if this blob is only stored locally on the user's device.
var is_local: bool

## The size of the blob's data in bytes.
var size: int


##############################################################
# METHODS
##############################################################

## Get an existing blob.
static func fetch(blob_or_id) -> GotmBlob:
	return await _GotmBlob.fetch(blob_or_id)


## Get the blob's data as a PoolByteArray. Can use either GotmBlob or GotmBlob.id as input.
static func get_data(blob_or_id) -> PackedByteArray:
	return await _GotmBlob.get_data(blob_or_id)


##############################################################
# PRIVATE
##############################################################

const _CLASS_NAME := "GotmBlob"
