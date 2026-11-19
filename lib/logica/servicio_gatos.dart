/// Reto 2: arma la URL de Cataas (Cats as a Service).
/// La API pone el texto encima de la foto si va en la ruta: /cat/says/<texto>
enum FiltroGato {
  ninguno('Normal', null),
  mono('Blanco y negro', 'mono'),
  negativo('Negativo', 'negate'),
  borroso('Borroso', 'blur');

  const FiltroGato(this.etiqueta, this.valor);
  final String etiqueta;
  final String? valor;
}

class ServicioGatos {
  static const base = 'https://cataas.com';

  /// [semilla] cambia la URL para que la app pida un gato NUEVO
  /// (si la URL es idéntica, Flutter reutiliza la imagen guardada).
  String urlGato({
    String texto = '',
    String color = 'white',
    int tamano = 40,
    FiltroGato filtro = FiltroGato.ninguno,
    int? semilla,
  }) {
    final t = texto.trim();
    final ruta = t.isEmpty ? '/cat' : '/cat/says/${Uri.encodeComponent(t)}';
    final params = <String, String>{
      if (t.isNotEmpty) 'fontColor': color,
      if (t.isNotEmpty) 'fontSize': '$tamano',
      if (filtro.valor != null) 'filter': filtro.valor!,
      'v': '${semilla ?? DateTime.now().millisecondsSinceEpoch}',
    };
    final query = params.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return '$base$ruta?$query';
  }
}
