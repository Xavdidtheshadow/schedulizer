require './referee'
require './game'
require 'pp'

Rank = Struct.new(:name, :score) do 
  def <=>(o)
    self[:score] <=> o[:score]
  end
end

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

  def check_availability
    possibilities = {}
    @num_rounds.times do |round|
      busy = []

      @games[round].each do |g|
        busy += @refs.select{|r| g.playing(r.team)}
      end

      possibilities[round] = @refs - busy
      puts "available for round #{round}: #{possibilities[round].sort}"

      @games[round].each do |g|
        if not possibilities[round].empty?
          g.hr = possibilities[round].pop
        else
          break
        end
      end
    end
  end

  def score_refs

  end
end