extends Node




var toDrop = "health"
var success = 0

func dropItem():
	var item:String
	if randi() % 2:
		item = "glocklin"
	else: item = "health"

	toDrop = item

	var result = randi_range(0, 10)
	print(result)
	

	if result <= success:
		if toDrop == "glocklin":
			#Drop Glocklin
			print("Glocklin dropped")
		
		if toDrop == "health":
			#Drop Health
			print("Health dropped")

		print("successful")
		success = 0

	else:
		print("no luck")
		success += 1


