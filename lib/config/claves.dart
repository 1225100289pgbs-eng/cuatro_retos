/// Las API keys NO se escriben en el código: llegan al compilar con
///   flutter run --dart-define-from-file=secrets.json
class Claves {
  static const tmdb = String.fromEnvironment('TMDB_API_KEY');
  static const clima = String.fromEnvironment('OWM_API_KEY');
}
