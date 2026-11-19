import 'dart:convert';

import 'package:cuatro_retos/logica/cliente_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final uri = Uri.parse('https://ejemplo.com/datos');

  test('con 200 regresa el JSON decodificado (con acentos)', () async {
    final cliente = MockClient((_) async =>
        http.Response.bytes(utf8.encode('{"ciudad":"Querétaro"}'), 200));
    final datos = await obtenerJson(cliente, uri, servicio: 'Prueba');
    expect(datos['ciudad'], 'Querétaro');
  });

  test('un código de error usa el mensaje personalizado', () async {
    final cliente = MockClient((_) async => http.Response('nope', 401));
    expect(
      () => obtenerJson(cliente, uri, servicio: 'Prueba', mensajes: {401: 'Key mala'}),
      throwsA(isA<ErrorApi>().having((e) => e.mensaje, 'mensaje', 'Key mala')),
    );
  });

  test('un código sin mensaje personalizado dice el número', () async {
    final cliente = MockClient((_) async => http.Response('x', 500));
    expect(
      () => obtenerJson(cliente, uri, servicio: 'Prueba'),
      throwsA(isA<ErrorApi>().having((e) => e.mensaje, 'mensaje', contains('500'))),
    );
  });

  test('sin internet lanza un ErrorApi amable', () async {
    final cliente = MockClient((_) async => throw Exception('socket roto'));
    expect(
      () => obtenerJson(cliente, uri, servicio: 'Prueba'),
      throwsA(isA<ErrorApi>().having((e) => e.mensaje, 'mensaje', contains('conexión'))),
    );
  });

  test('JSON roto lanza un ErrorApi', () async {
    final cliente = MockClient((_) async => http.Response('{no es json', 200));
    expect(() => obtenerJson(cliente, uri, servicio: 'Prueba'), throwsA(isA<ErrorApi>()));
  });
}
