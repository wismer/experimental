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
      begin
        if args.all? { |k,v| passed_args[k].class == v }
          original_method.call(passed_args)
        else
          exceptions = args.map do |k,v|
            passed_args[k].class != v ? "Expected #{v}, got #{passed_args[k].class}. " : ""
          end.join(" ")
          raise TypeError, exceptions
        end
      end
    })
  end
end

class SomeClass < TypeSet
  def test_method(arg1:, arg2:)
    (arg1 * arg2).split("")
  end
  typesafe(self, :test_method, arg1: String, arg2: Fixnum)

  def capitalize(names:)
    names.map { |name| name.capitalize }
  end
  typesafe(self, :capitalize, names: Array)
end

a = SomeClass.new
result = a.test_method(arg1: "hihi", arg2: 3)
another = a.capitalize(names: ["tywin", "maimonides", "philly phanatic"])
fail_another = a.capitalize(names: "joe")
# 1. Method gets called from the outside normally.
# 2. goes to module, dumps the arguments.
# 3. define_method ?