class LaporanModel {
  final int? id;
  final String kode_transaksi;
  final String diskon;
  final String total_harga;
  final String total_bayar;
  String kode_produk;
  int jumlah;
  String kasir;
  String tanggal_transaksi;
  String waktu;

  LaporanModel(
      {this.id,
      required this.kode_transaksi,
      required this.diskon,
      required this.total_harga,
      required this.total_bayar,
      required this.kode_produk,
      required this.jumlah,
      required this.kasir,
      required this.tanggal_transaksi,
      required this.waktu});

  factory LaporanModel.fromMap(Map<String, dynamic> json) => LaporanModel(
        id: json["id"],
        kode_transaksi: json["kode_transaksi"],
        diskon: json["diskon"],
        total_harga: json["total_harga"],
        total_bayar: json["total_bayar"],
        kode_produk: json["kode_produk"],
        jumlah: json["jumlah"],
        kasir: json["kasir"],
        tanggal_transaksi: json["tanggal_transaksi"],
        waktu: json["waktu"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "kode_transaksi": kode_transaksi,
        "diskon": diskon,
        "total_harga": total_harga,
        "total_bayar": total_bayar,
        "kode_produk": kode_produk,
        "jumlah": jumlah,
        "kasir": kasir,
        "tanggal_transaksi": tanggal_transaksi,
        "waktu": waktu,
      };
}
