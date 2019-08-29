function encrypt(val)
	val = val * 6132
	val = val / 2
	val = val + 5
	val = val - 1
	val = val * -2
	val = val * 718612
	val = val / 23
	return val
end

function decrypt(val)
	val = val * 23
	val = val / 718612
	val = val / -2
	val = val + 1
	val = val - 5
	val = val * 2
	val = val / 6132
	return val
end
