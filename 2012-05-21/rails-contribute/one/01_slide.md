!SLIDE 
# Contributing to Ruby on Rails #

!SLIDE
# Security
## security@rubyonrails.org

!SLIDE
# Documentation
## Add [ci skip]

!SLIDE
# User Rails idioms

!SLIDE
## Include tests that fail without your code, and pass with it

!SLIDE
## Two spaces, no tabs

!SLIDE
## No trailing whitespace. Blank lines should not have any space.

!SLIDE
# Indent after private/protected.
## (edge)

      @@@ ruby
        def method
        end

        private
          def private_method
          end


!SLIDE
# Good
      @@@ruby
        a && b
        a || b
# Bad
      @@@ruby
        a and b
        a or b

!SLIDE
# Good
      @@@ruby
        class << self
          def method
          end
        end
# Bad
      @@@ruby
        def self.method
        end

!SLIDE
# Good
      @@@ruby
        MyClass.my_method(my_arg) 
# Bad
      @@@ruby
        my_method( my_arg )
        my_method my_arg

!SLIDE
# Good
      @@@ruby
        a = b
# Bad
      @@@ruby
        a=b

!SLIDE
# Commit
## 50 character or less
## \newline
## Login description with linebreak after 72 chars
## Ident with 4 spaces (code)

!SLIDE
# Rebase
## Squash

!SLIDE center
# Thx
![st.jpg](st.jpg)

