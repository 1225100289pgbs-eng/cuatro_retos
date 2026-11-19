import 'dart:convert';

import 'package:cuatro_retos/logica/cliente_api.dart';
import 'package:cuatro_retos/logica/servicio_clima.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const jsonClima = {
  'name': 'Dolores Hidalgo',
  'main': {'temp': 22.6, 'feels_like': 21.9, 'humidity': 40},
  'weather': [
    {'description': 'nubes dispersas', 'icon': '03d'}
  ],
  'wind': {'speed': 5},
};

void main() {
  test('pide el clima en Celsius y en español', () {
    final uri = ServicioClima(apiKey: 'k').construirUri(' Dolores Hidalgo, MX ');
    expect(uri.queryParameters['q'], 'Dolores Hidalgo, MX');
    expect(uri.queryParameters['units'], 'metric');
    expect(uri.queryParameters['lang'], 'es');
    expect(uri.queryParameters['appid'], 'k');
  });

  test('convierte el JSON en un Clima', () async {
    final cliente = MockClient((_) async =>
        http.Response.bytes(utf8.encode(jsonEncode(jsonClima)), 200));
    final c = await ServicioClima(cliente: cliente, apiKey: 'k').obtener('Dolores Hidalgo');
    expect(c.ciudad, 'Dolores Hidalgo');
    expect(c.temperatura.round(), 23);
    expect(c.humedad, 40);
    expect(c.vientoKmh, 18); // 5 m/s = 18 km/h
    expect(c.descripcion, 'Nubes dispersas');
    expect(c.urlIcono, 'https://openweathermap.org/img/wn/03d@4x.png');
  });

  test('ciudad que no existe (404) da mensaje claro', () {
    final cliente = MockClient((_) async => http.Response('{}', 404));
    expect(
      () => ServicioClima(cliente: cliente, apiKey: 'k').obtener('Narnia'),
      throwsA(isA<ErrorApi>().having((e) => e.mensaje, 'mensaje', contains('ciudad'))),
    );
  });

  test('ciudad vacía no hace la petición', () {
    expect(() => ServicioClima(apiKey: 'k').obtener('   '), throwsA(isA<ErrorApi>()));
  });

  test('sin API key avisa', () {
    expect(() => ServicioClima(apiKey: '').obtener('Dolores'), throwsA(isA<ErrorApi>()));
  });
}
