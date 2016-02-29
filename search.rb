require 'unicode'
require_relative 'parser'


while (1)
  puts 'Input boolean queries or type \'exit\' to exit'
  str = gets.chomp.encode('UTF-8')
  if str.empty?
    next
  end
  break if str == 'exit'
  rpn = RPNExpression.from_infix(str)
  calc = RPNParser.new("index.dat")

  p calc.evaluate(rpn).sort
end