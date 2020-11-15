import 'dart:async';

import 'dart:io';
import 'ConnecTello.dart';

main() async {

	var ip = InternetAddress('192.168.0.10');
	var tello = new ConnectTello(localIP: ip);

  while(true) {
    stdout.write('Digite um comando: ');
    String comando = stdin.readLineSync();
    tello.sendCommand(comando);
    await Future.delayed(Duration(milliseconds: 100));
  }
  
}
