class Referee
  attr_accessor :name
  attr_accessor :team
  attr_accessor :stars
  attr_accessor :streak
  attr_accessor :pool #char

  def initialize(team, name)
    # puts 'New referee!'
    # call to refdevelopment.com/info/ID
    # response = open('')
    # @name = response['name']
    # @team = response['team']
    @name = name
    @team = team
    @stars = rand(1..10)
    @streak = 0
    @pool = @team[0]
    # mongo query for stars
    # db.stars.find({"to": id}).to_a.size
    # need something about cert level
  end

  # used for puts array of refs?!
  def inspect
    "#{@name}(#{@team})(#{@stars})"
  end

  # used for puts game
  def to_s
    "#{@name}(#{@team})(#{@stars})"
  end

  def <=>(o)
    @stars <=> o.stars
  end
end