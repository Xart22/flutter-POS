import 'package:bigsam_pos/pages/print_page.dart';
import 'package:flutter/material.dart';

import 'package:bigsam_pos/pages/outlet.dart';

class Setting extends StatelessWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Informasi Toko'),
              trailing: Icon(Icons.store),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InformasiToko()));
              },
            ),
            ListTile(
              title: const Text('User Pengguna'),
              trailing: Icon(Icons.person),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InformasiToko()));
              },
            ),
            ListTile(
              title: const Text('Printer'),
              trailing: Icon(Icons.print),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrinterPage()));
              },
            ),
          ],
        ));
  }
}
