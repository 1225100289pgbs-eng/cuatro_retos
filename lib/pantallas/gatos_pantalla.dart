import 'package:flutter/material.dart';

import '../logica/servicio_gatos.dart';

/// Reto 2: el texto del TextField viaja en la URL y aparece sobre el gato.
class GatosPantalla extends StatefulWidget {
  const GatosPantalla({super.key});

  @override
  State<GatosPantalla> createState() => _GatosPantallaState();
}

class _GatosPantallaState extends State<GatosPantalla> {
  final _servicio = ServicioGatos();
  final _texto = TextEditingController();
  String _color = 'white';
  FiltroGato _filtro = FiltroGato.ninguno;
  late String _url = _servicio.urlGato();

  static const _colores = {
    'white': Colors.white,
    'yellow': Colors.yellow,
    'red': Colors.red,
    'cyan': Colors.cyan,
  };

  void _generar() {
    FocusScope.of(context).unfocus();
    setState(() {
      _url = _servicio.urlGato(texto: _texto.text, color: _color, filtro: _filtro);
    });
  }

  @override
  void dispose() {
    _texto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(12), children: [
      TextField(
        controller: _texto,
        maxLength: 40,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _generar(),
        decoration: const InputDecoration(
          labelText: 'Frase del meme',
          hintText: 'Ej. Cuando es lunes',
          border: OutlineInputBorder(),
        ),
      ),
      const Text('Color del texto'),
      Wrap(spacing: 8, children: [
        for (final c in _colores.entries)
          ChoiceChip(
            avatar: CircleAvatar(backgroundColor: c.value, radius: 8),
            label: Text(c.key),
            selected: _color == c.key,
            onSelected: (_) => setState(() => _color = c.key),
          ),
      ]),
      const SizedBox(height: 8),
      const Text('Filtro'),
      Wrap(spacing: 8, children: [
        for (final f in FiltroGato.values)
          ChoiceChip(
            label: Text(f.etiqueta),
            selected: _filtro == f,
            onSelected: (_) => setState(() => _filtro = f),
          ),
      ]),
      const SizedBox(height: 12),
      FilledButton.icon(
        onPressed: _generar,
        icon: const Icon(Icons.pets),
        label: const Text('¡Generar meme!'),
      ),
      const SizedBox(height: 12),
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          _url,
          key: ValueKey(_url),
          height: 360,
          fit: BoxFit.cover,
          loadingBuilder: (_, hijo, progreso) => progreso == null
              ? hijo
              : const SizedBox(
                  height: 360, child: Center(child: CircularProgressIndicator())),
          errorBuilder: (_, __, ___) => const SizedBox(
            height: 200,
            child: Center(child: Text('😿 No se pudo cargar el gato. Intenta otra vez.')),
          ),
        ),
      ),
      const SizedBox(height: 8),
      SelectableText(_url, style: Theme.of(context).textTheme.bodySmall),
    ]);
  }
}
