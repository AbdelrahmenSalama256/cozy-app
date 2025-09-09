class TrackingEvent {
  final String id;
  final String transactionId;
  final String title;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  TrackingEvent({
    required this.id,
    required this.transactionId,
    required this.title,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TrackingEvent.fromJson(Map<String, dynamic> json) {
    return TrackingEvent(
      id: json['id'].toString(),
      transactionId: json['transaction_id'].toString(),
      title: json['title'] ?? '',
      text: json['text'] ?? '',
      createdAt:
          DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt:
          DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'title': title,
      'text': text,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
