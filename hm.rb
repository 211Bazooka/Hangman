@guesshash = {}

@answer = 'baby'

def gogo
	@input = gets.chomp
	asplit = @answer.split('')
	(asplit.include? (@input)) ? @guesshash[@input] = true : @guesshash[@input] = false
end


3.times {gogo}
puts "_________________________"
@guesshash.each {|k, v| puts k if v == true}