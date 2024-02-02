class Message {
  final String userId;
  final String? text;
  final String? imageUrl;
  final String? userImage;
  final String? username;
  final DateTime createdAt;

  Message({
    required this.userId,
    this.text,
    this.imageUrl,
    this.userImage,
    this.username,
    required this.createdAt,
  });
}
