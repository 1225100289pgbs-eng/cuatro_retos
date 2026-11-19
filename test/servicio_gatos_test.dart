import 'package:cuatro_retos/logica/servicio_gatos.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final s = ServicioGatos();

  test('sin texto pide un gato normal', () {
    final url = s.urlGato(semilla: 1);
    expect(url, 'https://cataas.com/cat?v=1');
  });

  test('el texto viaja en la URL, codificado', () {
    final url = s.urlGato(texto: 'Hola gato', semilla: 1);
    expect(url, startsWith('https://cataas.com/cat/says/Hola%20gato?'));
    expect(url, contains('fontColor=white'));
    expect(url, contains('fontSize=40'));
  });

  test('acentos y signos no rompen la URL', () {
    final url = s.urlGato(texto: '¿Ya es viernes?', semilla: 1);
    expect(Uri.parse(url).pathSegments.last, '¿Ya es viernes?');
  });

  test('color y filtro cambian los parámetros', () {
    final url = s.urlGato(texto: 'Miau', color: 'yellow', filtro: FiltroGato.mono, semilla: 1);
    final q = Uri.parse(url).queryParameters;
    expect(q['fontColor'], 'yellow');
    expect(q['filter'], 'mono');
  });

  test('una semilla distinta da una URL distinta (gato nuevo)', () {
    expect(s.urlGato(semilla: 1), isNot(s.urlGato(semilla: 2)));
  });
}
