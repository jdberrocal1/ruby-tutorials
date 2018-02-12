require_relative "../lib/Player.rb"

describe Player do 
  before(:each) do
    @player = Player.new("playerName","playerTitle","X")
  end
  context "When testing the Player class" do 
     
     it "should initialize the player values" do  
        expect(@player.name).to eq "playerName"
        expect(@player.title).to eq "playerTitle"
        expect(@player.value).to eq "X"
        expect(@player.wins_count).to eq 0
     end

     it "should add a winner count when call addWinningGame method" do 
        expect(@player.wins_count).to eq 0
        @player.addWinningGame
        expect(@player.wins_count).to eq 1
     end
     
  end
end