import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:property_management/chat/models/message_chat.dart';

class Chat {
  final String name;
  final String role;
  final String chatId;
  final String currentUserId;
  final String peerId;
  MessageChat? lastMessage;
  int unreadMessages;

  Chat({
    required this.name,
    required this.role,
    required this.chatId,
    required this.currentUserId,
    required this.peerId,
    this.lastMessage,
    this.unreadMessages = 0,
  });

  // Map<String, dynamic> toJson() {
  //   return {
  //     'idFrom': idFrom,
  //     'idTo': idTo,
  //     'timestamp': timestamp,
  //     'content': content,
  //     'type': type,
  //   };
  // }
}