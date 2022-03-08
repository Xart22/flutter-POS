import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:bigsam_pos/models/beban.dart';
import 'package:bigsam_pos/utils/database.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InfromasiBeban extends StatelessWidget {
  const InfromasiBeban({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Beban Perbulan'),
      ),
      body: const Beban(),
    );
  }
}

class Beban extends StatefulWidget {
  const Beban({Key? key}) : super(key: key);

  @override
  State<Beban> createState() => _BebanState();
}

class _BebanState extends State<Beban> {
  TextEditingController hargaListrikController = TextEditingController();
  TextEditingController hargaSewaController = TextEditingController();
  TextEditingController hargaLainController = TextEditingController();
  TextEditingController hargaPulsaController = TextEditingController();
  TextEditingController hargaInternetController = TextEditingController();
  TextEditingController gajiPegawaiController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  int? selectedId;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<BebanModel>>(
          future: DatabaseHelper.instance.getBeban(),
          builder:
              (BuildContext context, AsyncSnapshot<List<BebanModel>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('Loading...'));
            }
            if (snapshot.data!.isEmpty) {
              hargaInternetController.text = '';
              hargaListrikController.text = '';
              hargaLainController.text = '';
              hargaPulsaController.text = '';
              hargaSewaController.text = '';
              gajiPegawaiController.text = '';
            } else {
              selectedId = snapshot.data![0].id;
              hargaInternetController.text = snapshot.data![0].hargaInternet!;
              hargaListrikController.text = snapshot.data![0].hargaListrik!;
              hargaLainController.text = snapshot.data![0].hargaLain!;
              hargaPulsaController.text = snapshot.data![0].hargaPulsa!;
              hargaSewaController.text = snapshot.data![0].hargaSewa!;
              gajiPegawaiController.text = snapshot.data![0].gaji!;
            }

            return Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: hargaSewaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyTextInputFormatter(
                            locale: 'id_ID', decimalDigits: 0, symbol: '')
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Sewa Gedung',
                        hintText: 'Masukkan harga sewa gedung',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.store),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: hargaListrikController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyTextInputFormatter(
                            locale: 'id_ID', decimalDigits: 0, symbol: '')
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Listrik',
                        hintText: 'Masukkan harga listrik',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.power),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: hargaInternetController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyTextInputFormatter(
                            locale: 'id_ID', decimalDigits: 0, symbol: '')
                      ],
                      decoration: const InputDecoration(
                          labelText: 'Internet',
                          hintText: 'Masukkan harga internet',
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.signal_wifi_4_bar)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: hargaPulsaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyTextInputFormatter(
                            locale: 'id_ID', decimalDigits: 0, symbol: '')
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Pulsa',
                        hintText: 'Masukkan harga pulsa',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.phone_android),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: gajiPegawaiController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyTextInputFormatter(
                            locale: 'id_ID', decimalDigits: 0, symbol: '')
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Gaji Pegawai',
                        hintText: 'Masukkan gaji pegawai',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.people),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: hargaLainController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyTextInputFormatter(
                            locale: 'id_ID', decimalDigits: 0, symbol: '')
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Lain-lain',
                        hintText: 'Masukkan harga lain-lain',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.attach_money),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      child: Text('Save'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          selectedId != null;
                        }
                        try {
                          selectedId != null
                              ? await DatabaseHelper.instance.updateBeban(
                                  BebanModel(
                                    id: selectedId,
                                    hargaInternet: hargaInternetController.text,
                                    hargaListrik: hargaListrikController.text,
                                    hargaLain: hargaLainController.text,
                                    hargaPulsa: hargaPulsaController.text,
                                    hargaSewa: hargaSewaController.text,
                                    gaji: gajiPegawaiController.text,
                                  ),
                                )
                              : await DatabaseHelper.instance.insertBeban(
                                  BebanModel(
                                    hargaInternet: hargaInternetController.text,
                                    hargaListrik: hargaListrikController.text,
                                    hargaLain: hargaLainController.text,
                                    hargaPulsa: hargaPulsaController.text,
                                    hargaSewa: hargaSewaController.text,
                                    gaji: gajiPegawaiController.text,
                                  ),
                                );

                          Fluttertoast.showToast(msg: 'Data Berhasil Disimpan');
                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
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
