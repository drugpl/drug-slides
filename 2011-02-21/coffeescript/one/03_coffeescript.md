!SLIDE

# CoffeeScript #

!SLIDE bullets

* kompilowany do JS
* nie używamy ;
* nie używamy {} -- wystarczą wcięcia
* nie musimy używać () -- ale lepiej używać
* nie używamy var

!SLIDE
# Funkcje #

    @@@ coffeescript
    sqr = (x) -> x*x
    world = (x, y = "World") -> alert(x + " " + y)
    sqr(4) #=> 16
    world("Hello") #=> "Hello World"
    world("Hello", "Banana") #=> "Hello Banana"

!SLIDE

    @@@ coffeescript
    f = (a, b, c...) ->
      first = a
      second = b
      rest = c
    f(1, 2, 3, 4, 5)
    arr = [1, 2, 3, 4, 5]
    f(arr...)

!SLIDE
# Object literal #

    @@@ coffeescript
    a =
      "a", "b", "c"
      "d", "e", "f"
    #=> ["a", "b", "c", "d", "e", "f"]

!SLIDE

    @@@ coffeescript
    b =
      outer:
        inner:
          kaka: "dada"
          wawa: 2

    #=> {
          outer: {
            inner: {
              kaka: "dada",
              wawa: 2
            }
          }
        }

!SLIDE

# Instrukcje warunkowe #

    @@@ coffeescript
    a = 2 if b
    if a == 2 and b == 3
      alert("kaka")
    else
      alert("dada")
    c = if a == 2 then 3 else 4
    options or= defaults

!SLIDE

# Pętle #

    @@@ coffeescript
    for v in [1, 2, 3, 4]
      (...)

    for v, i in [1, 2, 3, 4]
      (...)

    for k, v of obj
      (...)

    while i-=1
      (...)

!SLIDE

# List comprehensions #

    @@@ coffeescript
    a = (x * x for x in [1, 2, 3, 4, 5])
    b = ("kaka" + num) while num-=1
    c = for i in [1, 2, 3]
      i + i

!SLIDE

# Pętle i domknięcia #
    @@@ coffeescript
    for i in [1, 2, 3]
      do (i) ->
        dom.onclick = -> alert(i)

!SLIDE

# Tablice #
    @@@ coffeescript
    a = [1, 2, 3, 4]
    [b, c, d, e] = a
    f = a[2..3]
    d = [5, 6, 7, 8]
    d[2..3] = a[1..3]

!SLIDE

# Zmienne - zasięg #

    @@@ coffeescript
    outer = 1
    f = ->
      inner = 1
      outer = 2

!SLIDE
# Operator egzystencjalny #

    @@@ coffeescript
    if not kaka?
      kaka = "dada"
    kaka ?= "dada"

!SLIDE
# Klasy #

    @@@ coffeescript
    class Animal
      constructor: (@name) ->
      move: (meters) ->
        alert @name + " moved " + meters + "m"

    class Snake
      move: ->
        alert "Slithering..."
        super 5

    Animal::jump = -> @move(10)

!SLIDE
# Podpinanie metod #

    @@@ coffeescript
    class Animal
      (...)
      bindEvents: ->
        $(".animal").bind("click", (e) => @move(5))

!SLIDE
# Cukierasy #

    @@@ coffeescript
    a = 200 < b < 300
    c = "#{ b / 100} kaka"
    OPERATOR = /// ^ (
      ?: [-=]>             # function
       | [-+*/%<>&|^!?=]=  # compound assign / compare
       | >>>=?             # zero-fill right shift
       | ([-+:])\1         # doubles
       | ([&|<>])\2=?      # logic / shift
       | \?\.              # soak access
       | \.{2,3}           # range or splat
    ) ///
