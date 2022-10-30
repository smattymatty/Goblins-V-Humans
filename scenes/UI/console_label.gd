extends Label

var turn_sent : int

func set_turn(turns_passed) -> void:
	turn_sent = turns_passed
	hint_tooltip = 'turn ' + str(turn_sent)
