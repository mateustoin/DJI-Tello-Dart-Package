import 'dart:convert';
import 'dart:io';
import 'dart:collection';
// Package required for required
import 'package:meta/meta.dart';

class ConnectTello {
	static ConnectTello _inicializeTello;

	// Tello's default IP Address and Port
	var _addressesDrone = new InternetAddress('192.168.10.1');
  	int _portDrone = 8889;
	static RawDatagramSocket _udpSocket;

	// Command storage to execute
	static Queue<List<int>> commands = new Queue<List<int>>();

	factory ConnectTello({@required InternetAddress localIP, int port = 9000}) {
		// If an object of ConnectTello doesn't exist
		if (_inicializeTello == null){
			_inicializeTello = new ConnectTello._connection(localIP, port);
		}

		return _inicializeTello;
	}

	Future<void> connectSocket(InternetAddress localIP, int port) async {
		RawDatagramSocket.bind(localIP, port)
      	.then((RawDatagramSocket udpSocket) async{
    		udpSocket.forEach((RawSocketEvent event) {
      			if (event == RawSocketEvent.read) {
					Datagram dg = udpSocket.receive();
					dg.data.forEach((x) => stdout.write(String.fromCharCode(x)));
					stdout.write('\n');
				}
    		});
			
			_udpSocket = udpSocket;

			while(true){
				while (commands.length != 0){
					var command = commands.removeFirst();
					udpSocket.send(command, _addressesDrone, _portDrone);
				}

				await Future.delayed(const Duration(milliseconds: 10));
			}
			/*
			var data = "command";
			var codec = new Utf8Codec();
			List<int> dataToSend = codec.encode(data);
			udpSocket.send(dataToSend, _addressesDrone, _portDrone);
			*/
  		});
	}
	ConnectTello._connection(InternetAddress localIP, int port) {
		connectSocket(localIP, port);
	}

	void sendCommand(String data) async{
		var codec = new Utf8Codec();
		List<int> dataToSend = codec.encode(data);
		commands.add(dataToSend);
	}
}

main() async{
	/*var data = "command";
	var codec = new Utf8Codec();

	var addressesDrone = new InternetAddress('192.168.10.1');
	int portDrone = 8889; //0 is random

	List<int> dataToSend = codec.encode(data);
	var addressesIListenFrom = new InternetAddress('192.168.10.3');
	int portIListenOn = 3030; //0 is random
	RawDatagramSocket.bind(addressesIListenFrom, portIListenOn)
		.then((RawDatagramSocket udpSocket) {
		udpSocket.forEach((RawSocketEvent event) {
		if (event == RawSocketEvent.read) {
			Datagram dg = udpSocket.receive();
			dg.data.forEach((x) => stdout.write(String.fromCharCode(x)));
			stdout.write('\n');
		}
		});
		//udpSocket.send(dataToSend, addressesDrone, portDrone);

	});*/
	var ip = InternetAddress('192.168.10.3');
	var tello = new ConnectTello(localIP: ip);
	while(true){
		await Future.delayed(const Duration(milliseconds: 1));
		stdout.write('Digite um comando: ');
		String nome = stdin.readLineSync();
		await tello.sendCommand(nome);
	}
}
