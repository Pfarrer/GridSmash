class_name CountingSet
extends RefCounted

var _dict = {}

func add(item: Variant):
	if item in _dict:
		_dict[item] += 1
	else:
		_dict[item] = 1
	
	return _dict[item]


func sub(item: Variant):
	if item in _dict:
		_dict[item] -= 1
		if _dict[item] == 0:
			_dict.erase(item)
			return 0
		else:
			return _dict[item]

	return 0
	

func remove(item: Variant):
	if item in _dict:
		_dict.erase(item)
	

func has(item: Variant) -> bool:
	return item in _dict


func items() -> Array:
	return _dict.keys()


func size() -> int:
	return _dict.size()
