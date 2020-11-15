import 'dart:io';

void main() {
	stdout.write('Digite um comando: ');
	String nome = stdin.readLineSync();

	print('O nome inserido foi: $nome');
	stdout.write('O nome inserido foi: $nome\n');
}