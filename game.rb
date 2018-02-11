require 'colorize' #gem install colorize
class Game
  attr_accessor :board, :user_name

  def initialize
    #Empty 3x3 board
    self.board = {
			"1"=>" ", "2"=>" ","3"=>" ",
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
    @user_wins_count = 0
    @cpu_wins_count = 0
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
    puts @user_wins_count
    puts ""
    puts "      #{self.user_name} = #{@user_value.red} Wins: #{@user_wins_count}"
    puts "      #{@cpu_name} = #{@cpu_value.blue} Wins: #{@cpu_wins_count}"
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
    pos = rand(2-10).to_s
    if isValidOption(pos)
      if self.board[pos] == " "
        self.board[pos] = @cpu_value
        checkGame(true)
      else 
        cpuTurn
      end
    else
      cpuTurn
    end
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
	    invalidInput unless input == 'exit'
	  end
  end

  def isOptionComplete(option, value)
    result = 0

    option.each do |pos|
      if self.board[pos] == value
        result+=1
      end
    end

    return result == 3
  end

  def checkIfBoardIsFull
    result = 0
    #check if all the positions in the board are taken
    self.board.each do |key, val|
      if val != " "
        result +=1
      end
    end

    return result == 9
  end
  
  def checkGame(isUserNextMove)
    @win_options.each do |option|
      #check if user wins 
      is_user_winner = isOptionComplete(option, @user_value)
      if is_user_winner
        @is_game_finished = true
        @user_wins_count += 1
        finishGame(@user_name)
        break
      else
        #check if cpu wins
        is_cpu_winner = isOptionComplete(option, @cpu_value)
        if is_cpu_winner
          @is_game_finished = true
          @cpu_wins_count +=1
          finishGame(@cpu_name)
          break
        end
      end
    end

    if !@is_game_finished
      if checkIfBoardIsFull
        @is_game_finished = true
        puts "draw"
      else
        if isUserNextMove
          displayBoard
          userTurn(false)
        else 
          displayBoard
          cpuTurn
        end
      end
    end
  end

  def finishGame(winner)
    displayBoard
    puts "#{winner} is the winner!"
    puts "Would you like to play again? (yes/no)"
    STDOUT.flush
    play_again = gets.chomp
    if play_again == 'yes'
      cleanBoard
      start(false)
    else
      puts "Thanks for playing!"
    end
  end

  def cleanBoard
    @available_options.each do |key|
      self.board[key] = " "
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

  def start(is_new_game)
    system "clear"
    if(is_new_game)
      displayWelcomeTitle
      getUserInfo
    end
    displayBoard
    userTurn(false)
  end
end

newGame = Game.new()
newGame.start(true)


