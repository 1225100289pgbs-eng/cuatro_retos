class Pelicula {
  final int id;
  final String titulo;
  final String resumen;
  final String? poster;
  final double calificacion;
  final String fecha;

  const Pelicula({
    required this.id,
    required this.titulo,
    required this.resumen,
    required this.poster,
    required this.calificacion,
    required this.fecha,
  });

  String? get urlPoster =>
      poster == null ? null : 'https://image.tmdb.org/t/p/w500$poster';

  String get anio => fecha.length >= 4 ? fecha.substring(0, 4) : '';

  factory Pelicula.desdeJson(Map<String, dynamic> j) {
    final resumen = (j['overview'] as String? ?? '').trim();
    return Pelicula(
      id: j['id'] as int,
      titulo: (j['title'] ?? j['name'] ?? 'Sin título') as String,
      resumen: resumen.isEmpty ? 'Sin descripción en español.' : resumen,
      poster: j['poster_path'] as String?,
      calificacion: (j['vote_average'] as num?)?.toDouble() ?? 0,
      fecha: j['release_date'] as String? ?? '',
    );
  }
}
