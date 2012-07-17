class Object
  def internal_class
    case internal_type
      when RubyInternal::T_OBJECT
        RubyInternal::RObject
      when RubyInternal::T_CLASS,  RubyInternal::T_ICLASS, RubyInternal::T_MODULE
        RubyInternal::RModule
      when RubyInternal::T_FLOAT
        RubyInternal::RFloat
      when RubyInternal::T_STRING
        RubyInternal::RString
      when RubyInternal::T_REGEXP
        RubyInternal::RRegexp
      when RubyInternal::T_ARRAY
        RubyInternal::RArray
      when RubyInternal::T_HASH
        RubyInternal::RHash
      when RubyInternal::T_STRUCT
        RubyInternal::RStruct
      when RubyInternal::T_BIGNUM
        RubyInternal::RBignum
      when RubyInternal::T_FILE
        RubyInternal::RFile
      when RubyInternal::T_DATA
        RubyInternal::RData
      else
        raise "No internal class for #{self}"
    end
  end

  def internal_type
    case self
      when Fixnum then RubyInternal::T_FIXNUM
      when NilClass then RubyInternal::T_NIL
      when FalseClass then RubyInternal::T_FALSE
      when TrueClass then RubyInternal::T_TRUE
      when Symbol then RubyInternal::T_SYMBOL
      else
        RubyInternal::RBasic.new(self.internal_ptr).flags & RubyInternal::T_MASK
    end
  end

  def direct_value?
    [Fixnum, Symbol, NilClass, TrueClass, FalseClass].any? do |klass|
      klass === self
    end
  end

  def internal_ptr(*args)
    if direct_value?
      raise(ArgumentError, "Can't get pointer to direct values.")
    end

    pos = self.object_id * 2
    DL::CPtr.new(pos, *args)
  end

  def internal
    if direct_value?
      raise(ArgumentError, "Can't get internal representation of direct values")
    end

    propagate_magic = nil # forward "declaration"
    do_magic = lambda do |obj, id|
      addr = obj.instance_eval { send(id) }
      sklass = class << obj; self end
      sklass.instance_eval do
        define_method(id) do
          case addr
            when 0
              return nil
            else
              begin
                r = RubyInternal::RClass.new DL::CPtr.new(addr, 5 * DL::SIZEOF_LONG)
              rescue RangeError
                r = RubyInternal::RClass.new DL::CPtr.new(addr - 2**32, 5 * DL::SIZEOF_LONG)
              end
              propagate_magic.call r, true
          end
          class << r; self end.instance_eval { define_method(:to_i) { addr } }
          r
        end
      end
    end

    propagate_magic = lambda do |obj, dosuper|
      do_magic.call(obj, :klass)
      do_magic.call(obj, :super) if dosuper
    end

    klass = internal_class
    r = klass.new(internal_ptr)

    case klass
      when RubyInternal::RClass, RubyInternal::RModule
        propagate_magic.call r, true
      else
        propagate_magic.call r, false
    end
    r
  end

  def class=(other)
    self.internal.klass = other.internal_ptr.to_i
  end

  def unfreeze
    return self if direct_value?

    self.internal.flags &= ~RubyInternal::FL_FREEZE
    return self
  end
end