require 'colorize' #gem install colorize

require_relative "Player"

class Game
  attr_accessor :board

  def initialize
    #Empty 3x3 board
    self.board = {
			"1"=>" ", "2"=>" ","3"=>" ",
			"4"=>" ", "5"=>" ", "6"=>" ",
			"7"=>" ", "8"=>" ", "9"=>" "
    }

    #available selectable options 
    @available_options = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    @available_jedi_names = ["Luke Skywalker", "Yoda", "Mace Windu", "Plo Koon", "Obi-Wan Kenobi", "Kit Fisto"]
    @available_sith_names = ["Darth Vader", "Dooku", "Darth Sidious", "Darth Maul", "Kylo Ren", "Grievous"]

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
    @player = nil
    @cpu = nil
  end

  def displayWelcomeTitle
    puts "*******************************"
    puts "*          Welcome            *"
    puts "*    Star Wars Tic Tac Toe    *"
    puts "*******************************"
  end

  def getUserInfo
    puts "What is your name?"
		STDOUT.flush
    player_name = gets.chomp
    getUserRole(player_name)
    system "clear"
  end

  def getUserRole(player_name)
    puts "Please select your playing Role"
    puts "Sith ( X )"
    puts "Jedi ( O )"
		STDOUT.flush
    user_role = gets.chomp
    if user_role.capitalize == "X" || user_role.capitalize == "O"
      is_user_jedi = user_role.capitalize == "X"
      player_title = is_user_jedi ? "Jedi Master" : "Lord Sith"
      @player = Player.new(player_name, player_title, user_role.capitalize)
      cpu_title = is_user_jedi ? "Lord Sith" : "Jedi Master"
      cpu_value = is_user_jedi ? "O" : "X"
      @cpu = Player.new(getCpuName(!is_user_jedi), cpu_title, cpu_value)
    else
      puts "Ups, that Role is not valid"
      getUserRole
    end
  end

  def getCpuName(is_cpu_jedi)
    if is_cpu_jedi
      return @available_jedi_names.sample
    else
      return @available_sith_names.sample
    end
  end

  def displayUser
    puts ""
    puts "   #{@player.title} #{@player.name} = #{@player.value.red} Wins: #{@player.wins_count}"
    puts "   #{@cpu.title} #{@cpu.name} = #{@cpu.value.blue} Wins: #{@cpu.wins_count}"
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
    puts "      ╠═════╬═════╬═════╣"
    puts "      ║     ║     ║     ║"
    puts "      ║  #{printValue(b["4"])}  ║  #{printValue(b["5"])}  ║  #{printValue(b["6"])}  ║"
    puts "      ║     ║     ║     ║"
    puts "      ╠═════╬═════╬═════╣"
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
        self.board[pos] = @cpu.value
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
      puts "#{@player.title} #{@player.name}, please select a position:"
    end

		STDOUT.flush
    pos = gets.chomp

    if isValidOption(pos)
      if self.board[pos] == " "
        self.board[pos] = @player.value
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
      is_user_winner = isOptionComplete(option, @player.value)
      if is_user_winner
        @is_game_finished = true
        @player.addWinningGame
        finishGame(@player)
        break
      else
        #check if cpu wins
        is_cpu_winner = isOptionComplete(option, @cpu.value)
        if is_cpu_winner
          @is_game_finished = true
          @cpu.addWinningGame
          finishGame(@cpu)
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
    puts "#{winner.title} #{winner.name} is the winner!"
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
  
  def firstMove
    # user_starts = rand() > 0.5
    # if user_starts
    userTurn(false)
    # else
    #   cpuTurn
    # end
  end

  def start(is_new_game)
    system "clear"
    if(is_new_game)
      displayWelcomeTitle
      getUserInfo
    end
    displayBoard
    #firstMove
    userTurn(false)
  end
end


