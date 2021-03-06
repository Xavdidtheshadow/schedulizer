class Referee
  attr_accessor :name
  attr_accessor :teams
  attr_accessor :requests
  attr_accessor :stars
  attr_accessor :streak
  attr_accessor :pool #char
  attr_accessor :hr
  attr_accessor :sr
  attr_accessor :ar
  attr_accessor :cert_str

  def initialize(r)
    # puts 'New referee!'
    # call to refdevelopment.com/info/ID
    # response = open('')
    # @name = response['name']
    # @team = response['team']
    @name = r['name']
    # @team = r['team'].first['code']
    # @team_name = r['team'].first['name']
    @teams = r['team']
    @requests = r['requests']
    @pool = r['team'].first['pool']
    # this is a str so that it matches what's read in from the file; could all be ints too, as long as they match
    @stars = r['score'].to_i || rand(1..6).to_s
    @streak = 0
    # @pool = @team[0]
    @cert_str = ''
    certify(r['qualifications'])
    # mongo query for stars
    # db.stars.find({"to": id}).to_a.size
    # need something about cert level
  end

  def team
    @teams.first['code']
  end

  def team_name
    @teams.first['name']
  end

  def request?(game_teams)
    # returns true if the ref requested out of one of these games
    req = false
    @requests.each do |r|
      req = true if game_teams.include? r['code']
    end
    # puts "ref requested not to ref #{@requests} so #{req} is returned for #{game_teams}"
    req
  end

  # used for puts array 
  def inspect
    "#{name}(#{team})(#{@stars})(#{@cert_str})"
  end

  # used for puts game
  def to_s
    "#{name}(#{team})(#{@cert_str})"
  end

  def <=>(o)
    @stars <=> o.stars
  end

  def certify(q)
    @hr = q[0]['status']
    @sr = q[1]['status']
    @ar = q[2]['status']

    certs = [@hr, @sr, @ar]
    labels = 'HSA'
    for i in 0..2
      @cert_str += labels[i] if certs[i]
    end
  end
end