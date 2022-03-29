extends Node



static func sort_initiative(a, b) -> bool:
	return a.get_initiative() > b.get_initiative()

static func sample(list : Array, n : int) -> Array:
	var sample = []
	randomize()
	for i in range(n):
		var x = randi()%list.size()
		sample.append(list[x])
		list.remove(x)
	return sample
