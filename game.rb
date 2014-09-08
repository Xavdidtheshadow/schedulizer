class Game
  attr_accessor :round

  def initialize(a, b, p)
    @team_a = a
    @team_b = b
    @hr = nil
    @sr = nil
    @ar1 = nil
    @ar2 = nil
    # could maybe take pitch info - need to make a spec
    @pitch = p
  end

  def display
    puts "Game between #{@team_a} and #{@team_b} on pitch #{@pitch}"
  end
end