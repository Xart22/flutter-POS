class PrinterModel {
  final int? id;
  final String? name;
  final String? address;
  final int? type;

  PrinterModel(
      {this.id, required this.name, required this.address, required this.type});

  factory PrinterModel.fromMap(Map<String, dynamic> json) => PrinterModel(
        id: 1,
        name: json['name'],
        address: json['address'],
        type: json['type'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': 1,
      'name': name,
      'address': address,
      'type': type,
    };
  }
}
