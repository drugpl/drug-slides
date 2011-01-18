!SLIDE 
## Class.include ##

    @@@ruby
    module Sanitizer
        def save
            puts "sanitized"
            super if defined(super)
        end
    end

    module Persistance
        def save
            puts "saved"
            super if defined(super)
        end
    end

    class User
        include Persistance
        include Sanitizer
    end

!SLIDE 
## Class.include ##

    @@@ruby
    module Sanitizer
        def save
            puts "sanitized"
            super if defined(super)
        end
    end

    module Persistance
        def save
            puts "saved"
            super if defined(super)
        end
    end

    class User
        include Persistance, Sanitizer
    end

!SLIDE
## Class.include ##

     > User.new.save

    => saved

    => sanitized

!SLIDE
## Class.include ##
    class User
        include Persistance, Sanitizer
    end

!SLIDE
## Class.include ##
    class User
        include Sanitizer, Persistance
    end

!SLIDE
## Class.include ##

     > User.new.save
    
    => sanitized

    => saved

