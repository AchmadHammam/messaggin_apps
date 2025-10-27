import 'package:messaging_application/model/user.dart';

class Chat {
  final int? id;
  final int? senderId;
  final int? receiverId;
  final int? readerId;
  String? message;
  final DateTime? createdAt;

  Chat({this.id, this.message, this.createdAt, this.senderId, this.receiverId, this.readerId});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      senderId: json['senderId'],
      id: json['id'],
      message: json['message'] as String,
      receiverId: json['receiverId'],
      readerId: json['readerId'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

class ChatRoom {
  final int id;
  final DateTime lastMessageAt;
  final String lastMessageBy;
  final int? totalUnread;
  final User user2;
  final User user1;
  final Chat? lastChatMessage;

  ChatRoom({
    required this.id,
    required this.lastMessageAt,
    required this.lastMessageBy,
    required this.user2,
    required this.user1,
    this.totalUnread = 0,
    this.lastChatMessage,
  });
  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      lastMessageBy: json['lastMessageBy'] as String,
      user2: User.fromJson(json['user2'] as Map<String, dynamic>),
      user1: User.fromJson(json['user1'] as Map<String, dynamic>),
      totalUnread: json['totalNotRead'],
      lastChatMessage: json['lastChatMessage'] != null
          ? Chat.fromJson(json['lastChatMessage'] as Map<String, dynamic>)
          : null,
    );
  }
}
