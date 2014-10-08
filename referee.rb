class Referee
  attr_accessor :name
  attr_accessor :team
  attr_accessor :stars

  # def <=>(anOther)
    # stars <=> anOther.stars
  # end

  def initialize(team)
    # puts 'New referee!'
    # call to refdevelopment.com/info/ID
    # response = open('')
    # @name = response['name']
    # @team = response['team']
    @team = team
    # mongo query for stars
    # db.stars.find({"to": id}).to_a.size
    # need something about cert level
  end

  # dunno why this doesn't work
  def to_s
    "Ref #{@team}"
  end
end