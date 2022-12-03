def base(r)
	r.ord - 'X'.ord + 1
end

def duel_result(r)

end

DUELS = {
	'A' => { 'X' => 3, 'Y' => 6, 'Z' => 0 },
	'B' => { 'X' => 0, 'Y' => 3, 'Z' => 6 },
	'C' => { 'X' => 6, 'Y' => 0, 'Z' => 3}
}

DUEL_OPTION = {
	'A' => { 'X' => 'Z', 'Y' => 'X', 'Z' => 'Y' },
	'B' => { 'X' => 'X', 'Y' => 'Y', 'Z' => 'Z' },
	'C' => { 'X' => 'Y', 'Y' => 'Z', 'Z' => 'X'}
}

def result(l, r)
	r = DUEL_OPTION[l][r]

	base(r) + DUELS[l][r]
end

@sum = 0
File.readlines('in.txt').each do |line|
	@sum += result(*line.split(' '))
end
puts @sum