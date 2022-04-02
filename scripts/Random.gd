extends Node
class_name Random


static func integer(minimum, maximum):
	var random = RandomNumberGenerator.new()
	random.randomize()
	return random.randi_range(minimum, maximum)


static func choose(options : Array = []):
	return 
