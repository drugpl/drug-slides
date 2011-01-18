!SLIDE smaller
## respond_to?(:super) ##

    @@@ruby
    module Sanitizer
        def save
            puts "sanitized"
            super
        end
    end

    module Persistance
        def save
            puts "saved"
            super
        end
    end

    class User
        include Persistance
        include Sanitizer
    end

!SLIDE smaller
## respond_to?(:super) ##

    @@@ruby
    module Sanitizer
        def save
            puts "sanitized"
            super
        end
    end

    module Persistance
        def save
            puts "saved"
            super
        end
    end

    class User
        include Persistance
        include Sanitizer
    end

!SLIDE
## respond_to?(:super) ##

     > User.new.save

    => sanitized

    => saved

    => save: super: no superclass method save (NoMethodError) 

!SLIDE smaller
## respond_to?(:super) ##

    @@@ruby
    module Sanitizer
        def save
            puts "sanitized"
            super if respond_to?(:super)
        end
    end

    module Persistance
        def save
            puts "saved"
            super if respond_to?(:super)
        end
    end

    class User
        include Persistance
        include Sanitizer
    end

!SLIDE smaller
## respond_to?(:super) ##

    @@@ruby
    module Sanitizer
        def save
            puts "sanitized"
            super if respond_to?(:super)
        end
    end

    module Persistance
        def save
            puts "saved"
            super if respond_to?(:super)
        end
    end

    class User
        include Persistance
        include Sanitizer
    end

!SLIDE 
## respond_to?(:super) ##
    
     > User.new.save
     => sanitized

!SLIDE smaller
## respond_to?(:super) ##

    @@@ruby
    module Sanitizer
        def save
            puts "sanitized"
            super if defined?(super)
        end
    end

    module Persistance
        def save
            puts "saved"
            super if defined?(super)
        end
    end

    class User
        include Persistance
        include Sanitizer
    end

!SLIDE
## respond_to?(:super) ##

     > User.new.save

    => sanitized

    => saved

