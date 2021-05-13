require_relative "cfl"

initial_symbol = "S"
terminals = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "-", "*", "/", "^", "(", ")"]
rules = {
  :S => ["S+I", "S-I", "N", "I", "M"],
  :I => ["I*M", "I/M", "N", "M"],
  :M => ["M^N", "N"],
  :N => ["BA", "A", "(S)", "B(S)"],
  :A => ["AA", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"],
  :B => ["BB", "-"]
}

cfl = CFL.new(terminals, rules, initial_symbol)

puts "9^(1*-2+3)-3/(6+3)"
puts "= #{cfl.recognize("9^(1*-2+3)-3/(6+3)")}"
puts "\n"

puts "(1+4)*2^4"
puts "= #{cfl.recognize("(1+4)*2^4")}"
puts "\n"

puts "7/(1-3)"
puts "= #{cfl.recognize("7/(1-3)")}"
puts "\n"

puts "9^(1*6/2+4)"
puts "= #{cfl.recognize("9^(1*6/2+4)")}"
puts "\n"

puts "2+4^-4/4"
puts "= #{cfl.recognize("2+4^-4/4")}"
puts "\n"

puts "^2+4"
puts "= #{cfl.recognize("^2+4")}"
puts "\n"

puts "9*2+"
puts "= #{cfl.recognize("9*2+")}"
puts "\n"

puts "9++3"
puts "= #{cfl.recognize("9++3")}"
puts "\n"

puts "()*3"
puts "= #{cfl.recognize("()*3")}"
puts "\n"

puts "(3+3"
puts "= #{cfl.recognize("(3+3")}"
