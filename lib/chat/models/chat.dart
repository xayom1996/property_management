import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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

  String getDate() {
    if (lastMessage == null) {
      return '';
    }
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(lastMessage!.timestamp));
    DateTime now = DateTime.now();
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return DateFormat('HH:mm').format(date);
    } else if (date.year != now.year) {
      return DateFormat('dd.MM.yyyy').format(date);
    }
    return DateFormat('dd.MM').format(date);
  }

  String getRole() {
    if (role == 'admin') {
      return 'админ';
    }
    if (role == 'manager') {
      return 'менеджер';
    }
    return role;
  }

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