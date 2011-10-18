!SLIDE 
# DRUG-bot #
## And stuff ##

!SLIDE
# WTF? #

!SLIDE
# IRC bot for *#drug.pl* at freenode #

!SLIDE
# Architecture #

!SLIDE bullets incremental
# Why is awesome and cool? #
* Based on plugins
* Rack style
* Simple

!SLIDE
# Without inheritance in plugins #
![akk](akapp.png)

!SLIDE
# Based on Coffeemaker #
## From DRUG-hackaton ##
### Thx for @pawelpacana ###
![app](app.png)


!SLIDE
# Rack style plugin #
![sweet](sweet.png)
## Yeah sooo simple ##

!SLIDE
    @@@ ruby
    class ExamplePlugin
      def initialize(bot)
        @bot = bot
      end

      def call(connection, message)
        # stuff
      end
    end

!SLIDE
# Message #
    @@@ ruby
      {
        :command => command,
        :user    => user,
        :nick    => nick,
        :host    => host,
        :message => message,
        :channel => channel
      }

!SLIDE
# Message #
    @@@ ruby
      {
        :command => "PRIVMSG",
        :user    => "LTe",
        :nick    => "LTe",
        :host    => "localhost",
        :message => "Hi there!",
        :channel => "#test"
      }

!SLIDE smaller
# Connection #
    @@@ ruby
    module Commands
      def join(channel)
        command("JOIN ##{channel}")
      end

      def part(channel)
        command("PART ##{channel}")
      end

      def msg(recipient, text)
        command("PRIVMSG #{recipient} :#{text}")
      end
    end

!SLIDE
# Example plugin #

!SLIDE smaller
    @@@ ruby
    class Motd
      include DrugBot::Plugin::Helpers

      def initialize(bot)
        @bot = bot
      end

      def call(connection, message)
        if on_join?(connection, message)
          connection.msg(message[:channel], 
          "DRUG-bot | Version: #{DrugBot::VERSION}")
        end
      end
    end

!SLIDE smaller
# Implementation of plugins management #
    @@@ ruby
    # @bot.register_plugin(ExamplePlugin)
    def register_plugin(plugin)
      @plugins[plugin] = plugin.new(self)
    end

    # on message
    @plugins.each do |plugin, instance|
      instance.call(@connection, m)
    end

    # Example
    { ExamplePlugin => @example_plugin_instance }

!SLIDE
# How to start bot #
    @@@ ruby
    require 'drug-bot'
    require 'drug-bot-motd'

    EM.run do
      @bot = DrugBot::Bot.new
      @bot.register_plugin(Motd)
      @bot.start
    end

!SLIDE
# Soł osom and emejzing #
![megusta](me-gusta.png)

!SLIDE bullets incremental
# Plugins #
* Plusone
* Motd
* Livereload
* Reddit
* Nerdpursuit
* Eval (aka SafeEval)

!SLIDE
# FLAME ON!!!!1111oneoneone #

!SLIDE
# FLAME OFFFFFF!!!!!1111oneoneone #

!SLIDE
# RuPy memes #

!SLIDE center
![9am](jose.png)

!SLIDE
![coffe](coffe.jpg)

!SLIDE
![always](always.jpg)

!SLIDE
# Ruby WTF - czyli rozmyślania na kacu #
# Thx for @jasiek! #
