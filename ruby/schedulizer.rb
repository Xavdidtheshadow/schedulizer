# Main!

require './schedule'
s = Schedule.new

s.assign_refs
s.print_games
# s.print_csv
s.double_check