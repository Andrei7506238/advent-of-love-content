import 'package:intl/intl.dart';

class Message {
  final DateTime date;
  final String content;
  final String image;

  Message({
    required this.date,
    required this.content,
    required this.image,
  });

  // Convert Message to JSON
  Map<String, dynamic> toJson() {
    return {
      'date': DateFormat('yyyy-MM-dd').format(date),
      'content': content,
      'image': image,
    };
  }

  // Create Message from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    final dynamic dateRaw = json['date'];
    DateTime parsedDate;

    if (dateRaw is DateTime) {
      parsedDate = dateRaw;
    } else if (dateRaw is int) {
      parsedDate = DateTime.fromMillisecondsSinceEpoch(dateRaw);
    } else if (dateRaw is String) {
      try {
        parsedDate = DateFormat('yyyy-MM-dd').parse(dateRaw);
      } catch (_) {
        parsedDate = DateTime.parse(dateRaw);
      }
    } else {
      parsedDate = DateTime.now();
    }

    return Message(
      date: parsedDate,
      content: (json['content'] as String?) ?? '',
      image: (json['image'] as String?) ?? '',
    );
  }

  // Create a copy with modified fields
  Message copyWith({
    DateTime? date,
    String? content,
    String? image,
  }) {
    return Message(
      date: date ?? this.date,
      content: content ?? this.content,
      image: image ?? this.image,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          content == other.content &&
          image == other.image;

  @override
  int get hashCode => date.hashCode ^ content.hashCode ^ image.hashCode;
}
