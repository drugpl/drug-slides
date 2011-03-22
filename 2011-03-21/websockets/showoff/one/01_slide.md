!SLIDE
# WebSockets #
Piotr Niełacny http://ruby-blog.pl/

!SLIDE
# Co to jest? #

## WebSocket jest technologią zapewniającą dwukierunkowy kanał komunikacji za pośrednictwem jednego gniazda TCP.

!SLIDE bullets incremental
# Jak to działa? #

* Handshake
* Utworzenie połączenia TCP (full-duplex)

!SLIDE bullets incremental

# A dokładniej? #

* Draft
* DRAFT
* I jeszcze raz DRAFT!

!SLIDE
# draft-hixie-thewebsocketprotocol-75

!SLIDE

# Handshake - client

    GET /vim-rlz HTTP/1.1
    Upgrade: WebSocket
    Connection: Upgrade
    Host: localhost
    Origin: localhost
    WebSocket-Protocol: tyskie-jest-lepsze

!SLIDE

# Upgrade: WebSocket
### The Upgrade general-header allows the client to specify what
### additional communication protocols it supports and would like to use if
### the server finds it appropriate to switch protocols.

!SLIDE
# WebSocket-Protocol
### The |WebSocket-Protocol| header is used in the WebSocket
### handshake.  It is sent from the client to the server and back from
### the server to the client to confirm the subprotocol of the
### connection.

!SLIDE
# Handshake - server 
    HTTP/1.1 101 Web Socket Protocol Handshake
    Upgrade: WebSocket
    Connection: Upgrade
    WebSocket-Origin: http://localhost
    WebSocket-Location: ws://localhost/vim-rlz
    WebSocket-Protocol: tyskie-jest-lepsze

!SLIDE
# WebSocket-Location
## ws?

!SLIDE
# URI (identyfikacja zasobu)
## A Uniform Resource Identifier (URI) is a compact string of characters for identifying an abstract or physical resource

!SLIDE
# ws - websocket
# wss - websocket TLS

!SLIDE center
# Draft? Muhahaha!;-)
![troll](troll.png)

!SLIDE
    @@@ ruby
    require 'socket'

    server = TCPServer.open(50000)

    handshake = <<HAND
    HTTP/1.1 101 Web Socket Protocol Handshake
    Upgrade: WebSocket
    Connection: Upgrade
    WebSocket-Origin: http://localhost
    WebSocket-Location: ws://localhost
    WebSocket-Protocol: drug
    \r
    HAND

    client = server.accept
    client.write(handshake)
    client.write("\x00Hacked BITCH!\xff")

!SLIDE
# Wszystkie nagłówki mogą być stworzone XMLHttpRequest...

!SLIDE
# draft-hixie-thewebsocketprotocol-76

!SLIDE
    GET /websocket HTTP/1.1
    Upgrade: WebSocket
    Connection: Upgrade
    Host: localhost
    Origin: localhost
    Sec-WebSocket-Key1: 12998 5 Y3 1  .P00
    Sec-WebSocket-Key2: 4 @1  46546xW%0l 1 5
    Sec-WebSocket-Protocol: drug

    ^n:ds[4U

!SLIDE
    HTTP/1.1 101 WebSocket Protocol Handshake
    Upgrade: WebSocket
    Connection: Upgrade
    Sec-WebSocket-Origin: http://localhost
    Sec-WebSocket-Location: ws://localhost/websocket
    Sec-websocketWebSocket-Protocol: drug

    8jKS'y:G*Co,Wxa-

!SLIDE bullets incremental smaller
## Algorytm
* Extract numbers at Key1(eg: 4 @1 46546xW%0l 1 5) and concatenate them
* Count number of spaces at Key1
* Devide #1 by #2
* Change the format of #3 into "big-endian 32 bit integer"
* Repeat #1 by #4 for Key2(eg: 12998 5 Y3 1 .P00)
* Concatenate #4, #5, and the body(eg: ^n:ds[4U) of the request
* Digest the result in MD5 format

!SLIDE smaller
    @@@ ruby
    num = key.gsub(/[^\d]/, "").to_i() / key.scan(/ /).size
    [num].pack("N")

!SLIDE
# Jak używać z ruby? #

!SLIDE smaller
    @@@ ruby
    # Gemfile
    gem 'em-websocket'

    # server.rb
    require 'lib/em-websocket'

    EventMachine::WebSocket.start(:host => "0.0.0.0", 
                                  :port => 8080, 
                                  :debug=> true) do |ws|
      ws.onopen    { ws.send "Hello Client!" }
      ws.onmessage { |msg| ws.send "Pong: #{msg}" }
      ws.onclose   { puts "WebSocket closed" }
      ws.onerror   { |e| puts "Error: #{e.message}" }
    end

!SLIDE smaller
    @@@ ruby
    # Gemfile
    gem 'cramp', :require => 'cramp/controller'

    # config/initializers/cramp_server.rb
    Cramp::Controller::Websocket.backend = :thin

    # app/cramps/communications_controller.rb
    class CommunicationsController < Cramp::Controller::Websocket
      periodic_timer :send_hello_world, :every => 2
      on_data :received_data
     
      def received_data(data)
        if data =~ /stop/
          render "You stopped the process"
          finish
        else
          render "Got your #{data}"
        end
      end
     
      def send_hello_world
        render "Hello from the Server!"
      end
    end

    # config/routes.rb
    match "/communicate", :to => CommunicationsController

!SLIDE
# Przeglądarka #

!SLIDE smaller
    @@@ javascript
    $(document).ready(function(){
      ws = new WebSocket("ws://localhost:10000");
      ws.onmessage = function(evt) { alert(event.data); }
      ws.onclose = function() { alert("socket closed"); };
      ws.onopen = function() {
        alert('socket open');
        ws.send("hello server");
      };
    });

!SLIDE bullets incremental
# Idealne? Nie
* proxy (low-level TCP)
* Content-Length - brak
* draft (ale czy to wada?)

!SLIDE
# Pytania? #

!SLIDE bullets incremental smaller
* http://en.wikipedia.org/wiki/WebSockets
* http://www.ietf.org/mail-archive/web/hybi/current/msg02149.html
* http://laktek.com/2010/02/16/building-real-time-web-apps-with-rails3/
* http://tools.ietf.org/id/draft-hixie-thewebsocketprotocol-75.txt
* http://tools.ietf.org/id/draft-hixie-thewebsocketprotocol-76.txt
* https://github.com/igrigorik/em-websocket
