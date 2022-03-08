import 'package:bigsam_pos/models/detail_laporan.dart';
import 'package:bigsam_pos/pages/laporan.dart';
import 'package:flutter/material.dart';
import 'package:bigsam_pos/pages/produk.dart';
import 'package:bigsam_pos/pages/kontak.dart';
import 'package:intl/intl.dart';

import '../utils/database.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const DataCard(),
        Container(
          margin: const EdgeInsets.only(left: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(60),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Produk()),
                    );
                  },
                  child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Column(
                        children: const [
                          Icon(
                            Icons.shopping_bag,
                            size: 80,
                            color: Colors.blue,
                          ),
                          Text('Produk',
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center)
                        ],
                      )),
                ),
              ),
              Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(60),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Kontak()),
                    );
                  },
                  child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Column(
                        children: const [
                          Icon(
                            Icons.contact_page,
                            size: 80,
                            color: Colors.blue,
                          ),
                          Text('Kontak',
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center)
                        ],
                      )),
                ),
              ),
              Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(60),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LaporanPage()),
                    );
                  },
                  child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Column(
                        children: const [
                          Icon(
                            Icons.assignment,
                            size: 80,
                            color: Colors.blue,
                          ),
                          Text('Laporan',
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.center)
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

class DataCard extends StatelessWidget {
  const DataCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DetailLaporanModel>>(
        future: DatabaseHelper.instance.getDetailLaporanByTanggal(
            DateFormat('dd/MM/yyyy').format(DateTime.now()),
            DateFormat('dd/MM/yyyy').format(DateTime.now())),
        builder: (BuildContext context,
            AsyncSnapshot<List<DetailLaporanModel>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading...'));
          }
          final totalPendapatan = _calculatePendapatan(snapshot.data);
          final String modal = _calculateTotalModal(snapshot.data!);

          return Container(
            margin: const EdgeInsets.only(left: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LaporanPage()),
                      );
                    },
                    child: SizedBox(
                      width: 250,
                      height: 100,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: const Text(
                              'Pendapatan Hari ini',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              'Rp. $totalPendapatan',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LaporanPage()),
                      );
                    },
                    child: SizedBox(
                      width: 250,
                      height: 100,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: const Text(
                              'Pengeluaran Hari ini',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              'Rp. $modal',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LaporanPage()),
                      );
                    },
                    child: SizedBox(
                      width: 250,
                      height: 100,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: const Text(
                              'Jumlah Transaksi Hari ini',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Text(
                              '${snapshot.data?.length ?? 0}',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _calculatePendapatan(data) {
    double total = 0;
    for (var i = 0; i < data.length; i++) {
      total += double.parse(data[i].total_bayar.replaceAll('.', ''));
    }
    return _formating(total);
  }

  _calculateTotalModal(List<DetailLaporanModel> data) {
    double total = 0;
    for (var item in data) {
      total += double.parse(item.hargaModal.replaceAll('.', '')) * item.jumlah;
    }
    return _formating(total);
  }

  _formating(double value) {
    final formatter =
        NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp. ');
    String newText = formatter.format(value).replaceAll('Rp. ', '');
    return newText;
  }
}
