import 'dart:convert';

import 'package:http/http.dart' as http;

/// Error con un mensaje que SÍ se le puede mostrar al usuario.
class ErrorApi implements Exception {
  final String mensaje;
  const ErrorApi(this.mensaje);
  @override
  String toString() => mensaje;
}

/// Hace un GET y regresa el JSON ya decodificado.
/// Convierte cualquier falla (sin internet, tiempo agotado, código de error,
/// JSON roto) en un ErrorApi con mensaje amable.
Future<dynamic> obtenerJson(
  http.Client cliente,
  Uri uri, {
  required String servicio,
  Map<int, String> mensajes = const {},
}) async {
  http.Response r;
  try {
    r = await cliente.get(uri).timeout(const Duration(seconds: 12));
  } catch (_) {
    throw ErrorApi('No hay conexión con $servicio. Revisa tu internet.');
  }
  if (r.statusCode != 200) {
    throw ErrorApi(
        mensajes[r.statusCode] ?? '$servicio respondió con error (${r.statusCode}).');
  }
  try {
    return jsonDecode(utf8.decode(r.bodyBytes));
  } catch (_) {
    throw ErrorApi('$servicio mandó datos que no se pueden leer.');
  }
}
