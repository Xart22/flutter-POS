// ignore: implementation_imports
import 'package:flutter/src/widgets/table.dart';

class DetailLaporanModel {
  final String kode_transaksi;
  final String diskon;
  final String total_harga;
  final String total_bayar;
  String kode_produk;
  int jumlah;
  String kasir;
  String tanggal_transaksi;
  String waktu;
  final String namaProduk;
  final String hargaProduk;
  final String stockProduk;
  final String satuanProduk;
  final String hargaModal;

  DetailLaporanModel({
    required this.kode_transaksi,
    required this.diskon,
    required this.total_harga,
    required this.total_bayar,
    required this.kode_produk,
    required this.jumlah,
    required this.kasir,
    required this.tanggal_transaksi,
    required this.waktu,
    required this.namaProduk,
    required this.hargaProduk,
    required this.stockProduk,
    required this.satuanProduk,
    required this.hargaModal,
  });

  factory DetailLaporanModel.fromMap(Map<String, dynamic> json) =>
      DetailLaporanModel(
        kode_transaksi: json["kode_transaksi"],
        diskon: json["diskon"],
        total_harga: json["total_harga"],
        total_bayar: json["total_bayar"],
        kode_produk: json["kode_produk"],
        jumlah: json["jumlah"],
        kasir: json["kasir"],
        tanggal_transaksi: json["tanggal_transaksi"],
        waktu: json["waktu"],
        namaProduk: json["nama_produk"],
        hargaProduk: json["harga_produk"],
        stockProduk: json["stock_produk"],
        satuanProduk: json["satuan_produk"],
        hargaModal: json["modal_produk"],
      );

  Map<String, dynamic> toMap(TableRow Function(dynamic video) param0) => {
        "kode_transaksi": kode_transaksi,
        "diskon": diskon,
        "total_harga": total_harga,
        "total_bayar": total_bayar,
        "kode_produk": kode_produk,
        "jumlah": jumlah,
        "kasir": kasir,
        "tanggal_transaksi": tanggal_transaksi,
        "waktu": waktu,
        "nama_produk": namaProduk,
        "harga_produk": hargaProduk,
        "stock_produk": stockProduk,
        "satuan_produk": satuanProduk,
        "modal_produk": hargaModal,
      };
}
