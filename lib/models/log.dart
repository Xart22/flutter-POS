class LogModel {
  final int? id;
  final String? message;

  final String? timestamp;

  LogModel({this.id, this.message, this.timestamp});

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      id: json['id'] as int?,
      message: json['message'] as String,
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
