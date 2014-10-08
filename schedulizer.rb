# Main!

require './schedule'
s = Schedule.new(6, 2, 3)

s.read_games
s.read_refs
s.print_games