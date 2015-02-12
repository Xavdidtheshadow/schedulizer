require './referee'
require './game'
require 'pp'
require 'pry'
require 'httparty'
require 'csv'

# don't build this file, it doesn't do anything

class Schedule
  def initialize
    @teams = {}
    @games = []
    @refs = []
    @possibilities = {}
    @wide = {}
    @fname = 'we'
    # can ref up to this many games in a row
    @streak = 3

    read_teams
    read_games
    read_refs
  end

  def read_games
    f = open("#{@fname}_games.txt")
    round = 0
    pitches = ['1', '2', '3', '4']
    pitch = 0
    round_games = []
    f.each do |line|
      # this is too flimsy
      if line[0] != '-'
        line = line.chomp.split('|')
        g = Game.new(line[0], line[1])
        g.round = round
        # pool = @teams[line[0]]
        # g.team_a_name = @teams[g.team_a]
        # g.team_b_name = @teams[g.team_b]
        g.pitch = pitches[pitch % pitches.size]
        g.pool = @teams[g.team_a]
        round_games << g
        pitch += 1
      else
        @games << round_games
        round_games = []
        round += 1
      end
    end
    @num_rounds = round
  end    

  def read_refs
    refs = HTTParty.get("http://westerncup.herokuapp.com/api/people")
    refs.each do |r|
      r = Referee.new(r)
      # don't really want goalkeepers and stuff
      @refs << r if r.cert_str != ''
    end
    # @refs.each do |r|
    #   puts r.name+': '
    # end
    # exit(0)
  end

  def read_teams
    f = open("#{@fname}_teams.txt")
    f.each do |line|
      line = line.chomp.split('|')
      @teams[line[1]] = line[2]
    end
  end

  def find_possibilities
    # whether or not you can ref before/after you play
    # best setup is false, true, so that you can ref after you play, but not before
    ref_before = false
    ref_after = true

    @num_rounds.times do |round|
      busy = []

      @games[round].each do |g|
        busy += @refs.select{|r| g.playing?(r.teams)}
        # this is broken now it's in a separate place
        # busy.map{|r| r.streak = 0}
      end

      @possibilities[round] = @refs - busy
    end
      
    # wide availability stuff
    @num_rounds.times do |round|
      wide = []
      # pull out anyone who's playing before or after this round

      if ref_before
        if round > 0
          @games[round - 1].each do |g|
            wide += @possibilities[round].select{|ref| g.playing?(ref.teams)}
          end
        end
      end

      if ref_after
        if round < @num_rounds - 1
          @games[round + 1].each do |g|
            wide += @possibilities[round].select{|ref| g.playing?(ref.teams)}
          end
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
      ['hr','sr','ar1','ar2'].each do |typ|
        @games[round].each do |g|
          rotation = 0
          avail = @possibilities[round].select{|r| r.instance_variable_get("@#{typ[/\D*/]}")}
          # binding.pry
          if not avail.empty?
            # repeated if statement cause list could empty midway
            while avail.last.streak > @streak
              # gotta take a break
              avail.last.streak = 0
              avail.pop
              break if avail.empty?
            end
            break if avail.empty?
            # only do this block if we're worrying about reffing your own pool and requests
            while avail.last.pool == g.pool or avail.last.request?([g.team_a, g.team_b])
              # can't ref your own pool! 
              # pick someone else! rotate & unrotate?
              avail.rotate!(-1)
              rotation += 1
              break if rotation == avail.size 
            end
            g.instance_variable_set("@#{typ}",avail.pop)
            if not g.instance_variable_get("@#{typ}").nil?
              g.instance_variable_get("@#{typ}").streak += 1 
              @possibilities[round] -= [g.instance_variable_get("@#{typ}")]
            end
              if rotation > 0
                avail.rotate!(rotation)
              end
          else
            break
          end
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
      puts ''
      puts "Available, but playing after round #{round}: #{@wide[round]}"
      # puts "---------------"
      puts ''
    end
  end

  def print_csv
    CSV.open("#{@fname}_results.csv", 'wb+') do |csv|
      csv << ['Round', 'Pitch', 'Team A', 'Team B', 'HR', 'SR', 'AR', 'AR', 'GR', 'SC']
      @num_rounds.times do |round|
        @games[round].each do |g|
          csv << g.to_csv
        end
      end
    end
  end

  def double_check
    puts "Issues: "
    @games.each do |round|
      round.each do |g|
        if g.hr.nil? or g.sr.nil? or g.ar2.nil?
          puts "#{g.round}:#{g.pitch} is invalid"
        end
      end
    end
  end
end