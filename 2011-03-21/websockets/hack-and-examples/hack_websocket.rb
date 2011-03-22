require 'socket'

@server = TCPServer.open(50000)

handshake = <<HAND
HTTP/1.1 101 Web Socket Protocol Handshake
Upgrade: WebSocket
Connection: Upgrade
WebSocket-Origin: http://localhost
WebSocket-Location: ws://localhost
WebSocket-Protocol: drug
\r
HAND

client = @server.accept
client.write(handshake)
client.write("\x00Hacked BITCH!\xff")

