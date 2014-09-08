require './referee'
require './game'

class Schedule
  def initialize(num_pools, num_teams, num_rounds)
    # puts 'time to schedule!'
    # number of games in a day(or in pool play)
    @num_teams = num_teams
    @num_pools = num_pools
    @num_rounds = num_rounds
    @games = []
    @refs = []
  end

  def read_games
    f = open('games.txt')
    round = 1
    pitch = 1
    f.each do |line|
      if line[0] != '-'
        line = line.split('')
        g = Game.new(line[0], line[2], pitch)
        g.round = round
        @games << g
        pitch += 1
      else
        round += 1
        pitch = 1
      end
    end
  end    

  def read_refs
    f = open('refs.txt')
    f.each do |line|
      r = Ref.new(line)
      @refs << r
    end
    puts "Read in #{@refs.size} referees"
  end

  def print_games
    @num_rounds.times do |round|
      puts "---------------"
      puts "Round: #{round+1}"
      puts "---------------"
      @games.each do |g|
        if g.round == round + 1
          g.display
        end
      end
    end
  end


end

# ABC

# DEF 