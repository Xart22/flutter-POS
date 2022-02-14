class KontakModel {
  final int? id;
  final String nama;
  final String nomor;
  final String? email;
  final String alamat;

  KontakModel({
    this.id,
    required this.nama,
    required this.nomor,
    this.email,
    required this.alamat,
  });

  factory KontakModel.fromMap(Map<String, dynamic> json) => KontakModel(
        id: json["id"],
        nama: json["nama"],
        nomor: json["nomor"],
        email: json["email"],
        alamat: json["alamat"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nama": nama,
        "nomor": nomor,
        "email": email,
        "alamat": alamat,
      };
}
