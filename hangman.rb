
class Game
		def initialize
			@lives = 7
			dictionary = File.open('5desk.txt', 'r').readlines.each{|word| word}
			@random_word = dictionary[rand(dictionary.size)].downcase.chomp
			@guesses = {}
		end

		def show_board
			puts "Guesses:   Lives: #{@lives}\n\r"
			@guesses.each {|k, v| print "#{k} " if v == false}
			puts "\n\r"
			puts board
		end

		def board
			@board = @random_word.split('').map! {|k| (@guesses[k] == true) ?  k :  "_"}.join('  ')
		end

		def answer
			@answer = @random_word.split('').map! {|k| (@guesses[k] == true) ?  k :  "_"}.join
		end

		def guess
			puts "Choose a letter:"
			
			loop do
				@input = gets.chomp.downcase
				alpha = ('a'.upto('z')).to_a
				valid_letter = alpha.include? (@input)
				unique_letter = ((@guesses.include? (@input)) == false)
				case
					when @input == "save"
						puts "Game Saved!"
						puts "Choose a Letter"
					when @input == "exit"
						exit

					when (valid_letter && unique_letter && @input.size == 1)
						if @random_word.split('').include? (@input)
							then @guesses[@input] = true
						else @guesses[@input] = false
							@lives -= 1
						end
						board
						show_board
						answer
						
						break

					else
						puts "Invalid input. Please choose a letter:"	
				end
			end
		end

		def start
			show_board
			loop do
				answer
					if @answer == @random_word
						puts "You Win!"
						exit
					elsif @lives <= 0
						puts "Game Over"
						puts "The Answer was #{@random_word}"
						exit
					else guess
				end
			end
		end
end

g = Game.new
g.start

