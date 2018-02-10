require 'colorize' #gem install colorize
class Game
  attr_accessor :board, :user_name

  def initialize
    #Empty 3x3 board
    self.board = {
			"1"=>"O", "2"=>" ","3"=>" ",
			"4"=>" ", "5"=>" ", "6"=>" ",
			"7"=>" ", "8"=>" ", "9"=>" "
    }

    #available selectable options 
    @available_options = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

    #8 different possible winning combinations
		@win_options = [
			['1', '2', '3'],
			['4', '5', '6'],
			['7', '8', '9'],
			['1', '4', '7'],
			['2', '5', '8'],
			['3', '6', '9'],
			['1', '5', '9'],
			['7', '5', '3']
    ]
    # variable to control game status
    @is_game_finished = false
    @cpu_name = "R2D2"
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
    puts "      #{@cpu_name} = #{@cpu_value.blue}"
  end

  def printValue(value)
    return value == "X" ? value.red : value.blue
  end

  def displayBoard()
    b = self.board
    displayUser
    puts ""
    puts "      ╔═════╦═════╦═════╗"
    puts "      ║     ║     ║     ║"
    puts "      ║  #{printValue(b["1"])}  ║  #{printValue(b["2"])}  ║  #{printValue(b["3"])}  ║"
    puts "      ║     ║     ║     ║"
    puts "      ║═════╬═════╬═════╣"
    puts "      ║     ║     ║     ║"
    puts "      ║  #{printValue(b["4"])}  ║  #{printValue(b["5"])}  ║  #{printValue(b["6"])}  ║"
    puts "      ║     ║     ║     ║"
    puts "      ║═════╬═════╬═════╣"
    puts "      ║     ║     ║     ║"
    puts "      ║  #{printValue(b["7"])}  ║  #{printValue(b["8"])}  ║  #{printValue(b["9"])}  ║"
    puts "      ║     ║     ║     ║"
    puts "      ╚═════╩═════╩═════╝"
    puts ""
  end

  def isValidOption(opt)
    return @available_options.include? opt
  end

  def cpuTurn
    #make a cpu movement
    #after that call checkGame(true)
  end

  def userTurn(isCalledAfterWrongInput)
    if !isCalledAfterWrongInput
      puts "#{user_name}, please select a position:"
    end

		STDOUT.flush
    pos = gets.chomp

    if isValidOption(pos)
      if self.board[pos] == " "
        self.board[pos] = @user_value
        checkGame(false)
      else 
        invalidMove
      end
    else
	    invalidInput unless pos == 'exit'
	  end
  end

  def checkGame(isUserNextMove)
    #check if board have one winning option
    if isUserNextMove
      userTurn
    else 
      cpuTurn
    end
  end

  def invalidMove
    system "clear"
    displayBoard
	  puts "Ups, that position is already taken, please select a new position:"
	  userTurn(true)
	end

  def invalidInput
    system "clear"
    displayBoard
	  puts "Ups, that position does not exist, please select a new position:"
	  userTurn(true)
	end

  def start 
    displayWelcomeTitle
    getUserInfo
    displayBoard
    userTurn(false)
  end
end

newGame = Game.new()
newGame.start