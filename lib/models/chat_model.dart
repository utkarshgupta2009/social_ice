import 'package:cloud_firestore/cloud_firestore.dart';

enum Filetype { text, image, video, document }

class ChatMessage {
  final String messageId;
  final String senderId;
  final String content;
  final String timestamp;
  final Filetype fileType;
  final String filename;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.fileType,
    required this.filename,
  });

  factory ChatMessage.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ChatMessage(
      messageId: snapshot.id,
      senderId: data['senderId'],
      content: data['content'],
      timestamp: data['timestamp'],
      fileType: Filetype.values[data['fileType']], // Convert the file type index to the enum value
      filename: data['filename'], // Handle nullable filename
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp,
      'fileType': fileType.index, // Store the file type as an index
      'filename': filename, // Include the filename if it's not null
    };
  }
}
