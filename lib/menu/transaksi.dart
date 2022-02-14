import 'package:bigsam_pos/global/printer.dart';
import 'package:bigsam_pos/models/cart.dart';
import 'package:bigsam_pos/global/cart.dart';
import 'package:bigsam_pos/pages/pembayaran.dart';
import 'package:bigsam_pos/wiget/subtotal.dart';
import 'package:flutter/material.dart';
import 'package:bigsam_pos/utils/database.dart';
import 'package:bigsam_pos/models/produk.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Transaksi extends StatefulWidget {
  const Transaksi({Key? key}) : super(key: key);

  @override
  _TransaksiState createState() => _TransaksiState();
}

class _TransaksiState extends State<Transaksi> {
  int ppnState = 0;
  int? selectedId;
  String totalState = "0";
  String? ppnTotal;
  String? kodeTransaksi;
  String searchProduk = "";

  TextEditingController _controllerJumlah = TextEditingController();
  TextEditingController nameProdukController = TextEditingController();
  TextEditingController hargaProdukController = TextEditingController();
  TextEditingController stokProdukController = TextEditingController();
  TextEditingController satuanProdukController = TextEditingController();
  TextEditingController kodeProdukController = TextEditingController();
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  String? _kodeProduk;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextField(
            controller: nameProdukController,
            decoration: const InputDecoration(
              icon: Icon(Icons.search),
              hintText: 'Cari Produk',
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {
                searchProduk = value;
              });
            },
          ),
        ),
        body: Row(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: MediaQuery.of(context).size.height / 1,
                  child: FutureBuilder<List<ProdukModel>>(
                      future: DatabaseHelper.instance.getProduk(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ProdukModel>> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: Text('Loading...'));
                        }

                        if (snapshot.data!.isEmpty) {
                          return const Center(child: Text('Belum Ada Produk'));
                        }

                        return ListView(
                          children: snapshot.data!.map((produk) {
                            if (searchProduk == '') {
                              return Center(
                                child: Card(
                                  color: selectedId == produk.id
                                      ? Colors.white70
                                      : Colors.white,
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Text(
                                          produk.namaProduk,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          produk.kodeProduk,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Harga : ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          produk.hargaProduk,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Stok : ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          produk.stockProduk,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          'Satuan : ',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          produk.satuanProduk,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      setState(() {
                                        _kodeProduk = produk.kodeProduk;
                                      });
                                      var check = await DatabaseHelper.instance
                                          .getCartByKode(
                                              _kodeProduk.toString());
                                      check.isNotEmpty
                                          ? await DatabaseHelper.instance
                                              .updateCart(CartModel(
                                              kode_transaksi: produk.kodeProduk,
                                              kode_produk: produk.kodeProduk,
                                              jumlah: check[0].jumlah + 1,
                                              satuan: produk.satuanProduk,
                                              total_harga: _formating(
                                                  (double.parse(
                                                          check[0]
                                                              .total_harga
                                                              .replaceAll(
                                                                  '.', '')) +
                                                      double.parse(produk
                                                          .hargaProduk
                                                          .replaceAll(
                                                              '.', '')))),
                                            ))
                                          : await DatabaseHelper.instance
                                              .insertCart(CartModel(
                                              kode_transaksi: produk.kodeProduk,
                                              kode_produk: produk.kodeProduk,
                                              jumlah: 1,
                                              satuan: produk.satuanProduk,
                                              total_harga: produk.hargaProduk,
                                            ));
                                      setState(() {});
                                    },
                                  ),
                                ),
                              );
                            } else if (produk.namaProduk
                                    .toLowerCase()
                                    .contains(searchProduk.toLowerCase()) ||
                                produk.kodeProduk
                                    .toLowerCase()
                                    .contains(searchProduk.toLowerCase())) {
                              return ListTile(
                                title: Text(produk.namaProduk),
                                subtitle: Text('Stok: ${produk.stockProduk}'),
                                trailing: Text('Rp. ${produk.hargaProduk}'),
                                onTap: () {
                                  setState(() {
                                    _kodeProduk = produk.kodeProduk;
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
                                  });
                                },
                              );
                            } else {
                              return Container();
                            }
                          }).toList(),
                        );
                      }),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.6,
                    width: MediaQuery.of(context).size.width / 3,
                    child: FutureBuilder<List<CartModel>>(
                        future: DatabaseHelper.instance.getCart(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<CartModel>> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: Text('Loading...'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            cartGlobal = snapshot.data!;
                            final List<CartModel>? cart = snapshot.data;
                            final int total = cart!.fold<int>(
                                0,
                                (t, e) =>
                                    t +
                                    int.parse(
                                        e.total_harga.replaceAll('.', '')));
                            totalState =
                                _formating(double.parse(total.toString()));
                            return ListView(
                              children: snapshot.data!.map((cart) {
                                return ListTile(
                                  title: Text(
                                    cart.nama_produk.toString(),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  subtitle: Text(
                                    cart.jumlah.toString() + ' ' + cart.satuan,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.start,
                                  ),
                                  trailing: Text("Rp. " + cart.total_harga,
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.start),
                                  onTap: () {
                                    setState(() {
                                      _controllerJumlah.text =
                                          cart.jumlah.toString();
                                    });
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25.0))),
                                      backgroundColor: Colors.white,
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              child: Text('Masukan Qty Produk',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                child: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          _controllerJumlah,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        await DatabaseHelper.instance.updateCart(CartModel(
                                                            kode_transaksi: cart
                                                                .kode_transaksi,
                                                            kode_produk: cart
                                                                .kode_produk,
                                                            jumlah: int.parse(
                                                                _controllerJumlah
                                                                    .text),
                                                            satuan: cart.satuan,
                                                            total_harga: _calculate(
                                                                cart
                                                                    .total_harga,
                                                                cart.jumlah,
                                                                _controllerJumlah
                                                                    .text)));

                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        'Tambahkan',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.blue,
                                                        fixedSize: Size(
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width,
                                                            40),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    DatabaseHelper.instance
                                        .deleteCart(cart.kode_produk);

                                    setState(() {});
                                  },
                                );
                              }).toList(),
                            );
                          }
                          return Container();
                        }),
                  ),
                  Subtotal(),
                  Container(
                      padding: const EdgeInsets.all(5),
                      height: 40, //height of button
                      width: MediaQuery.of(context).size.width / 3.0,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                          ),
                          onPressed: () {
                            if (totalState != '0') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Pembayaran(total: totalState)));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Tidak ada produk yang dibeli");
                            }
                          },
                          child: const Text("Bayar",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))))
                ]),
              ),
            ),
          ],
        ));
  }
}

_formating(double value) {
  final formatter =
      NumberFormat.currency(locale: 'id', decimalDigits: 0, symbol: 'Rp. ');
  String newText = formatter.format(value).replaceAll('Rp. ', '');
  return newText;
}

_generateKodeStruk() {
  var now = DateTime.now();
  var formatter = DateFormat.yMd();
  String formatted = formatter.format(now);
  return formatted.replaceAll('/', '');
}

_calculate(String total, int jumlahDb, String jumlahTambah) {
  var total_harga = double.parse(total.replaceAll('.', ''));
  var harga_produk = total_harga / jumlahDb;
  var jumlah = int.parse(jumlahTambah);
  var total_harga_baru = harga_produk * jumlah;
  return _formating(total_harga_baru);
}
