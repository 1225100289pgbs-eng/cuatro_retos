import 'package:flutter/material.dart';

import '../logica/servicio_peliculas.dart';
import '../modelos/estado_animo.dart';
import '../modelos/pelicula.dart';
import '../widgets/mensaje_error.dart';
import '../widgets/tarjeta_pelicula.dart';

/// Reto 1: el usuario elige su ánimo y ve una película al azar o una lista.
class PeliculasPantalla extends StatefulWidget {
  const PeliculasPantalla({super.key});

  @override
  State<PeliculasPantalla> createState() => _PeliculasPantallaState();
}

class _PeliculasPantallaState extends State<PeliculasPantalla> {
  final _servicio = ServicioPeliculas();
  EstadoAnimo _animo = EstadoAnimo.tendencias;
  bool _alAzar = false;
  bool _cargando = true;
  String? _error;
  List<Pelicula> _peliculas = [];

  @override
  void initState() {
    super.initState();
    // Espera a que la pantalla exista antes de llamar setState.
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargar());
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final resultado = _alAzar
          ? [await _servicio.alAzar(_animo)]
          : await _servicio.buscar(_animo);
      if (!mounted) return;
      setState(() => _peliculas = resultado);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 4),
        child: Text('¿Cómo te sientes este fin de semana?'),
      ),
      SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            for (final a in EstadoAnimo.values)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text('${a.emoji} ${a.etiqueta}'),
                  selected: a == _animo,
                  onSelected: (_) {
                    setState(() => _animo = a);
                    _cargar();
                  },
                ),
              ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: false, icon: Icon(Icons.list), label: Text('Lista')),
            ButtonSegment(value: true, icon: Icon(Icons.casino), label: Text('Al azar')),
          ],
          selected: {_alAzar},
          onSelectionChanged: (s) {
            setState(() => _alAzar = s.first);
            _cargar();
          },
        ),
      ),
      Expanded(child: _contenido()),
    ]);
  }

  Widget _contenido() {
    if (_cargando) return const Center(child: CircularProgressIndicator());
    if (_error != null) return MensajeError(mensaje: _error!, onReintentar: _cargar);
    return RefreshIndicator(
      onRefresh: _cargar,
      child: ListView(children: [
        for (final p in _peliculas) TarjetaPelicula(pelicula: p),
        if (_alAzar)
          Padding(
            padding: const EdgeInsets.all(12),
            child: OutlinedButton.icon(
              onPressed: _cargar,
              icon: const Icon(Icons.casino),
              label: const Text('Otra al azar'),
            ),
          ),
      ]),
    );
  }
}
