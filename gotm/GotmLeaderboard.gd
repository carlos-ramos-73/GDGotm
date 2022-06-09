# MIT License
#
# Copyright (c) 2020-2022 Macaroni Studios AB
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

class_name GotmLeaderboard
#warnings-disable

# Used for fetching ranks and scores.
# You do not need to create a leaderboard before creating scores.


##############################################################
# PROPERTIES
##############################################################

# Required. Filters by score name.
# For example, a name of "bananas_collected" will only fetch scores with the 
# same name.
var name: String = ""

# Optionally filter by score properties.
# For example, {level: "desert1"} will only fetch scores that has the same 
# value for that level, such as {level: "desert1", difficulty: "hard"} and
# {level: "desert1"}, but not {level: "snow1", difficulty: "hard"} or
# {difficulty: "hard"}.
var properties: Dictionary = {}

# Optionally filter by unique scores per user.
# If a user has multiple score entries, only the last created one will be 
# fetched. For example if a user created scores of 5 and then 2, the fetched 
# scores will only be 2.
var is_unique: bool = false

# Optionally filter by when scores were created.
# For example, GotmPeriod.sliding(GotmPeriod.TimeGranularity.WEEK) will only
# fetch scores created the last 7 days.
var period: GotmPeriod = GotmPeriod.all()

# Optionally filter by user.
# When set, only the scores that belong to that user will be fetched.
var user_id: String = ""


##############################################################
# METHODS
##############################################################

# If a score id (string) is provided, get the rank of that score among all
# scores that match the filters of this leaderboard.
# If a value (int) is provided, get the rank a score would have if it would
# have that value.
# Ranks start at 1.
# For example, if Score1 has value 5 and Score2 has value 6, then Score1 
# would have rank 2 and Score2 would have rank 1.
func get_rank(score_id_or_value) -> int:
	return yield(_GotmScore.get_rank(self, score_id_or_value), "completed")

# Fetch up to 20 scores that match the filters of this leaderboard sorted
# by their values in descending order (highest value first).
# If "after_score_id" is specified, fetch the scores that come after that score.
# If "ascending" is true, sort in ascending order (lowest value first).
func get_scores(after_score_id: String = "", ascending: bool = false) -> Array:
	return yield(_GotmScore.list(GotmScore, self, after_score_id, ascending), "completed")

class SurroundingScores:
	# Scores above "score" in descending order. The last element is the score above "score".
	var before: Array
	# The middle score
	var score: GotmScore
	# Scores below "score" descending order. The first element is the score below "score".
	var after: Array
# Fetch surrounding scores.
func get_surrounding_scores(score_id: String) -> SurroundingScores:
	return yield(_GotmLeaderboard.get_surrounding_scores(self, score_id), "completed")