!SLIDE 
# Rails 3 + Mountable Apps #

Paweł Pacana <pawel.pacana@syswise.eu>

!SLIDE bullets incremental
# Mountable Apps #

* reusable apps

!SLIDE bullets incremental
# Przykłady #

* prosty cms
* panel admina
* forum
* klient poczty/wiadomości 

!SLIDE bullets incremental
# Rails 2.x #

* engines
* słaba izolacja
* nie jako samodzielna aplikacja

!SLIDE bullets incremental
# Rails 3.x #

* engines
* enkapsulacja (Rails 3.1)
* własne routes
* własny middleware stack
* może serwować własne 'static files'
* własne pluginy

!SLIDE
# Samodzielna aplikacja? #
  
  "Wspólnie z osobami z rails core team zdecydowaliśmy, że najlepiej będzie na razie przetestować w boju montowalne engine’y i zobaczyć w jaki sposób programiści ich używają, a później popracować na montowalnymi aplikacjami." /drogus/

!SLIDE bullets incremental
# Enginex #

* http://github.com/josevalim/enginex

!SLIDE 
# Rails::Engine #

    @@@ Ruby
    enginex restful_admin

    # lib/restful_admin.rb
    require 'restful_admin/engine'

    # lib/restful_admin/engine.rb
    module RestfulAdmin
      class Engine < ::Rails::Engine
        isolate_namespace RestfulAdmin # namespace
      end
    end

!SLIDE
# Gemfile w engine #
  
    @@@ Ruby
    source "http://rubygems.org"

    # wymagane
    gem "rails", :git => "git://github.com/rails/rails.git"
    gem "arel", :git => "git://github.com/rails/arel.git"

    # dodatkowe
    gem "will_paginate", "~> 3.0.pre2"
    gem "simple_form"
    gem "responders"

    group :test do
      gem "capybara", ">= 0.3.9"
      gem "sqlite3-ruby", :require => "sqlite3"
      gem "factory_girl_rails"
    end

!SLIDE
# Gemfile w base #
  
    @@@ Ruby
    source "http://rubygems.org"

    gem "rails",          :git => "git://github.com/rails/rails.git"
    gem "arel",           :git => "git://github.com/rails/arel.git"
    gem 'restful_admin',  :path => '/home/sensei/code/restful_admin'
    # lub :git => 'git://github.com/pawelpacana/restful_admin'

!SLIDE bullets incremental
# Gemfile w base - cd. #

* bundler i rekursja?
* dopisać gemy z Gemfile engine do base
* dopisać zalezności w restful_admin.gemspec

!SLIDE bullets incremental
# Gemfile w base - cd. #

    @@@ Ruby
    require 'restful_admin/engine'
    # require external libraries here unless we have 
    # access to main apps Gemfile
    require 'will_paginate'
    require 'simple_form'
    require 'responders'

    spec = Gem::Specification.new do |s|
      s.name = "restful_admin"
      ...
      s.description = "Drop-in and go, have some rest!"
      s.add_dependency "simple_form"
      s.add_dependency "responders"
      s.add_dependency "meta_search"
    end

!SLIDE
# Routes w engine #

     @@@ Ruby
     RestfulAdmin::Engine.routes.draw do
        root :to => "home#index"

        controller :resources do
          get ':resource(.:format)', :to => :index, :as => 'resources'
          get ':resource/new(.:format)', :to => :new, :as => 'new_resource'
          get ':resource/:id(.:format)', :to => :show, :as => 'show_resource'
          post ':resource(.:format)', :to => :create
          get ':resource/:id/edit(.:format)', :to => :edit, :as => 'edit_resource'
          put ':resource/:id(.:format)', :to => :update
          delete ':resource/:id(.:format)', :to => :destroy, :as => 'destroy_resource'
        end
     end

!SLIDE 
# Routes w base #
      
      @@@ Ruby
      Blog::Application.routes.draw do
        resources :posts
        
        mount RestfulAdmin::Engine => "/admin", :as => "restful_admin"
      end

!SLIDE
# Helpery w engine #
      
      @@@ Ruby
      restful_admin.resources_path # :as => "restful_admin"

      main_app.posts_path

!SLIDE
# Izolacja w engine #

      @@@ Ruby
      RestfulAdmin::User

      restful_admin_users_path
      params[:restful_admin_user]

      # isolate_namespace
      users_path
      params[:user]
      

!SLIDE bullets incremental
# Migracje #

* rake railties:copy_migrations


!SLIDE bullets incremental
# Pliki statycznie #

* ActionDispatch::Static
* rake railties:create_symlinks

!SLIDE bullets incremental
# Have fun! #

* http://piotrsarnacki.com/2010/09/09/mountable-engines/
* https://github.com/pawelpacana/restful-admin
* http://gist.github.com/af7e572c2dc973add221
* http://www.themodestrubyist.com/2010/03/05/rails-3-plugins---part-2---writing-an-engine/
