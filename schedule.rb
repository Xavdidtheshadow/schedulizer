require './referee'
require './game'
require 'pp'

class Schedule
  def initialize
    @games = []
    @refs = []
    read_games
    read_refs
  end

  def read_games
    f = open('games.txt')
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
    f = open('refs.txt')
    f.each do |line|
      line = line.chomp.split('|')
      r = Referee.new(line[0],line[1])
      @refs << r
    end
    # puts "Read in #{@refs.size} referees"
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
    end
  end

  def assign_refs
    possibilities = {}
    @num_rounds.times do |round|
      busy = []

      @games[round].each do |g|
        busy += @refs.select{|r| g.playing(r.team)}
        busy.map{|r| r.streak = 0}
      end

      possibilities[round] = @refs - busy
      possibilities[round].sort_by! {|r| [r.pool == "X" ? 0 : 1,r.stars,r.name]}
      puts "available for round #{round}: #{possibilities[round]}"


      @games[round].each do |g|
        rotation = 0
        if not possibilities[round].empty?
          while not possibilities[round].empty? and possibilities[round].last.streak > 2
            # gotta take a break
            # puts "resetting #{possibilities[round].last}"
            possibilities[round].last.streak = 0
            possibilities[round].pop
          end
          while possibilities[round].last.pool == g.pool
            # can't ref your own pool! 
            # pick someone else! rotate & unrotate?
            possibilities[round].rotate! -1
            rotation += 1
          end
          g.hr = possibilities[round].pop
          g.hr.streak += 1 if not g.hr.nil?

          if rotation > 0
            possibilities[round].rotate! rotation
          end
        else
          break
        end
      end
      possibilities[round].map{|r| r.streak = 0}

      puts "---------------"
      puts "Round: #{round}"
      puts "---------------"
      @games[round].each do |g|
        puts g
        # find_refs(round, g)
      end

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

  def score_refs

  end
end