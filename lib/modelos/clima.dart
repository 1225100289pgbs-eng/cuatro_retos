class Clima {
  final String ciudad;
  final double temperatura;
  final double sensacion;
  final int humedad;
  final double vientoKmh;
  final String descripcion;
  final String icono;

  const Clima({
    required this.ciudad,
    required this.temperatura,
    required this.sensacion,
    required this.humedad,
    required this.vientoKmh,
    required this.descripcion,
    required this.icono,
  });

  String get urlIcono => 'https://openweathermap.org/img/wn/$icono@4x.png';

  factory Clima.desdeJson(Map<String, dynamic> j) {
    final main = j['main'] as Map<String, dynamic>;
    final lista = j['weather'] as List? ?? const [];
    final w = lista.isEmpty ? const <String, dynamic>{} : lista.first as Map<String, dynamic>;
    final desc = w['description'] as String? ?? '';
    final viento = (j['wind'] as Map<String, dynamic>?)?['speed'] as num? ?? 0;
    return Clima(
      ciudad: j['name'] as String? ?? '',
      temperatura: (main['temp'] as num).toDouble(),
      sensacion: (main['feels_like'] as num? ?? main['temp'] as num).toDouble(),
      humedad: (main['humidity'] as num? ?? 0).toInt(),
      vientoKmh: viento.toDouble() * 3.6, // la API da m/s
      descripcion: desc.isEmpty ? '' : desc[0].toUpperCase() + desc.substring(1),
      icono: w['icon'] as String? ?? '01d',
    );
  }
}
