import 'dart:async';
import 'dart:convert';
import 'dart:io';

// Class Singleton
class ConnectTello {
	static ConnectTello _inicializeTello;
  
  // StreamController used to manage tello commands
  StreamController<String> _controller;

  // Default IP and Port to send commands e recieve responses
	var _addressesDrone = new InternetAddress('192.168.10.1');
  int _portDrone = 8889;

  // Machine IP
	static var _addressMachine = new InternetAddress('0.0.0.0');

  // Inicialization of Constructor with default machine port
	factory ConnectTello({int port = 9000}) {

    // If object was not before, connect to Tello
		if (_inicializeTello == null)
			_inicializeTello = new ConnectTello._connection(_addressMachine, port);

		return _inicializeTello;
	}

	ConnectTello._connection(InternetAddress localIP, int port) {
    // Inicialization of StreamController and Connection to socket
    _controller = StreamController<String>();
		connectSocket(localIP, port);
	}

	connectSocket(InternetAddress localIP, int port) {
    // Connecting to tello, listening to Tello response messages and sending commands when controller recieve a command
		RawDatagramSocket.bind(localIP, port)
    .then((socket) {
      socket.forEach((event) {
        if (event == RawSocketEvent.read) {
          Datagram dg = socket.receive();
          dg.data.forEach((x) => stdout.write(String.fromCharCode(x)));
          stdout.write('\n');
        }
    	});
        
      _controller.stream.listen((event) { 
        socket.send(Utf8Codec().encode(event), _addressesDrone, _portDrone);
      });
    });
	}

	void sendCommand(String data) {
    // Sends a command event to controller
    _controller.sink.add(data);
	}
}