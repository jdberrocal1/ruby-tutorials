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

    # variable to control game status
    @is_game_finished = false
    @player = nil
    @cpu = nil
    @boardSize = 3
  end

  def displayWelcomeTitle
    puts "*******************************"
    puts "*          Welcome            *"
    puts "*    Star Wars Tic Tac Toe    *"
    puts "*******************************"
  end

  #take info from console
  def getUserInfo
    puts "What is your name?"
		STDOUT.flush
    player_name = gets.chomp
    getUserRole(player_name)
    system "clear"
  end

  #take info from console and define who is player role
  def getUserRole(player_name)
    puts "Please select your playing Role"
    puts "Sith ( O )"
    puts "Jedi ( X )"
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
      getUserRole(player_name)
    end
  end

  #return an available name for cpu depending on player role
  def getCpuName(is_cpu_jedi)
    if is_cpu_jedi
      return @available_jedi_names.sample
    else
      return @available_sith_names.sample
    end
  end

  #display player's info 
  def displayUser
    puts ""
    puts "   #{@player.title} #{@player.name} = #{printValue(@player.value)} Wins: #{@player.wins_count}"
    puts "   #{@cpu.title} #{@cpu.name} = #{printValue(@cpu.value)} Wins: #{@cpu.wins_count}"
  end

  def printValue(value)
    return value == "O" ? value.red : value.blue
  end

  #prints board on console
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

  #check if given option is valid
  def isValidOption(opt)
    return @available_options.include? opt
  end

  # return all the available positions
  def getAvailableMovements()
    available_movements = []
    self.board.each do |key, value|
      if value == " "
        available_movements.push(key)
      end
    end
    return available_movements
  end

  # get a random position and play on it
  def cpuTurn
    available_movements = getAvailableMovements
    pos = available_movements.sample
    self.board[pos] = @cpu.value
    checkGame(true)
  end

  # take the movement from user validate the selectionand play on it 
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

  # check if board is complete
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

  #check if there is a winnig column on board
  def checkVertical(board, value, boardSize)
    index = 1
    isValueEqual = true
    while index <= boardSize
      verticalIndex = index
      limit = (boardSize * boardSize) - boardSize + index
      isValueEqual = true
      while verticalIndex <= limit
        isValueEqual = board[verticalIndex.to_s] == value
        if !isValueEqual
          break
        end
        verticalIndex +=boardSize
      end
      if isValueEqual 
        return isValueEqual
      end
      index += 1
    end
    
    return isValueEqual
  end
  
   #check if there is a winnig row on board
  def checkHorizontal(board, value, boardSize)
    isValueEqual = true
    index = 1
    limit = (boardSize * boardSize) - boardSize + index
    while index <= limit
      isValueEqual = true
      horizontalIndex = index
      horizontalLimit = index + boardSize - 1
      while horizontalIndex <= horizontalLimit
        isValueEqual = board[horizontalIndex.to_s] == value
        if !isValueEqual
          break
        end
        horizontalIndex += 1
      end
      if isValueEqual 
        return isValueEqual
      end
      index += boardSize
    end
  
    return isValueEqual
  end
  
  #check if there is a winnig diagonal on board
  def checkFirstDiagonal(board, value, boardSize)
    index = 1
    isValueEqual = true
    diagonalLimit = boardSize * boardSize
    while index <= diagonalLimit
      isValueEqual = board[index.to_s] == value
      if !isValueEqual 
        break
      end
      index += boardSize + 1
    end
    
    return isValueEqual
  end
  
  #check if there is a winnig diagonal on board
  def checkSecondDiagonal(board, value, boardSize)
    index = boardSize
    isValueEqual = true
    diagonalLimit = (boardSize * boardSize) - boardSize + 1
    while index <= diagonalLimit
      isValueEqual = board[index.to_s] == value
      if !isValueEqual 
        break
      end
      index += boardSize - 1
    end
    
    return isValueEqual
  end

  # take the player value and evaluate all the posible winning options
  def isPlayerWinner(player)
    return checkHorizontal(self.board, player.value, @boardSize) || checkVertical(self.board, player.value, @boardSize) || checkFirstDiagonal(self.board, player.value, @boardSize) || checkSecondDiagonal(self.board, player.value, @boardSize)
  end
  
  #check if there is a winner player
  def checkGame(isUserNextMove)
    is_user_winner = isPlayerWinner(@player)
    if is_user_winner
      @is_game_finished = true
      @player.addWinningGame
      finishGame(@player, false)
    else
      is_cpu_winner = isPlayerWinner(@cpu)
      if is_cpu_winner
        @is_game_finished = true
        @cpu.addWinningGame
        finishGame(@cpu, false)
      end
    end

    if !@is_game_finished
      if checkIfBoardIsFull
        @is_game_finished = true
        finishGame(nil, true)
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

  #take the winner player and print result
  def finishGame(winner, isDraw)
    displayBoard
    if !isDraw
      puts "***** #{winner.title} #{winner.name} is the winner! *****"
    else
      puts "***** Draw: there is no winner! *****"
    end
    puts " "
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

  #clean the board for future games
  def cleanBoard
    @available_options.each do |key|
      self.board[key] = " "
    end
  end

  # display on console the error and try again
  def invalidMove
    system "clear"
    displayBoard
	  puts "Ups, that position is already taken, please select a new position:"
	  userTurn(true)
	end

  # display on console the error and try again
  def invalidInput
    system "clear"
    displayBoard
	  puts "Ups, that position does not exist, please select a new position:"
	  userTurn(true)
  end

  # define randomly who is the first player move
  def firstMove
    user_starts = true #rand() > 0.5
    displayBoard
    if user_starts
      userTurn(false)
    else
      cpuTurn
    end
  end

  #start point
  def start(is_new_game)
    system "clear"
    if(is_new_game)
      displayWelcomeTitle
      getUserInfo
    end
    firstMove
  end

end


