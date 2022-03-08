class OutletModel {
  int? id;
  String nama_toko;
  String alamat_toko;
  String no_hp;

  OutletModel({
    this.id,
    required this.nama_toko,
    required this.alamat_toko,
    required this.no_hp,
  });

  factory OutletModel.fromMap(Map<String, dynamic> json) {
    return OutletModel(
      id: json['id'],
      nama_toko: json['nama_toko'],
      alamat_toko: json['alamat_toko'],
      no_hp: json['no_hp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama_toko': nama_toko,
      'alamat_toko': alamat_toko,
      'no_hp': no_hp,
    };
  }
}
