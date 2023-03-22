class_name GotmFile

## A simple in-memory file descriptor used by [method Gotm.pick_files] and 
## [signal Gotm.files_dropped].


##############################################################
# PROPERTIES
##############################################################

## File name.
var name: String

## File data.
var data: PackedByteArray

## Last time the file was modified in unix time (seconds since epoch).
var modified_time: int


##############################################################
# METHODS
##############################################################

## Save the file to the browser's download folder.
func download() -> void:
	pass


##############################################################
# PRIVATE
##############################################################

const _CLASS_NAME := "GotmFile"
