import 'package:flutter/material.dart';

import '../logica/calculadora_cripto.dart';
import '../modelos/cripto.dart';

/// Precio de una cripto y cuánto compras con el monto escrito.
class TarjetaCripto extends StatelessWidget {
  final Cripto cripto;
  final double? montoUsd;
  const TarjetaCripto({super.key, required this.cripto, required this.montoUsd});

  @override
  Widget build(BuildContext context) {
    final monto = montoUsd;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Text(cripto.simbolo.substring(0, 1))),
        title: Text('${cripto.nombre} (${cripto.simbolo})'),
        subtitle: Text('Precio: ${formatearUsd(cripto.precioUsd)} USD'),
        trailing: monto == null
            ? null
            : Text(
                '${formatearCantidad(cuantoCompro(monto, cripto.precioUsd))}\n${cripto.simbolo}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
