import 'dart:math';

import 'package:http/http.dart' as http;

import '../config/claves.dart';
import '../modelos/estado_animo.dart';
import '../modelos/pelicula.dart';
import 'cliente_api.dart';

/// Reto 1: películas de TMDB según el estado de ánimo.
class ServicioPeliculas {
  final http.Client _cliente;
  final String apiKey;
  final Random _azar;

  ServicioPeliculas({http.Client? cliente, String? apiKey, Random? azar})
      : _cliente = cliente ?? http.Client(),
        apiKey = apiKey ?? Claves.tmdb,
        _azar = azar ?? Random();

  Uri construirUri(EstadoAnimo animo, {int pagina = 1}) {
    final comunes = {'api_key': apiKey, 'language': 'es-MX'};
    if (animo.generoId == null) {
      return Uri.https('api.themoviedb.org', '/3/trending/movie/week', comunes);
    }
    return Uri.https('api.themoviedb.org', '/3/discover/movie', {
      ...comunes,
      'with_genres': '${animo.generoId}',
      'sort_by': 'popularity.desc',
      'include_adult': 'false',
      'page': '$pagina',
    });
  }

  /// Lista de películas para ese estado de ánimo.
  Future<List<Pelicula>> buscar(EstadoAnimo animo, {int pagina = 1}) async {
    if (apiKey.isEmpty) {
      throw const ErrorApi(
          'Falta la API key de TMDB. Corre la app con --dart-define-from-file=secrets.json');
    }
    final datos = await obtenerJson(
      _cliente,
      construirUri(animo, pagina: pagina),
      servicio: 'TMDB',
      mensajes: const {401: 'La API key de TMDB no es válida.'},
    ) as Map<String, dynamic>;
    final resultados = datos['results'] as List? ?? const [];
    return resultados
        .map((e) => Pelicula.desdeJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Una sola película al azar (de una página al azar, para que varíe).
  Future<Pelicula> alAzar(EstadoAnimo animo) async {
    final lista = await buscar(animo, pagina: 1 + _azar.nextInt(5));
    if (lista.isEmpty) throw const ErrorApi('No encontré películas, intenta otra vez.');
    return lista[_azar.nextInt(lista.length)];
  }
}
