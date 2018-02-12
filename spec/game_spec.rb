require_relative "../lib/Game.rb"
$available_jedi_names = ["Luke Skywalker", "Yoda", "Mace Windu", "Plo Koon", "Obi-Wan Kenobi", "Kit Fisto"]
$available_sith_names = ["Darth Vader", "Dooku", "Darth Sidious", "Darth Maul", "Kylo Ren", "Grievous"]

describe Game do 
  before(:each) do
    @game = Game.new() 
  end
  context "When testing the Game class" do 
     it "should initialize the Game values" do 
        expect(@game.board).to be_truthy
     end
     
     it "should display welcome message on console when call displayWelcomeTitle method" do 
        expect do
          @game.displayWelcomeTitle
        end.to output("*******************************\n*          Welcome            *\n*    Star Wars Tic Tac Toe    *\n*******************************\n").to_stdout
     end

     it "should return a name when call getCpuName method" do 
        cpuName = @game.getCpuName(true)
        isValidName = $available_jedi_names.include? cpuName
        expect(isValidName).to be_truthy
     end
     
     it "should return a name when call getCpuName method" do 
        cpuName = @game.getCpuName(false)
        isValidName = $available_sith_names.include? cpuName
        expect(isValidName).to be_truthy
     end
     
     it "should return true when call isValidOption method with a valid option" do 
        isValidOption = @game.isValidOption("2")
        expect(isValidOption).to be_truthy
     end

     it "should return false when call isValidOption method with a invalid option" do 
        isValidOption = @game.isValidOption("0")
        expect(isValidOption).to be_falsy
     end
  end
end