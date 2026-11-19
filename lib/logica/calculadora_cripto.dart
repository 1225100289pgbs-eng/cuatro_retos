/// Reto 4: cuentas del convertidor. Dart puro, sin Flutter.

/// Convierte lo que escribió el usuario ("1,500.50", "$20") a double.
/// Regresa null si no es un monto válido mayor a cero.
double? leerMonto(String texto) {
  final limpio = texto.replaceAll(RegExp(r'[\$,\s]'), '');
  final valor = double.tryParse(limpio);
  if (valor == null || valor <= 0 || valor.isInfinite || valor.isNaN) return null;
  return valor;
}

/// Cuántas unidades de la cripto compras con [usd] dólares.
double cuantoCompro(double usd, double precioUsd) =>
    precioUsd <= 0 ? 0 : usd / precioUsd;

/// Muestra más decimales cuando la cantidad es pequeña (0.00012345 BTC).
String formatearCantidad(double cantidad) =>
    cantidad >= 1 ? cantidad.toStringAsFixed(4) : cantidad.toStringAsFixed(8);

/// 64321.5 -> "$64,321.50"
String formatearUsd(double valor) {
  final partes = valor.toStringAsFixed(2).split('.');
  final entero = partes[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return '\$$entero.${partes[1]}';
}
