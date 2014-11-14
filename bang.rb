require 'pry'
require 'set'

class Rascal < Object

  class RascalList < Object::Array
    def self.[](*args)
      type = args.first.class
      raise "type mismatch" if args.any? { |x| x.class != type }
      new(args)
    end
  end

  class RascalEnum < Object::Enumerator
  end

  class RascalString < Object::String
    class RascalChar
    end
  end

  class RascalTuple < Object::Set
  end

  class RascalNil < Object::NilClass
  end

  class RascalFloat < Object::Float
  end

  class RascalFixnum < Object::Fixnum
  end

  class RascalFunc < Object::Proc
    attr_reader :signature

    def array
      @signature[:out].respond_to?(:count)
    end

    def fixnum
      @signature[:out].respond_to?(:/)
    end

    def input_args
      @signature[:input].length
    end

    def invoke(trial_test, *args)
      if trial_test
        return call(args)
      end

      if args.length != input_args
        raise "#{args.length} supplied, but #{input_args} needed!"
      end

      errata = []

      @signature[:input].each_with_index do |input, i|
        arg_class = args[i].class
        if input[:case] != arg_class
          errata << "expected #{input[:case]} but #{arg_class} supplied!"
        end
      end

      if errata.length > 0
        raise errata.join("\n")
      end

      test_arguments = @signature[:input].map { |data| sample_data(data) }

      if invoke_tested?(test_arguments)
        return call(args)
      end
    end

    def invoke_tested?(test_arguments)
      result = instance_eval("self.invoke(true, #{test_arguments.join(', ')})")
      result.class == @signature[:output].first[:case]
    end

    def sample_data(data)
      if data[:case] == Fixnum
        rand(10)
      elsif data[:case] == Float
        rand
      elsif data[:case] == String
        "STRINGYTHINGY"
      elsif data[:case] == Array
        data[:case] = data[:context]
        RascalList[sample_data(data)]
      else
        raise "undetected type: #{data[:case]}"
      end
    end

    def signature=(signature)
      @signature = signature
    end

    # example type: { in: {singleton: [Fixnum], multi: } }
  end
end


rascal = Rascal::RascalFunc.new { |x,y| x + y }

rascal.signature = {
  input: [{case: Fixnum}, {case: Fixnum}],
  output: [{case: Fixnum}]
}

result = rascal.invoke(false,1,1)

p result
