import 'dart:convert';

import 'package:cuatro_retos/logica/cliente_api.dart';
import 'package:cuatro_retos/logica/servicio_cripto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('pide BTC, ETH y SOL en dólares', () {
    final q = ServicioCripto().construirUri().queryParameters;
    expect(q['ids'], 'bitcoin,ethereum,solana');
    expect(q['vs_currencies'], 'usd');
  });

  test('convierte la respuesta en la lista de criptos', () async {
    final cliente = MockClient((_) async => http.Response(
        jsonEncode({
          'solana': {'usd': 150.5},
          'bitcoin': {'usd': 64000},
          'ethereum': {'usd': 3200.25},
        }),
        200));
    final lista = await ServicioCripto(cliente: cliente).precios();
    expect(lista.map((c) => c.simbolo), ['BTC', 'ETH', 'SOL']);
    expect(lista.first.precioUsd, 64000.0);
    expect(lista.last.precioUsd, 150.5);
  });

  test('si falta una moneda en la respuesta, no truena', () async {
    final cliente = MockClient((_) async =>
        http.Response(jsonEncode({'bitcoin': {'usd': 64000}}), 200));
    final lista = await ServicioCripto(cliente: cliente).precios();
    expect(lista.length, 1);
  });

  test('demasiadas consultas (429) da mensaje claro', () {
    final cliente = MockClient((_) async => http.Response('{}', 429));
    expect(
      () => ServicioCripto(cliente: cliente).precios(),
      throwsA(isA<ErrorApi>().having((e) => e.mensaje, 'mensaje', contains('Espera'))),
    );
  });
}
