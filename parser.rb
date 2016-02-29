require 'unicode'
class String
  #methods for enabling unicode downcase and upcase
  def downcase
    Unicode::downcase(self)
  end
end

class Array
  #redefining boolean operators for arrays of documents
  def and(operand)
    self & operand
  end

  def or(operand)
    self | operand
  end

  def not(operand)
    operand - self
  end
end

#we get infix expression and convert it into RPN
class RPNExpression

  # Set up the table of known operators
  Operator = Struct.new(:precedence, :associativity)
  class Operator
    def left_associative?; associativity == :left; end
    def <(other)
      if left_associative?
        precedence <= other.precedence
      else
        precedence < other.precedence
      end
    end
  end

  Operators = {
      "and" => Operator.new(2, :left),
      "or" => Operator.new(2, :left),
      "not" => Operator.new(3, :right),
  }

  # create a new object
  def initialize(str)
    @expression = str
  end
  attr_reader :expression

  def self.from_infix(expression)
    rpn_expr = []
    op_stack = []
    tokens = expression.split
    until tokens.empty?
      term = tokens.shift

      if Operators.has_key?(term)
        op2 = op_stack.last
        if Operators.has_key?(op2) and Operators[term] < Operators[op2]
          rpn_expr << op_stack.pop
        end
        op_stack << term

      elsif term == "("
        op_stack << term

      elsif term == ")"
        until op_stack.last == "("
          rpn_expr << op_stack.pop
        end
        op_stack.pop

      else
        rpn_expr << term
      end
    end
    until op_stack.empty?
      rpn_expr << op_stack.pop
    end
    obj = self.new(rpn_expr.join(" "))
    obj.to_s
  end

  def to_s
    expression
  end
end

#parse RPN expression and evaluate it
class RPNParser

  def initialize(filename)
    @data = Marshal.load open(filename)
  end

  def evaluate(expression)
    expression = expression.split
    operands = []
    evaluation = []

    expression.each do |x|
      case x
        when "and", "or"
          operands = evaluation.pop(2)
          evaluation.push(operands[0].send(x, operands[1]))
        when "not"
          operands = evaluation.pop
          docs = @data.values.max[0]
          evaluation.push(operands.send(x, (1..docs).to_a))
        when /[A-Za-zА-Яа-я0-9]/
          @data[x.downcase].nil? ? evaluation.push([]) : evaluation.push(@data[x.downcase])
      end
    end
    evaluation.pop
  end
end