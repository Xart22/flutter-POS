class CartModel {
  final String kode_transaksi;
  final String kode_produk;
  int jumlah;
  final String satuan;
  late final String total_harga;
  final String? kontak_id;
  final String? customer_name;
  String? nama_produk;

  CartModel({
    required this.kode_transaksi,
    required this.kode_produk,
    required this.jumlah,
    required this.satuan,
    required this.total_harga,
    this.kontak_id,
    this.customer_name,
    this.nama_produk,
  });

  factory CartModel.fromMap(Map<String, dynamic> json) => CartModel(
        kode_transaksi: json["kode_transaksi"],
        kode_produk: json["kode_produk"],
        jumlah: json["jumlah"],
        total_harga: json["total_harga"],
        kontak_id: json["kontak_id"],
        customer_name: json["customer_name"],
        nama_produk: json['nama_produk'],
        satuan: json['satuan'],
      );

  Map<String, dynamic> toMap() => {
        "kode_transaksi": kode_transaksi,
        "kode_produk": kode_produk,
        "jumlah": jumlah,
        "total_harga": total_harga,
        "kontak_id": kontak_id,
        "customer_name": customer_name,
        "satuan": satuan,
      };
}
