import 'package:flutter/material.dart';

import 'pantallas/inicio_pantalla.dart';

void main() {
  runApp(MaterialApp(
    title: 'Los Cuatro Retos',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),
    home: const InicioPantalla(),
  ));
}
