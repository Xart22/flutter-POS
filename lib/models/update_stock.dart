class UpdateStock {
  final String kodeProduk;
  final String stockProduk;

  UpdateStock({required this.kodeProduk, required this.stockProduk});

  factory UpdateStock.fromMap(Map<String, dynamic> json) {
    return UpdateStock(
      kodeProduk: json['kode_produk'],
      stockProduk: json["stock_produk"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kode_produk': kodeProduk,
      "stock_produk": stockProduk,
    };
  }
}
