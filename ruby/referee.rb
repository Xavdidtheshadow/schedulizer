class Referee
  attr_accessor :name
  attr_accessor :team
  attr_accessor :team_name
  attr_accessor :stars
  attr_accessor :streak
  attr_accessor :pool #char
  attr_accessor :hr
  attr_accessor :sr
  attr_accessor :ar
  attr_accessor :cert_str

  def initialize(team, name, cert, stars)
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
    @cert_str = ''
    certify(cert)
    # mongo query for stars
    # db.stars.find({"to": id}).to_a.size
    # need something about cert level

  end

  # used for puts array 
  def inspect
    "#{@name}(#{@pool})(#{@stars})(#{@cert_str})"
  end

  # used for puts game
  def to_s
    "#{@name}(#{@pool})(#{@stars})(#{@cert_str})"
  end

  def <=>(o)
    @stars <=> o.stars
  end

  def certify(s)
    @hr = s['h'] ? true : false
    @sr = s['s'] ? true : false
    @ar = s['a'] ? true : false

    certs = [@hr, @sr, @ar]
    labels = 'HSA'
    for i in 0..2
      @cert_str += labels[i] if certs[i]
    end
  end
end