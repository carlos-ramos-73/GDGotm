class_name GotmConfig


## Configuration options when initializing GDGotm.

## The project key gives your game access to Gotm's cloud and lets you share data
## between players, for example scores and leaderboards. You can create a key in 
## your game's Gotm dashboard (https://gotm.io/dashboard).
## If you don't specify a project key, the plugin will not use Gotm's cloud and all
## data is only saved locally on the device your game is running on.
## [br]
## For example, if you specify a project key, all scores that you create with
## GotmScore.create will be saved in the cloud and will be visible to other players. 
## If you don't specify a project key, the scores will only be stored in the local
## storage of the device the game is running on, and will not be visible to other
## players.
var project_key: String = ""

## Scores and Leaderboards are always local when Gotm.is_live is false.
## If true, the features are local even if a project key is provided.
var force_local_scores: bool = false

## Contents are always local when Gotm.is_live is false.
## If true, the features are local even if a project key is provided.
var force_local_contents: bool = false

## Marks are always local when Gotm.is_live is false.
## If true, the features are local even if a project key is provided.
var force_local_marks: bool = false


##############################################################
# PRIVATE
##############################################################

const _CLASS_NAME := "GotmConfig"
