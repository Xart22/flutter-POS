import 'package:bigsam_pos/models/kontak.dart';
import 'package:bigsam_pos/utils/database.dart';
import 'package:flutter/material.dart';

class Kontak extends StatefulWidget {
  const Kontak({Key? key}) : super(key: key);

  @override
  _KontakState createState() => _KontakState();
}

class _KontakState extends State<Kontak> {
  final _formKey = GlobalKey<FormState>();
  int? selectedId;
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController nomorController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontak'),
      ),
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(20),
              child: FutureBuilder<List<KontakModel>>(
                  future: DatabaseHelper.instance.getKontak(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<KontakModel>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text('Loading...'));
                    }
                    return snapshot.data!.isEmpty
                        ? const Center(child: Text('Tidak Ada Kontak'))
                        : ListView(
                            children: snapshot.data!.map((kontak) {
                              return Center(
                                child: Card(
                                  color: selectedId == kontak.id
                                      ? Colors.white70
                                      : Colors.white,
                                  child: ListTile(
                                    title: Text(kontak.nama),
                                    subtitle: Text(kontak.alamat),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          selectedId = kontak.id;
                                          namaController.text = kontak.nama;
                                          alamatController.text = kontak.alamat;
                                          nomorController.text = kontak.nomor;
                                          emailController.text = kontak.email!;
                                        });
                                      },
                                    ),
                                    leading: const Icon(Icons.account_circle),
                                    onLongPress: () {
                                      setState(() {
                                        DatabaseHelper.instance
                                            .deleteKontak(kontak.id!);
                                      });
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                  }),
            ),
          ),
          Expanded(
            child: Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        hintText: 'Nama',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.account_circle),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama Tidak Boleh Kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: alamatController,
                      decoration: const InputDecoration(
                        hintText: 'Alamat',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.home),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'ALamat Tidak Boleh Kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nomorController,
                      decoration: const InputDecoration(
                        hintText: 'Nomor',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.phone),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nomor Tidak Boleh Kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        label: Text('Email'),
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      child: const Text('Save'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          selectedId != null
                              ? await DatabaseHelper.instance
                                  .updateKontak(KontakModel(
                                  id: selectedId,
                                  nama: namaController.text,
                                  alamat: alamatController.text,
                                  nomor: nomorController.text,
                                  email: emailController.text,
                                ))
                              : await DatabaseHelper.instance
                                  .insertKontak(KontakModel(
                                  nama: namaController.text,
                                  alamat: alamatController.text,
                                  nomor: nomorController.text,
                                  email: emailController.text,
                                ));
                        }
                        setState(() {
                          selectedId = null;
                          namaController.text = '';
                          alamatController.text = '';
                          nomorController.text = '';
                          emailController.text = '';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
