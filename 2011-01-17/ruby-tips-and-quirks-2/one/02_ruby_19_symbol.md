!SLIDE small
# String vs Symbol #

    @@@ruby
    class String
        unless instance_methods.include?("camelize")
            def camelize
                gsub(/\/(.?)/) { "::#{$1.upcase}" }
                .gsub(/(?:^|_)(.)/) { $1.upcase }
            end 
        end
    end

!SLIDE small
# String vs Symbol #

    @@@ruby
    class String
        unless instance_methods.any? { |m| m.to_s == "camelize" }
            def camelize
                gsub(/\/(.?)/) { "::#{$1.upcase}" }
                .gsub(/(?:^|_)(.)/) { $1.upcase }
            end 
        end
    end



    
!SLIDE small
# String vs Symbol #

    @@@ruby
    class String
        unless method_defined?(:camelize)
            def camelize
                gsub(/\/(.?)/) { "::#{$1.upcase}" }
                .gsub(/(?:^|_)(.)/) { $1.upcase }
            end 
        end
    end



