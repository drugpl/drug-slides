class Class
  def to_module
    result = nil
    fl_singleton = self.internal.flags & RubyInternal::FL_SINGLETON
    begin
      self.internal.flags &= ~ RubyInternal::FL_SINGLETON
      result = self.clone
    ensure
      self.internal.flags |= fl_singleton
    end
    o = RubyInternal::RObject.new(result.internal_ptr)
    o.flags &= ~ RubyInternal::T_MASK
    o.flags |= RubyInternal::T_MODULE
    o.klass = Module.internal_ptr.to_i
    return result
  end
end
