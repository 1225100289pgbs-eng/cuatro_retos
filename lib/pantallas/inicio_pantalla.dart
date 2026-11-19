import 'package:flutter/material.dart';

import 'clima_pantalla.dart';
import 'cripto_pantalla.dart';
import 'gatos_pantalla.dart';
import 'peliculas_pantalla.dart';

/// Pantalla principal: una pestaña por reto.
class InicioPantalla extends StatefulWidget {
  const InicioPantalla({super.key});

  @override
  State<InicioPantalla> createState() => _InicioPantallaState();
}

class _InicioPantallaState extends State<InicioPantalla> {
  int _indice = 0;

  static const _titulos = [
    '🎬 Recomendador de películas',
    '🐱 Memes de gatos',
    '🌤️ Clima minimalista',
    '🪙 Convertidor cripto',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titulos[_indice])),
      // IndexedStack conserva el estado de cada pestaña al cambiar.
      body: IndexedStack(index: _indice, children: const [
        PeliculasPantalla(),
        GatosPantalla(),
        ClimaPantalla(),
        CriptoPantalla(),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.movie), label: 'Películas'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'Gatos'),
          NavigationDestination(icon: Icon(Icons.wb_sunny), label: 'Clima'),
          NavigationDestination(icon: Icon(Icons.currency_bitcoin), label: 'Cripto'),
        ],
      ),
    );
  }
}
