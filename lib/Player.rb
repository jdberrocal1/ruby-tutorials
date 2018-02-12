class Player
  attr_accessor :name, :title, :value, :wins_count
  def initialize(name, title, value)
    self.name = name
    self.title = title
    self.value = value
    self.wins_count = 0
  end

  def addWinningGame
    self.wins_count +=1
  end
end