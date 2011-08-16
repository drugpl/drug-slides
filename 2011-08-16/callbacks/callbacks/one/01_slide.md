!SLIDE 
# Krotko o callbackach w RoR #

!SLIDE
    @@@ruby
      class User < ActiveRecord::Base
        before_save :login_required

        def login_required
          return nil
        end
      end

!SLIDE
    @@@ruby
      class User < ActiveRecord::Base
        before_save :login_required

        def login_required
          return nil
        end
      end

    User.new.save #=> ?

!SLIDE
    @@@ruby
      class User < ActiveRecord::Base
        before_save :login_required

        def login_required
          return nil
        end
      end

    User.new.save #=> true

!SLIDE smaller
    @@@ruby
        class UserController < ApplicationController
          before_filter :load_user, :load_profile

          def index
            render :text => "DRUG!"
          end

          def load_user
            return false
          end

          def load_profile
            puts "Load profile"
          end
        end

!SLIDE smaller
    @@@ruby
        class UserController < ApplicationController
          before_filter :load_user, :load_profile

          def index
            render :text => "DRUG!"
          end

          def load_user
            return false
          end

          def load_profile
            puts "Load profile"
          end
        end

        # Czy wykona sie load_profile?


!SLIDE smaller
    @@@ruby
        class UserController < ApplicationController
          before_filter :load_user, :load_profile

          def index
            render :text => "DRUG!"
          end

          def load_user
            return false
          end

          def load_profile
            puts "Load profile"
          end
        end

        # Czy wykona sie load_profile?
        # TAK!

!SLIDE
## Stworzymy czysta klase i uzyjemy ActiveSupport::Callbacks ##

!SLIDE smaller
    @@@ruby
      class User
        include ActiveSupport::Callbacks
        define_callback :save

        set_callback :save, :before, :saving_message

        def saving_message
          puts "saving..."
        end

        def save
          run_callbacks :save do
            puts "- save"
          end
        end
      end

!SLIDE
## Co zbudowac ActiveSupport::Callbaks ? ##

!SLIDE smaller
    @@@ruby
        value = nil
        halted = false

        unless halted
          result = saving_message
          halted = (false)
        end

        value = yield if block_given? && !halted
        halted ? false : (block_given? ? value : true)

!SLIDE smaller
    @@@ruby
      class User
        include ActiveSupport::Callbacks
        define_callback :save

        set_callback :save, :before, :saving_message
        set_callback :save, :before, :saving_message2

        def saving_message; puts "saving...";end
        def saving_message2; puts "saving2...";end

        def save
          run_callbacks :save do
            puts "- save"
          end
        end
      end

!SLIDE smaller
    @@@ruby
        value = nil
        halted = false

        unless halted
          result = saving_message
          halted = (false)
        end

        unless halted
          result = saving_message2
          halted = (false)
        end

        value = yield if block_given? && !halted
        halted ? false : (block_given? ? value : true)


!SLIDE smaller
    @@@ruby
      class User
        include ActiveSupport::Callbacks
        define_callback :save

        set_callback :save, :before, :saving_message
        set_callback :save, :before, :saving_message2, 
                                     :prepend => true

        def saving_message; puts "saving...";end
        def saving_message2; puts "saving2...";end

        def save
          run_callbacks :save do
            puts "- save"
          end
        end
      end

!SLIDE smaller
    @@@ruby
        value = nil
        halted = false

        unless halted
          result = saving_message2
          halted = (false)
        end

        unless halted
          result = saving_message
          halted = (false)
        end

        value = yield if block_given? && !halted
        halted ? false : (block_given? ? value : true)

!SLIDE smaller
    @@@ruby
      class User
        include ActiveSupport::Callbacks
        define_callback :save, 
                      :terminator => "result == false"

        set_callback :save, :before, :saving_message
        set_callback :save, :before, :saving_message2, 
                                     :prepend => true

        def saving_message; puts "saving...";end
        def saving_message2; puts "saving2...";end

        def save
          run_callbacks :save do
            puts "- save"
          end
        end
      end

!SLIDE smaller
    @@@ruby
        value = nil
        halted = false

        unless halted
          result = saving_message
          # nil == false #=> false
          halted = (result == false)
        end

        unless halted
          result = saving_message2
          halted = (result == false)
        end

        value = yield if block_given? && !halted
        halted ? false : (block_given? ? value : true)

!SLIDE smaller
    @@@ruby
        class UserController < ApplicationController
          before_filter :load_user, :load_profile

          def index
            render :text => "DRUG!"
          end

          def load_user
            render :text => "Helou DRUG!"
          end

          def load_profile
            puts "Load profile"
          end
        end

    # Czy callback sie trzeba zatrzyma?

!SLIDE smaller
    @@@ruby
        class UserController < ApplicationController
          before_filter :load_user, :load_profile

          def index
            render :text => "DRUG!"
          end

          def load_user
            render :text => "Helou DRUG!"
          end

          def load_profile
            puts "Load profile"
          end
        end

    # Czy callback sie trzeba zatrzyma?
    # TAK! Bo... :terminator => "response_body"

!SLIDE smaller
    @@@ruby
        value = nil
        halted = false

        unless halted
          result = load_user
          halted = (responde_body)
        end

        unless halted
          result = load_profile
          halted = (responde_body)
        end

        value = yield if block_given? && !halted
        halted ? false : (block_given? ? value : true)

!SLIDE
    @@@ruby
      class User < ActiveRecord::Base
        after_save :drug1
        after_save :drug2
      end

      # User.new.save
      # => drug1
      # => drug2

!SLIDE smaller
    @@@ruby
      class UsersController < ApplicationController
        after_filter :drug1
        after_filter :drug2
      end

      # drug2
      # drug1

!SLIDE
## Jak nie potrafisz zatrzymac callback'a? To co? ##

!SLIDE
    @@@ruby
      def callback_method
        exec('sudo shutdown -h now')
      end

!SLIDE
    @@@ruby
      class Proc
        def call
          # super empty method ;-)
        end
      end

!SLIDE
    @@@ruby
      def callback_method
        remove_const ActiveRecord
        remove_const ActiveSupport
      end

!SLIDE
    @@@ruby
      def callback_method
        class Rack
          def call(env)
            # haha !
          end
        end
      end

!SLIDE smaller
    @@@ruby
      require 'file'

      def callback_method
        File.rm(File.expand_path(__FILE__))
      end

!SLIDE
# Q & A #
