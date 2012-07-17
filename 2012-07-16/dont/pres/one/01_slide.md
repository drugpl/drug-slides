!SLIDE 
# Things you can’t do with Ruby #
## Piotr Niełacny ##
### Twitter: @piterniel ###
### Github:  LTe ###
### Email:   piotr.nielacny@gmail.com ###

!SLIDE
# Multi-inheritance

      @@@ruby
        class MyClass < FirstClass, SecClass
        end

### SyntaxError: (irb):1: syntax error, unexpected ',', expecting ';' or '\n'
### class MyClass < FirstClass, SecClass

!SLIDE
# Class mixin

      @@@ruby
          class MyClass
            include Array
          end

### TypeError: wrong argument type Class (expected Module)

!SLIDE
# Uninclude modules

      @@@ruby
      class MyClass
        include MyModule
      end

      MyClass.ancestors 
      # => [MyClass, MyModule, Object, Kernel, BasicObject]
      MyClass.uninclude(MyModule)

### NoMethodError: undefined method `uninclude' for MyClass:Class

!SLIDE
# Object unfreeze

      @@@ruby
        a = Array.new # => []
        a << "object" # => ["object"]
        a.freeze
        a.frozen? # => true
        a << "object2" # => RuntimeError: cant modify frozen Array
      ` a.unfreeze

### NoMethodError: undefined method `unfreeze' for ["object"]:Array

!SLIDE
# Change object class

      @@@ruby 
        o = Object.new
        o.class # => Object
        o.class = Array

### NoMethodError: undefined method `class=' for #<Object:0x00000001eedaa8>

!SLIDE
# Normally I should end the presentation

!SLIDE center image
![troll](troll.jpg)

!SLIDE center image
![matrix](matrix.jpg)

!SLIDE
# Clone ruby repository
      @@@
      git clone git://github.com/ruby/ruby.git

!SLIDE
# Fine file
      @@@
        include/ruby/ruby.h

!SLIDE
# You probably think I'll write an extension in C
## Hahahahahaha... no

!SLIDE
# In ruby.h file you can find
      @@@
          RUBY_Qfalse = 0,
          RUBY_Qtrue  = 2,
          RUBY_Qnil   = 4,
          RUBY_Qundef = 6,

          RUBY_T_NONE   = 0x00,

          RUBY_T_OBJECT = 0x01,
          RUBY_T_CLASS  = 0x02,
          RUBY_T_MODULE = 0x03,
          RUBY_T_FLOAT  = 0x04,
          RUBY_T_STRING = 0x05,
          RUBY_T_REGEXP = 0x06,
          RUBY_T_ARRAY  = 0x07,
          RUBY_T_HASH   = 0x08,
          RUBY_T_STRUCT = 0x09,
          RUBY_T_BIGNUM = 0x0a,
          RUBY_T_FILE   = 0x0b,

!SLIDE
# Move this to normal ruby module
      @@@ruby
      module RubyInternal
        Qfalse = 0
        Qtrue  = 2
        Qnil   = 4
        Qundef = 6

        T_NONE   = 0x00

        T_OBJECT = 0x01
        T_CLASS  = 0x02
        T_MODULE = 0x03
        T_FLOAT  = 0x04
        T_STRING = 0x05
        T_REGEXP = 0x06
        T_ARRAY  = 0x07
        T_HASH   = 0x08
        T_STRUCT = 0x09
        T_BIGNUM = 0x0a
        T_FILE   = 0x0b
      end

!SLIDE
# Find in ruby.h aliases for type
      @@@
      typedef unsigned long VALUE;
      typedef unsigned long ID;

!SLIDE
# And once again move to normal ruby module
      @@@ruby
      module RubyInternal
        # But how create alias?!
      end

!SLIDE
# We need to use DL (Dynamic Loader?)
      @@@ruby
      require 'dl'
      require 'dl/import'

      module LibSum
        extend DL::Importer
        dlload './libsum.so'
        extern 'double sum(double*, int)'
        extern 'double split(double)'
      end


!SLIDE
# So... ruby module
      @@@ruby
      require 'dl'
      require 'dl/value'
      require 'dl/import'
      require 'dl/struct'

      module RubyInternal
        extend DL::Importer
        
        # Constants

        typealias "VALUE", "unsigned long"
        typealias "ID", "unsigned long"
      end

!SLIDE
# Next, structures 
      @@@
      struct RBasic {
          VALUE flags;
          VALUE klass;
      };

!SLIDE
# And import :)
      @@@ruby
      struct RBasic {
          VALUE flags;
          VALUE klass;
      };

        module RubyInternals
          Basic = [
            "VALUE flags",
            "VALUE klass"
          ]

          RBasic = struct(Basic)
        end

!SLIDE
# Object
      @@@ruby
      struct RObject {
          struct RBasic basic;
          union {
        struct {
            long numiv;
            VALUE *ivptr;
                  struct st_table *iv_index_tbl;
        } heap;
        VALUE ary[ROBJECT_EMBED_LEN_MAX];
          } as;
      };

      module RubyInternal
        object_struct = [
          'long numiv',
          'VALUE *ivptr',
          'st_table *iv_index_tbl',
          'VALUE ara[3]'
        ]

        RObject = struct(Basic + object_struct)
      end

!SLIDE
# And long long boring import ;-)

!SLIDE
# We have constants, type alias and structures
## How can we refer to them?

!SLIDE
# Internal pointer of ruby object
      @@@ruby
        def internal_ptr(*args)
          pos = self.object_id * 2
          DL::CPtr.new(pos, *args)
        end

!SLIDE
# To INTERNALS!!!!
      @@@ruby

      def internal
        klass = internal_class # => RubyInternal::RObject
        r = klass.new(internal_ptr) # => <RubyInternal::RObject:0x00000>
        r
      end

!SLIDE
# Object internal
      @@@ruby
      Object.new.internal
       => #<RubyInternal::RObject:0x00000001849328 
            @entity=#<DL::CStructEntity:0x00000001940d60 
                     ptr=0x00000001849968 
                     size=64 
                     free=0x00000000000000>> 
      Object.new.internal.flags
       => 1 

      struct RBasic {
          VALUE flags;
          VALUE klass;
      };

!SLIDE
# Multi-inheritance
      @@@ruby
      class Class
        def to_module
          self.internal.flags &= ~ RubyInternal::FL_SINGLETON
          result = self.clone
          o = RubyInternal::RObject.new(result.internal_ptr)
          o.flags &= ~ RubyInternal::T_MASK
          o.flags |= RubyInternal::T_MODULE
          o.klass = Module.internal_ptr.to_i
          return result
        end
      end

!SLIDE
# Object unfreeze
      @@@ruby
        def unfreeze
          self.internal.flags &= ~RubyInternal::FL_FREEZE
          return self
        end

!SLIDE
# Change object class
      @@@ruby
        def class=(other)
          self.internal.klass = other.internal_ptr.to_i
        end

!SLIDE
# Uninclude
## C extension :(

      @@@
      for (prev = klass, cur = RCLASS_SUPER(klass); cur ; prev = cur, cur = RCLASS_SUPER(cur)) {
        if (BUILTIN_TYPE(cur) == T_ICLASS && RBASIC_KLASS(cur) == mod) {
          RCLASS_SET_SUPER(prev, RCLASS_SUPER(cur));
          return mod;
        }
      }

!SLIDE
# Impossible in nothing

!SLIDE
# Q & A
