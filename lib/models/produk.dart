class ProdukModel {
  final int? id;
  final String kodeProduk;
  final String namaProduk;
  final String hargaProduk;
  final String stockProduk;
  final String satuanProduk;

  ProdukModel({
    this.id,
    required this.kodeProduk,
    required this.namaProduk,
    required this.hargaProduk,
    required this.stockProduk,
    required this.satuanProduk,
  });

  factory ProdukModel.fromMap(Map<String, dynamic> json) => ProdukModel(
        id: json["id"],
        kodeProduk: json["kode_produk"],
        namaProduk: json["nama_produk"],
        hargaProduk: json["harga_produk"],
        stockProduk: json["stock_produk"],
        satuanProduk: json["satuan_produk"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "kode_produk": kodeProduk,
        "nama_produk": namaProduk,
        "harga_produk": hargaProduk,
        "stock_produk": stockProduk,
        "satuan_produk": satuanProduk,
      };
}
