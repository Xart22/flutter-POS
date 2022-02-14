import 'dart:ffi';

class TransaksiModel {
  final int? id;
  final String kode_transaksi;
  final int? kontak_id;
  final int user_id;
  final String total_harga;
  final String tanggal_transaksi;
  final String status_transaksi;

  TransaksiModel({
    this.id,
    required this.kode_transaksi,
    required this.kontak_id,
    required this.user_id,
    required this.total_harga,
    required this.tanggal_transaksi,
    required this.status_transaksi,
  });

  factory TransaksiModel.fromMap(Map<String, dynamic> json) => TransaksiModel(
        id: json["id"],
        kode_transaksi: json["kode_transaksi"],
        kontak_id: json["kontak_id"],
        user_id: json["user_id"],
        total_harga: json["total_harga"],
        tanggal_transaksi: json["tanggal_transaksi"],
        status_transaksi: json["status_transaksi"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "kode_transaksi": kode_transaksi,
        "id_kontak": kontak_id,
        "id_user": user_id,
        "total_harga": total_harga,
        "tanggal_transaksi": tanggal_transaksi,
        "status_transaksi": status_transaksi,
      };
}
