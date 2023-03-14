class_name GotmUser


## Holds information about a Gotm user.


##############################################################
# PROPERTIES
##############################################################
## These are all read-only.

## Globally unique ID.
## Read only.
var id: String = ""

## Current nickname. Can be changed at https://gotm.io/settings.
## Read only.
var display_name: String = ""

## The IP address of the user.
## Is empty if you are not in the same lobby.
## Read only.
var address: String = ""

##############################################################
# METHODS
##############################################################

## Fetch registered user by id.
## A registered user is someone who has signed up on Gotm.
## Returns null if there is no registered user with that id.
static func fetch(id: String) -> GotmUser:
	return await _GotmUser.fetch(id)

##############################################################
# PRIVATE
##############################################################

## Private variable for internal use
var _impl: Dictionary = {}
