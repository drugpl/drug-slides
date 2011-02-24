!SLIDE 
# Ładowanie kodu w Rails
## Czyli co zrobić, by trzymać kilka klas w jednym pliku

!SLIDE
	@@@ ruby
	# app/models/blog.rb

	class Post
	end 

	class Comment
	end 

	# app/controllers/blog.rb

	class PostsController < ApplicationController
	end 

	class CommentsController < ApplicationController
	end 

!SLIDE
## Oczekujemy, że w trybie development (cache_classes = false) klasy będą się przeładowywać razem ze stroną

!SLIDE bullets incremental
# Plan
* mechanizmy języka Ruby, które są potrzebne
* ActiveSupport::Dependencies
* 3 rozwiązania problemu kilku klas (dobre, takie sobie i całkiem złe)

!SLIDE
# Mechanizmy Ruby

!SLIDE bullets incremental
## load "plik.rb"
## require "plik"
* kluczowa różnica: require nie wczyta tego samego pliku dwukrotnie

!SLIDE bullets incremental
# Wniosek
* require się nie nadaje

!SLIDE bullets incremental
## autoload :Klasa, "plik"
* kiedy bedzie potrzebna Klasa, wczytaj plik

!SLIDE bullets incremental
## autoload używa require

!SLIDE bullets incremental
# Wniosek
## autoload się nie nadaje

!SLIDE bullets incremental
# Module#const_missing(name)
* kiedy brakuje jakiejś klasy, Ruby uruchamia metodę const_missing, dając jeszcze jedną szansę na załadowanie

!SLIDE bullets incremental
# Module#remove_const(name)
* usuwa klasę

!SLIDE bullets incremental
# ActiveSupport::Dependencies
* 1) odgaduje nazwę pliku z klasą i ładuje ją, kiedy jest potrzebna
* 2) potrafi usunąć wczytane klasy

!SLIDE bullets incremental
# 1) odgaduje nazwę pliku z klasą i ładuje ją, kiedy jest potrzebna
* nadpisuje const_missing
* nazwa pliku zgodna z konwencją: NazwaKlasy w nazwa_klasy.rb
* config.autoload_paths, domyślnie zawiera app/models, app/controllers, itd.

!SLIDE bullets incremental
# 2) potrafi usunąć wczytane klasy
* new_constants_in { ... }
* ActiveSupport::Dependencies.clear
* require_dependency "plik"

!SLIDE bullets incremental
# A co w trybie produkcyjnym?
* config.cache_classes = true wyłącza większość logiki i powoduje użycie require zamiast load

!SLIDE bullets incremental
# Sposób 1 (dobry)

!SLIDE bullets incremental
## Ładowanie modeli
	@@@ ruby
	# application_controller.rb
	# lub dowolny inny kontroler

	require_dependency "app/models/blog"
	class ApplicationController < ...

!SLIDE bullets incremental
## Ładowanie kontrolerów
* jest problem, bo ApplicationController też jest ładowany automatycznie, kiedy wykonuje się dziedziczenie
* gdzie wrzucić require_dependency, może initializer?

!SLIDE bullets incremental
	@@@ ruby
	# config/initializers/load_classes.rb

	require_dependency "app/controllers/blog"
* zadziała tylko przy pierwszym żądaniu :-(

!SLIDE bullets incremental
## Rozwiązanie: ActionDispatch::Callbacks
	@@@ ruby
	# config/initializers/load_classes.rb

	ActionDispatch::Callbacks.before do
	  require_dependency "app/controllers/blog"
	  require_dependency "app/models/blog"
	end

!SLIDE bullets incremental
# Sposób 2 (taki sobie)
* nadpisać const_missing i udawać autoload, który używa require_dependency zamiast require

!SLIDE small
	@@@ ruby
	require Rails.root.join "lib", "custom_const_missing"
	CustomConstMissing.hook!

	CustomConstMissing.map :Post, "app/models/blog"
	CustomConstMissing.map :PostsController,
		"app/controllers/blog"

!SLIDE bullets incremental
# Sposób 3 (całkiem zły)
* jest hackiem
* w ogóle nie działa

!SLIDE bullets incremental
## require (a więc i autoload) korzysta z tablicy załadowanych plików $LOADED_FEATURES / $"
* można usunąć coś z tej tablicy, żeby require załadował drugi raz

!SLIDE small
# Przykład
	@@@ ruby

	file_name = File.expand_path("../klasa.rb", __FILE__)

	autoload :Klasa, file_name
	Klasa # działa

	Object.instance_eval { remove_const :Klasa } # usuń
	Klasa rescue nil # nie działa, wyrzuca NameError

	$LOADED_FEATURES.delete file_name
	Klasa # znowu działa

!SLIDE bullets incremental
## nie udało mi się tego uruchomić w Rails
* ale może się jakoś da :-)
* o ile w ogóle warto

!SLIDE bullets incremental
# Koniec