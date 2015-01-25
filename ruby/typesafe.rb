class TypeSet
  class Error < RuntimeError; end
  class TypeError < Error
    "Check yo types"
  end
end

class TypeSet
  def self.typesafe(klass, meth, args={})
    original_method = klass.instance_method(meth).bind(klass.new)
    klass.send(:define_method, meth, ->(**passed_args) {
      if args.all? { |k,v| passed_args[k].class == v }
        output = original_method.call(passed_args)
      else
        exceptions = args.map do |k,v|
          passed_args[k].class != v ? "Expected #{v}, got #{passed_args[k].class}. " : ""
        end.join(" ")
        raise TypeError, exceptions
      end
    })
  end
end

class SomeClass < TypeSet
  def create_array_of_letters(arg1:, arg2:)
    (arg1 * (arg2 + @val)).split("")
  end
  typesafe(self, :create_array_of_letters, arg1: String, arg2: Fixnum)


  def capitalize(names:)
    names.map { |name| name.capitalize }
  end
  typesafe(self, :capitalize, names: Array)
end

some_class = SomeClass.new
convert_word_into_letters = some_class.create_array_of_letters(arg1: "hihi", arg2: 3)
# passes
array_of_names = some_class.capitalize(names: ["tywin", "maimonides", "philly phanatic"])
# passes
capitalize = some_class.capitalize(names: "joe, samantha, rick")
# raises a type error