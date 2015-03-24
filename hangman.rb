require 'yaml'

def start_menu
	puts "1. New Game\n2. Load Last Save"
	input = gets.chomp
	case input
	when '1'
		g = Game.new
	when '2'
		load = YAML.load_file('hangman_save.yaml')
		g = Game.new(load)
	end
end

class RandomWord
	attr_reader :instance
		def initialize
			dictionary = File.open('5desk.txt', 'r').readlines.each{|word| word}
			@instance = dictionary[rand(dictionary.size)].downcase.chomp
		end
end

class Game
	attr_accessor :solution, :lives, :guesses
		def initialize(hash = {lives: 7, guesses: {}, solution: RandomWord.new.instance})
			@lives = hash[:lives]
			dictionary = File.open('5desk.txt', 'r').readlines.each{|word| word}
			@solution = hash[:solution]
			@guesses = hash[:guesses]
			@hash = hash
			start
		end

		def show_board
			board
			puts "Guesses:   Lives: #{@hash[:lives]}\n\r"
			@guesses.each {|k, v| print "#{k} " if v == false}
			puts "\n\r"
			puts board
		end

		def board
			@board = @solution.split('').map! {|k| (@guesses[k] == true) ?  k :  "_"}.join('  ')
		end

		def answer
			@answer = @solution.split('').map! {|k| (@guesses[k] == true) ?  k :  "_"}.join
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
						save = YAML::dump(@hash)
						save_file = File.new('hangman_save.yaml', 'w+')
						save_file.write(save)
						puts "Game Saved!"
						puts "Choose a Letter:"

					when @input == "exit"
						exit

					when (valid_letter && unique_letter && @input.size == 1)
						if @solution.split('').include? (@input)
							then @guesses[@input] = true
						else @guesses[@input] = false
							@hash[:lives] -= 1
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
					if @answer == @solution
						puts "You Win!"
						exit
					elsif @hash[:lives] <= 0
						puts "Game Over"
						puts "The Answer was #{@solution}"
						exit
					else guess
				end
			end
		end
end

start_menu

