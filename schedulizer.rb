# Main!

require './schedule'
s = Schedule.new(12, 3, 6)

s.read_games
s.read_refs
s.check_availability
s.print_games