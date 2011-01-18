!SLIDE
## module functions ##

    @@@ruby
    module Security
        def generate_password
            ('a'..'z').sample(8)
        end
    end

    class User
        include Security
    end    

    User.new.generate_password

!SLIDE
## module functions ##

    @@@ruby
    module Security
        def generate_password
            ('a'..'z').sample(8)
        end
    end


!SLIDE
## module functions ##

    @@@ruby
    module Security
        extend self
        def generate_password
            ('a'..'z').sample(8)
        end
    end


!SLIDE
## module functions ##

    @@@ruby
    module Security
        extend self
        def generate_password
            ('a'..'z').sample(8)
        end
    end
    
    Security.generate_password

!SLIDE
## module functions ##

    @@@ruby
    module Security
        module_function
        def generate_password
            ('a'..'z').sample(8)
        end
    end
    
    Security.generate_password
