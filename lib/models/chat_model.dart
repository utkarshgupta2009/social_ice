import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String messageId;
  final String senderId;
  final String content;
  final String timestamp;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  factory ChatMessage.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ChatMessage(
      messageId: snapshot.id,
      senderId: data['senderId'],
      content: data['content'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
