import 'package:bigsam_pos/models/detail_laporan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/database.dart';

class DetailLaporanPage extends StatelessWidget {
  const DetailLaporanPage(
      {required this.kodeTransaksi,
      Key? key,
      required this.kasir,
      required this.tanggal})
      : super(key: key);

  final String kodeTransaksi;
  final String kasir;
  final String tanggal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Laporan $kodeTransaksi'),
      ),
      body: FutureBuilder<List<DetailLaporanModel>>(
          future: DatabaseHelper.instance.getDetailLaporan(kodeTransaksi),
          builder: (BuildContext context,
              AsyncSnapshot<List<DetailLaporanModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Loading...'));
            }
            final int total = snapshot.data!.fold<int>(
                0, (t, e) => t + int.parse(e.total_harga.replaceAll('.', '')));
            final String modal = _calculateTotalModal(snapshot.data!);
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.0, color: Color(0xFFDFDFDF)),
                      left: BorderSide(width: 1.0, color: Color(0xFFDFDFDF)),
                      right: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
                      bottom: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Kode Transaksi : $kodeTransaksi',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Kasir : $kasir',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Tanggal Transaksi : $tanggal ',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Detail Item',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(
                    child: Table(
                        border: TableBorder.all(color: Colors.black, width: 1),
                        children: [
                      const TableRow(
                          decoration: BoxDecoration(
                            color: Color(0xFFDFDFDF),
                          ),
                          children: [
                            Text(
                              'Kode Item',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Nama Item',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Harga',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Jumlah',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Subtotal',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ]),
                      for (var item in snapshot.data!)
                        TableRow(children: [
                          Text(
                            item.kode_transaksi,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            item.namaProduk,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            item.hargaProduk,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            item.jumlah.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            item.total_harga,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ])
                    ])),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              'Sub Total',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${_formating(total.toDouble())}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              'Diskon',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              snapshot.data![0].diskon,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              _calculateTotal(
                                  total.toString(), snapshot.data![0].diskon),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              'Pendapatan Kotor',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              _calculateTotal(
                                  total.toString(), snapshot.data![0].diskon),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              'Modal',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              modal,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              'Pendapatan Berish',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              _calculateTotal(
                                  _calculateTotal(total.toString(),
                                      snapshot.data![0].diskon),
                                  modal),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ]),
            );
          }),
    );
  }

  _formating(double value) {
    final formatter =
        NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp. ');
    String newText = formatter.format(value).replaceAll('Rp. ', '');
    return newText;
  }

  _calculateTotal(String subtotal, String diskon) {
    double total = double.parse(subtotal.replaceAll('.', '')) -
        double.parse(diskon.replaceAll('.', ''));
    return _formating(total);
  }

  _calculateTotalModal(List<DetailLaporanModel> data) {
    double total = 0;
    for (var item in data) {
      total += double.parse(item.hargaModal.replaceAll('.', '')) * item.jumlah;
    }
    return _formating(total);
  }
}
