import 'package:bigsam_pos/menu/user.dart';
import 'package:bigsam_pos/pages/beban.dart';
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
              title: const Text('Informasi Toko'),
              trailing: const Icon(Icons.store),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InformasiToko()));
              },
            ),
            ListTile(
              title: const Text('User Pengguna'),
              trailing: const Icon(Icons.person),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserPengguna()));
              },
            ),
            ListTile(
              title: const Text('Beban'),
              trailing: const Icon(Icons.attach_money),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InfromasiBeban()));
              },
            ),
            ListTile(
              title: const Text('Printer'),
              trailing: const Icon(Icons.print),
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
