import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:bigsam_pos/utils/formater.dart';
import 'package:bigsam_pos/utils/database.dart';
import 'package:bigsam_pos/models/produk.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class Produk extends StatefulWidget {
  const Produk({Key? key}) : super(key: key);

  @override
  _ProdukState createState() => _ProdukState();
}

class _ProdukState extends State<Produk> {
  final _formKey = GlobalKey<FormState>();
  int? selectedId;
  String? _errorMsg;
  TextEditingController nameProdukController = TextEditingController();
  TextEditingController hargaProdukController = TextEditingController();
  TextEditingController stokProdukController = TextEditingController();
  TextEditingController satuanProdukController = TextEditingController();
  TextEditingController kodeProdukController = TextEditingController();
  TextEditingController modalProdukController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Produk'),
        ),
        body: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2.1,
                    height: MediaQuery.of(context).size.height - 110,
                    child: FutureBuilder<List<ProdukModel>>(
                        future: DatabaseHelper.instance.getProduk(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ProdukModel>> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: Text('Loading...'));
                          }

                          return snapshot.data!.isEmpty
                              ? const Center(child: Text('Tidak Ada Produk'))
                              : ListView(
                                  children: snapshot.data!.map((produk) {
                                    return Center(
                                      child: Card(
                                        color: selectedId == produk.id
                                            ? Colors.white70
                                            : Colors.white,
                                        child: ListTile(
                                          title: Row(
                                            children: [
                                              Text(
                                                produk.kodeProduk,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                produk.namaProduk,
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          subtitle: Row(
                                            children: [
                                              const Text(
                                                'Harga : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                produk.hargaProduk,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Text(
                                                'Stok : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                produk.stockProduk,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Text(
                                                'Satuan : ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                produk.satuanProduk,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              selectedId = produk.id;
                                              await DatabaseHelper.instance
                                                  .deleteProduk(selectedId!);
                                              setState(() {});
                                            },
                                          ),
                                          onLongPress: () {
                                            setState(() {
                                              selectedId = produk.id;
                                              nameProdukController.text =
                                                  produk.namaProduk;
                                              hargaProdukController.text =
                                                  produk.hargaProduk;
                                              stokProdukController.text =
                                                  produk.stockProduk;
                                              satuanProdukController.text =
                                                  produk.satuanProduk;
                                              kodeProdukController.text =
                                                  produk.kodeProduk;
                                              modalProdukController.text =
                                                  produk.hargaModal;
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
              ),
            ),
            Card(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2.1,
                height: MediaQuery.of(context).size.height - 110,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: selectedId == null
                                ? const Text(
                                    'Tambah Produk',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const Text(
                                    'Edit Produk',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                          const Divider(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Kode Produk",
                              errorText: _errorMsg,
                            ),
                            controller: kodeProdukController,
                            inputFormatters: [UpperCaseTextFormatter()],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Kode Produk Tidak Boleh Kosong';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Nama Produk",
                            ),
                            controller: nameProdukController,
                            inputFormatters: [UpperCaseTextFormatter()],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Nama Produk Tidak Boleh Kosong';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyTextInputFormatter(
                                  locale: 'id_ID', decimalDigits: 0, symbol: '')
                            ],
                            decoration: const InputDecoration(
                              labelText: "Harga Produk",
                            ),
                            controller: hargaProdukController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Harga Produk Tidak Boleh Kosong';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                              CurrencyTextInputFormatter(
                                  locale: 'id_ID', decimalDigits: 0, symbol: '')
                            ],
                            decoration: const InputDecoration(
                              labelText: "Harga Modal",
                            ),
                            controller: modalProdukController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Modal Produk Tidak Boleh Kosong';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: const InputDecoration(
                              labelText: "Stok Produk",
                            ),
                            controller: stokProdukController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Stock Produk Tidak Boleh Kosong';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Satuan Produk",
                            ),
                            controller: satuanProdukController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Satuan Produk Tidak Boleh Kosong';
                              }
                              return null;
                            },
                          ),
                          Container(
                            color: Colors.blue,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 20.0),
                            child: TextButton(
                              child: Text(
                                selectedId == null ? "Tambah Produk" : "Simpan",
                                style: const TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    setState(() {
                                      _errorMsg = null;
                                    });
                                    selectedId != null
                                        ? await DatabaseHelper.instance
                                            .updateProduk(
                                            ProdukModel(
                                              id: selectedId,
                                              namaProduk:
                                                  nameProdukController.text,
                                              hargaProduk:
                                                  hargaProdukController.text,
                                              stockProduk:
                                                  stokProdukController.text,
                                              satuanProduk:
                                                  satuanProdukController.text,
                                              kodeProduk:
                                                  kodeProdukController.text,
                                              hargaModal:
                                                  modalProdukController.text,
                                            ),
                                          )
                                        : await DatabaseHelper.instance
                                            .insertProduk(
                                            ProdukModel(
                                              namaProduk:
                                                  nameProdukController.text,
                                              hargaProduk:
                                                  hargaProdukController.text,
                                              stockProduk:
                                                  stokProdukController.text,
                                              satuanProduk:
                                                  satuanProdukController.text,
                                              kodeProduk:
                                                  kodeProdukController.text,
                                              hargaModal:
                                                  modalProdukController.text,
                                            ),
                                          );
                                    setState(() {
                                      selectedId = null;
                                      nameProdukController.text = "";
                                      hargaProdukController.text = "";
                                      stokProdukController.text = "";
                                      satuanProdukController.text = "";
                                      kodeProdukController.text = "";
                                      modalProdukController.text = "";
                                    });
                                  } catch (e) {
                                    setState(() {
                                      _errorMsg = 'Kode Produk Sudah Ada';
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
