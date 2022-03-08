import 'package:bigsam_pos/models/laporan.dart';
import 'package:bigsam_pos/pages/pembaran_result.dart';
import 'package:bigsam_pos/utils/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:bigsam_pos/global/cart.dart';
import '../global/auth.dart';

class Pembayaran extends StatefulWidget {
  const Pembayaran({required this.total, Key? key}) : super(key: key);
  final String total;

  @override
  _PembayaranState createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {
  final CurrencyTextInputFormatter formatter = CurrencyTextInputFormatter();
  String totalFix = '-';
  final _uangController = TextEditingController();
  final _discountController = TextEditingController();
  String discount = "0";
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
                'Rp. ${totalFix == '-' ? widget.total : totalFix}',
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  'Discount',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp. $discount',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ]),
              const SizedBox(
                height: 20,
              ),
              Total(
                subtotal: totalFix == '-' ? widget.total : totalFix,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(children: [
                TextField(
                  controller: _discountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: false),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyTextInputFormatter(
                        locale: 'id_ID', decimalDigits: 0, symbol: '')
                  ],
                  onChanged: (value) async {
                    discount = await _calculateDiscount(value, widget.total);
                    totalFix = _calculateTotal(discount, widget.total);
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    labelText: 'Masukan Discount',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ]),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _uangController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyTextInputFormatter(
                      locale: 'id_ID', decimalDigits: 0, symbol: '')
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
                      onPressed: () async {
                        try {
                          cartGlobal?.forEach((cart) async {
                            await DatabaseHelper.instance
                                .insertLaporan(LaporanModel(
                              kode_transaksi: cart.kode_transaksi,
                              diskon: discount,
                              total_harga: cart.total_harga,
                              total_bayar:
                                  totalFix == '-' ? widget.total : totalFix,
                              kasir: userGlobal!.toUpperCase(),
                              kode_produk: cart.kode_produk,
                              tanggal_transaksi: DateFormat('dd/MM/yyyy')
                                  .format(DateTime.now()),
                              waktu:
                                  DateFormat('HH:mm:ss').format(DateTime.now()),
                              jumlah: cart.jumlah,
                            ));
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PembayaranResult(
                                        total: totalFix == '-'
                                            ? widget.total
                                            : totalFix,
                                        uang: _uangController.text,
                                        subTotal: widget.total,
                                        discount: discount,
                                      )));
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: 'Terjadi kesalahan',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: const Text('Uang Pas'))
                  : ElevatedButton(
                      onPressed: () async {
                        try {
                          var check =
                              _checkInput(widget.total, _uangController.text);
                          if (check == true) {
                            cartGlobal?.forEach((cart) async {
                              await DatabaseHelper.instance
                                  .insertLaporan(LaporanModel(
                                kode_transaksi: cart.kode_transaksi,
                                diskon: discount,
                                total_harga: cart.total_harga,
                                total_bayar:
                                    totalFix == '-' ? widget.total : totalFix,
                                kasir: userGlobal!.toUpperCase(),
                                kode_produk: cart.kode_produk,
                                tanggal_transaksi: DateFormat('dd/MM/yyyy')
                                    .format(DateTime.now()),
                                waktu: DateFormat('HH:mm:ss')
                                    .format(DateTime.now()),
                                jumlah: cart.jumlah,
                              ));
                            });

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PembayaranResult(
                                          total: totalFix,
                                          uang: _uangController.text,
                                          subTotal: widget.total,
                                          discount: discount,
                                        )));
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
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: 'Terjadi kesalahan',
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
  const Total({required this.subtotal, Key? key}) : super(key: key);
  final String subtotal;
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text(
        'Total',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Text(
        'Rp. $subtotal',
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ]);
  }
}

_calculateDiscount(String value, String subtotal) {
  var total = double.parse(subtotal.replaceAll('.', ''));
  var discount = value == '' ? 0.0 : double.parse(value.replaceAll('.', ''));
  if (discount >= total) {
    return _formating(total);
  } else {
    return _formating(discount);
  }
}

_calculateTotal(String value, String subtotal) {
  var total = double.parse(subtotal.replaceAll('.', ''));
  var discount = value == '' ? 0.0 : double.parse(value.replaceAll('.', ''));
  if (discount >= total) {
    return _formating(0.0);
  } else {
    return _formating(total - discount);
  }
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
