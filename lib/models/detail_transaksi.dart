class DetailTransaksiModel {
  final int? id;
  final int id_transaksi;
  final int id_user;
  final int id_produk;
  final String nama_produk;
  final int jumlah;
  final String total;
  final String nama_user;
  final String kontak_id;
  final String created_at;

  DetailTransaksiModel(
      {this.id,
      required this.id_transaksi,
      required this.id_user,
      required this.id_produk,
      required this.jumlah,
      required this.total,
      required this.nama_produk,
      required this.nama_user,
      required this.kontak_id,
      required this.created_at});

  factory DetailTransaksiModel.fromMap(Map<String, dynamic> json) =>
      DetailTransaksiModel(
        id: json['id'] as int,
        id_transaksi: json['id_transaksi'] as int,
        id_user: json['id_user'] as int,
        id_produk: json['id_produk'] as int,
        jumlah: json['jumlah'] as int,
        total: json['total'] as String,
        nama_produk: json['nama_produk'] as String,
        nama_user: json['nama_user'] as String,
        kontak_id: json['kontak_id'] as String,
        created_at: json['created_at'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'id_transaksi': id_transaksi,
        'id_user': id_user,
        'id_produk': id_produk,
        'jumlah': jumlah,
        'total': total,
        'nama_produk': nama_produk,
        'nama_user': nama_user,
        'kontak_id': kontak_id,
        'created_at': created_at,
      };
}
