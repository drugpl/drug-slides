
module ExampleModule
  module Deeper
    module InstanceMethods
      def my_instance_method
      end
    end

    module ClassMethods
      def my_class_method
      end
    end
  end

  def self.included(base)
    base.send(:include, Deeper::InstanceMethods)
    base.send(:extend,  Deeper::ClassMethods)
  end
end

module AnotherExampleModule
end

class ExampleClass
  include ExampleModule
  include AnotherExampleModule
end

ExampleClass.instance_eval do
  if(defined?(ExampleClass::Deeper) && ExampleClass.constants.map(&:to_sym).include?(:Deeper) && ExampleClass::Deeper.is_a?(Module))
    puts "dupa"
  end
end

class Object
  def self.define_method(*args)
    "fuck it"
  end
end

foo = Class.new(ExampleClass) do
  def bar
    puts "bar"
  end

  def self.name
    puts "hello"
    "lolz"
  end

  def class_name
    puts self.class.name
  end
end.freeze

puts "Nazwa #{foo.name.inspect}"
foo.freeze
Foo = foo
puts "Nazwa #{foo.name.inspect}"

foo = Class.new
n = 20
puts "N = #{n}"
n.times do |i|
  eval("Foo#{i} = foo")
end

puts foo.name.gsub("Foo", '').to_f / n

n.times do |i|
  self.class.send(:remove_const, :"Foo#{i}")
end


foo.name
#puts "Nazwa #{foo.name.inspect}"
puts "Nazwa #{foo.name.inspect}"
puts "Nazwa #{foo.inspect}"
