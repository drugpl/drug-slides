class MeineKleineKlasse

  attr_accessor :another_proc

  def initialize
    var = "another_proc"
    @another_proc = proc{puts var}
  end
end

class Proc

  alias :old_initialize :initialize
  alias :old_call :call

  attr_accessor :before, :after

  def initialize(&block)
    @before = []
    @after  = []
    old_initialize(&block)
  end

  def call(*args)
    @before ||= []
    @after  ||= []
    if @before && @after
      variables = eval("local_variables + instance_variables", self.binding)
      variables.each do |var|
        (@before + @after).each do |proc_to_bind|
          var_to_bind = self.binding.eval("#{var}")
          puts "Binduje #{var_to_bind}"
          eval("lambda { |v| #{var} = v }", proc_to_bind.binding).call(var_to_bind)
        end
      end

      (@before + @after).each do |p|
        p.call
      end
    end
    old_call(*args)
  end

  def <<(other)
    @before ||= []
    @after  ||= []
    puts self.object_id
    if other.is_a? Proc
      @before << other
    else
      raise Exception
    end
  end

  def >>(other)
    @before ||= []
    @after  ||= []
    if other.is_a? Proc
      @after.push other
    else
      raise Exception
    end
  end

  private

  def all_callbacks
    @after + @before
  end
end

puts "hello!"

var = 10

normal_proc   = proc{puts var}
another_proc  = MeineKleineKlasse.new.another_proc

normal_proc.before = [another_proc]

normal_proc.call

var = 12
normal_proc.call
