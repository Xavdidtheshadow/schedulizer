class Referee
  attr_accessor :name
  attr_accessor :team
  attr_accessor :stars

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
    # mongo query for stars
    # db.stars.find({"to": id}).to_a.size
    # need something about cert level
  end

  # used for puts array of refs?!
  def inspect
    "#{@name}(#{@team})(#{stars})"
  end

  # used for puts game
  def to_s
    "#{@name}(#{@team})(#{stars})"
  end

  def <=>(o)
    @stars <=> o.stars
  end
end