import 'dart:convert';
import 'dart:math';

import 'package:cuatro_retos/logica/cliente_api.dart';
import 'package:cuatro_retos/logica/servicio_peliculas.dart';
import 'package:cuatro_retos/modelos/estado_animo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

String jsonPeliculas() => jsonEncode({
      'results': [
        {
          'id': 1,
          'title': 'Coco',
          'overview': 'Miguel viaja a la Tierra de los Muertos.',
          'poster_path': '/coco.jpg',
          'vote_average': 8.2,
          'release_date': '2017-10-27',
        },
        {
          'id': 2,
          'title': 'Sin póster',
          'overview': '',
          'poster_path': null,
          'vote_average': 6,
          'release_date': '',
        },
      ],
    });

void main() {
  test('cada estado de ánimo pide su género a TMDB', () {
    final s = ServicioPeliculas(apiKey: 'abc');
    final uri = s.construirUri(EstadoAnimo.feliz);
    expect(uri.path, '/3/discover/movie');
    expect(uri.queryParameters['with_genres'], '35');
    expect(uri.queryParameters['api_key'], 'abc');
    expect(uri.queryParameters['language'], 'es-MX');
  });

  test('tendencias usa el endpoint de trending', () {
    final uri = ServicioPeliculas(apiKey: 'abc').construirUri(EstadoAnimo.tendencias);
    expect(uri.path, '/3/trending/movie/week');
  });

  test('buscar convierte el JSON en películas', () async {
    final cliente = MockClient((_) async =>
        http.Response.bytes(utf8.encode(jsonPeliculas()), 200));
    final lista = await ServicioPeliculas(cliente: cliente, apiKey: 'abc')
        .buscar(EstadoAnimo.feliz);
    expect(lista.length, 2);
    expect(lista.first.titulo, 'Coco');
    expect(lista.first.urlPoster, 'https://image.tmdb.org/t/p/w500/coco.jpg');
    expect(lista.first.anio, '2017');
    expect(lista.last.urlPoster, isNull);
    expect(lista.last.resumen, 'Sin descripción en español.');
  });

  test('alAzar regresa una de las películas recibidas', () async {
    final cliente = MockClient((_) async =>
        http.Response.bytes(utf8.encode(jsonPeliculas()), 200));
    final p = await ServicioPeliculas(cliente: cliente, apiKey: 'abc', azar: Random(7))
        .alAzar(EstadoAnimo.miedo);
    expect([1, 2], contains(p.id));
  });

  test('sin API key avisa con mensaje claro', () {
    expect(
      () => ServicioPeliculas(apiKey: '').buscar(EstadoAnimo.feliz),
      throwsA(isA<ErrorApi>().having((e) => e.mensaje, 'mensaje', contains('API key'))),
    );
  });

  test('key inválida (401) da mensaje de TMDB', () {
    final cliente = MockClient((_) async => http.Response('{}', 401));
    expect(
      () => ServicioPeliculas(cliente: cliente, apiKey: 'mala').buscar(EstadoAnimo.feliz),
      throwsA(isA<ErrorApi>().having((e) => e.mensaje, 'mensaje', contains('no es válida'))),
    );
  });
}
