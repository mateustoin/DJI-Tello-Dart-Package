import 'dart:convert';
import 'dart:io';

main() {
  RawDatagramSocket.bind("192.168.0.10", 8889).then((socket) => {
    socket.listen((event) {
        if(event == RawSocketEvent.read) {
          Datagram dg = socket.receive();

          if(dg == null) return;

          String data = "Drone Recebeu: ";
          
          dg.data.forEach((x) => data += String.fromCharCode(x));
          print(data);
          
          socket.send(Utf8Codec().encode("OK"), dg.address, dg.port);
        }
    })
  });
}