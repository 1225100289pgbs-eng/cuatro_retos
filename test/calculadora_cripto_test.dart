import 'package:cuatro_retos/logica/calculadora_cripto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('leerMonto entiende formatos comunes', () {
    expect(leerMonto('100'), 100);
    expect(leerMonto('1,500.50'), 1500.5);
    expect(leerMonto('\$ 20'), 20);
  });

  test('leerMonto rechaza montos inválidos', () {
    expect(leerMonto(''), isNull);
    expect(leerMonto('abc'), isNull);
    expect(leerMonto('0'), isNull);
    expect(leerMonto('-5'), isNull);
  });

  test('cuantoCompro divide dólares entre precio', () {
    expect(cuantoCompro(100, 50), 2);
    expect(cuantoCompro(100, 64000), closeTo(0.0015625, 1e-10));
  });

  test('cuantoCompro no divide entre cero', () {
    expect(cuantoCompro(100, 0), 0);
  });

  test('formatos para mostrar', () {
    expect(formatearUsd(64321.5), '\$64,321.50');
    expect(formatearUsd(150), '\$150.00');
    expect(formatearCantidad(2), '2.0000');
    expect(formatearCantidad(0.0015625), '0.00156250');
  });
}
