import 'dart:io';
import 'package:udp/udp.dart';

var name = 'Mateus';
var lista = ['nome1', 'nome2', 'nome3', 'nome4'];
void main() async{
  print(name);
  sleep(const Duration(seconds:1));
  print(lista[1]);
  //stdout.write(name);
}