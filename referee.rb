class Referee
  attr_accessor :name
  attr_accessor :team
  attr_accessor :stars

  # def <=>(anOther)
    # stars <=> anOther.stars
  # end

  def initialize(id)
    puts 'New referee!'
    # call to refdevelopment.com/info/ID
    # response = open('')
    # @name = response['name']
    # @team = response['team']
    # mongo query for stars
    # db.stars.find({"to": uid}).to_a.size
    # @stars = response['stars']
    # need something about cert level
  end
end