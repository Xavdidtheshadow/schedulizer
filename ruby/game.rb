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
    # @pitch = ['A','B','C','D'].index(@pool) % 2
    # could maybe take pitch info - need to make a spec
  end

  def playing?(teams)
    # team is now an array of teams
    p = false
    teams.each do |team|
      p = true if (team['code'] == @team_a or team['code'] == @team_b)
    end
    # puts "#{teams} looking for #{@team_a} or #{@team_b}. result: #{p}"
    p
  end

  def inspect
    "INSPECT Round #{@round}\nPitch #{@pitch}\nPool #{@pool}\n#{@team_a_name} vs #{@team_b_name}\nHR: #{@hr}\nSR: #{@sr}\nAR1: #{@ar1}\nAR2: #{@ar2}\n\n"
  end

  def to_s
    "Round #{@round}\nPitch #{@pitch}\nPool #{@pool}\n#{@team_a} vs #{@team_b}\nHR: #{@hr}\nSR: #{@sr}\nAR1: #{@ar1}\nAR2: #{@ar2}\n\n"
  end

  def to_csv
    [@round, @pitch, @team_a, @team_b, @hr, @sr, @ar1, @ar2, '', '']
  end
end