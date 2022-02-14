import 'package:bigsam_pos/pages/laporan.dart';
import 'package:flutter/material.dart';
import 'package:bigsam_pos/pages/produk.dart';
import 'package:bigsam_pos/pages/kontak.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Laporan()),
                    );
                    setStatate() {}
                  },
                  child: const SizedBox(
                    width: 250,
                    height: 100,
                    child: Text('Pendapatan Hari Ini'),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Laporan()),
                    );
                  },
                  child: const SizedBox(
                    width: 250,
                    height: 100,
                    child: Text('Pengeluaran Hari ini'),
                  ),
                ),
              ),
              Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Laporan()),
                    );
                  },
                  child: const SizedBox(
                    width: 250,
                    height: 100,
                    child: Text('Total Transaksi Hari ini'),
                  ),
                ),
              ),
            ],
          ),
        ),
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
                      MaterialPageRoute(builder: (context) => Produk()),
                    );
                  },
                  child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Container(
                        child: Column(
                          children: [
                            Icon(
                              Icons.shopping_bag,
                              size: 80,
                              color: Colors.blue,
                            ),
                            Text('Produk',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center)
                          ],
                        ),
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
                      child: Container(
                        child: Column(
                          children: [
                            Icon(
                              Icons.shopping_bag,
                              size: 80,
                              color: Colors.blue,
                            ),
                            Text('Kontak',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center)
                          ],
                        ),
                      )),
                ),
              ),
              Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(60),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Kontak()),
                    );
                  },
                  child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Container(
                        child: Column(
                          children: [
                            Icon(
                              Icons.shopping_bag,
                              size: 80,
                              color: Colors.blue,
                            ),
                            Text('Laporan',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center)
                          ],
                        ),
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
