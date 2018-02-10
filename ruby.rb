board = ["X", "O", "X", "O", "X", "X", "O", "X", "X"]

def display_board(b)
  puts "╔═════╦═════╦═════╗"
  puts "║     ║     ║     ║"
  puts "║  #{b[0]}  ║  #{b[1]}  ║  #{b[2]}  ║"
  puts "║     ║     ║     ║"
  puts "║═════╬═════╬═════╣"
  puts "║     ║     ║     ║"
  puts "║  #{b[3]}  ║  #{b[4]}  ║  #{b[5]}  ║"
  puts "║     ║     ║     ║"
  puts "║═════╬═════╬═════╣"
  puts "║     ║     ║     ║"
  puts "║  #{b[6]}  ║  #{b[7]}  ║  #{b[8]}  ║"
  puts "║     ║     ║     ║"
  puts "╚═════╩═════╩═════╝"
end

display_board(board)