import 'package:flutter/material.dart';

import '../modelos/clima.dart';

/// Tarjeta minimalista del clima actual.
class TarjetaClima extends StatelessWidget {
  final Clima clima;
  const TarjetaClima({super.key, required this.clima});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(clima.ciudad, style: t.headlineMedium),
      Image.network(
        clima.urlIcono,
        width: 140,
        height: 140,
        errorBuilder: (_, __, ___) => const Icon(Icons.wb_sunny, size: 100),
      ),
      Text('${clima.temperatura.round()}°C', style: t.displayLarge),
      Text(clima.descripcion, style: t.titleLarge),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _Dato(icono: Icons.thermostat, texto: 'Sensación ${clima.sensacion.round()}°'),
        _Dato(icono: Icons.water_drop, texto: '${clima.humedad}%'),
        _Dato(icono: Icons.air, texto: '${clima.vientoKmh.round()} km/h'),
      ]),
    ]);
  }
}

class _Dato extends StatelessWidget {
  final IconData icono;
  final String texto;
  const _Dato({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: [Icon(icono), const SizedBox(height: 4), Text(texto)]),
      );
}
