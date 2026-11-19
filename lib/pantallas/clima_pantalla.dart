import 'package:flutter/material.dart';

import '../logica/servicio_clima.dart';
import '../modelos/clima.dart';
import '../widgets/mensaje_error.dart';
import '../widgets/tarjeta_clima.dart';

/// Reto 3: clima actual de una ciudad, con estado de carga.
class ClimaPantalla extends StatefulWidget {
  const ClimaPantalla({super.key});

  @override
  State<ClimaPantalla> createState() => _ClimaPantallaState();
}

class _ClimaPantallaState extends State<ClimaPantalla> {
  final _servicio = ServicioClima();
  final _ciudad = TextEditingController(text: 'Dolores Hidalgo, MX');
  late Future<Clima> _futuro = _servicio.obtener(_ciudad.text);

  void _buscar() {
    FocusScope.of(context).unfocus();
    setState(() => _futuro = _servicio.obtener(_ciudad.text));
  }

  @override
  void dispose() {
    _ciudad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          controller: _ciudad,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _buscar(),
          decoration: InputDecoration(
            labelText: 'Ciudad',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: _buscar),
          ),
        ),
      ),
      Expanded(
        child: FutureBuilder<Clima>(
          future: _futuro,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return MensajeError(mensaje: snap.error.toString(), onReintentar: _buscar);
            }
            return Center(
              child: SingleChildScrollView(child: TarjetaClima(clima: snap.data!)),
            );
          },
        ),
      ),
    ]);
  }
}
