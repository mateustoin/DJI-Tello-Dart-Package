# Controlling DJI Tello Drone with Dart

Simple example to control Tello Drone with commands recieved from terminal.

```dart
import 'dart:async';
import 'dart:io';
import 'package:tello/ConnecTello.dart';

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
```