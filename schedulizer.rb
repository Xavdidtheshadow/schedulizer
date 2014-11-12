# Main!

require './schedule'
s = Schedule.new

s.assign_refs
s.print_games
s.double_check