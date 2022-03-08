class UserModel {
  final int? id;
  final String name;
  final String password;

  UserModel({
    this.id,
    required this.name,
    required this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "password": password,
      };
}
