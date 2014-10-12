class Referee
  attr_accessor :name
  attr_accessor :team
  attr_accessor :stars
  attr_accessor :streak

  # def <=>(anOther)
    # stars <=> anOther.stars
  # end

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
    # mongo query for stars
    # db.stars.find({"to": id}).to_a.size
    # need something about cert level
  end

  # used for puts array of refs?!
  def inspect
    "#{@name}(#{@team})(#{@stars})(#{@streak})"
  end

  # used for puts game
  def to_s
    "#{@name}(#{@team})(#{@stars})(#{@streak})"
  end

  def <=>(o)
    @stars <=> o.stars
  end
end