import 'package:bigsam_pos/global/outlet.dart';
import 'package:bigsam_pos/pages/pembaran_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bigsam_pos/models/outlet.dart';
import 'package:bigsam_pos/utils/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

import '../utils/formater.dart';

class Pembayaran extends StatefulWidget {
  const Pembayaran({required this.total, Key? key}) : super(key: key);
  final String total;

  @override
  _PembayaranState createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
  final _uangController = TextEditingController();
  String ppn = '0';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pembayaran',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rp. ${widget.total}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  'Sub Total',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp. ${widget.total}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ]),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<List<OutletModel>>(
                future: DatabaseHelper.instance.getOutlet(),
                builder: (context, snapshot) {
                  outletGlobal = snapshot.data;
                  if (snapshot.hasData) {
                    if (snapshot.data![0].pajak != 0) {
                      ppn = _calculatePPN(widget.total);

                      return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'PPN',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Rp. ${_calculatePPN(widget.total)}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ]);
                    }
                  }
                  return Container();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Total(
                subtotal: widget.total,
                ppn: ppn,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _uangController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyPtBrInputFormatter()
                ],
                onChanged: (value) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  labelText: 'Masukan Jumlah Uang',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _uangController.text == ''
                  ? ElevatedButton(
                      onPressed: () {
                        if (outletGlobal == null) {
                          Fluttertoast.showToast(
                              msg: 'Belum Ada Outlet',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PembayaranResult(
                                        total: widget.total,
                                        uang: _uangController.text,
                                        subTotal: widget.total,
                                        ppn: ppn == '0'
                                            ? '0'
                                            : _calculatePPN(widget.total),
                                      )));
                        }
                      },
                      child: const Text('Uang Pas'))
                  : ElevatedButton(
                      onPressed: () {
                        var check =
                            _checkInput(widget.total, _uangController.text);
                        if (check == true) {
                          if (outletGlobal == null) {
                            Fluttertoast.showToast(
                                msg: 'Belum Ada Outlet',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PembayaranResult(
                                          total: widget.total,
                                          uang: _uangController.text,
                                          subTotal: widget.total,
                                          ppn: ppn == '0'
                                              ? '0'
                                              : _calculatePPN(widget.total),
                                        )));
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Uang tidak cukup',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: const Text('Bayar'),
                    ),
            ],
          ),
        ));
  }
}

class Total extends StatelessWidget {
  const Total({required this.subtotal, required this.ppn, Key? key})
      : super(key: key);
  final String subtotal;
  final String ppn;
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        'Total',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Text(
        'Rp. ${_total(subtotal, ppn)}',
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ]);
  }
}

_calculatePPN(String subtotal) {
  var totalHarga = double.parse(subtotal.replaceAll('.', ''));
  var pajak = totalHarga * 0.1;
  return _formating(pajak);
}

_total(String subtotal, String ppn) {
  var totalHarga = double.parse(subtotal.replaceAll('.', ''));
  var pajak = ppn == null ? 0 : double.parse(ppn.replaceAll('.', ''));
  var total = totalHarga + pajak;
  return _formating(total);
}

_formating(double value) {
  final formatter =
      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp. ');
  String newText = formatter.format(value).replaceAll('Rp. ', '');
  return newText;
}

_checkInput(String total, String uang) {
  var totalHarga = double.parse(total.replaceAll('.', ''));
  var uangPembayaran = double.parse(uang.replaceAll('.', ''));
  if (uangPembayaran < totalHarga) {
    return false;
  } else {
    return true;
  }
}
