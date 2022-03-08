import 'dart:math';

import 'package:bigsam_pos/models/cart.dart';
import 'package:bigsam_pos/global/cart.dart';
import 'package:bigsam_pos/models/update_stock.dart';
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
  String searchProduk = "";

  TextEditingController _controllerJumlah = TextEditingController();
  TextEditingController nameProdukController = TextEditingController();
  TextEditingController hargaProdukController = TextEditingController();
  TextEditingController stokProdukController = TextEditingController();
  TextEditingController satuanProdukController = TextEditingController();
  TextEditingController kodeProdukController = TextEditingController();
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
                                      if (int.parse(produk.stockProduk) == 0) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Stok Produk Habis Mohon Untuk Update Stock",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else {
                                        var check = await DatabaseHelper
                                            .instance
                                            .getCartByKode(
                                                _kodeProduk.toString());
                                        if (check.isNotEmpty) {
                                          await DatabaseHelper.instance
                                              .updateCart(CartModel(
                                            kode_transaksi:
                                                check[0].kode_transaksi,
                                            kode_produk: produk.kodeProduk,
                                            jumlah: check[0].jumlah + 1,
                                            satuan: produk.satuanProduk,
                                            total_harga: _formating(
                                                (double.parse(check[0]
                                                        .total_harga
                                                        .replaceAll('.', '')) +
                                                    double.parse(produk
                                                        .hargaProduk
                                                        .replaceAll('.', '')))),
                                          ));
                                          await DatabaseHelper.instance
                                              .updateStock(UpdateStock(
                                            kodeProduk: produk.kodeProduk,
                                            stockProduk:
                                                (int.parse(produk.stockProduk) -
                                                        1)
                                                    .toString(),
                                          ));
                                        } else {
                                          var kodeTransaksi =
                                              await DatabaseHelper.instance
                                                  .getCart();

                                          await DatabaseHelper.instance
                                              .insertCart(CartModel(
                                            kode_transaksi:
                                                kodeTransaksi.isNotEmpty
                                                    ? kodeTransaksi[0]
                                                        .kode_transaksi
                                                    : _generateKodeTransaksi(),
                                            kode_produk: produk.kodeProduk,
                                            jumlah: 1,
                                            satuan: produk.satuanProduk,
                                            total_harga: produk.hargaProduk,
                                          ));
                                          await DatabaseHelper.instance
                                              .updateStock(UpdateStock(
                                            kodeProduk: produk.kodeProduk,
                                            stockProduk:
                                                (int.parse(produk.stockProduk) -
                                                        1)
                                                    .toString(),
                                          ));
                                        }
                                      }
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
                                      if (int.parse(produk.stockProduk) == 0) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Stok Produk Habis Mohon Untuk Update Stock",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      } else {
                                        var check = await DatabaseHelper
                                            .instance
                                            .getCartByKode(
                                                _kodeProduk.toString());
                                        if (check.isNotEmpty) {
                                          await DatabaseHelper.instance
                                              .updateCart(CartModel(
                                            kode_transaksi:
                                                check[0].kode_transaksi,
                                            kode_produk: produk.kodeProduk,
                                            jumlah: check[0].jumlah + 1,
                                            satuan: produk.satuanProduk,
                                            total_harga: _formating(
                                                (double.parse(check[0]
                                                        .total_harga
                                                        .replaceAll('.', '')) +
                                                    double.parse(produk
                                                        .hargaProduk
                                                        .replaceAll('.', '')))),
                                          ));
                                          await DatabaseHelper.instance
                                              .updateStock(UpdateStock(
                                            kodeProduk: produk.kodeProduk,
                                            stockProduk:
                                                (int.parse(produk.stockProduk) -
                                                        1)
                                                    .toString(),
                                          ));
                                        } else {
                                          await DatabaseHelper.instance
                                              .insertCart(CartModel(
                                            kode_transaksi:
                                                _generateKodeTransaksi(),
                                            kode_produk: produk.kodeProduk,
                                            jumlah: 1,
                                            satuan: produk.satuanProduk,
                                            total_harga: produk.hargaProduk,
                                          ));
                                          await DatabaseHelper.instance
                                              .updateStock(UpdateStock(
                                            kodeProduk: produk.kodeProduk,
                                            stockProduk:
                                                (int.parse(produk.stockProduk) -
                                                        1)
                                                    .toString(),
                                          ));
                                        }
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(top: 20),
                                child: const Center(
                                  child: Text('Produk tidak ditemukan',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              );
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
                                      shape: const RoundedRectangleBorder(
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
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12.0),
                                              child: Text('Masukan Qty Produk',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                            ),
                                            const SizedBox(
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
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        var stockProduk =
                                                            await DatabaseHelper
                                                                .instance
                                                                .getProdukByKode(
                                                                    cart.kode_produk);
                                                        if (int.parse(stockProduk[
                                                                    0]
                                                                .stockProduk) ==
                                                            0) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Stock produk habis",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .BOTTOM,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  Colors.red,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0);
                                                        } else {
                                                          await DatabaseHelper.instance.updateCart(CartModel(
                                                              kode_transaksi: cart
                                                                  .kode_transaksi,
                                                              kode_produk: cart
                                                                  .kode_produk,
                                                              jumlah: int.parse(
                                                                  _controllerJumlah
                                                                      .text),
                                                              satuan:
                                                                  cart.satuan,
                                                              total_harga: _calculate(
                                                                  cart
                                                                      .total_harga,
                                                                  cart.jumlah,
                                                                  _controllerJumlah
                                                                      .text)));

                                                          var finalStock = cart
                                                                      .jumlah <
                                                                  int.parse(
                                                                      _controllerJumlah
                                                                          .text)
                                                              ? int.parse(stockProduk[
                                                                          0]
                                                                      .stockProduk) -
                                                                  int.parse(
                                                                      _controllerJumlah
                                                                          .text)
                                                              : int.parse(stockProduk[
                                                                          0]
                                                                      .stockProduk) +
                                                                  (int.parse(
                                                                      _controllerJumlah
                                                                          .text));
                                                          await DatabaseHelper
                                                              .instance
                                                              .updateStock(UpdateStock(
                                                                  kodeProduk:
                                                                      stockProduk[
                                                                              0]
                                                                          .kodeProduk,
                                                                  stockProduk:
                                                                      finalStock
                                                                          .toString()));
                                                        }
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
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
                                  onLongPress: () async {
                                    await DatabaseHelper.instance
                                        .deleteCartByKodeProduk(
                                            cart.kode_produk);
                                    var stockProduk = await DatabaseHelper
                                        .instance
                                        .getProdukByKode(cart.kode_produk);
                                    await DatabaseHelper.instance.updateStock(
                                        UpdateStock(
                                            kodeProduk: cart.kode_produk,
                                            stockProduk: (int.parse(
                                                        stockProduk[0]
                                                            .stockProduk) +
                                                    cart.jumlah)
                                                .toString()));
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
                                  color: Colors.white)))),
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

String _generateKodeTransaksi() {
  var now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  String formatted = now.toString() + getRandomString(4);
  return formatted;
}

_calculate(String total, int jumlahDb, String jumlahTambah) {
  var totalHarga = double.parse(total.replaceAll('.', ''));
  var hargaProduk = totalHarga / jumlahDb;
  var jumlah = int.parse(jumlahTambah);
  var totalHargaBaru = hargaProduk * jumlah;
  return _formating(totalHargaBaru);
}

const _chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
