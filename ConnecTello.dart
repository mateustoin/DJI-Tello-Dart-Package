import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';

class ConnectTello {
	static ConnectTello _inicializeTello;
  
  StreamController<String> _controller;
	
	var _addressesDrone = new InternetAddress('192.168.0.10');
  int _portDrone = 8889;

	factory ConnectTello({@required InternetAddress localIP, int port = 9000}) {

		if (_inicializeTello == null)
			_inicializeTello = new ConnectTello._connection(localIP, port);

		return _inicializeTello;
	}

	ConnectTello._connection(InternetAddress localIP, int port) {
    _controller = StreamController<String>();
		connectSocket(localIP, port);
	}

	connectSocket(InternetAddress localIP, int port) {
		RawDatagramSocket.bind(localIP, port).then((socket) {
          socket.forEach((event) {
            if (event == RawSocketEvent.read) {
              Datagram dg = socket.receive();
              dg.data.forEach((x) => stdout.write(String.fromCharCode(x)));
              stdout.write('\n');
            }
    		  }
        );
        
        _controller.stream.listen((event) { 
          socket.send(Utf8Codec().encode(event), _addressesDrone, _portDrone);
        });

  	});
	}

	void sendCommand(String data) {
    _controller.sink.add(data);
	}
}