class Journal {
  String id;
  String content;
  DateTime createdAt;
  DateTime updatedAt;
  int userId;

  Journal({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  @override
  String toString() {
    return "$content \ncreated_at: $createdAt\nupdated_at:$updatedAt\nuserId:$userId";
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "content": content,
      "created_at": createdAt.toString(),
      "updated_at": updatedAt.toString(),
      "userId": userId,
    };
  }

  Journal.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        content = map["content"],
        createdAt = DateTime.parse(
          map["created_at"],
        ),
        updatedAt = DateTime.parse(
          map["updated_at"],
        ),
        userId = map['userId'];
}
