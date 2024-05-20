func xp_from_level(l):
	#print(32 ** (1.2 ** l))
	return 16 ** (1.1 ** l)
	
func Level_from_xp(xp):
	var level = 1
	while (xp_from_level(level) <= xp):
		level = level + 1
	return level
	
