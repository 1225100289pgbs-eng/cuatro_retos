import 'package:flutter/material.dart';

import '../logica/calculadora_cripto.dart';
import '../logica/servicio_cripto.dart';
import '../modelos/cripto.dart';
import '../widgets/mensaje_error.dart';
import '../widgets/tarjeta_cripto.dart';

/// Reto 4: precios de BTC, ETH y SOL y cuánto compras con tus dólares.
class CriptoPantalla extends StatefulWidget {
  const CriptoPantalla({super.key});

  @override
  State<CriptoPantalla> createState() => _CriptoPantallaState();
}

class _CriptoPantallaState extends State<CriptoPantalla> {
  final _servicio = ServicioCripto();
  final _monto = TextEditingController(text: '100');
  late Future<List<Cripto>> _futuro = _servicio.precios();
  double? _usd = 100;

  void _refrescar() => setState(() => _futuro = _servicio.precios());

  @override
  void dispose() {
    _monto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          controller: _monto,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (t) => setState(() => _usd = leerMonto(t)),
          decoration: InputDecoration(
            labelText: '¿Cuántos dólares quieres invertir?',
            prefixText: '\$ ',
            border: const OutlineInputBorder(),
            errorText: _monto.text.isNotEmpty && _usd == null
                ? 'Escribe un monto mayor a 0'
                : null,
          ),
        ),
      ),
      Expanded(
        child: FutureBuilder<List<Cripto>>(
          future: _futuro,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return MensajeError(mensaje: snap.error.toString(), onReintentar: _refrescar);
            }
            final lista = snap.data!;
            return RefreshIndicator(
              onRefresh: () async => _refrescar(),
              child: ListView(children: [
                for (final c in lista) TarjetaCripto(cripto: c, montoUsd: _usd),
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Jala hacia abajo para actualizar precios. Datos: CoinGecko.',
                      textAlign: TextAlign.center),
                ),
              ]),
            );
          },
        ),
      ),
    ]);
  }
}
