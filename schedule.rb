require './referee'
require './game'
require 'pp'

# don't build this file, it doesn't do anything

class Schedule
  def initialize
    @teams = {}
    @games = []
    @refs = []
    @possibilities = {}
    @wide = {}
    @fname = 'au'

    read_games
    read_refs
    read_teams
  end

  def read_games
    f = open("#{@fname}_games.txt")
    round = 0
    pitch = 0
    round_games = []
    f.each do |line|
      # this is too flimsy
      if line[0] != '-'
        line = line.chomp.split('|')
        g = Game.new(line[0], line[1])
        g.round = round
        g.pitch = pitch
        round_games << g
        pitch += 1
      else
        @games << round_games
        round_games = []
        round += 1
        pitch = 0
      end
    end
    @num_rounds = round
  end    

  def read_refs
    f = open("#{@fname}_refs.txt")
    f.each do |line|
      line = line.chomp.split('|')
      # if line.size == 3
        # r = Referee.new(line[0],line[1],line[2])
      # else
      r = Referee.new(line[0],line[1],line[2])
      # end
      @refs << r
    end
    # puts "Read in #{@refs.size} referees"
  end

  def read_teams
    f = open("#{@fname}_teams.txt")
    f.each do |line|
      line = line.chomp.split('|')
      @teams[line[0]] = line[1]
    end
  end

  def find_possibilities
    @num_rounds.times do |round|
      busy = []

      @games[round].each do |g|
        busy += @refs.select{|r| g.playing(r.team)}
        # this is broken now it's in a separate place
        # busy.map{|r| r.streak = 0}
      end

      @possibilities[round] = @refs - busy
    end
      
    # wide availability stuff
    @num_rounds.times do |round|
      wide = []
      # pull out anyone who's playing before or after this round
      if round > 0
        @games[round - 1].each do |g|
          wide += @possibilities[round].select{|ref| g.playing(ref.team)}
        end
      end

      if round < @num_rounds - 1
        @games[round + 1].each do |g|
          wide += @possibilities[round].select{|ref| g.playing(ref.team)}
        end
      end

      @possibilities[round] -= wide
      @wide[round] = wide

      @possibilities[round].sort_by! {|ref| [ref.pool == "X" ? 0 : 1,ref.stars,ref.name]}
      @wide[round].sort_by! {|ref| [ref.pool == "X" ? 0 : 1,ref.stars,ref.name]}
    end
    # pp @possibilities
    # pp @wide
  end

  def assign_refs
    find_possibilities
    
    @num_rounds.times do |round|
      @games[round].each do |g|
        rotation = 0
        if not @possibilities[round].empty?
          while not @possibilities[round].empty? and @possibilities[round].last.streak > 2
            # gotta take a break
            @possibilities[round].last.streak = 0
            @possibilities[round].pop
          end
          # only do this block if we're worrying about reffing your own pool
          while @possibilities[round].last.pool == g.pool
            # can't ref your own pool! 
            # pick someone else! rotate & unrotate?
            @possibilities[round].rotate! -1
            rotation += 1
            break if rotation == @possibilities[round].size 
          end
          g.hr = @possibilities[round].pop
          g.hr.streak += 1 if not g.hr.nil?

          if rotation > 0
            @possibilities[round].rotate! rotation
          end
        else
          break
        end
      end
      @possibilities[round].map{|r| r.streak = 0}
    end
  end

  def print_games
    @num_rounds.times do |round|
      puts "---------------"
      puts "Round: #{round}"
      puts "---------------"
      @games[round].each do |g|
        puts g
        # find_refs(round, g)
      end
      # puts "---------------"
      puts "Also available for round #{round}: #{@possibilities[round]}"
      puts "Available before and after round #{round}: #{@wide[round]}"
      puts "---------------"
      puts ''
    end
  end

  def double_check
    @games.each do |round|
      round.each do |g|
        if g.hr.nil?
          puts "#{g.round}:#{g.pitch} is invalid"
        end
      end
    end
  end
end