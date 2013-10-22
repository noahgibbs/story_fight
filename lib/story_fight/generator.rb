require "multi_json"

module StoryFight
  class Generator
    def load_json_file(filename)
      load_json_string File.read filename
    end

    def load_json_string(s)
      load_hash MultiJson.load s
    end

    def load_hash(content)
      @symbols = content
    end

    def generate(start_symbol = "start")
      raise "Load generator first!" unless @symbols

      expr = @symbols[start_symbol]
      raise "Can't generate symbol #{start_symbol.inspect}!" unless expr

      evaluate_expr expr
    end

    protected

    def get_one_of(array)
      # Get weight of choosing each element
      weights = array.map { |elt| elt.is_a?(Array) && elt[0].is_a?(Numeric) ? elt[0] : 1.0 }

      # Figure out total weight and choose random number
      total = weights.inject(0.0, &:+)
      choice = rand * total

      (0..weights.size).each do |idx|
        # Picked this one?  Return it.
        return array[idx] if choice <= weights[idx]

        # Otherwise, cut out the weight for this choice and move on
        choice -= weights[idx]
      end

      # Didn't choose any earlier element?  Return the last one.
      return array[-1]
    end

    def evaluate_expr(expr)
      case expr
      when String
        expr[0] == ":" ? generate(expr[1..-1]) : expr
      when Array
        expr = expr[1..-1] if expr[0].is_a?(Numeric)

        if expr.size == 1 && expr[0].is_a?(String)
          return evaluate_expr expr[0]
        end

        case expr[0]
        when "one_of", "||", "any"
          evaluate_expr get_one_of(expr[1..-1])
        when "+"
          expr[1..-1].map { |e| evaluate_expr(e) }.join("")
        else
          raise "Markov doesn't know expression operator #{expr[0]}!"
        end
      else
        raise "Markov can't evaluate expression #{expr.inspect}!"
      end
    end
  end
end
