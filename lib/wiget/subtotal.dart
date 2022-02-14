import 'package:bigsam_pos/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/cart.dart';

class Subtotal extends StatelessWidget {
  const Subtotal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CartModel>>(
      future: DatabaseHelper.instance.getCart(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<CartModel>? cart = snapshot.data;
          final int total = cart!.fold<int>(
              0, (t, e) => t + int.parse(e.total_harga.replaceAll('.', '')));
          return SizedBox(
            width: MediaQuery.of(context).size.width / 3.0,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sub Total : ',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Rp. ' + _formating(total),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }
        return const Text('\$0');
      },
    );
  }
}

_formating(int value) {
  final formatter =
      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp. ');
  String newText = formatter.format(value).replaceAll('Rp. ', '');
  return newText;
}
