class Message {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final MessageType type;
  final String? imageUrl;
  final List<String> reactions;
  final double? voiceDuration;

  Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.type = MessageType.text,
    this.imageUrl,
    this.reactions = const [],
    this.voiceDuration,
  });
}

enum MessageType { text, image, voice }
