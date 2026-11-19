import 'package:http/http.dart' as http;

import '../config/claves.dart';
import '../modelos/clima.dart';
import 'cliente_api.dart';

/// Reto 3: clima actual de OpenWeatherMap.
class ServicioClima {
  final http.Client _cliente;
  final String apiKey;

  ServicioClima({http.Client? cliente, String? apiKey})
      : _cliente = cliente ?? http.Client(),
        apiKey = apiKey ?? Claves.clima;

  Uri construirUri(String ciudad) =>
      Uri.https('api.openweathermap.org', '/data/2.5/weather', {
        'q': ciudad.trim(),
        'appid': apiKey,
        'units': 'metric', // grados Celsius
        'lang': 'es',
      });

  Future<Clima> obtener(String ciudad) async {
    if (apiKey.isEmpty) {
      throw const ErrorApi(
          'Falta la API key de OpenWeatherMap. Corre la app con --dart-define-from-file=secrets.json');
    }
    if (ciudad.trim().isEmpty) throw const ErrorApi('Escribe una ciudad.');
    final datos = await obtenerJson(
      _cliente,
      construirUri(ciudad),
      servicio: 'OpenWeatherMap',
      mensajes: const {
        401: 'La API key del clima no es válida (si es nueva, puede tardar hasta 2 horas en activarse).',
        404: 'No encontré esa ciudad. Prueba con "Ciudad, MX".',
      },
    ) as Map<String, dynamic>;
    return Clima.desdeJson(datos);
  }
}
