require './referee'
require './game'
require 'pp'

class Schedule
  def initialize(num_teams, num_pools, num_rounds)
    # puts 'time to schedule!'
    # number of games in a day(or in pool play)
    @num_pools = num_pools
    @num_teams = num_teams
    @num_rounds = num_rounds
    @games = []
    @refs = []
    @busy = []
  end

  def read_games
    f = open('games.txt')
    round = 0
    pitch = 0
    round_games = []
    f.each do |line|
      # this is too flimsy
      if line[0] != '-'
        line = line.chomp.split('v')
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
  end    

  def read_refs
    f = open('refs.txt')
    f.each do |line|
      r = Referee.new(line.chomp)
      @refs << r
    end
    puts "Read in #{@refs.size} referees"
  end

  def print_games
    @num_rounds.times do |round|
      puts "---------------"
      puts "Round: #{round}"
      puts "---------------"
      @games[round].each do |g|
        g.display
        find_refs(round, g)
      end
      puts "available for this round: #{@refs - @busy}"
      @busy = []
    end
  end

  def find_refs(round, game)

    @refs.each do |ref|
      if game.playing(ref.team)
        @busy << ref
      end
    end
  end

end

# ABC

# DEF 