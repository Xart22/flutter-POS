import 'package:flutter/material.dart';
import 'package:bigsam_pos/models/outlet.dart';
import 'package:bigsam_pos/utils/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InformasiToko extends StatelessWidget {
  const InformasiToko({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Toko'),
      ),
      body: const FormToko(),
    );
  }
}

class FormToko extends StatefulWidget {
  const FormToko({Key? key}) : super(key: key);

  @override
  _FormTokoState createState() => _FormTokoState();
}

class _FormTokoState extends State<FormToko> {
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController nomorController = TextEditingController();
  TextEditingController pajakController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<OutletModel>>(
          future: DatabaseHelper.instance.getOutlet(),
          builder: (BuildContext context,
              AsyncSnapshot<List<OutletModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Loading...'));
            }
            if (snapshot.data!.isEmpty) {
              namaController.text = '';
              alamatController.text = '';
              nomorController.text = '';
            } else {
              selectedId = snapshot.data![0].id;
              namaController.text = snapshot.data![0].nama_toko;
              alamatController.text = snapshot.data![0].alamat_toko;
              nomorController.text = snapshot.data![0].no_hp;
            }

            return Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Toko',
                        hintText: 'Nama Toko',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.store),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama Toko Tidak Boleh Kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: alamatController,
                      decoration: const InputDecoration(
                        labelText: 'Alamat Toko',
                        hintText: 'Alamat Toko',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.home),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'ALamat Toko Tidak Boleh Kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nomorController,
                      decoration: const InputDecoration(
                        labelText: 'Nomor HP',
                        hintText: 'Nomor',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nomor Tidak Boleh Kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      child: const Text('Save'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          selectedId != null;
                        }
                        try {
                          selectedId != null
                              ? await DatabaseHelper.instance.updateOutlet(
                                  OutletModel(
                                    id: selectedId,
                                    nama_toko: namaController.text,
                                    alamat_toko: alamatController.text,
                                    no_hp: nomorController.text,
                                  ),
                                )
                              : await DatabaseHelper.instance.insertOutlet(
                                  OutletModel(
                                    nama_toko: namaController.text,
                                    alamat_toko: alamatController.text,
                                    no_hp: nomorController.text,
                                  ),
                                );

                          Fluttertoast.showToast(msg: 'Data Berhasil Disimpan');
                          Navigator.pop(context);
                        } catch (e) {
                          Fluttertoast.showToast(msg: 'Data Gagal Disimpan');
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
