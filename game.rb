class Game
  attr_accessor :round
  attr_accessor :pitch
  attr_accessor :pool #char
  attr_accessor :hr
  attr_accessor :sr
  attr_accessor :ar1
  attr_accessor :ar2
  attr_accessor :team_a
  attr_accessor :team_a_name
  attr_accessor :team_b
  attr_accessor :team_b_name

  def initialize(a, b)
    @team_a = a
    @team_b = b
    @pool = @team_a[0]
    @pitch = ['A','B','C'].index(@pool)
    # could maybe take pitch info - need to make a spec
  end

  def playing(team)
    team == @team_a or team == @team_b
  end

  def inspect
    "INSPECT Game between #{@team_a} and #{@team_b} on pitch #{@pitch}"
  end

  def to_s
    "Round #{@round}\nPitch #{@pitch}\n#{@team_a_name} vs #{@team_b_name}\nHR: #{@hr}\nSR: #{@sr}\nAR: #{@ar}\n\n"
  end
end