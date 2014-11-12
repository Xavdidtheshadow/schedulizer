class Referee
  attr_accessor :name
  attr_accessor :team
  attr_accessor :stars
  attr_accessor :streak
  attr_accessor :pool #char

  def initialize(team, name, stars)
    # puts 'New referee!'
    # call to refdevelopment.com/info/ID
    # response = open('')
    # @name = response['name']
    # @team = response['team']
    @name = name
    @team = team
    # this is a str so that it matches what's read in from the file; could all be ints too, as long as they match
    @stars = stars || rand(1..6).to_s
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