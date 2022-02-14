import 'package:bigsam_pos/models/outlet.dart';
import 'package:bigsam_pos/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PPN extends StatelessWidget {
  const PPN({required this.subtotal, Key? key}) : super(key: key);
  final String subtotal;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OutletModel>>(
      future: DatabaseHelper.instance.getOutlet(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data![0].pajak != 0) {
            return SizedBox(
              width: MediaQuery.of(context).size.width / 3.0,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PPN : ',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp. ' + _calculatePPN(subtotal),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return Container();
      },
    );
  }
}

_calculatePPN(String subtotal) {
  var total_harga = double.parse(subtotal.replaceAll('.', ''));
  var pajak = total_harga * 0.1;
  return _formating(pajak);
}

_formating(double value) {
  final formatter =
      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp. ');
  String newText = formatter.format(value).replaceAll('Rp. ', '');
  return newText;
}
