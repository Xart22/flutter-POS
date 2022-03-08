class BebanModel {
  int? id;
  String? hargaListrik;
  String? hargaSewa;
  String? hargaLain;
  String? gaji;
  String? hargaInternet;
  String? hargaPulsa;

  BebanModel({
    this.id,
    this.hargaListrik,
    this.hargaSewa,
    this.hargaLain,
    this.gaji,
    this.hargaInternet,
    this.hargaPulsa,
  });

  factory BebanModel.fromMap(Map<String, dynamic> json) => BebanModel(
        id: json["id"],
        hargaListrik: json["harga_listrik"],
        hargaSewa: json["harga_sewa"],
        hargaLain: json["harga_lain"],
        gaji: json["gaji"],
        hargaInternet: json["harga_internet"],
        hargaPulsa: json["harga_pulsa"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "harga_listrik": hargaListrik,
        "harga_sewa": hargaSewa,
        "harga_lain": hargaLain,
        "gaji": gaji,
        "harga_internet": hargaInternet,
        "harga_pulsa": hargaPulsa,
      };
}
