require 'colorize'
class Game
  attr_accessor :board, :user_name, :cpu_name

  def initialize
    self.board = ["X", "O", " ", " ", " ", " ", " ", " ", " "]
    self.cpu_name = "R2D2"
    @cpu_value = "O"
    @user_value = "X"
  end

  def displayWelcomeTitle
    puts "*******************************"
    puts "*          Welcome            *"
    puts "*        Tic Tac Toe          *"
    puts "*******************************"
  end

  def getUserInfo
    puts "What is your name?"
		STDOUT.flush
    self.user_name = gets.chomp
    system "clear"
  end

  def displayUser
    puts ""
    puts "      #{self.user_name} = #{@user_value.red}"
    puts "      #{self.cpu_name} = #{@cpu_value.blue}"
  end

  def displayBoard(b)
    puts ""
    puts "      ╔═════╦═════╦═════╗"
    puts "      ║     ║     ║     ║"
    puts "      ║  #{b[0].red}  ║  #{b[1].blue}  ║  #{b[2]}  ║"
    puts "      ║     ║     ║     ║"
    puts "      ║═════╬═════╬═════╣"
    puts "      ║     ║     ║     ║"
    puts "      ║  #{b[3]}  ║  #{b[4]}  ║  #{b[5]}  ║"
    puts "      ║     ║     ║     ║"
    puts "      ║═════╬═════╬═════╣"
    puts "      ║     ║     ║     ║"
    puts "      ║  #{b[6]}  ║  #{b[7]}  ║  #{b[8]}  ║"
    puts "      ║     ║     ║     ║"
    puts "      ╚═════╩═════╩═════╝"
    puts ""
  end

  def start 
    displayWelcomeTitle
    getUserInfo
    displayUser
    displayBoard(self.board)
  end
end

newGame = Game.new()
newGame.start