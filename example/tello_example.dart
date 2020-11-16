import 'dart:async';
import 'dart:io';
import 'package:tello/telo.dart';

main() async {
  // Connect to Tello when machine WiFi is already connected to the drone
	var tello = new ConnectTello();

  while(true) {
    stdout.write('Write a command: ');
    String comando = stdin.readLineSync();
    tello.sendCommand(comando);
    await Future.delayed(Duration(milliseconds: 100));
  }
}
