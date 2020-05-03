require 'colorize'

class Mastermind
  COLORS = [:black, :blue, :green, :magenta, :red, :light_yellow, :light_black]
  CODE_LENGTH = 4
  LINE_SEPARATOR = '+' * (CODE_LENGTH * 4 + 1)
  NUMBER_OF_ROUNDS = 12

  def initialize
    @guesses = []
    @round = 0
    NUMBER_OF_ROUNDS.times do
      @guesses << Array.new(CODE_LENGTH, COLORS[0])
    end
  end

  def play
    self.generate_code
    begin
      self.play_round
    end until @round == NUMBER_OF_ROUNDS
  end

  private

  def generate_code
    @code = []
    CODE_LENGTH.times { @code << COLORS[rand(1..COLORS.length-1)] }
  end

  def display_line(line)
    line.each do |peg|
      print "| #{"O".colorize(peg)} "
    end
    puts "|"
  end

  def display
    3.times { puts }
    puts LINE_SEPARATOR
    @guesses.each { |line| display_line(line)}
    puts LINE_SEPARATOR
  end

  def get_guess
    begin
      guess = []
      puts "Enter your guess, valid colours are :"
      COLORS[1..-1].each do |valid_color|
        print "#{valid_color.to_s.colorize(valid_color)}, "
      end
      puts
      CODE_LENGTH.times do |i|
        guess << COLORS[0]
        begin
          puts "Enter colour n° #{i+1}"
          guess[i] = gets.chomp.to_sym
        end until COLORS[1..-1].any? { |valid_color| guess[i] == valid_color}
      end
      display_line(guess)
      puts "Are you happy with your choice ?"
      confirm = gets.chomp
    end until confirm == "yes"
    guess
  end

  def play_round
    self.display
    @guesses[@round] = self.get_guess
    @round += 1
  end
end

new_game = Mastermind.new
new_game.play