import 'package:flutter/material.dart';

import '../modelos/pelicula.dart';

/// Card con el póster y los datos de una película.
class TarjetaPelicula extends StatelessWidget {
  final Pelicula pelicula;
  const TarjetaPelicula({super.key, required this.pelicula});

  @override
  Widget build(BuildContext context) {
    final url = pelicula.urlPoster;
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          width: 110,
          height: 165,
          child: url == null
              ? const ColoredBox(
                  color: Colors.black12, child: Icon(Icons.movie, size: 48))
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(pelicula.titulo,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text('⭐ ${pelicula.calificacion.toStringAsFixed(1)}   ${pelicula.anio}'),
              const SizedBox(height: 6),
              Text(pelicula.resumen, maxLines: 5, overflow: TextOverflow.ellipsis),
            ]),
          ),
        ),
      ]),
    );
  }
}
