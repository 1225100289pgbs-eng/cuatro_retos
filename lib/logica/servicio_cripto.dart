import 'package:http/http.dart' as http;

import '../modelos/cripto.dart';
import 'cliente_api.dart';

/// Reto 4: precios de CoinGecko (API pública, sin key).
class ServicioCripto {
  final http.Client _cliente;
  ServicioCripto({http.Client? cliente}) : _cliente = cliente ?? http.Client();

  /// id de CoinGecko -> (nombre, símbolo)
  static const monedas = {
    'bitcoin': ('Bitcoin', 'BTC'),
    'ethereum': ('Ethereum', 'ETH'),
    'solana': ('Solana', 'SOL'),
  };

  Uri construirUri() => Uri.https('api.coingecko.com', '/api/v3/simple/price', {
        'ids': monedas.keys.join(','),
        'vs_currencies': 'usd',
      });

  Future<List<Cripto>> precios() async {
    final datos = await obtenerJson(
      _cliente,
      construirUri(),
      servicio: 'CoinGecko',
      mensajes: const {429: 'Demasiadas consultas a CoinGecko. Espera un minuto.'},
    ) as Map<String, dynamic>;
    return [
      for (final e in monedas.entries)
        if (datos[e.key] is Map && (datos[e.key] as Map)['usd'] is num)
          Cripto(
            id: e.key,
            nombre: e.value.$1,
            simbolo: e.value.$2,
            precioUsd: ((datos[e.key] as Map)['usd'] as num).toDouble(),
          ),
    ];
  }
}
