extends Node



static func sort_initiative(a, b) -> bool:
	return a.get_initiative() > b.get_initiative()
