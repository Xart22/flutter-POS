import 'package:bigsam_pos/global/cart.dart';
import 'package:bigsam_pos/global/outlet.dart';
import 'package:bigsam_pos/global/printer.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animated_check/animated_check.dart';

import '../main.dart';

class PembayaranResult extends StatelessWidget {
  const PembayaranResult(
      {required this.total,
      required this.uang,
      required this.ppn,
      required this.subTotal,
      Key? key})
      : super(key: key);
  final String total;
  final String uang;
  final String ppn;
  final String subTotal;

  @override
  Widget build(BuildContext context) {
    _insertTransaksi();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pembayaran Berhasil'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(flex: 2, child: ChecklisAnimation()),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Card(
                                margin: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 15,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Total Pembayaran',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Rp. ' + total,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Card(
                                margin: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 15,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Diterima',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        uang == ''
                                            ? 'Rp. ' + total
                                            : 'Rp. ' + uang,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Card(
                                margin: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 15,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Kembalian',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        uang == ''
                                            ? 'Rp. 0'
                                            : 'Rp. ' + _calculate(total, uang),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 10),
                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    _printReceipt(subTotal, ppn, total, uang,
                                        _calculate(total, uang));
                                  },
                                  child: const Text('Cetak Struk'))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.green),
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      MyStatefulWidget.routeName,
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                  child: const Text('Transaksi Baru'))),
                          const SizedBox(width: 10),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_calculate(String total, String uang) {
  var totalInt = double.parse(total.replaceAll('.', ''));
  if (uang == '') {
    return '0';
  }

  var uangInt = double.parse(uang.replaceAll('.', ''));
  var kembalian = uangInt - totalInt;
  return _formating(kembalian);
}

_formating(double value) {
  final formatter =
      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp. ');
  String newText = formatter.format(value).replaceAll('Rp. ', '');
  return newText;
}

_insertTransaksi() async {}

class ChecklisAnimation extends StatefulWidget {
  const ChecklisAnimation({Key? key}) : super(key: key);

  @override
  _ChecklisAnimationState createState() => _ChecklisAnimationState();
}

class _ChecklisAnimationState extends State<ChecklisAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCirc));

    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => _animationController.forward());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green, width: 2),
            borderRadius: BorderRadius.circular(100),
            color: Colors.white,
          ),
          child: AnimatedCheck(
            color: Colors.green,
            progress: _animation,
            size: 180,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Pembayaran Berhasil',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    ));
  }
}

writeSpace(String msg1, String msg2) {
  var msg = msg1 + msg2;
  var msgLength = msg.length;
  var space = '';
  for (var i = 0; i < (32 - msgLength); i++) {
    space += ' ';
  }
  return space;
}

_calculateBasePrice(String total, int jumlahDb) {
  var total_harga = double.parse(total.replaceAll('.', ''));
  var harga_produk = total_harga / jumlahDb;
  return _formating(harga_produk);
}

_printReceipt(String subTotal, String ppn, String total, String uang,
    String kembali) async {
  uang == '' ? uang = total : uang;
  Map<String, dynamic> config = Map();
  List<LineText> list = [];
  for (var element in outletGlobal!) {
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: element.nama_toko,
        weight: 2,
        size: 10,
        width: 2,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: element.alamat_toko,
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '--------------------------------',
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Kasir',
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: writeSpace('kasir', 'Tes'),
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Tes',
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
    list.add(LineText(linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'Waktu',
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: writeSpace(
            'Waktu', DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now())),
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
    list.add(LineText(linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'No. Transaksi',
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: writeSpace('No. Transaksi', cartGlobal![0].kode_transaksi),
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: cartGlobal![0].kode_transaksi,
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '--------------------------------',
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '### LUNAS ###',
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '--------------------------------',
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
  }
  for (var item in cartGlobal!) {
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: item.nama_produk!,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: _calculateBasePrice(item.total_harga, item.jumlah) +
            ' x ' +
            item.jumlah.toString(),
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: writeSpace(
            _calculateBasePrice(item.total_harga, item.jumlah) +
                ' x ' +
                item.jumlah.toString(),
            item.total_harga),
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: item.total_harga,
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
    list.add(LineText(linefeed: 1));
  }
  //SUB TOTAL WRAP
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '--------------------------------',
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Sub Total',
      align: LineText.ALIGN_LEFT,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: writeSpace('Sub Total', subTotal),
      align: LineText.ALIGN_LEFT,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: subTotal,
      align: LineText.ALIGN_LEFT,
      linefeed: 0));

  //END SUB TOTAL WRAP
  //PPN WRAP
  if (ppn != '0') {
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: '--------------------------------',
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'PPN',
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: writeSpace('PPN', ppn),
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: ppn,
        align: LineText.ALIGN_LEFT,
        linefeed: 0));
  }
  //END PPN WRAP
  //TOTAL WRAP
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '--------------------------------',
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Total',
      align: LineText.ALIGN_LEFT,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: writeSpace('Total', total),
      align: LineText.ALIGN_LEFT,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: total,
      align: LineText.ALIGN_LEFT,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: '--------------------------------',
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  //END TOTAL WRAP
  //WRAP UANG
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Bayar',
      align: LineText.ALIGN_LEFT,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: writeSpace('Bayar', uang),
      align: LineText.ALIGN_LEFT,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: uang,
      align: LineText.ALIGN_LEFT,
      linefeed: 0));
  //END UANG WRAP
  //KEMBALIAN WRAP
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Kembali',
      align: LineText.ALIGN_LEFT,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: writeSpace('Kembali', kembali),
      align: LineText.ALIGN_LEFT,
      linefeed: 0));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: kembali,
      align: LineText.ALIGN_LEFT,
      linefeed: 0));
  //END KEMBALIAN WRAP
  //TERIMA KASIH WRAP
  list.add(LineText(linefeed: 1));
  list.add(LineText(
      type: LineText.TYPE_TEXT,
      content: 'Terimakasih atas kunjungan anda',
      align: LineText.ALIGN_CENTER,
      linefeed: 1));
  //END TERIMA KASIH WRAP
  await BluetoothPrint.instance.printReceipt(config, list);
}
