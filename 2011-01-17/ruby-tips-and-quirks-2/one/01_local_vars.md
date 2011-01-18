!SLIDE 
# Ruby Tips & Quirks #2 #

### Michał Łomnicki ###
### www.starware.com.pl ###

!SLIDE Zmienne lokalne
# Zmienne lokalne #

    @@@ruby
    puts local_variables.inspect

    y = 4

    puts local_variables.inspect


!SLIDE Zmienne lokalne
# Zmienne lokalne #

    @@@ruby
    puts local_variables.inspect # => ["y"]

    y = 4

    puts local_variables.inspect # => ["y"]

!SLIDE Zmienne lokalne
# Zmienne lokalne #

## Ruby 1.8 ##

    @@@ruby
    puts local_variables.inspect # => ["y"]

    y = 4

    puts local_variables.inspect # => ["y"]

!SLIDE Zmienne lokalne
# Zmienne lokalne #

## Ruby 1.9 ##

    @@@ruby
    puts local_variables.inspect # => [:y]

    y = 4

    puts local_variables.inspect # => [:y]

