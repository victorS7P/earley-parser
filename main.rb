require_relative "cfl"

terminals = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "-", "*", "/", "^", "(", ")"]

rules = {
  :S => ["S+I", "S-I", "N", "I", "M"],
  :I => ["I*M", "I/M", "N", "M"],
  :M => ["M^N", "N"],
  :N => ["BA", "A", "(S)", "B(S)"],
  :A => ["AA", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
  :B => ["BB", "-"]
}

# terminals = ["1", "2", "3", "4", "+", "*"]

# rules = {
#   :S => ["S+M", "M"],
#   :M => ["M*T", "T"],
#   :T => ["1", "2", "3", "4"]
# }

initial_symbol = "S"

cfl = CFL.new(terminals, rules, initial_symbol)

pp "true = #{cfl.recognize("9^(1*-2+3)-3/(6+3)")}"
pp "true = #{cfl.recognize("(1+4)*2^4")}"
pp "true = #{cfl.recognize("7/(1-3)")}"
pp "true = #{cfl.recognize("9^(1*6/2+4)")}"
pp "true = #{cfl.recognize("2+4^-4/4")}"
puts "\n"
pp "false = #{cfl.recognize("^2+4")}"
pp "false = #{cfl.recognize("9*2+")}"
pp "false = #{cfl.recognize("9++3")}"
pp "false = #{cfl.recognize("()*3")}"
pp "false = #{cfl.recognize("(3+3")}"

# pp cfl.recognize("9^(1*-2+3)-3/(6+3)")
# pp cfl.recognize("3+1)")
