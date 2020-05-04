require 'colorize'
require 'pry'

class Mastermind
  COLORS = [:black, :blue, :green, :magenta, :red, :light_yellow, :light_black]
  CODE_LENGTH = 4
  LINE_SEPARATOR = '+' * (CODE_LENGTH * 4 + 1)
  NUMBER_OF_ROUNDS = 12

  def initialize
    @board = []
    @round = 0
    NUMBER_OF_ROUNDS.times do
      empty_pegs = Array.new(CODE_LENGTH, COLORS[0])
      empty_result = {}
      @board << {guess: empty_pegs, result: empty_result}
    end
  end

  def play_as_human
    self.initialize
    @code = self.generate_random_pegs
    begin
      self.play_round_as_human
    end until (@round == NUMBER_OF_ROUNDS) || self.win?
    if self.win?
      puts "Congratulations you won !"
    else
      puts "Better luck next time !"
    end
    puts "The code was:"
    puts display_pegs(@code)
  end

  def play_as_computer
    self.initialize
    @code = self.get_code
    begin
      self.play_round_as_computer
      gets
    end until (@round == NUMBER_OF_ROUNDS) || self.win?
    if self.win?
      puts "The computer won ! Better luck next time"
    else
      puts "Congratulations ! The computer lost"
    end
    puts "The code was:"
    puts display_pegs(@code)
  end

  private

  def random_color
    COLORS[rand(1..COLORS.length-1)]
  end

  def generate_random_pegs
    pegs = []
    CODE_LENGTH.times { pegs << self.random_color }
    pegs
  end

  def get_code
    puts "Please select your code"
    self.get_selection
  end

  def win?
    @board[@round-1][:result][:correct_position] == CODE_LENGTH
  end

  def valid_selection?(selection)
    (selection.size == CODE_LENGTH) && selection.all? do |selected_color|
      COLORS[1..-1].any? { |valid_color| selected_color == valid_color}
    end
  end

  def display_pegs(line)
    display = ''
    line.each do |peg|
      display += "| #{"O".colorize(peg)} "
    end
    display += "|"
  end

  def display_result(result)
    "#{result[:correct_position].to_s.green} " +
      "#{result[:incorrect_position].to_s.red}"
  end

  def display_line(line)
    " " * 4 + display_pegs(line[:guess]) + 
    " " * 4 + display_result(line[:result])
  end

  def display
    10.times { puts }
    puts " " * 4 + LINE_SEPARATOR
    @board.each { |line| puts display_line(line) }
    puts " " * 4 + LINE_SEPARATOR
    2.times { puts }
  end

  def get_selection
    begin
      puts "Enter your selection, valid colours are :"
      COLORS[1..-1].each do |valid_color|
        print "#{valid_color.to_s.colorize(valid_color)}, "
      end
      puts
      begin
        puts "Enter #{CODE_LENGTH} colours separated by spaces"
        selection = gets.chomp.split.map { |color| color.to_sym}
      end until self.valid_selection?(selection)
      puts display_pegs(selection)
      puts "Are you happy with your choice ?"
      confirm = gets.chomp
    end until confirm == "yes" || confirm == "y"
    selection
  end

  def calculate_result(guess, code)
    result = {correct_position: 0, incorrect_position: 0}
    guess = guess.dup
    code = code.dup
    CODE_LENGTH.times do |i|
      if guess[i] == code[i]
        result[:correct_position] += 1
        guess[i] = code[i] = COLORS[0]
      end
    end
    CODE_LENGTH.times do |code_index|
      CODE_LENGTH.times do |guess_index|
        if (code[code_index] != COLORS[0]) && 
           (code[code_index] == guess[guess_index])
          result[:incorrect_position] += 1
          guess[guess_index] = code[code_index] = COLORS[0]
        end
      end
    end
    result
  end

  def enter_new_guess(guess)
    @board[@round][:guess] = guess
    @board[@round][:result] = self.calculate_result(guess, @code)
  end
    

  def play_round_as_human
    self.display
    self.enter_new_guess(get_selection)
    @round += 1
  end

  def possible_guess?(guess)
    @board[0..@round-1].all? do |prev_round|
      self.calculate_result(prev_round[:guess], guess) == prev_round[:result]
    end
  end

  def play_round_as_computer
    guess = self.generate_random_pegs
    until @round == 0 || self.possible_guess?(guess)
      guess = self.generate_random_pegs
    end
    self.enter_new_guess(guess)
    self.display
    @round += 1
  end
end

new_game = Mastermind.new
begin
  puts "Enter '1' to play Mastermind, '2' to play against the computer, " + 
       "or 'quit' to exit"
  user_input = gets.chomp
  new_game.play_as_human if user_input == "1"
  new_game.play_as_computer if user_input == "2"
end until  user_input == "quit" || user_input == "q"